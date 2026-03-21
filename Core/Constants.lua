local _, addon = ...
addon.Constants = {}
local C = addon.Constants

---------------------------------------------------------------------------
-- Score color brackets (calibrated to TacoTip TBC ranges: BRACKET_SIZE=400)
---------------------------------------------------------------------------

C.BRACKET_SIZE = 400

-- WarcraftLogs-inspired color scheme.
-- Thresholds calibrated against reference gear sets:
--   Blue entry  = full ilvl 115 blues, no gems/enchants (score 1085)
--   Purple entry = full Kara ilvl 115 epics, no gems/enchants (score 1740)
-- Gems/enchants push players deeper into brackets or into the next one.
-- WarcraftLogs-inspired colors with WoW-standard quality labels.
-- Thresholds calibrated against reference gear sets:
--   Rare (blue) entry  = full ilvl 115 blues, no gems/enchants (score 1085)
--   Epic (purple) entry = full Kara ilvl 115 epics, no gems/enchants (score 1740)
-- Gems/enchants push players deeper into brackets or into the next one.
C.SCORE_BRACKETS = {
    { threshold = 3100, label = "Ascendant",  color = { 0.90, 0.80, 0.50 } }, -- Gold (#e5cc80) — Full Sunwell BIS, perfect everything
    { threshold = 2800, label = "Mythic",     color = { 0.89, 0.41, 0.66 } }, -- Pink (#e268a8) — Sunwell geared, near-perfect
    { threshold = 2400, label = "Legendary",  color = { 1.00, 0.50, 0.00 } }, -- Orange (#ff8000) — T6 optimized
    { threshold = 1740, label = "Epic",       color = { 0.64, 0.21, 0.93 } }, -- Purple (#a335ee) — Kara/T4/T5 raider
    { threshold = 1085, label = "Rare",       color = { 0.00, 0.44, 0.87 } }, -- Blue (#0070ff) — Heroic geared, raid-ready
    { threshold = 500,  label = "Uncommon",   color = { 0.12, 1.00, 0.00 } }, -- Green (#1eff00) — Normal dungeons, gearing up
    { threshold = 0,    label = "Poor",       color = { 0.40, 0.40, 0.40 } }, -- Grey (#666666) — Fresh 70
}

-- Expansion-wide theoretical max (full Sunwell BIS, perfect gems/enchants, all specs)
C.MAX_PLAUSIBLE_SCORE = 3500

-- Calibration scale factor: raw score × SCALE = displayed score
-- Weights in StatWeights.lua are pre-calibrated so base items ≈ TacoTip GearScore.
-- This scale factor is reserved for future global tuning if needed.
C.SCORE_SCALE = 1.0

---------------------------------------------------------------------------
-- Equipment slots (skip slot 4 = shirt)
---------------------------------------------------------------------------

C.EQUIP_SLOTS = { 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 }

C.SLOT_NAMES = {
    [1]  = "Head",
    [2]  = "Neck",
    [3]  = "Shoulder",
    [5]  = "Chest",
    [6]  = "Waist",
    [7]  = "Legs",
    [8]  = "Feet",
    [9]  = "Wrist",
    [10] = "Hands",
    [11] = "Finger 1",
    [12] = "Finger 2",
    [13] = "Trinket 1",
    [14] = "Trinket 2",
    [15] = "Back",
    [16] = "Main Hand",
    [17] = "Off Hand",
    [18] = "Ranged",
}

---------------------------------------------------------------------------
-- Stat key mappings
-- GetItemStats() returns keys like "ITEM_MOD_STRENGTH_SHORT" => value
-- We map to short canonical names for weight lookups
---------------------------------------------------------------------------

-- Forward mapping: canonical name => GetItemStats key(s)
-- Some canonical stats map to multiple GetItemStats keys (e.g., TBC splits spell damage/healing)
C.STAT_KEYS = {
    STRENGTH     = "ITEM_MOD_STRENGTH_SHORT",
    AGILITY      = "ITEM_MOD_AGILITY_SHORT",
    STAMINA      = "ITEM_MOD_STAMINA_SHORT",
    INTELLECT    = "ITEM_MOD_INTELLECT_SHORT",
    SPIRIT       = "ITEM_MOD_SPIRIT_SHORT",
    HIT_RATING   = "ITEM_MOD_HIT_RATING_SHORT",
    CRIT_RATING  = "ITEM_MOD_CRIT_RATING_SHORT",
    HASTE_RATING = "ITEM_MOD_HASTE_RATING_SHORT",
    ATTACK_POWER = "ITEM_MOD_ATTACK_POWER_SHORT",
    DEFENSE      = "ITEM_MOD_DEFENSE_RATING_SHORT",
    DODGE        = "ITEM_MOD_DODGE_RATING_SHORT",
    PARRY        = "ITEM_MOD_PARRY_RATING_SHORT",
    BLOCK_RATING = "ITEM_MOD_BLOCK_RATING_SHORT",
    RESILIENCE   = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    EXPERTISE    = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ARMOR_PEN    = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    SPELL_PEN    = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    BLOCK_VALUE  = "ITEM_MOD_BLOCK_VALUE_SHORT",
}

-- Reverse lookup: GetItemStats key => canonical stat name
-- TBC Classic uses different keys than retail/WotLK:
--   - Spell damage and healing are separate stats (no unified SPELL_POWER)
--   - MP5 key is ITEM_MOD_POWER_REGEN0_SHORT (not MANA_REGENERATION)
--   - Armor is RESISTANCE0_NAME
C.STAT_REVERSE = {}
for canonical, itemModKey in pairs(C.STAT_KEYS) do
    C.STAT_REVERSE[itemModKey] = canonical
end

-- TBC-specific stat mappings
-- Spell damage → SPELL_POWER (for DPS casters)
C.STAT_REVERSE["ITEM_MOD_SPELL_DAMAGE_DONE"] = "SPELL_POWER"
-- Spell healing → HEAL_POWER (separate weight for healers)
C.STAT_REVERSE["ITEM_MOD_SPELL_HEALING_DONE"] = "HEAL_POWER"
-- MP5
C.STAT_REVERSE["ITEM_MOD_POWER_REGEN0_SHORT"] = "MP5"
-- Armor (useful for tanks)
C.STAT_REVERSE["RESISTANCE0_NAME"] = "ARMOR"
-- Also try the retail-style keys in case some items use them
C.STAT_REVERSE["ITEM_MOD_SPELL_POWER_SHORT"] = "SPELL_POWER"
C.STAT_REVERSE["ITEM_MOD_MANA_REGENERATION_SHORT"] = "MP5"

---------------------------------------------------------------------------
-- Spec detection: class + talent tree index => spec key
---------------------------------------------------------------------------

C.SPEC_MAP = {
    WARRIOR = { "WARRIOR_ARMS",     "WARRIOR_FURY",     "WARRIOR_PROT" },
    PALADIN = { "PALADIN_HOLY",     "PALADIN_PROT",     "PALADIN_RET" },
    HUNTER  = { "HUNTER_BM",        "HUNTER_MM",        "HUNTER_SURV" },
    ROGUE   = { "ROGUE_ASSASSIN",   "ROGUE_COMBAT",     "ROGUE_SUBTLETY" },
    PRIEST  = { "PRIEST_DISC",      "PRIEST_HOLY",      "PRIEST_SHADOW" },
    SHAMAN  = { "SHAMAN_ELE",       "SHAMAN_ENH",       "SHAMAN_RESTO" },
    MAGE    = { "MAGE_ARCANE",      "MAGE_FIRE",        "MAGE_FROST" },
    WARLOCK = { "WARLOCK_AFFLIC",   "WARLOCK_DEMO",     "WARLOCK_DESTRO" },
    DRUID   = { "DRUID_BALANCE",    "DRUID_FERAL",      "DRUID_RESTO" },
}

---------------------------------------------------------------------------
-- Default profile (AceDB)
---------------------------------------------------------------------------

C.DEFAULTS = {
    profile = {
        enabled = true,
        showPaperdoll = true,
        showItemTooltip = false,
        debugMode = false,
    },
}
