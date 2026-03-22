---------------------------------------------------------------------------
-- TrueGearScore Addon Channel
-- Broadcasts the player's own score to GUILD/PARTY/RAID via AceComm-3.0.
-- Receives and caches scores from other TGS users.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
addon:RegisterModule("AddonChannel", M)

local C = addon.Constants

local COMM_PREFIX = "TGS"
local PROTOCOL_VERSION = 1
local BROADCAST_DEBOUNCE = 10  -- seconds between broadcasts
local SCORE_UPDATE_DELAY = 2   -- seconds to debounce OnScoreUpdated

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Anti-fake: per-GUID score history for rapid-change detection
local SCORE_CHANGE_THRESHOLD = 500  -- flag if score jumps by this much
local SCORE_CHANGE_WINDOW = 60      -- within this many seconds
local scoreHistory = {}              -- { [guid] = { score, timestamp } }

-- State
local lastBroadcastTime = 0
local scoreUpdateTimer = nil

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    AceComm.RegisterComm(self, COMM_PREFIX, function(prefix, message, distribution, sender)
        M:OnCommReceived(prefix, message, distribution, sender)
    end)

    -- Register events for broadcast triggers
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("GROUP_JOINED")
    eventFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_ENTERING_WORLD" then
            -- Delay to let score settle after login/reload
            C_Timer.After(5, function()
                M:BroadcastScore()
            end)
        elseif event == "GROUP_JOINED" then
            C_Timer.After(2, function()
                M:BroadcastScore()
            end)
        end
    end)
end

---------------------------------------------------------------------------
-- OnScoreUpdated callback (called by SelfScanner)
---------------------------------------------------------------------------

function M:OnScoreUpdated(score)
    -- Debounce: wait SCORE_UPDATE_DELAY seconds before broadcasting
    if scoreUpdateTimer then
        scoreUpdateTimer:Cancel()
    end
    scoreUpdateTimer = C_Timer.NewTimer(SCORE_UPDATE_DELAY, function()
        scoreUpdateTimer = nil
        M:BroadcastScore()
    end)
end

---------------------------------------------------------------------------
-- Broadcasting
---------------------------------------------------------------------------

function M:BroadcastScore()
    local now = GetTime()
    if (now - lastBroadcastTime) < BROADCAST_DEBOUNCE then
        return
    end

    local selfScanner = addon:GetModule("SelfScanner")
    if not selfScanner then return end

    local score = selfScanner:GetScore()
    if not score or score <= 0 then return end

    local payload = {
        score = score,
        guid = addon.playerGUID,
        specKey = addon.playerSpec,
        version = PROTOCOL_VERSION,
    }

    local success, serialized = AceSerializer:Serialize(payload)
    if not success then
        addon:DebugPrint("AddonChannel: serialization failed")
        return
    end

    lastBroadcastTime = now

    -- Send to each channel the player is in
    if IsInGuild() then
        AceComm:SendCommMessage(COMM_PREFIX, serialized, "GUILD", nil, "NORMAL")
    end
    if IsInRaid() then
        AceComm:SendCommMessage(COMM_PREFIX, serialized, "RAID", nil, "NORMAL")
    elseif IsInGroup() then
        AceComm:SendCommMessage(COMM_PREFIX, serialized, "PARTY", nil, "NORMAL")
    end

    addon:DebugPrint("AddonChannel: broadcast score " .. score)
end

---------------------------------------------------------------------------
-- Receiving
---------------------------------------------------------------------------

function M:OnCommReceived(prefix, message, distribution, sender)
    if prefix ~= COMM_PREFIX then return end

    -- Ignore own messages
    local playerName = UnitName("player")
    if sender == playerName then return end

    local success, payload = AceSerializer:Deserialize(message)
    if not success or type(payload) ~= "table" then
        addon:DebugPrint("AddonChannel: failed to deserialize from " .. tostring(sender))
        return
    end

    -- Validate required fields
    local score = tonumber(payload.score)
    local guid = payload.guid
    if not score or not guid or type(guid) ~= "string" then
        addon:DebugPrint("AddonChannel: invalid payload from " .. tostring(sender))
        return
    end

    -- Anti-fake: reject negative scores
    if score < 0 then
        addon:DebugPrint("AddonChannel: rejected negative score " .. score .. " from " .. tostring(sender))
        return
    end

    -- Anti-fake: reject scores above theoretical max
    if score > C.MAX_PLAUSIBLE_SCORE then
        addon:DebugPrint("AddonChannel: rejected implausible score " .. score .. " from " .. tostring(sender))
        return
    end

    -- Anti-fake: reject zero scores
    if score <= 0 then
        addon:DebugPrint("AddonChannel: rejected zero score from " .. tostring(sender))
        return
    end

    -- Anti-fake: warn on near-cap scores (>90% of max)
    if score > C.MAX_PLAUSIBLE_SCORE * 0.9 then
        addon:DebugPrint("AddonChannel: WARNING near-cap score " .. score .. " from " .. tostring(sender) .. " (GUID " .. tostring(guid) .. ")")
    end

    -- Anti-fake: detect rapid score changes (>500 in <1 minute)
    local prevHistory = scoreHistory[guid]
    if prevHistory then
        local now = GetTime()
        if (now - prevHistory.timestamp) < SCORE_CHANGE_WINDOW then
            local delta = math.abs(score - prevHistory.score)
            if delta > SCORE_CHANGE_THRESHOLD then
                addon:DebugPrint("AddonChannel: SUSPICIOUS rapid score change for " .. tostring(guid) ..
                    " (" .. prevHistory.score .. " -> " .. score .. " in " ..
                    math.floor(now - prevHistory.timestamp) .. "s) from " .. tostring(sender))
                -- Still store it (might be legitimate respec/gear swap), but the log flags it
            end
        end
    end

    -- Record in score history for change detection
    scoreHistory[guid] = { score = score, timestamp = GetTime() }

    -- Store in cache
    addon.ScoreCache:Set(guid, {
        score = math.floor(score),
        source = "broadcast",
        specKey = payload.specKey,
    })

    addon:DebugPrint("AddonChannel: received score " .. score .. " from " .. tostring(sender) .. " (" .. tostring(guid) .. ")")
end
