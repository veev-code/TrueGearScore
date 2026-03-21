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
local LABEL_SIZE = 10
local VALUE_SIZE = 10

-- Positioning: BOTTOMLEFT of PaperDollFrame (mirrors TacoTip layout)
local GS_LABEL_X, GS_LABEL_Y = 72, 248
local GS_VALUE_X, GS_VALUE_Y = 72, 260
local ILVL_LABEL_X, ILVL_LABEL_Y = 270, 248
local ILVL_VALUE_X, ILVL_VALUE_Y = 270, 260

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    if PaperDollFrame then
        PaperDollFrame:HookScript("OnShow", function()
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
    if PersonalGearScore then
        PersonalGearScore:Hide()
        PersonalGearScore:SetText("")
    end
    if PersonalGearScoreText then
        PersonalGearScoreText:Hide()
        PersonalGearScoreText:SetText("")
    end
    if PersonalAvgItemLvl then
        PersonalAvgItemLvl:Hide()
        PersonalAvgItemLvl:SetText("")
    end
    if PersonalAvgItemLvlText then
        PersonalAvgItemLvlText:Hide()
        PersonalAvgItemLvlText:SetText("")
    end
end

---------------------------------------------------------------------------
-- Display creation
---------------------------------------------------------------------------

function M:EnsureDisplay()
    if self.gsValue then return end

    local parent = PaperDollFrame or CharacterFrame

    -- GearScore label ("TrueGearScore")
    self.gsLabel = parent:CreateFontString(nil, "OVERLAY")
    self.gsLabel:SetFont(FONT, LABEL_SIZE)
    self.gsLabel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", GS_LABEL_X, GS_LABEL_Y)
    self.gsLabel:SetText("TrueGearScore")
    self.gsLabel:SetTextColor(0.53, 0.53, 0.53, 1)  -- Grey label

    -- GearScore value
    self.gsValue = parent:CreateFontString(nil, "OVERLAY")
    self.gsValue:SetFont(FONT, VALUE_SIZE)
    self.gsValue:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", GS_VALUE_X, GS_VALUE_Y)
    self.gsValue:SetText("0")

    -- iLvl label
    self.ilvlLabel = parent:CreateFontString(nil, "OVERLAY")
    self.ilvlLabel:SetFont(FONT, LABEL_SIZE)
    self.ilvlLabel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", ILVL_LABEL_X, ILVL_LABEL_Y)
    self.ilvlLabel:SetText("iLvl")
    self.ilvlLabel:SetTextColor(0.53, 0.53, 0.53, 1)

    -- iLvl value
    self.ilvlValue = parent:CreateFontString(nil, "OVERLAY")
    self.ilvlValue:SetFont(FONT, VALUE_SIZE)
    self.ilvlValue:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", ILVL_VALUE_X, ILVL_VALUE_Y)
    self.ilvlValue:SetText("0")
end

---------------------------------------------------------------------------
-- Average item level computation
---------------------------------------------------------------------------

function M:ComputeAverageItemLevel()
    local totalIlvl = 0
    local count = 0

    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            local _, _, _, itemLevel = GetItemInfo(itemLink)
            if itemLevel and itemLevel > 0 then
                totalIlvl = totalIlvl + itemLevel
                count = count + 1
            end
        end
    end

    if count > 0 then
        return math.floor(totalIlvl / count)
    end
    return 0
end

---------------------------------------------------------------------------
-- Score update
---------------------------------------------------------------------------

function M:UpdateScore()
    if not self.gsValue then return end

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

    -- iLvl
    local avgIlvl = self:ComputeAverageItemLevel()
    if avgIlvl > 0 then
        local r, g, b = addon.ScoreColors:GetColor(score)
        self.ilvlValue:SetText(tostring(avgIlvl))
        self.ilvlValue:SetTextColor(r, g, b, 1)
    else
        self.ilvlValue:SetText("--")
        self.ilvlValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end
end

--- Called by SelfScanner when score changes.
function M:OnScoreUpdated(score)
    if CharacterFrame and CharacterFrame:IsShown() then
        self:UpdateScore()
    end
end

function M:Refresh()
    self:UpdateScore()
end
