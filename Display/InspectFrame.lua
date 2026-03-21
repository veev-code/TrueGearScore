---------------------------------------------------------------------------
-- TrueGearScore Inspect Frame Display
-- Shows TrueGearScore on the Blizzard Inspect frame.
-- Mirrors the Paperdoll layout: bottom-left with score + iLvl.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("InspectFrameDisplay", M)

local C = addon.Constants
local FONT = "Fonts\\FRIZQT__.TTF"

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    -- InspectFrame may not exist yet at init time (loaded on demand)
    -- Hook it when it appears
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(_, event, addonName)
        -- InspectFrame is part of Blizzard_InspectUI
        if InspectFrame and not self.hooked then
            self.hooked = true
            InspectFrame:HookScript("OnShow", function()
                self:OnInspectShow()
            end)
            eventFrame:UnregisterEvent("ADDON_LOADED")
        end
    end)

    -- Also try immediately in case it's already loaded
    if InspectFrame then
        self.hooked = true
        InspectFrame:HookScript("OnShow", function()
            self:OnInspectShow()
        end)
    end
end

---------------------------------------------------------------------------
-- Display
---------------------------------------------------------------------------

function M:OnInspectShow()
    self:EnsureDisplay()
    -- Update with a small delay to let InspectHandler capture the data
    C_Timer.After(0.5, function()
        self:UpdateScore()
    end)
    C_Timer.After(2, function()
        self:UpdateScore()
    end)
end

function M:EnsureDisplay()
    if self.gsValue then return end

    local parent = InspectPaperDollFrame or InspectFrame
    if not parent then return end

    self.gsLabel = parent:CreateFontString(nil, "OVERLAY")
    self.gsLabel:SetFont(FONT, 10)
    self.gsLabel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 72, 248)
    self.gsLabel:SetText("TrueGearScore")
    self.gsLabel:SetTextColor(0.53, 0.53, 0.53, 1)

    self.gsValue = parent:CreateFontString(nil, "OVERLAY")
    self.gsValue:SetFont(FONT, 10)
    self.gsValue:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 72, 260)
    self.gsValue:SetText("")
end

function M:UpdateScore()
    if not self.gsValue then return end
    if not InspectFrame or not InspectFrame:IsShown() then return end

    local unit = InspectFrame.unit or "target"
    local guid = UnitGUID(unit)
    if not guid then
        self.gsValue:SetText("--")
        self.gsValue:SetTextColor(0.53, 0.53, 0.53, 1)
        return
    end

    local cached = addon.ScoreCache:Get(guid)
    if cached and cached.score > 0 then
        local r, g, b = addon.ScoreColors:GetColor(cached.score)
        self.gsValue:SetText(tostring(cached.score))
        self.gsValue:SetTextColor(r, g, b, 1)
    else
        self.gsValue:SetText("...")
        self.gsValue:SetTextColor(0.53, 0.53, 0.53, 1)
    end
end
