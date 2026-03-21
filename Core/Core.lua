local ADDON_NAME, addon = ...
_G.TrueGearScore = addon
addon.name = ADDON_NAME
addon.version = nil
addon.modules = {}
addon.playerClass = nil
addon.playerGUID = nil
addon.playerSpec = nil

local C = addon.Constants

---------------------------------------------------------------------------
-- Module registry
---------------------------------------------------------------------------

function addon:RegisterModule(name, module)
    self.modules[name] = module
    module.addon = self
    module.name = name
end

function addon:GetModule(name)
    return self.modules[name]
end

function addon:InitializeModules()
    for name, module in pairs(self.modules) do
        if module.Initialize then
            local ok, err = pcall(module.Initialize, module)
            if not ok then
                self:PrintError("Failed to initialize module " .. name .. ": " .. tostring(err))
            end
        end
    end
end

---------------------------------------------------------------------------
-- Logging (persists to TrueGearScoreLog SavedVariable)
-- Follows VeevHUD Logger pattern: structured entries, session tracking
---------------------------------------------------------------------------

local MAX_LOG_ENTRIES = 500

local function GetLog()
    TrueGearScoreLog = TrueGearScoreLog or { entries = {}, session = 0 }
    return TrueGearScoreLog
end

function addon:Log(level, msg)
    local log = GetLog()
    log.entries[#log.entries + 1] = {
        time = date("%H:%M:%S"),
        level = level,
        msg = tostring(msg),
        session = log.session,
    }
    while #log.entries > MAX_LOG_ENTRIES do
        table.remove(log.entries, 1)
    end
end

function addon:StartNewSession()
    -- Clear old entries so SavedVariables only contains current session
    TrueGearScoreLog = nil
    local log = GetLog()
    log.session = (log.session or 0) + 1
    self:Log("INFO", "=== Session " .. log.session .. " started ===")
    self:Log("INFO", "Player: " .. (UnitName("player") or "?") .. " Class: " .. tostring(self.playerClass))
    self:Log("INFO", "Game version: " .. (GetBuildInfo() or "?"))
end

function addon:ClearLog()
    TrueGearScoreLog = nil
    self:Print("Log cleared.")
end

