---------------------------------------------------------------------------
-- TrueGearScore Item Scoring Engine
-- Core scoring pipeline: item link → stats → weighted score
--
-- Two-pass algorithm:
-- Pass 1: Sum raw stats across all items (for cap engine context)
-- Pass 2: Score each item using cap-aware effective weights
--
-- This means each item's score reflects its value IN CONTEXT of the
-- full gear set — identical items can score differently depending on
-- what else is equipped.
---------------------------------------------------------------------------

local _, addon = ...
addon.ItemScoring = {}

local C = addon.Constants
local STAT_REVERSE = C.STAT_REVERSE

---------------------------------------------------------------------------
-- Item link parsing
---------------------------------------------------------------------------

--- Parse an item link to extract itemID, enchantID, and gem IDs.
-- Item link format: |Hitem:itemID:enchantID:gemID1:gemID2:gemID3:gemID4:suffixID:uniqueID:...|h
-- @param itemLink  Full item link string
-- @return table    { itemID, enchantID, gems = { id1, id2, id3, id4 } } or nil
function addon.ItemScoring:ParseItemLink(itemLink)
    if not itemLink then return nil end

    local itemString = itemLink:match("item:([%d:%-]+)")
    if not itemString then return nil end

    local fields = {}
    for field in itemString:gmatch("([^:]*):?") do
        fields[#fields + 1] = tonumber(field) or 0
    end

    return {
        itemID    = fields[1] or 0,
        enchantID = fields[2] or 0,
        gems = {
            fields[3] or 0,
            fields[4] or 0,
            fields[5] or 0,
            fields[6] or 0,
        },
    }
end

---------------------------------------------------------------------------
-- Stat collection from individual sources
---------------------------------------------------------------------------

--- Get base stats from an item via GetItemStats().
-- @param itemLink  Full item link
-- @return table    { STAT_NAME = value, ... } using canonical names
function addon.ItemScoring:GetBaseStats(itemLink)
    local rawStats = {}
    GetItemStats(itemLink, rawStats)

    local stats = {}
    for itemModKey, value in pairs(rawStats) do
        local canonical = STAT_REVERSE[itemModKey]
        if canonical then
            stats[canonical] = (stats[canonical] or 0) + value
        else
            addon:DebugPrint("GetBaseStats: unmapped key '" .. tostring(itemModKey) .. "' = " .. tostring(value) .. " on " .. tostring(itemLink))
        end
    end
    return stats
end

--- Get stat contributions from socketed gems.
-- @param gems  Array of gem item IDs from ParseItemLink
-- @return table  { STAT_NAME = value, ... }
function addon.ItemScoring:GetGemStats(gems)
    local stats = {}
    local db = addon.GemDatabase
    if not db then return stats end

    for _, gemID in ipairs(gems) do
        if gemID and gemID > 0 then
            local gemData = db[gemID]
            if gemData then
                for stat, value in pairs(gemData) do
                    if not stat:match("^_") then  -- Skip metadata keys like _NOTE
                        stats[stat] = (stats[stat] or 0) + value
                    end
                end
            end
        end
    end
    return stats
end

--- Get stat contributions from an enchant.
-- @param enchantID  Enchant ID from item link
-- @return table     { STAT_NAME = value, ... }
function addon.ItemScoring:GetEnchantStats(enchantID)
    if not enchantID or enchantID == 0 then return {} end
    local db = addon.EnchantDatabase
    if not db then return {} end
    return db[enchantID] or {}
end

--- Get equivalent stat contributions from item procs/equip effects.
-- @param itemID  Item ID
-- @return table  { STAT_NAME = value, ... }
function addon.ItemScoring:GetProcStats(itemID)
    if not itemID or itemID == 0 then return {} end
    local db = addon.ProcDatabase
    if not db then return {} end
    return db[itemID] or {}
end

---------------------------------------------------------------------------
-- Aggregate stats for a single item
---------------------------------------------------------------------------

--- Collect all stat contributions for a single item.
-- @param itemLink  Full item link
-- @return table    { STAT_NAME = totalValue, ... }
function addon.ItemScoring:GetItemTotalStats(itemLink)
    local parsed = self:ParseItemLink(itemLink)
    if not parsed then return {} end

    local stats = self:GetBaseStats(itemLink)

    -- Add gem stats
    local gemStats = self:GetGemStats(parsed.gems)
    for stat, value in pairs(gemStats) do
        stats[stat] = (stats[stat] or 0) + value
    end

    -- Add enchant stats
    local enchantStats = self:GetEnchantStats(parsed.enchantID)
    for stat, value in pairs(enchantStats) do
        stats[stat] = (stats[stat] or 0) + value
    end

    -- Add proc/equip stats
    local procStats = self:GetProcStats(parsed.itemID)
    for stat, value in pairs(procStats) do
        stats[stat] = (stats[stat] or 0) + value
    end

    return stats
end

---------------------------------------------------------------------------
-- Score a single item with pre-computed effective weights
---------------------------------------------------------------------------

--- Score a single item given effective weights.
-- @param itemLink          Full item link
-- @param effectiveWeights  { STAT_NAME = weight, ... } from CapEngine
-- @return number           Integer score for this item
function addon.ItemScoring:ScoreItem(itemLink, effectiveWeights)
    local stats = self:GetItemTotalStats(itemLink)
    local score = 0

    for stat, value in pairs(stats) do
        local weight = effectiveWeights[stat] or 0
        score = score + (value * weight)
    end

    return math.max(0, math.floor(score))
end

---------------------------------------------------------------------------
-- Score an entire character (two-pass pipeline)
---------------------------------------------------------------------------

--- Score all equipped items for a character.
-- @param equippedItems  Table of { [slotID] = itemLink, ... }
-- @param specKey        Player spec key (e.g., "WARRIOR_ARMS"). If nil, uses addon.playerSpec.
-- @return table         { totalScore, perSlot = { [slotID] = score }, effectiveWeights = {} }
function addon.ItemScoring:ScoreCharacter(equippedItems, specKey)
    specKey = specKey or addon.playerSpec
    if not specKey then
        addon:DebugPrint("ScoreCharacter: no spec key available")
        return { totalScore = 0, perSlot = {}, effectiveWeights = {} }
    end

    local specData = addon.StatWeights:GetSpecWeights(specKey)
    if not specData then
        addon:DebugPrint("ScoreCharacter: no weights for spec " .. specKey)
        return { totalScore = 0, perSlot = {}, effectiveWeights = {} }
    end

    -- Pass 1: Sum raw stats across all items (full: base+gems+enchants+procs)
    local statTotals = {}
    local itemStats = {}       -- Cache per-item full stats for pass 2
    local itemBaseStats = {}   -- Cache per-item base-only stats (no gems/enchants/procs)
    local itemGemStats = {}    -- Cache per-item gem stats for breakdown
    local itemEnchantStats = {} -- Cache per-item enchant stats for breakdown
    local itemProcStats = {}   -- Cache per-item proc stats for breakdown

    for slotID, itemLink in pairs(equippedItems) do
        local stats = self:GetItemTotalStats(itemLink)
        local baseStats = self:GetBaseStats(itemLink)
        local parsed = self:ParseItemLink(itemLink)
        itemStats[slotID] = stats
        itemBaseStats[slotID] = baseStats
        if parsed then
            itemGemStats[slotID] = self:GetGemStats(parsed.gems)
            itemEnchantStats[slotID] = self:GetEnchantStats(parsed.enchantID)
            itemProcStats[slotID] = self:GetProcStats(parsed.itemID)
        end
        for stat, value in pairs(stats) do
            statTotals[stat] = (statTotals[stat] or 0) + value
        end
    end

    -- Compute effective weights from totals (using full stats for cap awareness)
    local effectiveWeights = addon.CapEngine:ComputeEffectiveWeights(statTotals, specKey)

    -- Pass 2: Score each item with effective weights
    local perSlot = {}
    local perSlotDetails = {}  -- { [slotID] = { { stat, value, weight, contribution }, ... } }
    local totalRaw = 0

    for slotID, stats in pairs(itemStats) do
        local slotScore = 0
        local details = {}
        for stat, value in pairs(stats) do
            local weight = effectiveWeights[stat] or 0
            local contribution = value * weight
            if contribution > 0 then
                details[#details + 1] = {
                    stat = stat,
                    value = value,
                    weight = weight,
                    contribution = contribution,
                }
            end
            slotScore = slotScore + contribution
        end
        -- Sort details by contribution descending for readability
        table.sort(details, function(a, b) return a.contribution > b.contribution end)
        slotScore = math.max(0, math.floor(slotScore))
        perSlot[slotID] = slotScore
        perSlotDetails[slotID] = details
        totalRaw = totalRaw + slotScore
    end

    -- Set bonus scoring: detect equipped sets, count pieces, add bonus stats
    local setBonusScore = 0
    local setBonusDetails = {}
    local setDB = addon.SetBonusDatabase
    if setDB then
        -- Count equipped pieces per setID
        local setCounts = {}
        for slotID, itemLink in pairs(equippedItems) do
            -- GetItemInfo return #16 is setID (0 or nil if not part of a set)
            local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemLink)
            if setID and setID > 0 then
                setCounts[setID] = (setCounts[setID] or 0) + 1
            end
        end

        -- Look up active bonuses and score them
        for setID, count in pairs(setCounts) do
            local setData = setDB[setID]
            if setData and setData.bonuses then
                for threshold, bonusStats in pairs(setData.bonuses) do
                    if count >= threshold then
                        local bonusScore = 0
                        for stat, value in pairs(bonusStats) do
                            local weight = effectiveWeights[stat] or 0
                            bonusScore = bonusScore + (value * weight)
                        end
                        bonusScore = math.max(0, math.floor(bonusScore))
                        if bonusScore > 0 then
                            setBonusScore = setBonusScore + bonusScore
                            setBonusDetails[#setBonusDetails + 1] = {
                                setName = setData.name,
                                setID = setID,
                                pieces = count,
                                threshold = threshold,
                                score = bonusScore,
                            }
                            addon:DebugPrint("SetBonus: " .. setData.name .. " " .. threshold .. "pc active (" .. count .. " equipped) = +" .. bonusScore)
                        end
                    end
                end
            end
        end
        totalRaw = totalRaw + setBonusScore
    end

    -- Compute base-only score (what TacoTip roughly measures — no gems/enchants/procs)
    local baseOnlyRaw = 0
    for slotID, baseStats in pairs(itemBaseStats) do
        local slotBase = 0
        for stat, value in pairs(baseStats) do
            local weight = effectiveWeights[stat] or 0
            slotBase = slotBase + (value * weight)
        end
        baseOnlyRaw = baseOnlyRaw + math.max(0, slotBase)
    end
    baseOnlyRaw = math.floor(baseOnlyRaw)

    -- Compute per-category breakdown (gems, enchants, procs scored separately)
    local gemScoreRaw = 0
    local enchantScoreRaw = 0
    local procScoreRaw = 0
    for slotID, _ in pairs(equippedItems) do
        local gs = itemGemStats[slotID]
        if gs then
            for stat, value in pairs(gs) do
                local weight = effectiveWeights[stat] or 0
                gemScoreRaw = gemScoreRaw + (value * weight)
            end
        end
        local es = itemEnchantStats[slotID]
        if es then
            for stat, value in pairs(es) do
                local weight = effectiveWeights[stat] or 0
                enchantScoreRaw = enchantScoreRaw + (value * weight)
            end
        end
        local ps = itemProcStats[slotID]
        if ps then
            for stat, value in pairs(ps) do
                local weight = effectiveWeights[stat] or 0
                procScoreRaw = procScoreRaw + (value * weight)
            end
        end
    end

    -- Apply calibration scale factors:
    -- 1. Global scale (C.SCORE_SCALE) — reserved for future tuning, default 1.0
    -- 2. Per-spec scale (SPEC_SCALE) — normalizes cross-class score parity
    local globalScale = C.SCORE_SCALE or 1
    local specScale = addon.StatWeights:GetSpecScale(specKey)
    local scale = globalScale * specScale
    local totalScore = math.floor(totalRaw * scale)
    local baseOnlyScore = math.floor(baseOnlyRaw * scale)
    for slotID, raw in pairs(perSlot) do
        perSlot[slotID] = math.floor(raw * scale)
    end

    -- Gear efficiency: how much of the item potential has been realized
    -- via gems, enchants, and procs. Potential ≈ baseOnly * 1.30 (full
    -- gems + enchants typically add ~30% over base stats alone).
    local efficiency = nil
    if baseOnlyScore > 0 then
        local potentialScore = math.floor(baseOnlyScore * 1.30)
        efficiency = math.min(100, math.floor(totalScore / potentialScore * 100 + 0.5))
    end

    addon:DebugPrint("ScoreCharacter: raw=" .. totalRaw .. " baseOnly=" .. baseOnlyRaw .. " scaled=" .. totalScore .. " baseScaled=" .. baseOnlyScore .. " eff=" .. tostring(efficiency) .. "% (x" .. scale .. ") spec=" .. specKey)

    local scaledSetBonus = math.floor(setBonusScore * scale)
    local scaledGems = math.floor(math.max(0, gemScoreRaw) * scale)
    local scaledEnchants = math.floor(math.max(0, enchantScoreRaw) * scale)
    local scaledProcs = math.floor(math.max(0, procScoreRaw) * scale)
    local scaledBase = totalScore - scaledGems - scaledEnchants - scaledProcs - scaledSetBonus

    return {
        totalScore = totalScore,
        perSlot = perSlot,
        perSlotDetails = perSlotDetails,
        effectiveWeights = effectiveWeights,
        rawScore = totalRaw,
        baseOnlyRaw = baseOnlyRaw,
        baseOnlyScore = baseOnlyScore,
        setBonusScore = scaledSetBonus,
        setBonusDetails = setBonusDetails,
        efficiency = efficiency,
        breakdown = {
            base = scaledBase,
            gems = scaledGems,
            enchants = scaledEnchants,
            procs = scaledProcs,
            setBonuses = scaledSetBonus,
        },
    }
end
