local _, addon = ...
addon.Database = {}

local C = addon.Constants

function addon.Database:Initialize()
    local AceDB = LibStub("AceDB-3.0")
    local defaults = { profile = C.DEFAULTS.profile }

    addon.db = AceDB:New("TrueGearScoreDB", defaults, true)

    addon.db.RegisterCallback(addon, "OnNewProfile", "OnProfileChanged")
    addon.db.RegisterCallback(addon, "OnProfileChanged", "OnProfileChanged")
    addon.db.RegisterCallback(addon, "OnProfileCopied", "OnProfileChanged")
    addon.db.RegisterCallback(addon, "OnProfileReset", "OnProfileChanged")
end

function addon:OnProfileChanged()
    -- Refresh modules on profile change
    for _, module in pairs(self.modules) do
        if module.Refresh then
            local ok, err = pcall(module.Refresh, module)
            if not ok then
                self:PrintError("Failed to refresh module " .. (module.name or "?") .. ": " .. tostring(err))
            end
        end
    end

    -- Rescore
    local selfScanner = self:GetModule("SelfScanner")
    if selfScanner and selfScanner.ScanEquipment then
        selfScanner:ScanEquipment()
    end
end
