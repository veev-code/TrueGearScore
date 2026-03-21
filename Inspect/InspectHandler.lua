---------------------------------------------------------------------------
-- TrueGearScore Inspect Handler
-- Hooks INSPECT_READY to capture full item links (with gems/enchants)
-- from other players. Queues inspect requests to avoid flooding.
--
-- Key: We hook INSPECT_READY directly, NOT LibClassicInspector's cache,
-- because LCI only stores item IDs (no gem/enchant data).
-- GetInventoryItemLink(unit, slot) during active inspect gives full links.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("InspectHandler", M)

local C = addon.Constants

-- Inspect queue and state
M.inspectQueue = {}      -- { unit1, unit2, ... }
M.inspecting = false     -- Currently waiting for INSPECT_READY
M.inspectUnit = nil      -- Unit we're currently inspecting
M.inspectGUID = nil      -- GUID of unit we're inspecting
M.lastInspectTime = 0    -- Throttle: minimum 1.5s between inspects
M.callbacks = {}         -- { [guid] = { func1, func2, ... } }

local INSPECT_THROTTLE = 1.5  -- Seconds between NotifyInspect calls

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("INSPECT_READY")
    eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
    eventFrame:SetScript("OnEvent", function(_, event, arg1)
        if event == "INSPECT_READY" then
            self:OnInspectReady(arg1)
        elseif event == "UNIT_INVENTORY_CHANGED" then
            if arg1 and UnitIsPlayer(arg1) and not UnitIsUnit(arg1, "player") then
                local guid = UnitGUID(arg1)
                if guid then
                    addon.ScoreCache:Invalidate(guid)
                end
            end
        end
    end)

    -- Background inspect ticker (same pattern as LibClassicInspector)
    -- Every 1.5s: try target, then queue, then cycle party/raid members
    C_Timer.NewTicker(1.5, function()
        self:InspectTick()
    end)
end

---------------------------------------------------------------------------
-- Background inspect ticker
---------------------------------------------------------------------------

function M:InspectTick()
    if InCombatLockdown() then return end
    if self.inspecting then return end

    -- Priority 1: current target
    if UnitExists("target") and self:TryProactiveInspect("target") then
        return
    end

    -- Priority 2: mouseover (if hovering)
    if UnitExists("mouseover") and self:TryProactiveInspect("mouseover") then
        return
    end

    -- Priority 3: process manual queue
    if #self.inspectQueue > 0 then
        self:ProcessQueue()
        return
    end

    -- Priority 4: cycle through group members
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            if self:TryProactiveInspect("raid" .. i) then return end
        end
    elseif IsInGroup() then
        for i = 1, GetNumGroupMembers() - 1 do
            if self:TryProactiveInspect("party" .. i) then return end
        end
    end
end

--- Try to queue an inspect for a unit. Returns true if queued.
function M:TryProactiveInspect(unit)
    if not UnitExists(unit) or not UnitIsPlayer(unit) or UnitIsUnit(unit, "player") then
        return false
    end
    if not CanInspect(unit) then return false end

    local guid = UnitGUID(unit)
    if not guid then return false end
    if addon.ScoreCache:Get(guid) then return false end  -- Already cached

    self:QueueInspect(unit, guid)
    return true
end

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

--- Request a score for a unit. Returns cached score if available,
--- otherwise queues an inspect and calls callback when done.
-- @param unit      Unit token (e.g., "target", "mouseover")
-- @param callback  Optional function(guid, score, entry) called when score is ready
-- @return table or nil  Cached score entry if immediately available
function M:RequestScore(unit)
    if not unit or not UnitIsPlayer(unit) or UnitIsUnit(unit, "player") then
        return nil
    end

    local guid = UnitGUID(unit)
    if not guid then return nil end

    -- Check cache first
    local cached = addon.ScoreCache:Get(guid)
    if cached then
        return cached
    end

    -- Can we inspect this unit?
    if not CanInspect(unit) then
        return nil
    end

    -- Queue the inspect
    self:QueueInspect(unit, guid)
    return nil
end

