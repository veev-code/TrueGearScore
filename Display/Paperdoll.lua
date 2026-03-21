---------------------------------------------------------------------------
-- TrueGearScore Paperdoll Display
-- Shows the player's TrueGearScore on the character panel (paperdoll).
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("Paperdoll", M)

M.scoreText = nil

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    -- Hook CharacterFrame to create/update our display
    if CharacterFrame then
        CharacterFrame:HookScript("OnShow", function()
            self:EnsureDisplay()
            self:UpdateScore()
        end)
    end
end

---------------------------------------------------------------------------
-- Display creation
---------------------------------------------------------------------------

function M:EnsureDisplay()
    if self.scoreText then return end

    -- Create the score FontString on the paperdoll frame
    local parent = PaperDollFrame or CharacterFrame
    local text = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")

    -- Position: top-right of the character model area
    text:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -20, -20)
    text:SetJustifyH("RIGHT")
    text:SetText("")

    -- Label above the score
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("BOTTOMRIGHT", text, "TOPRIGHT", 0, 2)
    label:SetJustifyH("RIGHT")
    label:SetText("|cff888888TrueGearScore|r")

    self.scoreText = text
    self.labelText = label
end

---------------------------------------------------------------------------
-- Score update
---------------------------------------------------------------------------

function M:UpdateScore()
    if not self.scoreText then return end

    local selfScanner = addon:GetModule("SelfScanner")
    if not selfScanner or not selfScanner.currentScore then
        self.scoreText:SetText("|cff888888--|r")
        return
    end

    local score = selfScanner.currentScore
    if score == 0 then
        self.scoreText:SetText("|cff888888--|r")
        return
    end

    local r, g, b = addon.ScoreColors:GetColor(score)
    self.scoreText:SetTextColor(r, g, b)
    self.scoreText:SetText(tostring(score))
end

--- Called by SelfScanner when score changes.
function M:OnScoreUpdated(score)
    -- Only update if character frame is visible
    if CharacterFrame and CharacterFrame:IsShown() then
        self:UpdateScore()
    end
end

function M:Refresh()
    self:UpdateScore()
end
