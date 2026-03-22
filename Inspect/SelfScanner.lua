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
    eventFrame:RegisterEvent("PLAYER_LOGIN")
    eventFrame:SetScript("OnEvent", function(_, event, slotID)
        if event == "PLAYER_EQUIPMENT_CHANGED" then
            -- Debounce: cancel previous timer so rapid gear swaps collapse into one scan
            if self.equipChangeTimer then
                self.equipChangeTimer:Cancel()
            end
            self.equipChangeTimer = C_Timer.After(0.5, function()
                self:ScanEquipment()
                self.equipChangeTimer = nil
            end)
        elseif event == "PLAYER_LOGIN" then
            -- Delay initial scan to let equipment data load from server
            C_Timer.After(1, function()
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
        self.mode = nil
        addon:DebugPrint("SelfScanner: no items equipped")
        -- Fall through to notify display modules
    else
        local result = addon.ItemScoring:ScoreCharacterBestMode(items)

        -- Validate scoring result
        if type(result) ~= "table" then
            addon:DebugPrint("SelfScanner: ERROR — ScoreCharacter returned " .. type(result) .. " instead of table")
            self.currentScore = 0
            self.perSlotScores = {}
            self.effectiveWeights = {}
            self.breakdown = nil
            self.mode = nil
            -- Fall through to notify display modules
        else
            self.currentScore = result.totalScore
            self.resolvedSpec = result.specKey  -- Resolved sub-spec (e.g., DRUID_FERAL_CAT vs DRUID_FERAL_BEAR)
            self.mode = result.mode             -- "pve" or "pvp"
            self.perSlotScores = result.perSlot
            self.perSlotDetails = result.perSlotDetails
            self.effectiveWeights = result.effectiveWeights
            self.rawScore = result.rawScore
            self.baseOnlyRaw = result.baseOnlyRaw
            self.baseOnlyScore = result.baseOnlyScore
            self.breakdown = result.breakdown
            self.efficiency = result.efficiency

            -- Cache self score so display modules can use ScoreCache uniformly
            addon.ScoreCache:Set(addon.playerGUID, {
                score = self.currentScore,
                source = "self",
                timestamp = GetTime(),
                efficiency = self.efficiency,
                mode = self.mode,
            })

            addon:DebugPrint("SelfScanner: score updated to " .. self.currentScore .. " eff=" .. tostring(self.efficiency) .. "%")
        end
    end

    -- Always notify display modules (even on error/empty, so they can update)
    for _, module in pairs(addon.modules) do
        if module.OnScoreUpdated then
            local ok, err = pcall(module.OnScoreUpdated, module, self.currentScore or 0)
            if not ok then
                addon:DebugPrint("SelfScanner: OnScoreUpdated error in module: " .. tostring(err))
            end
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
