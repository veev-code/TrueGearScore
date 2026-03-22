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
-- Socket bonus detection via tooltip scanning
---------------------------------------------------------------------------

-- Socket bonus detection uses GetItemStats() differential rather than
-- tooltip text parsing — this is localization-safe. When all sockets
-- are matched, GetItemStats() on the full link includes the socket bonus
-- stats. We compare against the clean (no-gem) link to extract the bonus.

--- Build a "clean" item link with gem slots zeroed out.
-- Used to detect socket layout via GetItemStats() on the ungemmed item.
-- @param itemLink  Full item link
-- @return string   Item link with gem IDs set to 0
local function BuildCleanItemLink(itemLink)
    -- Item link format: item:itemID:enchantID:gem1:gem2:gem3:gem4:suffixID:...
    -- Replace gem fields (positions 3-6 in the colon-delimited item string) with 0
    return itemLink:gsub("(item:%d+:%d+):%d+:%d+:%d+:%d+:", "%1:0:0:0:0:")
end

--- Get the socket layout of an item (how many of each socket color).
-- Strips gems from the link and reads EMPTY_SOCKET_* from GetItemStats().
-- @param itemLink  Full item link (may have gems)
-- @return table    { RED = count, YELLOW = count, BLUE = count, META = count } or nil if no sockets
local function GetSocketLayout(itemLink)
    local cleanLink = BuildCleanItemLink(itemLink)
    local rawStats = {}
    GetItemStats(cleanLink, rawStats)

    local layout = {}
    local totalSockets = 0

    for key, value in pairs(rawStats) do
        if key == "EMPTY_SOCKET_RED" then
            layout.RED = (layout.RED or 0) + value
            totalSockets = totalSockets + value
        elseif key == "EMPTY_SOCKET_YELLOW" then
            layout.YELLOW = (layout.YELLOW or 0) + value
            totalSockets = totalSockets + value
        elseif key == "EMPTY_SOCKET_BLUE" then
            layout.BLUE = (layout.BLUE or 0) + value
            totalSockets = totalSockets + value
        elseif key == "EMPTY_SOCKET_META" then
            layout.META = (layout.META or 0) + value
            totalSockets = totalSockets + value
        end
    end

    if totalSockets == 0 then return nil end
    return layout
end

--- TBC socket color matching rules.
-- Returns true if a gem of the given color satisfies a socket of the given color.
local SOCKET_MATCH = {
    -- RED socket accepts: Red, Orange, Purple, Prismatic
    RED    = { RED = true, ORANGE = true, PURPLE = true, PRISMATIC = true },
    -- YELLOW socket accepts: Yellow, Orange, Green, Prismatic
    YELLOW = { YELLOW = true, ORANGE = true, GREEN = true, PRISMATIC = true },
    -- BLUE socket accepts: Blue, Green, Purple, Prismatic
    BLUE   = { BLUE = true, GREEN = true, PURPLE = true, PRISMATIC = true },
    -- META socket accepts: Meta only
    META   = { META = true },
}

