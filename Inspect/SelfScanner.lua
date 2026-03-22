---------------------------------------------------------------------------
-- TrueGearScore Self Scanner
-- Scans the player's own equipped items and triggers rescoring.
-- Listens for gear changes and fires SCORE_UPDATED when score changes.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("SelfScanner", M)

local C = addon.Constants

-- Cached state
M.equippedItems = {}
M.currentScore = nil
M.perSlotScores = {}
M.effectiveWeights = {}

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    eventFrame:SetScript("OnEvent", function(_, event, slotID)
        if event == "PLAYER_EQUIPMENT_CHANGED" then
            -- Small delay to let item data settle
            C_Timer.After(0.2, function()
                self:ScanEquipment()
            end)
        end
    end)
end

---------------------------------------------------------------------------
-- Equipment scanning
---------------------------------------------------------------------------

function M:ScanEquipment()
    local items = {}
    local hasAny = false

    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            items[slotID] = itemLink
            hasAny = true
        end
    end

    self.equippedItems = items

    if not hasAny then
        self.currentScore = 0
        self.perSlotScores = {}
        self.effectiveWeights = {}
        self.breakdown = nil
        addon:DebugPrint("SelfScanner: no items equipped")
        return
    end

    local result = addon.ItemScoring:ScoreCharacter(items)
    self.currentScore = result.totalScore
    self.perSlotScores = result.perSlot
    self.perSlotDetails = result.perSlotDetails
    self.effectiveWeights = result.effectiveWeights
    self.rawScore = result.rawScore
    self.baseOnlyRaw = result.baseOnlyRaw
    self.baseOnlyScore = result.baseOnlyScore
    self.breakdown = result.breakdown
    self.efficiency = result.efficiency

    addon:DebugPrint("SelfScanner: score updated to " .. self.currentScore .. " eff=" .. tostring(self.efficiency) .. "%")

    -- Notify display modules
    for _, module in pairs(addon.modules) do
        if module.OnScoreUpdated then
            module:OnScoreUpdated(self.currentScore)
        end
    end
end

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

function M:GetScore()
    return self.currentScore
end

function M:GetPerSlotScores()
    return self.perSlotScores
end

function M:GetEquippedItems()
    return self.equippedItems
end

function M:GetEffectiveWeights()
    return self.effectiveWeights
end
