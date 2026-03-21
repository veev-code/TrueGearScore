---------------------------------------------------------------------------
-- TrueGearScore Cap Engine
-- Computes effective stat weights accounting for caps and diminishing returns
--
-- The engine is called once per full character rescan. Flow:
-- 1. Sum raw stats across all equipped items
-- 2. For each stat, compute effective weight based on current total vs cap
-- 3. Return effective weight table for ItemScoring to use
---------------------------------------------------------------------------

local _, addon = ...
addon.CapEngine = {}

local C = addon.Constants

--- Compute the effective weight for one point of a stat given current totals.
-- @param statName   Canonical stat name (e.g., "HIT_RATING")
-- @param currentTotal  Total rating of this stat across all gear
-- @param specKey    Player spec key (e.g., "WARRIOR_ARMS")
-- @return number    Effective weight-per-point
function addon.CapEngine:GetEffectiveWeight(statName, currentTotal, specKey)
    local specData = addon.StatWeights:GetSpecWeights(specKey)
    if not specData then return 0 end

    local baseWeight = specData.weights[statName] or 0
    if baseWeight == 0 then return 0 end

    local capInfo = specData.caps and specData.caps[statName]
    if not capInfo then
        return baseWeight  -- No cap defined, full value
    end

    if currentTotal <= capInfo.softCap then
        return baseWeight  -- Below cap, full value
    elseif currentTotal <= capInfo.hardCap then
        return baseWeight * capInfo.overCapWeight  -- Diminished between soft and hard cap
    else
        return baseWeight * 0.01  -- Past hard cap, essentially worthless
    end
end

--- Compute effective weights for all stats given the player's total stat budget.
-- @param statTotals  Table of { STAT_NAME = totalValue, ... } across all gear
-- @param specKey     Player spec key
-- @return table      { STAT_NAME = effectiveWeight, ... }
function addon.CapEngine:ComputeEffectiveWeights(statTotals, specKey)
    local specData = addon.StatWeights:GetSpecWeights(specKey)
    if not specData then return {} end

    local effective = {}
    for statName, baseWeight in pairs(specData.weights) do
        local total = statTotals[statName] or 0
        effective[statName] = self:GetEffectiveWeight(statName, total, specKey)
    end
    return effective
end