--- Check if all gem colors match their corresponding sockets.
-- Socket order in the item matches gem order in the link (gem1 → socket1, etc.).
-- @param gems         Array of gem item IDs from ParseItemLink
-- @param socketLayout Table from GetSocketLayout: { RED = n, YELLOW = n, BLUE = n, META = n }
-- @return boolean     True if all sockets are filled with matching gems
local function AreSocketsMatched(gems, socketLayout)
    local db = addon.GemDatabase
    if not db then return false end

    -- Build ordered list of socket colors from layout
    -- Socket order convention: META first, then RED, YELLOW, BLUE
    -- (this matches WoW's internal socket ordering in the item link)
    local socketOrder = {}
    for _ = 1, (socketLayout.META or 0) do
        socketOrder[#socketOrder + 1] = "META"
    end
    for _ = 1, (socketLayout.RED or 0) do
        socketOrder[#socketOrder + 1] = "RED"
    end
    for _ = 1, (socketLayout.YELLOW or 0) do
        socketOrder[#socketOrder + 1] = "YELLOW"
    end
    for _ = 1, (socketLayout.BLUE or 0) do
        socketOrder[#socketOrder + 1] = "BLUE"
    end

    -- Check each socket has a matching gem
    for i, socketColor in ipairs(socketOrder) do
        local gemID = gems[i]
        if not gemID or gemID == 0 then
            return false  -- Empty socket = bonus inactive
        end

        local gemData = db[gemID]
        if not gemData or not gemData._COLOR then
            return false  -- Unknown gem = can't verify match
        end

        local accepted = SOCKET_MATCH[socketColor]
        if not accepted or not accepted[gemData._COLOR] then
            return false  -- Gem doesn't match socket
        end
    end

    return true
end

--- Get socket bonus stats for an item if the bonus is active (all sockets matched).
-- Uses a localization-safe approach: compares GetItemStats() on the full link
-- (which includes socket bonus when active) against a clean link (gems zeroed out,
-- no socket bonus). The difference is the socket bonus stats.
-- @param itemLink  Full item link
-- @param gems      Array of gem IDs from ParseItemLink
-- @return table    { STAT_NAME = value, ... } or empty table
function addon.ItemScoring:GetSocketBonusStats(itemLink, gems)
    local socketLayout = GetSocketLayout(itemLink)
    if not socketLayout then return {} end  -- No sockets on this item

    -- Check if all gems match their socket colors
    if not AreSocketsMatched(gems, socketLayout) then
        return {}  -- Bonus inactive
    end

    -- Socket bonus is active. Extract it by comparing GetItemStats() on the
    -- original link (includes socket bonus) vs clean link (no gems → no bonus).
    -- We strip gem stats from the difference to isolate the bonus.
    local fullStats = {}
    GetItemStats(itemLink, fullStats)

    local cleanLink = BuildCleanItemLink(itemLink)
    local cleanStats = {}
    GetItemStats(cleanLink, cleanStats)

    local bonusStats = {}
    for key, fullValue in pairs(fullStats) do
        -- Skip socket keys and gem-contributed stats
        if not key:match("^EMPTY_SOCKET") then
            local cleanValue = cleanStats[key] or 0
            local diff = fullValue - cleanValue
            if diff > 0 then
                -- This difference includes gem stats + socket bonus.
                -- We need to subtract the gem contributions to get just the bonus.
                -- Since GetItemTotalStats already handles gems separately, we just
                -- need the "extra" stats that appear on the full link but not base+gems.
                local canonical = STAT_REVERSE[key]
                if canonical then
                    bonusStats[canonical] = diff
                end
            end
        end
    end

    -- Subtract gem stat contributions from the difference to isolate socket bonus
    local db = addon.GemDatabase
    if db then
        for _, gemID in ipairs(gems) do
            if gemID and gemID > 0 then
                local gemData = db[gemID]
                if gemData then
                    for stat, value in pairs(gemData) do
                        if not stat:match("^_") and bonusStats[stat] then
                            bonusStats[stat] = bonusStats[stat] - value
                            if bonusStats[stat] <= 0 then
                                bonusStats[stat] = nil
                            end
                        end
                    end
                end
            end
        end
    end

    return bonusStats
end

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
            else
                addon:DebugPrint("GetGemStats: unknown gem ID " .. gemID .. " — stats not scored")
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
    local data = db[enchantID]
    if not data then
        addon:DebugPrint("GetEnchantStats: unknown enchant ID " .. enchantID .. " — stats not scored")
        return {}
    end
    return data
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

    -- Add socket bonus stats (if all gems match their socket colors)
    local socketBonusStats = self:GetSocketBonusStats(itemLink, parsed.gems)
    for stat, value in pairs(socketBonusStats) do
        stats[stat] = (stats[stat] or 0) + value
    end

    return stats
end

---------------------------------------------------------------------------
-- Shared stat scoring helper
---------------------------------------------------------------------------

--- Sum weighted stat values for a stat table.
-- @param stats              { STAT_NAME = value, ... }
-- @param effectiveWeights   { STAT_NAME = weight, ... }
-- @return number            Raw (unrounded) weighted sum
local function ScoreStats(stats, effectiveWeights)
    local score = 0
    for stat, value in pairs(stats) do
        score = score + (value * (effectiveWeights[stat] or 0))
    end
    return score
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
    return math.max(0, math.floor(ScoreStats(stats, effectiveWeights)))
end

---------------------------------------------------------------------------
-- Score an entire character (two-pass pipeline)
---------------------------------------------------------------------------

--- Score all equipped items for a character.
-- @param equippedItems  Table of { [slotID] = itemLink, ... }
-- @param specKey        Player spec key (e.g., "WARRIOR_ARMS"). If nil, uses addon.playerSpec.
-- @param mode           Scoring mode: "pve" (default) or "pvp"
-- @return table         { totalScore, perSlot = { [slotID] = score }, effectiveWeights = {}, mode = "pve"/"pvp" }
function addon.ItemScoring:ScoreCharacter(equippedItems, specKey, mode)
    mode = mode or "pve"
    specKey = specKey or addon.playerSpec
    if not specKey then
        addon:DebugPrint("ScoreCharacter: no spec key available")
        return { totalScore = 0, perSlot = {}, effectiveWeights = {}, mode = mode }
    end

    -- Feral druids have two roles (cat DPS / bear tank) under one talent tree.
    -- Score with both weight tables and use whichever the gear scores higher with.
    -- This lets the gear self-select: tank gear → bear, DPS gear → cat.
    if specKey == "DRUID_FERAL" then
        local catData = (mode == "pvp") and addon.StatWeights:GetSpecPvPWeights("DRUID_FERAL_CAT") or addon.StatWeights:GetSpecWeights("DRUID_FERAL_CAT")
        local bearData = (mode == "pvp") and addon.StatWeights:GetSpecPvPWeights("DRUID_FERAL_BEAR") or addon.StatWeights:GetSpecWeights("DRUID_FERAL_BEAR")
        if not catData and not bearData then
            addon:DebugPrint("ScoreCharacter: no weights for DRUID_FERAL_CAT or DRUID_FERAL_BEAR")
            return { totalScore = 0, perSlot = {}, effectiveWeights = {}, mode = mode }
        end
        local catResult = self:ScoreCharacter(equippedItems, "DRUID_FERAL_CAT", mode)
        local bearResult = self:ScoreCharacter(equippedItems, "DRUID_FERAL_BEAR", mode)
        if bearResult.totalScore > catResult.totalScore then
            return bearResult
        end
        return catResult
    end

    local specData
    if mode == "pvp" then
        specData = addon.StatWeights:GetSpecPvPWeights(specKey)
    else
        specData = addon.StatWeights:GetSpecWeights(specKey)
    end
    if not specData then
        addon:DebugPrint("ScoreCharacter: no weights for spec " .. specKey .. " mode=" .. mode)
        return { totalScore = 0, perSlot = {}, effectiveWeights = {}, mode = mode }
    end

    -- Pass 1: Sum raw stats across all items (full: base+gems+enchants+procs)
    -- Each source is collected individually for the per-category breakdown.
    local statTotals = {}
    local itemStats = {}       -- Cache per-item full stats for pass 2
    local itemBaseStats = {}   -- Cache per-item base-only stats (no gems/enchants/procs)
    local itemGemStats = {}    -- Cache per-item gem stats for breakdown
    local itemEnchantStats = {} -- Cache per-item enchant stats for breakdown
    local itemProcStats = {}   -- Cache per-item proc stats for breakdown
    local itemSocketBonusStats = {} -- Cache per-item socket bonus stats for breakdown

    for slotID, itemLink in pairs(equippedItems) do
        local parsed = self:ParseItemLink(itemLink)

        -- Collect each stat source individually (avoids redundant GetBaseStats call)
        local baseStats = self:GetBaseStats(itemLink)
        itemBaseStats[slotID] = baseStats

        local gemStats, enchantStats, procStats, socketBonusStats = {}, {}, {}, {}
        if parsed then
            gemStats = self:GetGemStats(parsed.gems)
            enchantStats = self:GetEnchantStats(parsed.enchantID)
            procStats = self:GetProcStats(parsed.itemID)
            socketBonusStats = self:GetSocketBonusStats(itemLink, parsed.gems)
        end
        itemGemStats[slotID] = gemStats
        itemEnchantStats[slotID] = enchantStats
        itemProcStats[slotID] = procStats
        itemSocketBonusStats[slotID] = socketBonusStats

        -- Build full stats by merging all sources
        local stats = {}
        for stat, value in pairs(baseStats) do
            stats[stat] = (stats[stat] or 0) + value
        end
        for stat, value in pairs(gemStats) do
            stats[stat] = (stats[stat] or 0) + value
        end
        for stat, value in pairs(enchantStats) do
            stats[stat] = (stats[stat] or 0) + value
        end
        for stat, value in pairs(procStats) do
            stats[stat] = (stats[stat] or 0) + value
        end
        for stat, value in pairs(socketBonusStats) do
            stats[stat] = (stats[stat] or 0) + value
        end
        itemStats[slotID] = stats

        for stat, value in pairs(stats) do
            statTotals[stat] = (statTotals[stat] or 0) + value
        end
    end

    -- Compute effective weights from totals (using full stats for cap awareness)
    local effectiveWeights = addon.CapEngine:ComputeEffectiveWeights(statTotals, specKey, mode)

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
        slotScore = math.max(0, slotScore)
        perSlot[slotID] = slotScore  -- Raw (unrounded) — floored for display later
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
                        local bonusScore = math.max(0, ScoreStats(bonusStats, effectiveWeights))
                        if bonusScore > 0 then
                            setBonusScore = setBonusScore + bonusScore
                            setBonusDetails[#setBonusDetails + 1] = {
                                setName = setData.name,
                                setID = setID,
                                pieces = count,
                                threshold = threshold,
                                score = math.floor(bonusScore),
                            }
                            addon:DebugPrint("SetBonus: " .. setData.name .. " " .. threshold .. "pc active (" .. count .. " equipped) = +" .. math.floor(bonusScore))
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
        baseOnlyRaw = baseOnlyRaw + math.max(0, ScoreStats(baseStats, effectiveWeights))
    end

    -- Compute per-category breakdown (gems, enchants, procs, socket bonuses scored separately)
    local gemScoreRaw = 0
    local enchantScoreRaw = 0
    local procScoreRaw = 0
    local socketBonusScoreRaw = 0
    for slotID, _ in pairs(equippedItems) do
        if itemGemStats[slotID] then
            gemScoreRaw = gemScoreRaw + ScoreStats(itemGemStats[slotID], effectiveWeights)
        end
        if itemEnchantStats[slotID] then
            enchantScoreRaw = enchantScoreRaw + ScoreStats(itemEnchantStats[slotID], effectiveWeights)
        end
        if itemProcStats[slotID] then
            procScoreRaw = procScoreRaw + ScoreStats(itemProcStats[slotID], effectiveWeights)
        end
        if itemSocketBonusStats[slotID] then
            socketBonusScoreRaw = socketBonusScoreRaw + ScoreStats(itemSocketBonusStats[slotID], effectiveWeights)
        end
    end

    -- Apply calibration scale factors:
    -- 1. Global scale (C.SCORE_SCALE) — reserved for future tuning, default 1.0
    -- 2. Per-spec scale (SPEC_SCALE) — normalizes cross-class score parity
    -- 3. PvP dampening (C.PVP_SCORE_DAMPENING) — compensates for resilience inflation
    local globalScale = C.SCORE_SCALE or 1
    local specScale
    if mode == "pvp" then
        specScale = addon.StatWeights:GetSpecPvPScale(specKey)
    else
        specScale = addon.StatWeights:GetSpecScale(specKey)
    end
    local scale = globalScale * specScale
    if mode == "pvp" then
        scale = scale * (C.PVP_SCORE_DAMPENING or 1)
    end
    -- Single floor at the end: totalScore is the only place we truncate to integer.
    -- Per-slot values are floored individually for display (integer requirement)
    -- but their raw unrounded values were summed into totalRaw above.
    local totalScore = math.floor(totalRaw * scale)
    local baseOnlyScore = math.floor(baseOnlyRaw * scale)
    for slotID, raw in pairs(perSlot) do
        perSlot[slotID] = math.floor(raw * scale)
    end

    -- Gear optimization: count filled gem sockets and enchanted slots
    -- vs total available. 100% = every socket gemmed, every slot enchanted.
    -- This is a concrete, verifiable metric — not an estimate.
    local totalSockets = 0
    local filledSockets = 0
    local enchantableSlots = 0
    local enchantedSlots = 0

    -- Enchantable slot IDs (slots that can have a permanent enchant in TBC)
    local ENCHANTABLE = { [1]=true, [3]=true, [5]=true, [7]=true, [8]=true,
        [9]=true, [10]=true, [15]=true, [16]=true, [17]=true, [18]=true }

    for slotID, itemLink in pairs(equippedItems) do
        local parsed = self:ParseItemLink(itemLink)
        if parsed then
            -- Count gem sockets: check how many sockets the item has via clean link
            local cleanLink = BuildCleanItemLink(itemLink)
            if cleanLink then
                local layout = GetSocketLayout(cleanLink)
                if not layout then layout = {} end
                local slotSockets = (layout.RED or 0) + (layout.YELLOW or 0) + (layout.BLUE or 0) + (layout.META or 0)
                totalSockets = totalSockets + slotSockets

                -- Count filled sockets
                for _, gemID in ipairs(parsed.gems) do
                    if gemID > 0 then
                        filledSockets = filledSockets + 1
                    end
                end
            end

            -- Count enchants
            if ENCHANTABLE[slotID] then
                enchantableSlots = enchantableSlots + 1
                if parsed.enchantID > 0 then
                    enchantedSlots = enchantedSlots + 1
                end
            end
        end
    end

    local totalSlots = totalSockets + enchantableSlots
    local filledSlots = filledSockets + enchantedSlots
    local efficiency = nil
    if totalSlots > 0 then
        efficiency = math.floor(filledSlots / totalSlots * 100 + 0.5)
    end

    addon:DebugPrint("ScoreCharacter: raw=" .. totalRaw .. " baseOnly=" .. baseOnlyRaw .. " scaled=" .. totalScore .. " baseScaled=" .. baseOnlyScore .. " eff=" .. tostring(efficiency) .. "% (x" .. scale .. ") spec=" .. specKey)

    -- Breakdown categories: floor each individually, then derive base as remainder.
    -- This guarantees breakdown values sum exactly to totalScore. The base category
    -- absorbs any positive rounding remainder from the other categories' floors.
    local scaledSetBonus = math.floor(setBonusScore * scale)
    local scaledGems = math.floor(math.max(0, gemScoreRaw) * scale)
    local scaledEnchants = math.floor(math.max(0, enchantScoreRaw) * scale)
    local scaledProcs = math.floor(math.max(0, procScoreRaw) * scale)
    local scaledSocketBonuses = math.floor(math.max(0, socketBonusScoreRaw) * scale)
    -- Base absorbs rounding remainder so breakdown always sums to totalScore.
    -- Guard against negative in edge cases (e.g., negative-weight stats in base).
    local scaledBase = math.max(0, totalScore - scaledGems - scaledEnchants - scaledProcs - scaledSetBonus - scaledSocketBonuses)

    return {
        totalScore = totalScore,
        specKey = specKey,  -- Resolved spec (e.g., DRUID_FERAL_CAT or DRUID_FERAL_BEAR)
        mode = mode,        -- "pve" or "pvp"
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
            base = scaledBase,  -- Includes rounding remainder so breakdown sums to totalScore
            gems = scaledGems,
            enchants = scaledEnchants,
            procs = scaledProcs,
            setBonuses = scaledSetBonus,
            socketBonuses = scaledSocketBonuses,
        },
    }
end

---------------------------------------------------------------------------
-- Score with best mode (PvE vs PvP auto-detection)
---------------------------------------------------------------------------

--- Score a character with both PvE and PvP weights, returning the higher result.
-- This provides automatic PvE/PvP mode detection based on gear composition:
-- PvP gear (with resilience) scores higher under PvP weights, PvE gear scores
-- higher under PvE weights.
-- @param equippedItems  Table of { [slotID] = itemLink, ... }
-- @param specKey        Player spec key. If nil, uses addon.playerSpec.
-- @return table         Same as ScoreCharacter, with mode = "pve" or "pvp"
function addon.ItemScoring:ScoreCharacterBestMode(equippedItems, specKey)
    -- Score with the detected spec first
    local bestResult = self:ScoreCharacter(equippedItems, specKey, "pve")
    local bestSpec = specKey

    -- Try ALL specs for this class, take highest SCALED score.
    -- The gear decides which spec it's best for. If same-class specs
    -- produce very different scores on the same gear, the weights or
    -- SPEC_SCALE need tuning — not the selection logic.
    local class = specKey and specKey:match("^([A-Z]+)_")

    if class and C.SPEC_MAP[class] then
        for _, candidateSpec in ipairs(C.SPEC_MAP[class]) do
            if candidateSpec ~= specKey then
                local candidateResult = self:ScoreCharacter(equippedItems, candidateSpec, "pve")
                if type(candidateResult) == "table" and candidateResult.totalScore > bestResult.totalScore then
                    bestResult = candidateResult
                    bestSpec = candidateSpec
                end
            end
        end
    end

    if bestSpec ~= specKey then
        addon:DebugPrint("ScoreCharacterBestMode: Gear chose " .. bestSpec .. " (" .. bestResult.totalScore .. ") over detected " .. specKey)
    end

    -- Check PvP mode only if gear has meaningful resilience (≥50 rating ≈ 2+ PvP pieces)
    local totalResilience = 0
    for _, itemLink in pairs(equippedItems) do
        local stats = self:GetBaseStats(itemLink)
        totalResilience = totalResilience + (stats.RESILIENCE or 0)
    end

    if totalResilience >= 150 then
        local pvpResult = self:ScoreCharacter(equippedItems, bestSpec, "pvp")
        if pvpResult.totalScore > bestResult.totalScore then
            addon:DebugPrint("ScoreCharacterBestMode: PvP wins (" .. pvpResult.totalScore .. " > " .. bestResult.totalScore .. ") resil=" .. totalResilience)
            return pvpResult
        end
    end

    return bestResult
end