--- Register a one-shot callback for when a GUID's score becomes available.
-- @param guid      Player GUID
-- @param callback  function(guid, score, cacheEntry)
function M:RegisterCallback(guid, callback)
    if not self.callbacks[guid] then
        self.callbacks[guid] = {}
    end
    self.callbacks[guid][#self.callbacks[guid] + 1] = callback
end

---------------------------------------------------------------------------
-- Inspect queue management
---------------------------------------------------------------------------

function M:QueueInspect(unit, guid)
    -- Don't double-queue
    if self.inspectGUID == guid then return end
    for _, entry in ipairs(self.inspectQueue) do
        if entry.guid == guid then return end
    end

    self.inspectQueue[#self.inspectQueue + 1] = { unit = unit, guid = guid }
    self:ProcessQueue()
end

function M:ProcessQueue()
    if self.inspecting then return end
    if #self.inspectQueue == 0 then return end

    local now = GetTime()
    if (now - self.lastInspectTime) < INSPECT_THROTTLE then
        -- Wait and retry
        C_Timer.After(INSPECT_THROTTLE - (now - self.lastInspectTime) + 0.1, function()
            self:ProcessQueue()
        end)
        return
    end

    local entry = table.remove(self.inspectQueue, 1)
    if not entry then return end

    -- Verify unit is still valid and in range
    if not UnitIsPlayer(entry.unit) or not CanInspect(entry.unit) then
        -- Skip this one, try next
        self:ProcessQueue()
        return
    end

    -- Verify GUID still matches (unit token may have changed target)
    if UnitGUID(entry.unit) ~= entry.guid then
        self:ProcessQueue()
        return
    end

    self.inspecting = true
    self.inspectUnit = entry.unit
    self.inspectGUID = entry.guid
    self.lastInspectTime = now

    addon:DebugPrint("InspectHandler: NotifyInspect(" .. entry.unit .. ") guid=" .. entry.guid)
    NotifyInspect(entry.unit)

    -- Safety timeout: if INSPECT_READY never fires, reset after 5s
    C_Timer.After(5, function()
        if self.inspecting and self.inspectGUID == entry.guid then
            addon:DebugPrint("InspectHandler: Inspect timeout for " .. entry.guid)
            self.inspecting = false
            self.inspectUnit = nil
            self.inspectGUID = nil
            self:ProcessQueue()
        end
    end)
end

---------------------------------------------------------------------------
-- INSPECT_READY handler
---------------------------------------------------------------------------

function M:OnInspectReady(guid)
    if not self.inspecting then return end

    -- Anniversary Edition may pass various arg types for guid
    -- Accept the event if we're actively inspecting
    local targetGUID = self.inspectGUID
    if not targetGUID then
        self.inspecting = false
        self:ProcessQueue()
        return
    end

    addon:DebugPrint("InspectHandler: INSPECT_READY, targetGUID=" .. tostring(targetGUID))

    -- Find the unit token for this GUID.
    -- Try the original unit token first (nameplate indices can shift between
    -- NotifyInspect and INSPECT_READY, so checking the stored token first
    -- avoids a scan miss).
    local unit = nil
    if self.inspectUnit and UnitGUID(self.inspectUnit) == targetGUID then
        unit = self.inspectUnit
    end

    if not unit then
        for _, testUnit in ipairs({"target", "mouseover", "focus", "party1", "party2", "party3", "party4",
            "raid1","raid2","raid3","raid4","raid5","raid6","raid7","raid8","raid9","raid10",
            "raid11","raid12","raid13","raid14","raid15","raid16","raid17","raid18","raid19","raid20",
            "raid21","raid22","raid23","raid24","raid25"}) do
            if UnitGUID(testUnit) == targetGUID then
                unit = testUnit
                break
            end
        end
    end

    -- Also scan nameplates (nameplate1 through nameplate40)
    if not unit then
        for i = 1, 40 do
            local testUnit = "nameplate" .. i
            if UnitGUID(testUnit) == targetGUID then
                unit = testUnit
                break
            end
        end
    end

    if not unit then
        addon:DebugPrint("InspectHandler: Could not find unit for GUID " .. targetGUID)
        self.inspecting = false
        self.inspectUnit = nil
        self.inspectGUID = nil
        self:ProcessQueue()
        return
    end

    addon:DebugPrint("InspectHandler: Found unit=" .. unit .. " for GUID=" .. targetGUID)

    -- Capture full item links (with gems/enchants!)
    local equippedItems = {}
    local itemCount = 0
    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink(unit, slotID)
        if itemLink then
            equippedItems[slotID] = itemLink
            itemCount = itemCount + 1
        end
    end

    addon:Log("DIAG", "InspectHandler: Captured " .. itemCount .. " items from " .. unit)

    if itemCount > 0 then
        -- Detect their spec
        local specKey = self:DetectInspectSpec(unit, targetGUID)

        -- Score them
        local result = addon.ItemScoring:ScoreCharacter(equippedItems, specKey)

        -- Cache the result
        addon.ScoreCache:Set(targetGUID, {
            score = result.totalScore,
            perSlot = result.perSlot,
            source = "inspect",
            specKey = specKey,
            baseScore = result.baseOnlyScore,
        })

        addon:Log("DIAG", "InspectHandler: Scored " .. result.totalScore .. " for " .. tostring(specKey) .. " (raw=" .. result.rawScore .. " base=" .. result.baseOnlyRaw .. ")")

        -- Fire callbacks
        self:FireCallbacks(targetGUID, result.totalScore)
    else
        addon:DebugPrint("InspectHandler: No items captured! GetInventoryItemLink returned nil for all slots")
    end

    -- Reset state and process next in queue
    self.inspecting = false
    self.inspectUnit = nil
    self.inspectGUID = nil
    ClearInspectPlayer()
    self:ProcessQueue()
end

---------------------------------------------------------------------------
-- Spec detection for inspected players
---------------------------------------------------------------------------

function M:DetectInspectSpec(unit, guid)
    local _, class = GetPlayerInfoByGUID(guid)
    if not class then return nil end

    -- Try LibClassicInspector first (TacoTip bundles it, most reliable)
    local CI = LibStub and LibStub:GetLibrary("LibClassicInspector", true)
    if CI and CI.GetSpecialization then
        local specIndex = CI:GetSpecialization(guid)
        if specIndex and specIndex > 0 then
            local specMap = C.SPEC_MAP[class]
            local specKey = specMap and specMap[specIndex] or (class .. "_UNKNOWN")
            addon:Log("DIAG", "InspectHandler: Spec via LibClassicInspector: " .. specKey .. " (index=" .. specIndex .. ")")
            return specKey
        end
    end

    -- Fallback: try GetTalentTabInfo with inspect flag
    -- NOTE: This returns OUR talents in Anniversary Edition, not the target's.
    -- Keeping as fallback in case LCI isn't available.
    local points = {}
    local numTabs = 3
    local usingInspectAPI = false

    -- Try multiple API signatures
    for i = 1, numTabs do
        local ok, _, _, pointsSpent = pcall(GetTalentTabInfo, i, true, false)
        if ok then
            points[i] = tonumber(pointsSpent) or 0
            usingInspectAPI = true
        end
    end

    if not usingInspectAPI then
        for i = 1, numTabs do
            local _, _, pointsSpent = GetTalentTabInfo(i, true)
            points[i] = tonumber(pointsSpent) or 0
        end
    end

    addon:Log("DIAG", "InspectHandler: Talent API fallback " .. class .. " talents=" .. (points[1] or 0) .. "/" .. (points[2] or 0) .. "/" .. (points[3] or 0) .. " (WARNING: may be player's own talents)")

    local maxTree, maxPoints = 1, 0
    for i = 1, 3 do
        if (points[i] or 0) > maxPoints then
            maxTree = i
            maxPoints = points[i]
        end
    end

    local specMap = C.SPEC_MAP[class]
    local specKey = specMap and specMap[maxTree] or (class .. "_UNKNOWN")
    addon:Log("DIAG", "InspectHandler: Detected spec " .. specKey .. " for " .. tostring(class))
    return specKey
end

---------------------------------------------------------------------------
-- Callback management
---------------------------------------------------------------------------

function M:FireCallbacks(guid, score)
    local cbs = self.callbacks[guid]
    if not cbs then return end

    local entry = addon.ScoreCache:Get(guid)
    for _, cb in ipairs(cbs) do
        local ok, err = pcall(cb, guid, score, entry)
        if not ok then
            addon:DebugPrint("InspectHandler: Callback error: " .. tostring(err))
        end
    end

    self.callbacks[guid] = nil
end
