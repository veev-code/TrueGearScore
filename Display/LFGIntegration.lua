---------------------------------------------------------------------------
-- TrueGearScore LFG Integration
-- Soft-hooks LFGBulletinBoard (LFGBB) tooltips to show cached TrueGearScore
-- when hovering over player entries in the request list.
-- No hard dependency — silently does nothing if LFGBB is not loaded.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("LFGIntegration", M)

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    -- Soft dependency: only hook if LFGBB is loaded
    local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
    if not (IsAddOnLoaded and IsAddOnLoaded("LFGBulletinBoard")) then
        return
    end

    -- GBB global must exist (LFGBB's main table)
    if not GBB then return end

    addon:DebugPrint("LFGIntegration: LFGBB detected, hooking tooltips")
    self:HookEntryTooltips()
end

function M:Refresh()
    -- No cached state to update; reads addon.db.profile directly
end

---------------------------------------------------------------------------
-- Hook LFGBB entry tooltips
--
-- EntryFrameMixin:OnEnter builds a GameTooltip for request list entries.
-- We hook GameTooltip:Show so that after LFGBB finishes adding its lines,
-- we append a TrueGearScore line if we have a cached score for that player.
--
-- We track the "pending" request data via a secure post-hook on OnEnter
-- of each entry frame, rather than trying to hook the mixin directly
-- (which may not be accessible as an upvalue).
---------------------------------------------------------------------------

function M:HookEntryTooltips()
    -- Hook GameTooltip:Show — fires after LFGBB finishes building the tooltip.
    -- We check if the tooltip was built by an LFGBB entry by looking at the
    -- tooltip owner and whether we have stashed request data.
    self.pendingRequest = nil

    -- Use hooksecurefunc on GameTooltip Show to append our line
    hooksecurefunc(GameTooltip, "Show", function(tooltip)
        local request = self.pendingRequest
        if not request then return end

        -- Clear pending so we only fire once per OnEnter
        self.pendingRequest = nil

        self:AppendScoreLine(tooltip, request)
    end)

    -- Hook the scroll child's children as they're created.
    -- LFGBB creates entry frames parented to GroupBulletinBoardFrame_ScrollChildFrame.
    -- We hook OnEnter on each to stash the requestData before GameTooltip:Show fires.
    if GroupBulletinBoardFrame_ScrollChildFrame then
        hooksecurefunc(GroupBulletinBoardFrame_ScrollChildFrame, "SetPoint", function()
            -- Re-scan children whenever layout changes
            self:HookChildFrames()
        end)
        -- Also hook immediately for already-created frames
        self:HookChildFrames()
    end

    -- Additionally, hook the frame pool acquire path if possible.
    -- LFGBB uses CreateObjectPool; frames get OnEnter set via Mixin.
    -- We can hook GameTooltip_SetDefaultAnchor as a signal that an LFGBB
    -- tooltip is being built, but the simplest reliable approach is to
    -- hook OnEnter on each child frame of the scroll child.

    -- Weak-keyed table: allows GC of recycled LFGBB frames
    self.hookedFrames = setmetatable({}, {__mode = "k"})
end

function M:HookChildFrames()
    if not GroupBulletinBoardFrame_ScrollChildFrame then return end

    local children = { GroupBulletinBoardFrame_ScrollChildFrame:GetChildren() }
    for _, child in ipairs(children) do
        if child.requestData ~= nil and not self.hookedFrames[child] then
            self.hookedFrames[child] = true
            child:HookScript("OnEnter", function(frame)
                if frame.requestData then
                    self.pendingRequest = frame.requestData
                end
            end)
            child:HookScript("OnLeave", function()
                self.pendingRequest = nil
            end)
        end
    end
end

---------------------------------------------------------------------------
-- Append score line to LFGBB tooltip
---------------------------------------------------------------------------

function M:AppendScoreLine(tooltip, request)
    if not addon.db.profile.showLFGIntegration then return end
    if not request then return end

    -- Don't double-add
    if addon.ScoreColors:HasScoreLine(tooltip) then return end

    -- Try to find a cached score for this player
    local score, source = self:LookupScore(request)
    if not score or score <= 0 then return end

    local r, g, b = addon.ScoreColors:GetColor(score)
    local sourceTag = ""
    if source == "broadcast" then
        sourceTag = "~"
    end

    tooltip:AddLine("TrueGearScore: " .. sourceTag .. tostring(score), r, g, b)
    -- Defer Show() to avoid re-entrancy inside the tooltip hook
    C_Timer.After(0, function()
        if tooltip:IsShown() then
            tooltip:Show()  -- Resize tooltip to fit new line
        end
    end)
end

---------------------------------------------------------------------------
-- Score lookup: GUID from requestData, then ScoreCache
---------------------------------------------------------------------------

function M:LookupScore(request)
    -- LFGBB stores sender GUID directly on requestData
    local guid = request.guid
    if guid then
        local cached = addon.ScoreCache:Get(guid)
        if cached then
            return cached.score, cached.source
        end
    end

    -- Fallback: try to resolve name to GUID via unit iteration
    -- (only works if the player is nearby / in group)
    local name = request.name
    if name then
        local guid2 = self:GUIDFromName(name)
        if guid2 then
            local cached = addon.ScoreCache:Get(guid2)
            if cached then
                return cached.score, cached.source
            end
        end
    end

    return nil, nil
end

--- Attempt to resolve a player name to a GUID by checking common unit IDs.
function M:GUIDFromName(name)
    -- Check target, mouseover, party, raid
    local units = { "target", "mouseover" }
    for i = 1, 4 do units[#units + 1] = "party" .. i end
    for i = 1, 40 do units[#units + 1] = "raid" .. i end

    for _, unitID in ipairs(units) do
        if UnitExists(unitID) and UnitIsPlayer(unitID) then
            local unitName = UnitName(unitID)
            -- Match with or without realm suffix
            if unitName == name or (unitName and name:match("^(.+)-") == unitName) then
                return UnitGUID(unitID)
            end
        end
    end

    return nil
end
