---------------------------------------------------------------------------
-- TrueGearScore Inspect Frame Display
-- Shows TrueGearScore on the Blizzard Inspect frame.
-- Mirrors Paperdoll layout: GS bottom-left, iLvl bottom-right.
-- Hides TacoTip's inspect GearScore if present.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("InspectFrame", M)

local C = addon.Constants
local FONT = "Fonts\\FRIZQT__.TTF"
local LABEL_SIZE = 11
local VALUE_SIZE = 15

-- Same positioning as Paperdoll, anchored to InspectModelFrame
local GS_LABEL_X, GS_LABEL_Y = 12, 40
local GS_VALUE_X, GS_VALUE_Y = 12, 24
local ILVL_LABEL_X, ILVL_LABEL_Y = -12, 40
local ILVL_VALUE_X, ILVL_VALUE_Y = -12, 24

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    -- InspectFrame may not exist yet (loaded on demand)
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(_, event, addonName)
        if InspectFrame and not self.hooked then
            self:HookInspectFrame()
            eventFrame:UnregisterEvent("ADDON_LOADED")
        end
    end)

    -- Try immediately in case already loaded
    if InspectFrame then
        self:HookInspectFrame()
    end
end

function M:Refresh()
    -- No cached state to update; reads addon.db.profile directly
end

function M:HookInspectFrame()
    if self.hooked then return end
    self.hooked = true

    InspectFrame:HookScript("OnShow", function()
        self:OnInspectShow()
    end)

    InspectFrame:HookScript("OnHide", function()
        if self.updateTimer1 then self.updateTimer1:Cancel(); self.updateTimer1 = nil end
        if self.updateTimer2 then self.updateTimer2:Cancel(); self.updateTimer2 = nil end
    end)
end

---------------------------------------------------------------------------
-- Hide TacoTip's inspect GearScore if present
---------------------------------------------------------------------------

function M:HideTacoTipInspect()
    addon:HideTacoTipFrames("Inspect")
end

---------------------------------------------------------------------------
-- Display creation
---------------------------------------------------------------------------

function M:OnInspectShow()
    if not addon.db.profile.showInspectFrame then return end

    self:EnsureDisplay()
    self:HideTacoTipInspect()

    -- Cancel any pending timers from a previous show
    if self.updateTimer1 then self.updateTimer1:Cancel(); self.updateTimer1 = nil end
    if self.updateTimer2 then self.updateTimer2:Cancel(); self.updateTimer2 = nil end

    -- Capture the unit at show time to guard against rapid inspect switches
    local showUnit = InspectFrame and InspectFrame.unit or "target"
    local showGUID = UnitGUID(showUnit)

    -- Update with delays to let InspectHandler capture data
    -- Each timer validates the inspect target hasn't changed
    self:UpdateScore()
    self.updateTimer1 = C_Timer.NewTimer(0.5, function()
        self.updateTimer1 = nil
        if InspectFrame and InspectFrame:IsShown() and UnitGUID(InspectFrame.unit or "target") == showGUID then
            self:UpdateScore()
        end
    end)
    self.updateTimer2 = C_Timer.NewTimer(2, function()
        self.updateTimer2 = nil
        if InspectFrame and InspectFrame:IsShown() and UnitGUID(InspectFrame.unit or "target") == showGUID then
            self:UpdateScore()
        end
    end)
end

function M:EnsureDisplay()
    if self.gsValue then return end

    -- Anchor to the model frame inside the inspect window
    local anchor = InspectModelFrame or InspectPaperDollFrame
    if not anchor then return end

    -- GearScore label
    self.gsLabel = anchor:CreateFontString(nil, "OVERLAY")
    self.gsLabel:SetFont(FONT, LABEL_SIZE)
    self.gsLabel:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", GS_LABEL_X, GS_LABEL_Y)
    self.gsLabel:SetText("TrueGearScore")
    self.gsLabel:SetTextColor(0.53, 0.53, 0.53, 1)

    -- GearScore value
    self.gsValue = anchor:CreateFontString(nil, "OVERLAY")
    self.gsValue:SetFont(FONT, VALUE_SIZE)
    self.gsValue:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", GS_VALUE_X, GS_VALUE_Y)
    self.gsValue:SetText("")

    -- iLvl label (bottom-right)
    self.ilvlLabel = anchor:CreateFontString(nil, "OVERLAY")
    self.ilvlLabel:SetFont(FONT, LABEL_SIZE)
    self.ilvlLabel:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", ILVL_LABEL_X, ILVL_LABEL_Y)
    self.ilvlLabel:SetText("iLvl")
    self.ilvlLabel:SetTextColor(0.53, 0.53, 0.53, 1)
    self.ilvlLabel:SetJustifyH("RIGHT")

    -- iLvl value (bottom-right)
    self.ilvlValue = anchor:CreateFontString(nil, "OVERLAY")
    self.ilvlValue:SetFont(FONT, VALUE_SIZE)
    self.ilvlValue:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", ILVL_VALUE_X, ILVL_VALUE_Y)
    self.ilvlValue:SetText("")
    self.ilvlValue:SetJustifyH("RIGHT")
end

---------------------------------------------------------------------------
-- Compute average item level for inspected player (delegates to shared utility)
---------------------------------------------------------------------------

function M:ComputeInspectIlvl(unit)
    return addon:ComputeAverageItemLevel(unit)
end

---------------------------------------------------------------------------
-- Score update
---------------------------------------------------------------------------

function M:UpdateScore()
    if not self.gsValue then return end
    if not InspectFrame or not InspectFrame:IsShown() then return end

    self:HideTacoTipInspect()

    local unit = InspectFrame.unit or "target"
    local guid = UnitGUID(unit)
    if not guid then
        self.gsValue:SetText("--")
        self.gsValue:SetTextColor(0.53, 0.53, 0.53, 1)
        self.ilvlValue:SetText("--")
        self.ilvlValue:SetTextColor(0.53, 0.53, 0.53, 1)
        return
    end

    -- Score
    local cached = addon.ScoreCache:Get(guid)
    if cached and cached.score > 0 then
        local r, g, b = addon.ScoreColors:GetColor(cached.score)
        self.gsValue:SetText(tostring(cached.score))
        self.gsValue:SetTextColor(r, g, b, 1)
    else
        self.gsValue:SetText("--")
        self.gsValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end

    -- iLvl (neutral white — iLvl is not a score)
    local avgIlvl = self:ComputeInspectIlvl(unit)
    if avgIlvl > 0 then
        self.ilvlValue:SetText(tostring(avgIlvl))
        self.ilvlValue:SetTextColor(1, 1, 1, 1)
    else
        self.ilvlValue:SetText("--")
        self.ilvlValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end
end
