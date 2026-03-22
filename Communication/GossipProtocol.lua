---------------------------------------------------------------------------
-- TrueGearScore Gossip Protocol
-- Query/response protocol for sharing cached third-party scores.
-- When we need a score and the player isn't in inspect range or cache,
-- we ask other TGS users "who knows this GUID's score?" via GUILD/PARTY/RAID.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
addon:RegisterModule("GossipProtocol", M)

local C = addon.Constants

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

local QUERY_PREFIX = "TGSQ"
local RESPONSE_PREFIX = "TGSR"
local PROTOCOL_VERSION = 1

-- Throttle settings
local QUERY_COOLDOWN = 5         -- max 1 query per 5 seconds
local RESPONSE_WINDOW = 10       -- max 5 responses per this window
local MAX_RESPONSES_PER_WINDOW = 5
local STALENESS_THRESHOLD = 300  -- 5 minutes — don't share stale data

-- State
local lastQueryTime = 0
local responseTimestamps = {}  -- ring buffer of recent response times
local pendingQueries = {}      -- { [guid] = true } — GUIDs we've asked about recently

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

--- Check if we can send a response (throttle check).
local function CanSendResponse()
    local now = GetTime()
    -- Prune old timestamps
    local cutoff = now - RESPONSE_WINDOW
    local fresh = {}
    for _, t in ipairs(responseTimestamps) do
        if t > cutoff then
            fresh[#fresh + 1] = t
        end
    end
    responseTimestamps = fresh
    return #responseTimestamps < MAX_RESPONSES_PER_WINDOW
end

local function RecordResponseSent()
    responseTimestamps[#responseTimestamps + 1] = GetTime()
end

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    AceComm.RegisterComm(self, QUERY_PREFIX, function(prefix, message, distribution, sender)
        M:OnQueryReceived(prefix, message, distribution, sender)
    end)
    AceComm.RegisterComm(self, RESPONSE_PREFIX, function(prefix, message, distribution, sender)
        M:OnResponseReceived(prefix, message, distribution, sender)
    end)

    -- Periodically prune shared score history to avoid unbounded growth
    C_Timer.NewTicker(120, function()
        addon.ScoreValidation:PruneHistory()
    end)
end

---------------------------------------------------------------------------
-- Query: ask the network for a GUID's score
---------------------------------------------------------------------------

--- Request a score for a GUID from other TGS users.
-- Call this when the GUID is not in ScoreCache and not in inspect range.
-- @param guid  Player GUID to ask about
function M:QueryScore(guid)
    if not guid or type(guid) ~= "string" then return end

    -- Don't query for ourselves
    if guid == addon.playerGUID then return end

    -- Already have it cached?
    if addon.ScoreCache:Get(guid) then return end

    -- Throttle queries
    local now = GetTime()
    if (now - lastQueryTime) < QUERY_COOLDOWN then return end

    -- Already asked recently? Only suppress if cache already has data.
    if pendingQueries[guid] and addon.ScoreCache:Get(guid) then return end

    local payload = {
        guid = guid,
        version = PROTOCOL_VERSION,
    }

    local success, serialized = AceSerializer:Serialize(payload)
    if not success then
        addon:DebugPrint("GossipProtocol: query serialization failed")
        return
    end

    lastQueryTime = now
    pendingQueries[guid] = true

    -- Clear pending flag after a reasonable timeout
    C_Timer.After(QUERY_COOLDOWN, function()
        pendingQueries[guid] = nil
    end)

    -- Broadcast query to available channels
    if IsInGuild() then
        AceComm:SendCommMessage(QUERY_PREFIX, serialized, "GUILD", nil, "BULK")
    end
    if IsInRaid() then
        AceComm:SendCommMessage(QUERY_PREFIX, serialized, "RAID", nil, "BULK")
    elseif IsInGroup() then
        AceComm:SendCommMessage(QUERY_PREFIX, serialized, "PARTY", nil, "BULK")
    end

    addon:DebugPrint("GossipProtocol: queried score for " .. guid)
end

---------------------------------------------------------------------------
-- Receive query: respond if we have a fresh cached score
---------------------------------------------------------------------------

function M:OnQueryReceived(prefix, message, distribution, sender)
    if prefix ~= QUERY_PREFIX then return end

    -- Ignore own messages
    local playerName = UnitName("player")
    if sender == playerName then return end

    local success, payload = AceSerializer:Deserialize(message)
    if not success or type(payload) ~= "table" then return end

    local guid = payload.guid
    if not guid or type(guid) ~= "string" then return end

    -- Check if we have this GUID cached
    local cached = addon.ScoreCache:Get(guid)
    if not cached then return end

    -- Only share inspect or broadcast data, not gossip (avoid rumor chains)
    if cached.source == "gossip" then return end

    -- Check staleness
    if (GetTime() - cached.timestamp) > STALENESS_THRESHOLD then return end

    -- Throttle responses
    if not CanSendResponse() then return end

    local response = {
        guid = guid,
        score = cached.score,
        specKey = cached.specKey,
        timestamp = cached.timestamp,
        version = PROTOCOL_VERSION,
    }

    local ok, serialized = AceSerializer:Serialize(response)
    if not ok then return end

    RecordResponseSent()

    -- Respond on same channel we received on
    AceComm:SendCommMessage(RESPONSE_PREFIX, serialized, distribution, nil, "BULK")

    addon:DebugPrint("GossipProtocol: responded with score " .. cached.score .. " for " .. guid .. " to " .. distribution)
end

---------------------------------------------------------------------------
-- Receive response: store gossip score in cache
---------------------------------------------------------------------------

function M:OnResponseReceived(prefix, message, distribution, sender)
    if prefix ~= RESPONSE_PREFIX then return end

    -- Ignore own messages
    local playerName = UnitName("player")
    if sender == playerName then return end

    local success, payload = AceSerializer:Deserialize(message)
    if not success or type(payload) ~= "table" then return end

    local guid = payload.guid
    local score = tonumber(payload.score)

    if not guid or type(guid) ~= "string" then return end
    if not addon.ScoreValidation:ValidateScore(score, sender) then return end

    -- Check for suspicious rapid score changes
    if addon.ScoreValidation:IsSuspiciousChange(guid, score, sender) then
        addon:DebugPrint("GossipProtocol: ignoring suspicious gossip for " .. guid)
        return
    end

    addon.ScoreValidation:RecordScoreHistory(guid, score)

    -- Store with source="gossip" (lowest priority)
    -- ScoreCache:Set already protects inspect > broadcast; we also protect broadcast > gossip
    local existing = addon.ScoreCache:Get(guid)
    if existing and (existing.source == "inspect" or existing.source == "broadcast") then
        return  -- don't downgrade
    end

    addon.ScoreCache:Set(guid, {
        score = math.floor(score),
        source = "gossip",
        specKey = payload.specKey,
    })

    addon:DebugPrint("GossipProtocol: received gossip score " .. score .. " for " .. guid .. " from " .. sender)
end
