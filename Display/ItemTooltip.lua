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
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
        self:OnTooltipSetItem(tooltip)
    end)
end

---------------------------------------------------------------------------
-- Check if we already added our line to the tooltip
---------------------------------------------------------------------------

function M:HasScoreLine(tooltip)
    for i = 1, tooltip:NumLines() do
        local left = _G["GameTooltipTextLeft" .. i]
        if left then
            local text = left:GetText()
            if text and text:match("^TrueGearScore") then
                return true
            end
        end
    end
    return false
end

---------------------------------------------------------------------------
-- Tooltip hook
---------------------------------------------------------------------------

function M:OnTooltipSetItem(tooltip)
    if not addon.db.profile.showItemTooltip then return end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    -- Only show for equippable items (GetItemInfo slot 9 = equipLoc)
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    if not equipLoc or equipLoc == "" then return end

    -- Duplicate prevention
    if self:HasScoreLine(tooltip) then return end

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
        tooltip:AddLine("TrueGearScore: " .. tostring(score), r, g, b)
        tooltip:Show()
    end
end
