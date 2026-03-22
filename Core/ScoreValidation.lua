---------------------------------------------------------------------------
-- TrueGearScore Score Validation
-- Shared anti-fake validation utilities used by AddonChannel and GossipProtocol.
---------------------------------------------------------------------------

local _, addon = ...
addon.ScoreValidation = {}

local C = addon.Constants

-- Suspicious score tracking (shared across all consumers)
local SCORE_CHANGE_THRESHOLD = 500  -- flag if score jumps by this much
local SCORE_CHANGE_WINDOW = 60      -- within this many seconds

local scoreHistory = {}  -- { [guid] = { score, timestamp } }

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------

--- Validate a score value. Returns true if plausible, false otherwise.
-- @param score   Score value to validate
-- @param sender  Sender name (for debug logging)
-- @return boolean
function addon.ScoreValidation:ValidateScore(score, sender)
    if type(score) ~= "number" then
        addon:DebugPrint("ScoreValidation: non-numeric score from " .. tostring(sender))
        return false
    end
    if score <= 0 then
        addon:DebugPrint("ScoreValidation: invalid score (" .. score .. ") from " .. tostring(sender))
        return false
    end
    if score > C.MAX_PLAUSIBLE_SCORE then
        addon:DebugPrint("ScoreValidation: rejected implausible score " .. score .. " from " .. tostring(sender))
        return false
    end
    if score > C.MAX_PLAUSIBLE_SCORE * 0.9 then
        addon:DebugPrint("ScoreValidation: WARNING near-cap score " .. score .. " from " .. tostring(sender))
    end
    return true
end

--- Check if a score change for a GUID looks suspicious (rapid large delta).
-- @param guid    Player GUID
-- @param score   New score
-- @param sender  Sender name (for debug logging)
-- @return boolean  true if suspicious
function addon.ScoreValidation:IsSuspiciousChange(guid, score, sender)
    local prev = scoreHistory[guid]
    if not prev then return false end

    local now = GetTime()
    if (now - prev.timestamp) > SCORE_CHANGE_WINDOW then
        return false  -- old data, not suspicious
    end

    local delta = math.abs(score - prev.score)
    if delta > SCORE_CHANGE_THRESHOLD then
        addon:DebugPrint("ScoreValidation: SUSPICIOUS score change for " .. tostring(guid) ..
            " (" .. prev.score .. " -> " .. score .. " in " ..
            math.floor(now - prev.timestamp) .. "s)" ..
            (sender and (" from " .. tostring(sender)) or ""))
        return true
    end

    return false
end

--- Record a score in the per-GUID history for change detection.
-- @param guid   Player GUID
-- @param score  Score value
function addon.ScoreValidation:RecordScoreHistory(guid, score)
    scoreHistory[guid] = {
        score = score,
        timestamp = GetTime(),
    }
end

--- Prune old score history entries to prevent unbounded growth.
function addon.ScoreValidation:PruneHistory()
    local now = GetTime()
    for guid, entry in pairs(scoreHistory) do
        if (now - entry.timestamp) > SCORE_CHANGE_WINDOW * 2 then
            scoreHistory[guid] = nil
        end
    end
end
