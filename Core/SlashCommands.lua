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
    elseif cmd == "statkeys" then
        self:DumpStatKeys()
    elseif cmd == "diag" then
        self:RunDiagnostic()
    elseif cmd == "calibrate" then
        self:RunCalibration()
    elseif cmd == "log" then
        addon:PrintRecentLog(tonumber(args[2]) or 30)
    elseif cmd == "clearlog" then
        addon:ClearLog()
    elseif cmd == "config" or cmd == "options" then
        local options = addon:GetModule("Options")
        if options then
            options:Open()
        end
    elseif cmd == "report" then
        self:ReportScore(args[2])
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

    addon:DiagPrint("=== CALIBRATION: All Reference BIS Sets ===")

    -- Request all items first to ensure they're cached
    local allItemIDs = {}
    for setKey, setData in pairs(sets) do
        for slotID, itemID in pairs(setData.items) do
            allItemIDs[itemID] = true
        end
    end

    local uncached = 0
    for itemID in pairs(allItemIDs) do
        local name = GetItemInfo(itemID)
        if not name then
            uncached = uncached + 1
            C_Item.RequestLoadItemDataByID(itemID)
        end
    end

    if uncached > 0 then
        addon:DiagPrint("Note: " .. uncached .. " items not yet cached — scoring what we can.")
    end

    -- Score ALL reference sets, track P1 base scores per spec for normalization
    local p1BaseBySpec = {}  -- { [specKey] = baseOnlyRaw }
    local allResults = {}    -- { { setKey, name, spec, baseRaw, fullRaw } }

    for setKey, setData in pairs(sets) do
        local specKey = setData.spec
        local equippedItems = {}
        local missing = 0

        for slotID, itemID in pairs(setData.items) do
            local _, itemLink = GetItemInfo(itemID)
            if itemLink then
                equippedItems[slotID] = itemLink
            else
                missing = missing + 1
            end
        end

        if missing > 0 then
            addon:Log("DIAG", setData.name .. ": SKIPPED (" .. missing .. " uncached)")
        else
            -- Score WITHOUT spec scale (raw weights only) to get uncalibrated base
            local origScale = addon.StatWeights.SPEC_SCALE[specKey]
            addon.StatWeights.SPEC_SCALE[specKey] = 1.0
            local result = addon.ItemScoring:ScoreCharacter(equippedItems, specKey)
            addon.StatWeights.SPEC_SCALE[specKey] = origScale

            allResults[#allResults + 1] = {
                setKey = setKey,
                name = setData.name,
                spec = specKey,
                baseRaw = result.baseOnlyRaw,
                fullRaw = result.rawScore,
            }

            addon:Log("DIAG", setData.name .. " [" .. specKey .. "] base=" .. result.baseOnlyRaw .. " full=" .. result.rawScore)

            -- Track P1 sets for calibration anchor
            if setKey:match("_P1$") then
                p1BaseBySpec[specKey] = result.baseOnlyRaw
            end
        end
    end

    -- Compute SPEC_SCALE: normalize all P1 base scores to PRIEST_DISC P1 target
    local target = p1BaseBySpec["PRIEST_DISC"] or 1740
    addon:DiagPrint("Calibration target (PRIEST_DISC P1 base): " .. target)
    addon:DiagPrint("")
    addon:DiagPrint("=== SPEC_SCALE factors (paste into StatWeights.lua) ===")

    local scaleOutput = {}
    for specKey, p1Base in pairs(p1BaseBySpec) do
        local scale = target / p1Base
        scaleOutput[#scaleOutput + 1] = { spec = specKey, scale = scale, p1Base = p1Base }
    end

    -- Sort by spec name for readability
    table.sort(scaleOutput, function(a, b) return a.spec < b.spec end)

    for _, entry in ipairs(scaleOutput) do
        local scaleStr = string.format("%.3f", entry.scale)
        addon:DiagPrint("  [\"" .. entry.spec .. "\"] = " .. scaleStr .. ",  -- P1 base=" .. entry.p1Base)
    end

    -- Also show all set scores for verification
    addon:DiagPrint("")
    addon:DiagPrint("=== All set scores (raw, before SPEC_SCALE) ===")
    table.sort(allResults, function(a, b) return a.spec < b.spec or (a.spec == b.spec and a.baseRaw < b.baseRaw) end)
    for _, r in ipairs(allResults) do
        addon:Log("DIAG", r.spec .. " | " .. r.name .. " | base=" .. r.baseRaw .. " full=" .. r.fullRaw)
    end

    ---------------------------------------------------------------------------
    -- PVP_SPEC_SCALE calibration: S3 PvP BIS ≈ P3/BT/Hyjal PvE BIS
    ---------------------------------------------------------------------------
    -- For each spec with both a _PVP_S3 and _P3 reference set:
    --   1. Score the PvP set with PvP weights, SPEC_SCALE=1, no dampening (raw)
    --   2. Get the P3 PvE score (already scaled by SPEC_SCALE)
    --   3. PVP_SPEC_SCALE = P3_PvE_score / PvP_S3_raw
    -- This ensures S3 PvP gear scores the same as T6/BT/Hyjal PvE gear.
    ---------------------------------------------------------------------------

    -- Collect P3 PvE scaled scores and PVP_S3 raw PvP scores per spec
    local p3PveScaledBySpec = {}  -- { [specKey] = scaled P3 PvE score }
    local pvpS3RawBySpec = {}     -- { [specKey] = raw PvP S3 score (PvP weights, scale=1, no dampening) }

    for setKey, setData in pairs(sets) do
        local specKey = setData.spec
        local equippedItems = {}
        local missing = 0

        for slotID, itemID in pairs(setData.items) do
            local _, itemLink = GetItemInfo(itemID)
            if itemLink then
                equippedItems[slotID] = itemLink
            else
                missing = missing + 1
            end
        end

        if missing > 0 then
            -- skip incomplete sets
        elseif setKey:match("_P3$") then
            -- Score P3 PvE set WITH SPEC_SCALE (the calibrated PvE score)
            local result = addon.ItemScoring:ScoreCharacter(equippedItems, specKey, "pve")
            p3PveScaledBySpec[specKey] = result.totalScore
        elseif setKey:match("_PVP_S3$") then
            -- Score PvP S3 set with PvP weights but NO PVP_SPEC_SCALE and NO dampening
            -- Temporarily set PVP_SPEC_SCALE to 1.0 and bypass dampening
            local origPvpScale = addon.StatWeights.PVP_SPEC_SCALE[specKey]
            local origDampening = C.PVP_SCORE_DAMPENING
            addon.StatWeights.PVP_SPEC_SCALE[specKey] = 1.0
            C.PVP_SCORE_DAMPENING = 1.0
            local result = addon.ItemScoring:ScoreCharacter(equippedItems, specKey, "pvp")
            addon.StatWeights.PVP_SPEC_SCALE[specKey] = origPvpScale
            C.PVP_SCORE_DAMPENING = origDampening
            pvpS3RawBySpec[specKey] = result.totalScore
        end
    end

    -- Compute and output PVP_SPEC_SCALE
    local pvpScaleOutput = {}
    for specKey, pvpRaw in pairs(pvpS3RawBySpec) do
        local pveTarget = p3PveScaledBySpec[specKey]
        if pveTarget and pvpRaw > 0 then
            local pvpScale = pveTarget / pvpRaw
            pvpScaleOutput[#pvpScaleOutput + 1] = {
                spec = specKey,
                scale = pvpScale,
                pvpRaw = pvpRaw,
                pveTarget = pveTarget,
            }
        else
            addon:Log("DIAG", "PVP_SPEC_SCALE: " .. specKey .. " — missing P3 PvE set or zero PvP score, skipped")
        end
    end

    if #pvpScaleOutput > 0 then
        table.sort(pvpScaleOutput, function(a, b) return a.spec < b.spec end)
        addon:DiagPrint("")
        addon:DiagPrint("=== PVP_SPEC_SCALE factors (S3 PvP → P3/BT PvE target) ===")
        addon:DiagPrint("-- Paste into StatWeights.lua PVP_SPEC_SCALE table")
        for _, entry in ipairs(pvpScaleOutput) do
            local scaleStr = string.format("%.3f", entry.scale)
            addon:DiagPrint("  PVP_SPEC_SCALE[\"" .. entry.spec .. "\"] = " .. scaleStr .. ",  -- S3 raw=" .. entry.pvpRaw .. ", P3 PvE target=" .. entry.pveTarget)
        end
    else
        addon:DiagPrint("")
        addon:DiagPrint("PVP_SPEC_SCALE: No specs with both _PVP_S3 and _P3 reference sets found.")
    end

    addon:DiagPrint("=== CALIBRATION COMPLETE ===")
    addon:DiagPrint("Run /tgs log to view details, or /reload + check SavedVariables")
end

function addon.SlashCommands:DumpStatKeys()
    addon:DiagPrint("--- StatKey Audit: All Equipped Items ---")

    local unmappedAll = {}  -- { [key] = { count, exampleValue, exampleSlot } }
    local totalItems = 0
    local totalKeys = 0
    local mappedKeys = 0

    for _, slotID in ipairs(C.EQUIP_SLOTS) do
        local link = GetInventoryItemLink("player", slotID)
        if link then
            totalItems = totalItems + 1
            local slotName = C.SLOT_NAMES[slotID] or ("Slot " .. slotID)
            local rawStats = {}
            GetItemStats(link, rawStats)

            for key, value in pairs(rawStats) do
                totalKeys = totalKeys + 1
                if C.STAT_REVERSE[key] then
                    mappedKeys = mappedKeys + 1
                else
                    addon:Log("DIAG", "UNMAPPED | " .. slotName .. " | " .. tostring(key) .. " = " .. tostring(value) .. " | " .. link)
                    if not unmappedAll[key] then
                        unmappedAll[key] = { count = 0, exampleValue = value, exampleSlot = slotName }
                    end
                    unmappedAll[key].count = unmappedAll[key].count + 1
                end
            end
        end
    end

    -- Summary
    addon:DiagPrint("Scanned " .. totalItems .. " items, " .. totalKeys .. " stat keys total.")
    addon:DiagPrint("Mapped: " .. mappedKeys .. " | Unmapped: " .. (totalKeys - mappedKeys))

    local unmappedCount = 0
    for key, info in pairs(unmappedAll) do
        unmappedCount = unmappedCount + 1
        addon:DiagPrint("  |cffff4444" .. key .. "|r — seen " .. info.count .. "x (e.g., " .. info.exampleSlot .. " = " .. info.exampleValue .. ")")
    end

    if unmappedCount == 0 then
        addon:DiagPrint("|cff00ff00All stat keys are mapped.|r")
    else
        addon:DiagPrint(unmappedCount .. " unique unmapped key(s). Check /tgs log for per-item details.")
    end

    addon:DiagPrint("--- End StatKey Audit ---")
end

function addon.SlashCommands:ReportScore(channelArg)
    local selfScanner = addon:GetModule("SelfScanner")
    if not selfScanner or not selfScanner.currentScore then
        addon:Print("No score available yet. Try |cff00ff00/tgs rescan|r first.")
        return
    end

    local score = selfScanner.currentScore
    local label = addon.ScoreColors:GetBracketLabel(score)

    -- Determine chat channel
    local channel
    if channelArg then
        local arg = channelArg:upper()
        if arg == "PARTY" or arg == "RAID" or arg == "GUILD" or arg == "SAY" then
            channel = arg
        else
            addon:Print("Invalid channel: " .. channelArg .. ". Use: party, raid, guild, say")
            return
        end
    else
        -- Auto-detect based on current group status
        if IsInRaid() then
            channel = "RAID"
        elseif IsInGroup() then
            channel = "PARTY"
        elseif IsInGuild() then
            channel = "GUILD"
        else
            addon:Print("Not in a guild or group. Specify channel: |cff00ff00/tgs report <party|raid|guild|say>|r")
            return
        end
    end

    SendChatMessage("TrueGearScore: " .. score .. " (" .. label .. ")", channel)
    addon:Print("Score reported to " .. channel)
end

function addon.SlashCommands:ShowHelp()
    addon:Print("Commands:")
    addon:Print("  |cff00ff00/tgs|r — Show your TrueGearScore")
    addon:Print("  |cff00ff00/tgs report [channel]|r — Share score to chat (party/raid/guild/say)")
    addon:Print("  |cff00ff00/tgs breakdown|r — Per-slot score breakdown")
    addon:Print("  |cff00ff00/tgs spec|r — Show detected spec")
    addon:Print("  |cff00ff00/tgs rescan|r — Force gear rescan")
    addon:Print("  |cff00ff00/tgs statkeys|r — Audit GetItemStats keys for unmapped entries")
    addon:Print("  |cff00ff00/tgs diag|r — Run diagnostic (logs to SavedVariables)")
    addon:Print("  |cff00ff00/tgs log [n]|r — Show recent log entries")
    addon:Print("  |cff00ff00/tgs clearlog|r — Clear log")
    addon:Print("  |cff00ff00/tgs config|r — Open options panel")
    addon:Print("  |cff00ff00/tgs debug|r — Toggle debug mode")
    addon:Print("  |cff00ff00/tgs help|r — This message")
end
