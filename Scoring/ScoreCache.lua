---------------------------------------------------------------------------
-- TrueGearScore Score Cache
-- Per-player score cache keyed by GUID, with TTL expiry.
-- Sources: "self" (own scan), "inspect" (full item links), "broadcast" (addon message)
-- Inspect > broadcast (inspect has full gem/enchant data, broadcast is just a number)
---------------------------------------------------------------------------

local _, addon = ...
addon.ScoreCache = {}

local cache = {}  -- { [guid] = { score, perSlot, timestamp, source, specKey } }
local DEFAULT_TTL = 300  -- 5 minutes

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------

--- Get a cached score for a player GUID.
-- @param guid  Player GUID
-- @return table or nil  { score, perSlot, timestamp, source, specKey }
function addon.ScoreCache:Get(guid)
    local entry = cache[guid]
    if not entry then return nil end

    -- Check TTL
    if (GetTime() - entry.timestamp) > DEFAULT_TTL then
        cache[guid] = nil
        return nil
    end

    return entry
end

--- Store a score in the cache.
-- @param guid    Player GUID
-- @param data    Table with: score (number), perSlot (table, optional), source (string), specKey (string, optional)
function addon.ScoreCache:Set(guid, data)
    -- Don't overwrite inspect data with broadcast data
    local existing = cache[guid]
    if existing and existing.source == "inspect" and data.source == "broadcast" then
        -- Only overwrite if existing is expired
        if (GetTime() - existing.timestamp) <= DEFAULT_TTL then
            return
        end
    end

    cache[guid] = {
        score = data.score,
        perSlot = data.perSlot,
        timestamp = GetTime(),
        source = data.source or "unknown",
        specKey = data.specKey,
        baseScore = data.baseScore,
    }
end

--- Invalidate a cached entry (e.g., player changed gear).
-- @param guid  Player GUID
function addon.ScoreCache:Invalidate(guid)
    cache[guid] = nil
end

--- Prune all expired entries from cache.
function addon.ScoreCache:Prune()
    local now = GetTime()
    for guid, entry in pairs(cache) do
        if (now - entry.timestamp) > DEFAULT_TTL then
            cache[guid] = nil
        end
    end
end

--- Get number of cached entries (for diagnostics).
function addon.ScoreCache:GetSize()
    local count = 0
    for _ in pairs(cache) do count = count + 1 end
    return count
end

--- Clear all cached entries.
function addon.ScoreCache:Clear()
    cache = {}
end
