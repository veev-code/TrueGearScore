local _, addon = ...
addon.SlashCommands = {}

local C = addon.Constants

function addon.SlashCommands:Register()
    SLASH_TRUEGEARSCORE1 = "/tgs"
    SLASH_TRUEGEARSCORE2 = "/truegearscore"
    SlashCmdList["TRUEGEARSCORE"] = function(msg)
        self:HandleCommand(msg)
    end
end

function addon.SlashCommands:HandleCommand(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        args[#args + 1] = word:lower()
    end

    local cmd = args[1]

    if not cmd then
        self:PrintScore()
    elseif cmd == "help" then
        self:ShowHelp()
    elseif cmd == "debug" then
        addon.db.profile.debugMode = not addon.db.profile.debugMode
        addon:Print("Debug mode: " .. (addon.db.profile.debugMode and "|cff00ff00ON|r" or "|cffff4444OFF|r"))
    elseif cmd == "breakdown" then
        self:PrintBreakdown()
    elseif cmd == "spec" then
        addon:Print("Detected spec: |cff00ff00" .. (addon.playerSpec or "unknown") .. "|r")
    elseif cmd == "rescan" then
        local selfScanner = addon:GetModule("SelfScanner")
        if selfScanner then
            selfScanner:ScanEquipment()
            addon:Print("Rescan complete.")
        end
    elseif cmd == "diag" then
        self:RunDiagnostic()
    elseif cmd == "calibrate" then
        self:RunCalibration()
    elseif cmd == "log" then
        addon:PrintRecentLog(tonumber(args[2]) or 30)
    elseif cmd == "clearlog" then
        addon:ClearLog()
    else
        addon:Print("Unknown command: " .. cmd .. ". Type |cff00ff00/tgs help|r for a list.")
    end
end

function addon.SlashCommands:PrintScore()
    local selfScanner = addon:GetModule("SelfScanner")
    if not selfScanner or not selfScanner.currentScore then
        addon:DiagPrint("No score available yet. Try /tgs rescan")
        return
    end

    local score = selfScanner.currentScore
    local label = addon.ScoreColors:GetBracketLabel(score)
    local baseScore = selfScanner.baseOnlyScore or 0
    local bonus = score - baseScore
    addon:DiagPrint("Your TrueGearScore: " .. score .. " (" .. label .. ")")
    addon:DiagPrint("  Base (items only): " .. baseScore .. " | Gems+Enchants+Procs: +" .. bonus)
end

function addon.SlashCommands:PrintBreakdown()
    local selfScanner = addon:GetModule("SelfScanner")
    if not selfScanner or not selfScanner.currentScore then
        addon:DiagPrint("No score available yet. Try /tgs rescan")
        return
    end

    addon:DiagPrint("--- TrueGearScore Breakdown ---")

    local perSlot = selfScanner.perSlotScores or {}
    local perSlotDetails = selfScanner.perSlotDetails or {}
    local total = 0
    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local slotScore = perSlot[slotID]
        if slotScore and slotScore > 0 then
            local name = C.SLOT_NAMES[slotID] or ("Slot " .. slotID)
            addon:DiagPrint("  " .. name .. ": " .. slotScore)
            total = total + slotScore

            -- Log per-stat detail
            local details = perSlotDetails[slotID]
            if details then
                for _, d in ipairs(details) do
                    addon:Log("DIAG", "    " .. d.stat .. ": " .. d.value .. " x " .. string.format("%.2f", d.weight) .. " = " .. string.format("%.1f", d.contribution))
                end
            end
        end
    end

    addon:DiagPrint("  Total: " .. total .. " (" .. addon.ScoreColors:GetBracketLabel(total) .. ")")
end

function addon.SlashCommands:RunDiagnostic()
    addon:DiagPrint("--- Diagnostic ---")
    addon:DiagPrint("Class: " .. tostring(addon.playerClass))
    addon:DiagPrint("Spec: " .. tostring(addon.playerSpec))

    -- Check spec weights
    local specData = addon.StatWeights:GetSpecWeights(addon.playerSpec)
    addon:DiagPrint("Has weights: " .. tostring(specData ~= nil))
    if specData then
        local weightCount = 0
        for _ in pairs(specData.weights) do weightCount = weightCount + 1 end
        addon:DiagPrint("Weight entries: " .. weightCount)
    end

    -- Check equipped items
    local itemCount = 0
    local sampleLink = nil
    local sampleSlot = nil
    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local link = GetInventoryItemLink("player", slotID)
        if link then
            itemCount = itemCount + 1
            if not sampleLink then
                sampleLink = link
                sampleSlot = slotID
            end
        end
    end
    addon:DiagPrint("Equipped items: " .. itemCount)

    -- Test one item end-to-end
    if sampleLink then
        addon:DiagPrint("Sample slot " .. sampleSlot .. ": " .. sampleLink)

        -- Raw item link string (for debugging parse)
        local itemString = sampleLink:match("item:([%d:%-]+)")
        addon:DiagPrint("  Item string: " .. tostring(itemString))

        -- Raw GetItemStats output
        local rawStats = {}
        GetItemStats(sampleLink, rawStats)
        local statCount = 0
        for k, v in pairs(rawStats) do
            addon:DiagPrint("  Raw: " .. tostring(k) .. " = " .. tostring(v))
            statCount = statCount + 1
        end
        addon:DiagPrint("  Raw stat count: " .. statCount)

        -- Check if STAT_REVERSE has matching keys
        local matchCount = 0
        for k in pairs(rawStats) do
            if C.STAT_REVERSE[k] then
                matchCount = matchCount + 1
            else
                addon:DiagPrint("  UNMAPPED key: " .. tostring(k))
            end
        end
        addon:DiagPrint("  Mapped stats: " .. matchCount .. "/" .. statCount)

        -- Parsed link
        local parsed = addon.ItemScoring:ParseItemLink(sampleLink)
        if parsed then
            addon:DiagPrint("  Parsed itemID=" .. parsed.itemID .. " enchantID=" .. parsed.enchantID)
            addon:DiagPrint("  Parsed gems: " .. parsed.gems[1] .. ", " .. parsed.gems[2] .. ", " .. parsed.gems[3] .. ", " .. parsed.gems[4])
        else
            addon:DiagPrint("  ParseItemLink returned nil!")
        end

        -- Canonical stats
        local stats = addon.ItemScoring:GetBaseStats(sampleLink)
        local canonCount = 0
        for k, v in pairs(stats) do
            addon:DiagPrint("  Canonical: " .. k .. " = " .. v)
            canonCount = canonCount + 1
        end
        addon:DiagPrint("  Canonical stat count: " .. canonCount)

        -- Total stats (base + gems + enchant + proc)
        local totalStats = addon.ItemScoring:GetItemTotalStats(sampleLink)
        for k, v in pairs(totalStats) do
            addon:DiagPrint("  Total: " .. k .. " = " .. v)
        end
    else
        addon:DiagPrint("No items equipped!")
    end

    addon:DiagPrint("--- End Diagnostic ---")
    addon:Print("Diagnostic logged. /reload then check SavedVariables, or /tgs log")
end

function addon.SlashCommands:RunCalibration()
    local sets = addon.ReferenceSets
    if not sets then
        addon:DiagPrint("ReferenceSets not loaded!")
        return
    end

    addon:DiagPrint("=== CALIBRATION: Reference BIS Sets ===")
    addon:DiagPrint("Scoring base items only (no gems/enchants/procs)")

    -- Request all items first to ensure they're cached
    local allItemIDs = {}
    for setKey, setData in pairs(sets) do
        for slotID, itemID in pairs(setData.items) do
            allItemIDs[itemID] = true
        end
    end

    -- Pre-request all items
    local uncached = 0
    for itemID in pairs(allItemIDs) do
        local name = GetItemInfo(itemID)
        if not name then
            uncached = uncached + 1
            C_Item.RequestLoadItemDataByID(itemID)
        end
    end

    if uncached > 0 then
        addon:DiagPrint("Note: " .. uncached .. " items not yet cached — scoring what we can, skipping missing.")
    end

    -- Score each set using base stats only (item link built from ID, no enchant/gems)
    local orderedSets = {
        "PRIEST_HEAL_HEROIC_BLUES",
        "PRIEST_HEAL_PRERAID",
        "PRIEST_HEAL_P1",
        "PRIEST_HEAL_P2",
        "PRIEST_HEAL_P3",
        "PRIEST_HEAL_P4",
        "PRIEST_HEAL_P5",
    }

    for _, setKey in ipairs(orderedSets) do
        local setData = sets[setKey]
        if setData then
            local specKey = setData.spec
            local equippedItems = {}
            local missingItems = {}

            for slotID, itemID in pairs(setData.items) do
                -- Build a clean item link (no enchant, no gems) from itemID
                local _, itemLink = GetItemInfo(itemID)
                if itemLink then
                    equippedItems[slotID] = itemLink
                else
                    missingItems[#missingItems + 1] = itemID
                end
            end

            if #missingItems > 0 then
                addon:DiagPrint(setData.name .. ": SKIPPED (" .. #missingItems .. " items not cached)")
            else
                local result = addon.ItemScoring:ScoreCharacter(equippedItems, specKey)
                addon:DiagPrint(setData.name)
                addon:DiagPrint("  Base score: " .. result.baseOnlyScore .. " (raw " .. result.baseOnlyRaw .. ")")
                addon:DiagPrint("  Full score: " .. result.totalScore .. " (raw " .. result.rawScore .. ")")

                -- Per-slot breakdown (log only, not chat)
                for _, slotID in ipairs(C.EQUIP_SLOTS) do
                    local slotScore = result.perSlot[slotID]
                    if slotScore and slotScore > 0 then
                        local name = C.SLOT_NAMES[slotID] or ("Slot " .. slotID)
                        addon:Log("DIAG", "    " .. name .. ": " .. slotScore)
                    end
                end
            end
        end
    end

    addon:DiagPrint("=== CALIBRATION COMPLETE ===")
    addon:DiagPrint("Note: Scores are base-only (items from GetItemInfo have no gems/enchants)")
end

function addon.SlashCommands:ShowHelp()
    addon:Print("Commands:")
    addon:Print("  |cff00ff00/tgs|r — Show your TrueGearScore")
    addon:Print("  |cff00ff00/tgs breakdown|r — Per-slot score breakdown")
    addon:Print("  |cff00ff00/tgs spec|r — Show detected spec")
    addon:Print("  |cff00ff00/tgs rescan|r — Force gear rescan")
    addon:Print("  |cff00ff00/tgs diag|r — Run diagnostic (logs to SavedVariables)")
    addon:Print("  |cff00ff00/tgs log [n]|r — Show recent log entries")
    addon:Print("  |cff00ff00/tgs clearlog|r — Clear log")
    addon:Print("  |cff00ff00/tgs debug|r — Toggle debug mode")
    addon:Print("  |cff00ff00/tgs help|r — This message")
end
