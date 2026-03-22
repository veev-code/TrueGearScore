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

function M:Refresh()
    -- No cached state to update; reads addon.db.profile directly
end

---------------------------------------------------------------------------
-- Tooltip hook
---------------------------------------------------------------------------

function M:OnTooltipSetUnit(tooltip)
    if not addon.db.profile.showUnitTooltip then return end

    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local guid = UnitGUID(unit)
    if not guid then return end

    -- Don't add if already present
    if addon.ScoreColors:HasScoreLine(tooltip) then return end

    -- Self: use SelfScanner directly
    if UnitIsUnit(unit, "player") then
        local selfScanner = addon:GetModule("SelfScanner")
        if selfScanner and selfScanner.currentScore and selfScanner.currentScore > 0 then
            self:AddScoreLine(tooltip, selfScanner.currentScore, nil, selfScanner.efficiency)
            if IsShiftKeyDown() and selfScanner.breakdown then
                self:AddBreakdownLines(tooltip, selfScanner.breakdown)
            end
        end
        return
    end

    -- Others: check cache
    local cached = addon.ScoreCache:Get(guid)
    if cached then
        self:AddScoreLine(tooltip, cached.score, cached.source, cached.efficiency)
        if IsShiftKeyDown() and cached.breakdown then
            self:AddBreakdownLines(tooltip, cached.breakdown)
        end
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

function M:AddScoreLine(tooltip, score, source, efficiency)
    if not score or score <= 0 then return end

    local r, g, b = addon.ScoreColors:GetColor(score)
    local sourceTag = ""
    if source == "broadcast" then
        sourceTag = "~"
    end

    -- Show efficiency percentage when available (inspect/self sources only)
    local effSuffix = ""
    if efficiency and efficiency > 0 then
        effSuffix = " (" .. tostring(efficiency) .. "%)"
    end

    tooltip:AddLine("TrueGearScore: " .. sourceTag .. tostring(score) .. effSuffix, r, g, b)
end

---------------------------------------------------------------------------
-- Add breakdown lines to tooltip (shift-hover detail)
---------------------------------------------------------------------------

local BREAKDOWN_CATEGORIES = {
    { key = "base",           label = "Base Stats" },
    { key = "gems",           label = "Gems" },
    { key = "enchants",       label = "Enchants" },
    { key = "procs",          label = "Procs" },
    { key = "setBonuses",     label = "Set Bonuses" },
    { key = "socketBonuses",  label = "Socket Bonuses" },
}

function M:AddBreakdownLines(tooltip, breakdown)
    for _, cat in ipairs(BREAKDOWN_CATEGORIES) do
        local value = breakdown[cat.key]
        if value and value > 0 then
            tooltip:AddLine("  " .. cat.label .. ": +" .. tostring(value), 0.62, 0.62, 0.62)
        end
    end
end