function addon:PrintRecentLog(count)
    local log = TrueGearScoreLog
    if not log or not log.entries or #log.entries == 0 then
        self:Print("No log entries. Run |cff00ff00/tgs diag|r to generate diagnostic data.")
        return
    end
    count = count or 30
    self:Print("Log (last " .. count .. " entries):")
    local start = math.max(1, #log.entries - count + 1)
    for i = start, #log.entries do
        local e = log.entries[i]
        local color = "|cffffffff"
        if e.level == "ERROR" then color = "|cffff0000"
        elseif e.level == "DEBUG" then color = "|cff888888"
        elseif e.level == "DIAG" then color = "|cffffff00" end
        DEFAULT_CHAT_FRAME:AddMessage(string.format("  %s[%s] %s: %s|r", color, e.time, e.level, e.msg))
    end
end

---------------------------------------------------------------------------
-- Chat output
---------------------------------------------------------------------------

function addon:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffTrueGearScore:|r " .. tostring(msg))
end

function addon:PrintError(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff4444TrueGearScore:|r " .. tostring(msg))
end

function addon:DebugPrint(msg)
    if self.db and self.db.profile.debugMode then
        DEFAULT_CHAT_FRAME:AddMessage("|cff888888TGS Debug:|r " .. tostring(msg))
    end
    self:Log("DEBUG", msg)
end

--- Print to chat AND write to diagnostic log
function addon:DiagPrint(msg)
    self:Print(msg)
    self:Log("DIAG", msg)
end

---------------------------------------------------------------------------
-- API Discovery: test what runtime APIs give us for gems, enchants, sets
-- Results logged to TrueGearScoreLog. Remove after discovery is complete.
---------------------------------------------------------------------------

function addon:RunAPIDiscovery()
    self:Log("DIAG", "=== API DISCOVERY v2 START ===")

    local C = addon.Constants

    -- TEST: GetItemInfo return value #16 = setID, then GetItemSetInfo(setID) = setName
    self:Log("DIAG", "=== SET DETECTION VIA GetItemInfo ===")
    local setsFound = {}  -- setID => { name, pieces = { slotID => itemID } }

    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            -- GetItemInfo has many return values; #16 might be setID in TBC
            local results = { GetItemInfo(itemLink) }
            local itemName = results[1]
            local numResults = #results

            -- Try to find setID — it might be at different positions
            -- Log all return values for one item so we can find it
            if slotID == 1 then  -- Just log fully for first slot
                self:Log("DIAG", "GetItemInfo return count for slot 1: " .. numResults)
                for ri = 1, numResults do
                    local val = results[ri]
                    if val ~= nil and val ~= "" then
                        self:Log("DIAG", "  [" .. ri .. "] = " .. tostring(val) .. " (" .. type(val) .. ")")
                    end
                end
            end

            -- In retail, return #16 is setID. Test various positions.
            -- Also try itemEquipLoc at #9, itemSetID might be somewhere around #16-17
            for _, idx in ipairs({15, 16, 17}) do
                local val = results[idx]
                if val and type(val) == "number" and val > 0 and val < 10000 then
                    local setName = GetItemSetInfo and GetItemSetInfo(val)
                    if setName then
                        self:Log("DIAG", "  Slot " .. slotID .. ": " .. tostring(itemName) .. " → setID=" .. val .. " at index " .. idx .. " → setName=" .. tostring(setName))
                        if not setsFound[val] then
                            setsFound[val] = { name = setName, pieces = {} }
                        end
                        setsFound[val].pieces[slotID] = true
                    end
                end
            end
        end
    end

    -- Summarize sets found
    for setID, info in pairs(setsFound) do
        local count = 0
        for _ in pairs(info.pieces) do count = count + 1 end
        self:Log("DIAG", "SET: " .. info.name .. " (ID=" .. setID .. ") — " .. count .. " pieces equipped")
    end

    if not next(setsFound) then
        self:Log("DIAG", "No sets found via GetItemInfo/GetItemSetInfo path")
    end

    -- TEST: Tooltip scanning for set bonus text (already proven to work)
    self:Log("DIAG", "=== SET BONUSES VIA TOOLTIP ===")
    if not self.scanTooltip then
        self.scanTooltip = CreateFrame("GameTooltip", "TGSScanTooltip", nil, "GameTooltipTemplate")
        self.scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    end

    local seenSets = {}
    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            local tip = self.scanTooltip
            tip:ClearLines()
            tip:SetHyperlink(itemLink)
            for li = 1, tip:NumLines() do
                local left = _G["TGSScanTooltipTextLeft" .. li]
                if left then
                    local text = left:GetText() or ""
                    local r, g, b = left:GetTextColor()
                    -- Log set name lines and bonus lines
                    local setName, cur, total = text:match("^(.+) %((%d+)/(%d+)%)$")
                    if setName and not seenSets[setName] then
                        seenSets[setName] = true
                        self:Log("DIAG", "SET TOOLTIP: " .. setName .. " (" .. cur .. "/" .. total .. ") — slot " .. slotID)
                    end
                    -- Set bonus lines: "(2) Set: ..." or "Set: ..."
                    local bonusCount, bonusText = text:match("^%((%d+)%) Set: (.+)")
                    if bonusCount then
                        self:Log("DIAG", "  BONUS (" .. bonusCount .. "pc): " .. bonusText)
                        -- Log the text color (green = inactive, grey = inactive, gold = active?)
                        self:Log("DIAG", "    color: r=" .. string.format("%.2f", r) .. " g=" .. string.format("%.2f", g) .. " b=" .. string.format("%.2f", b))
                    end
                    -- Also catch "Set: ..." without number prefix (some sets)
                    if text:match("^Set: ") and not bonusCount then
                        self:Log("DIAG", "  BONUS (unnumbered): " .. text)
                        self:Log("DIAG", "    color: r=" .. string.format("%.2f", r) .. " g=" .. string.format("%.2f", g) .. " b=" .. string.format("%.2f", b))
                    end
                end
            end
        end
    end

    self:Log("DIAG", "=== API DISCOVERY v2 END ===")
    self:Print("API discovery v2 logged. /reload to flush, then check SavedVariables.")
end

---------------------------------------------------------------------------
-- Spec detection via talent tree inspection
---------------------------------------------------------------------------

function addon:DetectSpec()
    local class = self.playerClass
    if not class then return end

    local points = {}
    for i = 1, GetNumTalentTabs() do
        local _, _, pointsSpent = GetTalentTabInfo(i)
        points[i] = tonumber(pointsSpent) or 0
    end

    local maxTree, maxPoints = 1, 0
    for i = 1, 3 do
        if (tonumber(points[i]) or 0) > maxPoints then
            maxTree = i
            maxPoints = points[i]
        end
    end

    local specMap = C.SPEC_MAP[class]
    self.playerSpec = specMap and specMap[maxTree] or (class .. "_UNKNOWN")
    self:DebugPrint("Detected spec: " .. self.playerSpec)
end

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")

local GetMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" then
        -- Anniversary Edition may pass addon index (number) or name (string)
        -- Accept either: match by name or skip non-matching addons
        if type(arg1) == "number" then
            -- arg1 is addon index, not name — just initialize on first ADDON_LOADED we see
            -- and check if our addon is loaded
            local loaded = C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(ADDON_NAME)
            if not loaded then return end
        elseif arg1 ~= ADDON_NAME then
            return
        end

        addon.version = (GetMetadata and GetMetadata(ADDON_NAME, "Version")) or "dev"

        addon.Database:Initialize()

        self:UnregisterEvent("ADDON_LOADED")

    elseif event == "PLAYER_LOGIN" then
        -- UnitClass/UnitGUID not reliably available until PLAYER_LOGIN
        addon.playerClass = select(2, UnitClass("player"))
        addon.playerGUID = UnitGUID("player")

        addon:StartNewSession()
        addon:DetectSpec()
        addon:InitializeModules()
        addon.SlashCommands:Register()
        addon:Print("v" .. addon.version .. " loaded. Type |cff00ff00/tgs|r for your score.")

        -- Trigger initial self-scan after a short delay (let equipment data load)
        -- Then auto-print score + breakdown to log for easy diagnosis
        C_Timer.After(1, function()
            local selfScanner = addon:GetModule("SelfScanner")
            if selfScanner then
                selfScanner:ScanEquipment()
            end

            -- Auto-print score to chat and log
            C_Timer.After(0.5, function()
                addon.SlashCommands:PrintScore()
                addon.SlashCommands:PrintBreakdown()
            end)

            -- Auto-run calibration (items may need caching, retry after delay)
            C_Timer.After(3, function()
                addon.SlashCommands:RunCalibration()
                -- Retry after longer delay for item caching
                C_Timer.After(10, function()
                    addon.SlashCommands:RunCalibration()
                end)
            end)
        end)

        self:UnregisterEvent("PLAYER_LOGIN")

    elseif event == "CHARACTER_POINTS_CHANGED" then
        addon:DetectSpec()
        -- Rescan since spec change affects weights
        local selfScanner = addon:GetModule("SelfScanner")
        if selfScanner and selfScanner.ScanEquipment then
            selfScanner:ScanEquipment()
        end
    end
end)
