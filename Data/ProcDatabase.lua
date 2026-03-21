---------------------------------------------------------------------------
-- TrueGearScore Proc Database
-- Maps item IDs to equivalent stat budgets for proc/equip effects
-- Values represent average-uptime equivalent stats based on sim data
-- Format: [itemID] = { STAT_NAME = value, ... }
-- Stat names match canonical keys in Constants.STAT_KEYS
--
-- These values are intentionally approximate. The goal is "directionally
-- correct" so that proc-heavy items like DST score appropriately rather
-- than being penalized for low ilvl.
---------------------------------------------------------------------------

local _, addon = ...
addon.ProcDatabase = {

    -- ===== Trinkets =====

    -- Dragonspine Trophy (Gruul's Lair)
    -- 325 haste/10s, ~1 PPM ≈ ~12% uptime → 40 haste avg
    [28830] = { HASTE_RATING = 40 },

    -- Icon of the Silver Crescent (Badge of Justice)
    -- 155 SP/20s on-use/2min = 25.8 avg + passive 43 SP (passive already in GetItemStats)
    [29370] = { SPELL_POWER = 26 },

    -- Bloodlust Brooch (Badge of Justice)
    -- 278 AP/20s on-use/2min = 46 avg + passive 72 AP (passive already in GetItemStats)
    [29383] = { ATTACK_POWER = 46 },

    -- Skull of Gul'dan (Black Temple)
    -- 175 haste/20s on-use/2min = 29 avg + passive 55 SP (passive in GetItemStats)
    [32483] = { HASTE_RATING = 29 },

    -- Eye of Magtheridon (Magtheridon's Lair)
    -- 170 SP/10s on crit, ~25% uptime → 43 SP avg + passive 54 SP (passive in GetItemStats)
    [28789] = { SPELL_POWER = 43 },

    -- Hourglass of the Unraveller (Black Morass)
    -- 300 AP/10s, ~10% uptime → 30 AP avg
    [28034] = { ATTACK_POWER = 30 },

    -- Tsunami Talisman (SSC - Leotheras)
    -- 340 AP/10s, ~10% uptime → 34 AP avg + passive 38 crit (passive in GetItemStats)
    [30627] = { ATTACK_POWER = 34 },

    -- Sextant of Unstable Currents (SSC - Hydross)
    -- 190 SP/15s, ~20% uptime → 38 SP avg + passive 40 crit (passive in GetItemStats)
    [30626] = { SPELL_POWER = 38 },

    -- Blackened Naaru Sliver (Black Temple)
    -- Passive 44 haste + 55 AP/20s on-use/2min (passive in GetItemStats)
    [34427] = { ATTACK_POWER = 18 },

    -- Shard of Contempt (Magisters' Terrace)
    -- 230 AP/20s, ~30% uptime → 69 AP avg (passive 44 expertise in GetItemStats)
    [34472] = { ATTACK_POWER = 69 },

    -- Hex Shrunken Head (Zul'Aman)
    -- 211 SP/20s on-use/2min = 35 avg + passive 53 SP (passive in GetItemStats)
    [33829] = { SPELL_POWER = 35 },

    -- Berserker's Call (Zul'Aman)
    -- 360 AP/20s on-use/2min = 60 avg + passive 90 AP (passive in GetItemStats)
    [33831] = { ATTACK_POWER = 60 },
}
