---------------------------------------------------------------------------
-- TrueGearScore Paperdoll Display
-- Shows the player's TrueGearScore and iLvl on the character panel.
-- Layout mirrors TacoTip's bottom-left placement.
-- If TacoTip is installed, hides its GearScore display to avoid duplication.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("Paperdoll", M)

local C = addon.Constants
local FONT = "Fonts\\FRIZQT__.TTF"
local LABEL_SIZE = 11
local VALUE_SIZE = 15

-- Positioning: anchored to CharacterModelFrame bottom area
-- Label sits above value. GS on left, iLvl on right.
-- GS anchored BOTTOMLEFT, iLvl anchored BOTTOMRIGHT
local GS_LABEL_X, GS_LABEL_Y = 12, 40
local GS_VALUE_X, GS_VALUE_Y = 12, 24
local ILVL_LABEL_X, ILVL_LABEL_Y = -12, 40
local ILVL_VALUE_X, ILVL_VALUE_Y = -12, 24

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    if PaperDollFrame then
        PaperDollFrame:HookScript("OnShow", function()
            if not addon.db.profile.showPaperdoll then
                self:HideDisplay()
                return
            end
            self:EnsureDisplay()
            self:HideTacoTip()
            self:UpdateScore()
        end)
    end
end

---------------------------------------------------------------------------
-- Hide TacoTip's GearScore display if present
---------------------------------------------------------------------------

function M:HideTacoTip()
    addon:HideTacoTipFrames("Personal")
end

---------------------------------------------------------------------------
-- Display creation
---------------------------------------------------------------------------

function M:EnsureDisplay()
    if self.gsValue then return end

    local anchor = CharacterModelFrame or PaperDollFrame or CharacterFrame

    -- GearScore label ("TrueGearScore")
    self.gsLabel = anchor:CreateFontString(nil, "OVERLAY")
    self.gsLabel:SetFont(FONT, LABEL_SIZE)
    self.gsLabel:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", GS_LABEL_X, GS_LABEL_Y)
    self.gsLabel:SetText("TrueGearScore")
    self.gsLabel:SetTextColor(0.53, 0.53, 0.53, 1)  -- Grey label

    -- GearScore value
    self.gsValue = anchor:CreateFontString(nil, "OVERLAY")
    self.gsValue:SetFont(FONT, VALUE_SIZE)
    self.gsValue:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", GS_VALUE_X, GS_VALUE_Y)
    self.gsValue:SetText("0")

    -- iLvl label (anchored bottom-right)
    self.ilvlLabel = anchor:CreateFontString(nil, "OVERLAY")
    self.ilvlLabel:SetFont(FONT, LABEL_SIZE)
    self.ilvlLabel:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", ILVL_LABEL_X, ILVL_LABEL_Y)
    self.ilvlLabel:SetText("iLvl")
    self.ilvlLabel:SetTextColor(0.53, 0.53, 0.53, 1)
    self.ilvlLabel:SetJustifyH("RIGHT")

    -- iLvl value (anchored bottom-right)
    self.ilvlValue = anchor:CreateFontString(nil, "OVERLAY")
    self.ilvlValue:SetFont(FONT, VALUE_SIZE)
    self.ilvlValue:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", ILVL_VALUE_X, ILVL_VALUE_Y)
    self.ilvlValue:SetText("0")
    self.ilvlValue:SetJustifyH("RIGHT")
end

---------------------------------------------------------------------------
-- Average item level computation (delegates to shared utility)
---------------------------------------------------------------------------

function M:ComputeAverageItemLevel()
    return addon:ComputeAverageItemLevel("player")
end

---------------------------------------------------------------------------
-- Score update
---------------------------------------------------------------------------

function M:HideDisplay()
    if self.gsLabel then self.gsLabel:Hide() end
    if self.gsValue then self.gsValue:Hide() end
    if self.ilvlLabel then self.ilvlLabel:Hide() end
    if self.ilvlValue then self.ilvlValue:Hide() end
end

function M:ShowDisplay()
    if self.gsLabel then self.gsLabel:Show() end
    if self.gsValue then self.gsValue:Show() end
    if self.ilvlLabel then self.ilvlLabel:Show() end
    if self.ilvlValue then self.ilvlValue:Show() end
end

function M:UpdateScore()
    if not self.gsValue then return end
    if not addon.db.profile.showPaperdoll then self:HideDisplay() return end
    self:ShowDisplay()

    local selfScanner = addon:GetModule("SelfScanner")
    local score = selfScanner and selfScanner.currentScore or 0

    -- GearScore
    if score > 0 then
        local r, g, b = addon.ScoreColors:GetColor(score)
        self.gsValue:SetText(tostring(score))
        self.gsValue:SetTextColor(r, g, b, 1)
    else
        self.gsValue:SetText("--")
        self.gsValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end

    -- iLvl (neutral white — iLvl is not a score)
    local avgIlvl = self:ComputeAverageItemLevel()
    if avgIlvl > 0 then
        self.ilvlValue:SetText(tostring(avgIlvl))
        self.ilvlValue:SetTextColor(1, 1, 1, 1)
    else
        self.ilvlValue:SetText("--")
        self.ilvlValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end
end

--- Called by SelfScanner when score changes.
function M:OnScoreUpdated(score)
    if not addon.db.profile.showPaperdoll then return end
    if CharacterFrame and CharacterFrame:IsShown() then
        self:UpdateScore()
    end
end

function M:Refresh()
    if not addon.db.profile.showPaperdoll then
        self:HideDisplay()
        return
    end
    self:UpdateScore()
end
