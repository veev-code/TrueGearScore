---------------------------------------------------------------------------
-- TrueGearScore Options Panel
-- AceConfig-3.0 options table, registered with Interface Options.
-- Open via /tgs config, /tgs options, or Interface → AddOns → TrueGearScore.
---------------------------------------------------------------------------

local _, addon = ...

local M = {}
M.addon = addon
addon:RegisterModule("Options", M)

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

---------------------------------------------------------------------------
-- Options table
---------------------------------------------------------------------------

local function GetOptionsTable()
    return {
        type = "group",
        name = "TrueGearScore",
        args = {
            general = {
                type = "group",
                name = "General",
                order = 1,
                inline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        name = "Enable TrueGearScore",
                        desc = "Enable or disable the addon entirely.",
                        width = "full",
                        order = 1,
                        get = function() return addon.db.profile.enabled end,
                        set = function(_, val)
                            addon.db.profile.enabled = val
                            M:RefreshAll()
                        end,
                    },
                },
            },
            display = {
                type = "group",
                name = "Display",
                order = 2,
                inline = true,
                args = {
                    showPaperdoll = {
                        type = "toggle",
                        name = "Character Panel Score",
                        desc = "Show your TrueGearScore on the character (paperdoll) panel.",
                        width = "full",
                        order = 1,
                        get = function() return addon.db.profile.showPaperdoll end,
                        set = function(_, val)
                            addon.db.profile.showPaperdoll = val
                            M:RefreshModule("Paperdoll")
                        end,
                    },
                    showUnitTooltip = {
                        type = "toggle",
                        name = "Unit Tooltip Score",
                        desc = "Show TrueGearScore on player unit tooltips (mouseover, target).",
                        width = "full",
                        order = 2,
                        get = function() return addon.db.profile.showUnitTooltip end,
                        set = function(_, val)
                            addon.db.profile.showUnitTooltip = val
                            M:RefreshModule("UnitTooltip")
                        end,
                    },
                    showItemTooltip = {
                        type = "toggle",
                        name = "Item Tooltip Score",
                        desc = "Show per-item TrueGearScore on item tooltips. Off by default — can be noisy.",
                        width = "full",
                        order = 3,
                        get = function() return addon.db.profile.showItemTooltip end,
                        set = function(_, val)
                            addon.db.profile.showItemTooltip = val
                            M:RefreshModule("ItemTooltip")
                        end,
                    },
                    showInspectFrame = {
                        type = "toggle",
                        name = "Inspect Frame Score",
                        desc = "Show TrueGearScore on the inspect frame when inspecting other players.",
                        width = "full",
                        order = 4,
                        get = function() return addon.db.profile.showInspectFrame end,
                        set = function(_, val)
                            addon.db.profile.showInspectFrame = val
                            M:RefreshModule("InspectFrameDisplay")
                        end,
                    },
                },
            },
            debug = {
                type = "group",
                name = "Debug",
                order = 3,
                inline = true,
                args = {
                    debugMode = {
                        type = "toggle",
                        name = "Debug Mode",
                        desc = "Enable verbose debug output in chat and the log.",
                        width = "full",
                        order = 1,
                        get = function() return addon.db.profile.debugMode end,
                        set = function(_, val)
                            addon.db.profile.debugMode = val
                        end,
                    },
                },
            },
        },
    }
end

---------------------------------------------------------------------------
-- Refresh helpers
---------------------------------------------------------------------------

function M:RefreshModule(name)
    local mod = addon:GetModule(name)
    if mod and mod.Refresh then
        local ok, err = pcall(mod.Refresh, mod)
        if not ok then
            addon:PrintError("Failed to refresh " .. name .. ": " .. tostring(err))
        end
    end
end

function M:RefreshAll()
    for _, mod in pairs(addon.modules) do
        if mod.Refresh then
            local ok, err = pcall(mod.Refresh, mod)
            if not ok then
                addon:PrintError("Failed to refresh " .. (mod.name or "?") .. ": " .. tostring(err))
            end
        end
    end
end

---------------------------------------------------------------------------
-- Open the options panel
---------------------------------------------------------------------------

function M:Open()
    -- InterfaceOptionsFrame_OpenToCategory needs to be called twice on first open
    -- (known Blizzard bug). AceConfigDialog handles this internally.
    AceConfigDialog:Open("TrueGearScore")
end

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

function M:Initialize()
    AceConfig:RegisterOptionsTable("TrueGearScore", GetOptionsTable)
    AceConfigDialog:AddToBlizOptions("TrueGearScore", "TrueGearScore")
end
