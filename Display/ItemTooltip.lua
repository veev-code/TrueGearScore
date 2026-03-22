---------------------------------------------------------------------------
-- TrueGearScore Item Tooltip
-- Shows per-item TrueGearScore on item mouseover tooltips.
-- Default OFF — enable via addon.db.profile.showItemTooltip.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("ItemTooltip", M)

---------------------------------------------------------------------------
-- equipLoc → slot ID mapping
-- Dual-slot types (finger, trinket) map to a table of two slot IDs.
---------------------------------------------------------------------------

local EQUIPLOC_TO_SLOT = {
    INVTYPE_HEAD            = 1,
    INVTYPE_NECK            = 2,
    INVTYPE_SHOULDER        = 3,
    INVTYPE_CHEST           = 5,
    INVTYPE_ROBE            = 5,
    INVTYPE_WAIST           = 6,
    INVTYPE_LEGS            = 7,
    INVTYPE_FEET            = 8,
    INVTYPE_WRIST           = 9,
    INVTYPE_HAND            = 10,
    INVTYPE_FINGER          = { 11, 12 },
    INVTYPE_TRINKET         = { 13, 14 },
    INVTYPE_CLOAK           = 15,
    INVTYPE_WEAPONMAINHAND  = 16,
    INVTYPE_2HWEAPON        = 16,
    INVTYPE_WEAPON          = 16,
    INVTYPE_WEAPONOFFHAND   = 17,
    INVTYPE_SHIELD          = 17,
    INVTYPE_HOLDABLE        = 17,
    INVTYPE_RANGED          = 18,
    INVTYPE_RANGEDRIGHT     = 18,
    INVTYPE_THROWN           = 18,
    INVTYPE_RELIC           = 18,
}

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    self.enabled = addon.db.profile.showItemTooltip

    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
        self:OnTooltipSetItem(tooltip)
    end)
end

function M:Refresh()
    self.enabled = addon.db.profile.showItemTooltip
end

---------------------------------------------------------------------------
-- Tooltip hook
---------------------------------------------------------------------------

function M:OnTooltipSetItem(tooltip)
    if not self.enabled then return end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    -- Only show for equippable items (GetItemInfo slot 9 = equipLoc)
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    if not equipLoc or equipLoc == "" then return end

    -- Duplicate prevention
    if addon.ScoreColors:HasScoreLine(tooltip) then return end

    -- Get effective weights from SelfScanner (cap-aware), fall back to raw spec weights
    local selfScanner = addon:GetModule("SelfScanner")
    local effectiveWeights = selfScanner and selfScanner:GetEffectiveWeights()

    if not effectiveWeights or not next(effectiveWeights) then
        -- Fallback: use raw spec weights if SelfScanner hasn't run yet
        if addon.playerSpec and addon.StatWeights then
            local specData = addon.StatWeights:GetSpecWeights(addon.playerSpec)
            if specData then
                effectiveWeights = specData
            end
        end
    end

    if not effectiveWeights or not next(effectiveWeights) then return end

    local score = addon.ItemScoring:ScoreItem(itemLink, effectiveWeights)
    if score and score > 0 then
        local r, g, b = addon.ScoreColors:GetColor(score)

        -- Compute delta vs currently equipped item in that slot
        local deltaText = self:GetDeltaText(equipLoc, score, effectiveWeights, selfScanner)

        local line = "TrueGearScore: " .. tostring(score)
        if deltaText then
            line = line .. "  " .. deltaText
        end

        tooltip:AddLine(line, r, g, b)
    end
end

---------------------------------------------------------------------------
-- Compute upgrade/downgrade delta text
---------------------------------------------------------------------------

function M:GetDeltaText(equipLoc, newScore, effectiveWeights, selfScanner)
    if not selfScanner then return nil end

    local equippedItems = selfScanner:GetEquippedItems()
    if not equippedItems then return nil end

    local slotMapping = EQUIPLOC_TO_SLOT[equipLoc]
    if not slotMapping then return nil end

    local equippedScore

    if type(slotMapping) == "table" then
        -- Dual-slot (finger/trinket): compare against the lower-scoring equipped item
        local scores = {}
        local hasAny = false
        for _, slotID in ipairs(slotMapping) do
            local link = equippedItems[slotID]
            if link then
                local s = addon.ItemScoring:ScoreItem(link, effectiveWeights)
                scores[#scores + 1] = s
                hasAny = true
            end
        end
        if not hasAny then
            return "|cff00ff00(new)|r"
        end
        -- Pick the lower score — the new item would replace the weaker one
        table.sort(scores)
        equippedScore = scores[1]
    else
        -- Single slot
        local link = equippedItems[slotMapping]
        if not link then
            return "|cff00ff00(new)|r"
        end
        equippedScore = addon.ItemScoring:ScoreItem(link, effectiveWeights)
    end

    if not equippedScore then return nil end

    local delta = newScore - equippedScore
    if delta > 0 then
        return "|cff00ff00(+" .. delta .. " upgrade)|r"
    elseif delta < 0 then
        return "|cffff4444(" .. delta .. " downgrade)|r"
    else
        return "|cff888888(same)|r"
    end
end
