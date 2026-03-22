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

-- Module init order is non-deterministic (pairs() over a hash table).
-- Modules must NOT depend on other modules being initialized first.
-- If a module needs another module, it should defer that access to a later
-- event (e.g., PLAYER_LOGIN callback) or use lazy lookup via addon:GetModule().
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
-- Logging (persists to TrueGearScoreLog SavedVariable when debugMode is on)
-- Follows VeevHUD Logger pattern: structured entries, session tracking,
-- SavedVariable writes gated behind debugMode.
---------------------------------------------------------------------------

local MAX_LOG_ENTRIES = 500

-- Check if debug mode is enabled (safe before DB init)
local function IsDebugMode()
    return addon.db and addon.db.profile and addon.db.profile.debugMode
end

-- Get log storage (only creates SavedVariables entry if debug mode is on)
local function GetLog()
    if not IsDebugMode() then
        return nil
    end
    TrueGearScoreLog = TrueGearScoreLog or { entries = {}, session = 0 }
    return TrueGearScoreLog
end

function addon:Log(level, msg)
    local log = GetLog()
    if not log then return end  -- Debug mode off, skip logging
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
    if not IsDebugMode() then return end
    -- Clear old entries so SavedVariables only contains current session
    TrueGearScoreLog = nil
    local log = GetLog()
    if not log then return end
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

-- Debug output: chat print AND SavedVariable log only when debugMode is on.
function addon:DebugPrint(msg)
    if self.db and self.db.profile.debugMode then
        DEFAULT_CHAT_FRAME:AddMessage("|cff888888TGS Debug:|r " .. tostring(msg))
        self:Log("DEBUG", msg)
    end
end

-- User-facing diagnostic output: always prints to chat (it's user-requested),
-- but only writes to SavedVariable log when debugMode is on.
function addon:DiagPrint(msg)
    self:Print(msg)
    self:Log("DIAG", msg)
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
        C_Timer.After(C.INITIAL_SCAN_DELAY, function()
            local selfScanner = addon:GetModule("SelfScanner")
            if selfScanner then
                selfScanner:ScanEquipment()
            end
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
