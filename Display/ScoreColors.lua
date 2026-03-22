---------------------------------------------------------------------------
-- TrueGearScore Score Colors
-- Maps numeric scores to color brackets for display.
-- Brackets are calibrated to TacoTip GearScore ranges (BRACKET_SIZE=400).
---------------------------------------------------------------------------

local _, addon = ...
addon.ScoreColors = {}

local C = addon.Constants

--- Get the RGB color for a score based on bracket thresholds.
-- Brackets are walked in descending order (highest threshold first).
-- @param score  Numeric score
-- @return r, g, b  Color values (0-1)
function addon.ScoreColors:GetColor(score)
    score = score or 0
    for _, bracket in ipairs(C.SCORE_BRACKETS) do
        if score >= bracket.threshold then
            return bracket.color[1], bracket.color[2], bracket.color[3]
        end
    end
    return 0.62, 0.62, 0.62  -- Fallback grey
end

--- Get a WoW escape-coded colored string for a score.
-- @param score  Numeric score
-- @return string  "|cffRRGGBBscore|r"
function addon.ScoreColors:GetColoredString(score)
    score = score or 0
    local r, g, b = self:GetColor(score)
    return string.format("|cff%02x%02x%02x%d|r",
        math.floor(r * 255),
        math.floor(g * 255),
        math.floor(b * 255),
        score)
end

--- Get the bracket label for a score (e.g., "Epic", "Legendary").
-- @param score  Numeric score
-- @return string  Bracket label
function addon.ScoreColors:GetBracketLabel(score)
    score = score or 0
    for _, bracket in ipairs(C.SCORE_BRACKETS) do
        if score >= bracket.threshold then
            return bracket.label
        end
    end
    return "Trash"
end

--- Get the content readiness tier for a score (e.g., "Kara-ready", "SSC/TK-ready").
-- @param score  Numeric score
-- @return string|nil  Content tier label, or nil if below all tiers
function addon.ScoreColors:GetContentTier(score)
    score = score or 0
    for _, tier in ipairs(C.CONTENT_TIERS) do
        if score >= tier.threshold then
            return tier.label
        end
    end
    return nil
end
