---------------------------------------------------------------------------
-- TrueGearScore Score Cache
-- Per-player score cache keyed by GUID, with TTL expiry.
-- Sources: "self" (own scan), "inspect" (full item links), "broadcast" (addon message)
-- Inspect > broadcast (inspect has full gem/enchant data, broadcast is just a number)
---------------------------------------------------------------------------

local _, addon = ...
addon.ScoreCache = {}

local cache = {}  -- { [guid] = { score, perSlot, timestamp, source, specKey, efficiency } }
local DEFAULT_TTL = 300  -- 5 minutes
local MAX_CACHE_SIZE = 500
local PRUNE_INTERVAL = 60  -- seconds

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------

--- Get a cached score for a player GUID.
-- @param guid  Player GUID
-- @return table or nil  { score, perSlot, timestamp, source, specKey, efficiency }
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
-- Source priority: self > inspect > broadcast > gossip
local SOURCE_PRIORITY = { self = 4, inspect = 3, broadcast = 2, gossip = 1 }

function addon.ScoreCache:Set(guid, data)
    -- Don't overwrite higher-priority data with lower-priority data
    local existing = cache[guid]
    if existing then
        local existingPrio = SOURCE_PRIORITY[existing.source] or 0
        local newPrio = SOURCE_PRIORITY[data.source] or 0
        if newPrio < existingPrio then
            -- Only overwrite if existing is expired
            if (GetTime() - existing.timestamp) <= DEFAULT_TTL then
                return
            end
        end
    end

    -- Enforce size cap before inserting
    if addon.ScoreCache:GetSize() >= MAX_CACHE_SIZE then
        addon.ScoreCache:Prune()
        -- If still over after pruning expired entries, evict oldest
        if addon.ScoreCache:GetSize() >= MAX_CACHE_SIZE then
            local oldestGUID, oldestTime = nil, math.huge
            for g, entry in pairs(cache) do
                if entry.timestamp < oldestTime then
                    oldestGUID = g
                    oldestTime = entry.timestamp
                end
            end
            if oldestGUID then
                cache[oldestGUID] = nil
            end
        end
    end

    cache[guid] = {
        score = data.score,
        perSlot = data.perSlot,
        timestamp = GetTime(),
        source = data.source or "unknown",
        specKey = data.specKey,
        baseScore = data.baseScore,
        breakdown = data.breakdown,
        efficiency = data.efficiency,
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

---------------------------------------------------------------------------
-- Auto-prune timer: periodically remove expired entries
---------------------------------------------------------------------------

local pruneFrame = CreateFrame("Frame")
pruneFrame.elapsed = 0
pruneFrame:SetScript("OnUpdate", function(self, dt)
    self.elapsed = self.elapsed + dt
    if self.elapsed >= PRUNE_INTERVAL then
        self.elapsed = 0
        addon.ScoreCache:Prune()
    end
end)
