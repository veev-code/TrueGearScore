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

-- Hidden tooltip for scanning socket bonus text (created on first use)
local scanTooltip

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

--- Scan tooltip for socket bonus stats.
-- Creates a hidden tooltip, sets the item, and scans for the "Socket Bonus:" line.
-- Parses the stat name and value from the bonus text.
-- @param itemLink  Full item link
-- @return table    { STAT_NAME = value, ... } or empty table if no bonus found
local function ParseSocketBonusFromTooltip(itemLink)
    -- Create hidden scan tooltip on first use
    if not scanTooltip then
        scanTooltip = CreateFrame("GameTooltip", "TGSScanTooltip", nil, "GameTooltipTemplate")
        scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    scanTooltip:ClearLines()
    scanTooltip:SetHyperlink(itemLink)

    local stats = {}
    local numLines = scanTooltip:NumLines()

    for i = 1, numLines do
        local line = _G["TGSScanTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text and text:match("Socket Bonus:") then
                -- Parse "+X Stat" patterns from the bonus line
                -- Examples: "Socket Bonus: +4 Intellect", "Socket Bonus: +3 Spell Damage"
                -- Can have multiple stats: "Socket Bonus: +4 Stamina and +2 Mana every 5 Sec."
                for value, stat in text:gmatch("%+(%d+)%s+(.-)%s*$") do
                    -- Also try to match multiple bonuses separated by " and "
                    -- But most TBC socket bonuses are single-stat
                end

                -- More robust: extract all +N patterns with their stat text
                -- TBC socket bonuses are typically single stat, but handle edge cases
                local bonusText = text:match("Socket Bonus:%s*(.*)")
                if bonusText then
                    -- Map tooltip stat names to canonical stat names
                    local BONUS_STAT_MAP = {
                        ["Strength"]       = "STRENGTH",
                        ["Agility"]        = "AGILITY",
                        ["Stamina"]        = "STAMINA",
                        ["Intellect"]      = "INTELLECT",
                        ["Spirit"]         = "SPIRIT",
                        ["Spell Damage"]   = "SPELL_POWER",
                        ["Spell Power"]    = "SPELL_POWER",
                        ["Healing"]        = "HEAL_POWER",
                        ["Attack Power"]   = "ATTACK_POWER",
                        ["Hit Rating"]     = "HIT_RATING",
                        ["Critical Strike Rating"] = "CRIT_RATING",
                        ["Crit Rating"]    = "CRIT_RATING",
                        ["Haste Rating"]   = "HASTE_RATING",
                        ["Defense Rating"] = "DEFENSE",
                        ["Dodge Rating"]   = "DODGE",
                        ["Parry Rating"]   = "PARRY",
                        ["Resilience Rating"] = "RESILIENCE",
                        ["Resilience"]     = "RESILIENCE",
                        ["Block Rating"]   = "BLOCK_RATING",
                        ["Block Value"]    = "BLOCK_VALUE",
                        ["Expertise Rating"] = "EXPERTISE",
                        ["Spell Penetration"] = "SPELL_PEN",
                        ["Mana every 5 Sec."] = "MP5",
                        ["Mana every 5 sec."] = "MP5",
                        ["mana per 5 sec."]   = "MP5",
                        ["mana per 5 Sec."]   = "MP5",
                        ["Spell Damage and Healing"] = "SPELL_POWER",
                    }

                    -- Match patterns like "+4 Intellect", "+3 Spell Damage"
                    for val, statName in bonusText:gmatch("%+(%d+)%s+([%a%s%.]+)") do
                        -- Trim trailing whitespace/punctuation
                        statName = statName:match("^(.-)%s*$")
                        local canonical = BONUS_STAT_MAP[statName]
                        if canonical then
                            stats[canonical] = (stats[canonical] or 0) + tonumber(val)
                        else
                            addon:DebugPrint("ParseSocketBonus: unmapped bonus stat '" .. statName .. "' = " .. val .. " on " .. tostring(itemLink))
                        end
                    end
                end
                break  -- Only one socket bonus line per item
            end
        end
    end

    return stats
end

--- Get socket bonus stats for an item if the bonus is active (all sockets matched).
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

    -- Bonus is active — parse the stats from tooltip
    return ParseSocketBonusFromTooltip(itemLink)
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

    -- Add socket bonus stats (if all gems match their socket colors)
    local socketBonusStats = self:GetSocketBonusStats(itemLink, parsed.gems)
    for stat, value in pairs(socketBonusStats) do
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
    local itemSocketBonusStats = {} -- Cache per-item socket bonus stats for breakdown

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
            itemSocketBonusStats[slotID] = self:GetSocketBonusStats(itemLink, parsed.gems)
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

    -- Compute per-category breakdown (gems, enchants, procs, socket bonuses scored separately)
    local gemScoreRaw = 0
    local enchantScoreRaw = 0
    local procScoreRaw = 0
    local socketBonusScoreRaw = 0
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
        local sbs = itemSocketBonusStats[slotID]
        if sbs then
            for stat, value in pairs(sbs) do
                local weight = effectiveWeights[stat] or 0
                socketBonusScoreRaw = socketBonusScoreRaw + (value * weight)
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
    local scaledSocketBonuses = math.floor(math.max(0, socketBonusScoreRaw) * scale)
    local scaledBase = totalScore - scaledGems - scaledEnchants - scaledProcs - scaledSetBonus - scaledSocketBonuses

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
            socketBonuses = scaledSocketBonuses,
        },
    }
end
