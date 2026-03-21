---------------------------------------------------------------------------
-- TrueGearScore Unit Tooltip
-- Shows TrueGearScore on player unit tooltips (mouseover, target, etc.)
-- For self: reads directly from SelfScanner (instant).
-- For others: checks ScoreCache, then requests inspect if needed.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("UnitTooltip", M)


---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
        self:OnTooltipSetUnit(tooltip)
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

function M:OnTooltipSetUnit(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local guid = UnitGUID(unit)
    if not guid then return end

    -- Don't add if already present
    if self:HasScoreLine(tooltip) then return end

    -- Self: use SelfScanner directly
    if UnitIsUnit(unit, "player") then
        local selfScanner = addon:GetModule("SelfScanner")
        if selfScanner and selfScanner.currentScore and selfScanner.currentScore > 0 then
            self:AddScoreLine(tooltip, selfScanner.currentScore)
        end
        return
    end

    -- Others: check cache
    local cached = addon.ScoreCache:Get(guid)
    if cached then
        self:AddScoreLine(tooltip, cached.score, cached.source)
        return
    end

    -- No cached score — request inspect
    local inspectHandler = addon:GetModule("InspectHandler")
    if inspectHandler then
        inspectHandler:RequestScore(unit)
        tooltip:AddLine("TrueGearScore: ...", 0.53, 0.53, 0.53)
    end
end

---------------------------------------------------------------------------
-- Add score line to tooltip
---------------------------------------------------------------------------

function M:AddScoreLine(tooltip, score, source)
    if not score or score <= 0 then return end

    local r, g, b = addon.ScoreColors:GetColor(score)
    local sourceTag = ""
    if source == "broadcast" then
        sourceTag = "~"
    end

    tooltip:AddLine("TrueGearScore: " .. sourceTag .. tostring(score), r, g, b)
end
