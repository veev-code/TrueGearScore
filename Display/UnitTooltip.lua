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
-- Tooltip hook
---------------------------------------------------------------------------

function M:OnTooltipSetUnit(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local guid = UnitGUID(unit)
    if not guid then return end

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
        local immediate = inspectHandler:RequestScore(unit)
        if immediate then
            self:AddScoreLine(tooltip, immediate.score, immediate.source)
        else
            -- Register callback to update tooltip when inspect completes
            inspectHandler:RegisterCallback(guid, function(cbGuid, score, entry)
                -- Tooltip may have changed by now — verify it still shows this unit
                local _, currentUnit = GameTooltip:GetUnit()
                if currentUnit and UnitGUID(currentUnit) == cbGuid then
                    self:AddScoreLine(GameTooltip, score, entry and entry.source)
                    GameTooltip:Show()  -- Refresh tooltip to display new line
                end
            end)
        end
    end
end

---------------------------------------------------------------------------
-- Add score line to tooltip
---------------------------------------------------------------------------

function M:AddScoreLine(tooltip, score, source)
    if not score or score <= 0 then return end

    local r, g, b = addon.ScoreColors:GetColor(score)
    local label = addon.ScoreColors:GetBracketLabel(score)
    local sourceTag = ""
    if source == "broadcast" then
        sourceTag = " ~"  -- Tilde indicates unverified (addon broadcast, not inspect)
    end

    tooltip:AddDoubleLine(
        "TrueGearScore",
        tostring(score) .. " (" .. label .. ")" .. sourceTag,
        0.53, 0.53, 0.53,  -- Left text: grey
        r, g, b             -- Right text: bracket color
    )
end
