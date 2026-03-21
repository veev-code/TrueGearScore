---------------------------------------------------------------------------
-- TrueGearScore Stat Weights
-- Per-class/spec weight tables and stat cap definitions (PvE)
--
-- Weights are pre-calibrated so that base item stats (no gems/enchants/procs)
-- produce scores comparable to TacoTip GearScore. Gems, enchants, and procs
-- add on top — rewarding player effort.
--
-- Weight convention: values are calibrated, not normalized to 1.0.
-- Relative ratios between stats within a spec are what matter.
--
-- Cap structure per stat:
--   softCap:  full weight up to this value
--   hardCap:  zero weight past this value
--   overCapWeight: multiplier for points between softCap and hardCap
---------------------------------------------------------------------------

local _, addon = ...
addon.StatWeights = {}

---------------------------------------------------------------------------
-- Stat caps reference (at level 70):
--   Melee special hit cap: 142 rating = 9%
--   Melee DW white hit cap: ~363-408 rating (varies with talents)
--   Caster hit cap (base): 202 rating = 16% (reduced by talents)
--   Expertise dodge cap: 95 rating = 26 expertise = 6.5%
--   Defense cap (uncrittable): 490 defense skill (= 332 rating above base 350)
---------------------------------------------------------------------------

addon.StatWeights.SPECS = {

    ---------------------------------------------------------------------------
    -- WARRIOR
    ---------------------------------------------------------------------------

    WARRIOR_ARMS = {
        weights = {
            STRENGTH     = 0.78,
            AGILITY      = 0.51,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.67,
            HASTE_RATING = 0.55,
            EXPERTISE    = 0.86,
            ARMOR_PEN    = 0.59,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    WARRIOR_FURY = {
        weights = {
            STRENGTH     = 0.78,
            AGILITY      = 0.51,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 1.02,
            CRIT_RATING  = 0.71,
            HASTE_RATING = 0.51,
            EXPERTISE    = 0.86,
            ARMOR_PEN    = 0.55,
            STAMINA      = 0.04,
        },
        caps = {
            -- DW: 142 for specials (soft), 363 for white hits with Precision
            HIT_RATING = { softCap = 142, hardCap = 363, overCapWeight = 0.25 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    WARRIOR_PROT = {
        weights = {
            STAMINA      = 0.78,
            ARMOR        = 0.04,
            DEFENSE      = 0.63,
            DODGE        = 0.59,
            PARRY        = 0.55,
            BLOCK_RATING = 0.47,
            EXPERTISE    = 0.67,
            HIT_RATING   = 0.39,
            STRENGTH     = 0.24,
            AGILITY      = 0.31,
            ATTACK_POWER = 0.12,
        },
        caps = {
            DEFENSE    = { softCap = 332, hardCap = 400, overCapWeight = 0.30 },
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- PALADIN
    ---------------------------------------------------------------------------

    PALADIN_HOLY = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.67,
            SPELL_POWER  = 0.63,
            MP5          = 0.71,
            CRIT_RATING  = 0.59,
            HASTE_RATING = 0.47,
            STAMINA      = 0.08,
            SPIRIT       = 0.20,
        },
        caps = {},
    },

    PALADIN_PROT = {
        weights = {
            STAMINA      = 0.78,
            ARMOR        = 0.04,
            DEFENSE      = 0.63,
            DODGE        = 0.51,
            PARRY        = 0.47,
            BLOCK_RATING = 0.55,
            SPELL_POWER  = 0.31,
            HIT_RATING   = 0.35,
            EXPERTISE    = 0.59,
            INTELLECT    = 0.24,
            STRENGTH     = 0.16,
        },
        caps = {
            DEFENSE    = { softCap = 332, hardCap = 400, overCapWeight = 0.30 },
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    PALADIN_RET = {
        weights = {
            STRENGTH     = 0.78,
            ATTACK_POWER = 0.39,
            CRIT_RATING  = 0.63,
            HIT_RATING   = 0.86,
            HASTE_RATING = 0.51,
            EXPERTISE    = 0.82,
            AGILITY      = 0.43,
            SPELL_POWER  = 0.24,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- HUNTER
    ---------------------------------------------------------------------------

    HUNTER_BM = {
        weights = {
            AGILITY      = 0.78,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.59,
            HASTE_RATING = 0.55,
            INTELLECT    = 0.16,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
        },
    },

    HUNTER_MM = {
        weights = {
            AGILITY      = 0.78,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.63,
            HASTE_RATING = 0.51,
            ARMOR_PEN    = 0.43,
            INTELLECT    = 0.16,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
        },
    },

    HUNTER_SURV = {
        weights = {
            AGILITY      = 0.78,
            ATTACK_POWER = 0.35,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.67,
            HASTE_RATING = 0.47,
            INTELLECT    = 0.16,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- ROGUE
    ---------------------------------------------------------------------------

    ROGUE_ASSASSIN = {
        weights = {
            AGILITY      = 0.78,
            STRENGTH     = 0.43,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 1.02,
            CRIT_RATING  = 0.67,
            HASTE_RATING = 0.63,
            EXPERTISE    = 0.94,
            ARMOR_PEN    = 0.51,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 79, hardCap = 363, overCapWeight = 0.30 },
            EXPERTISE  = { softCap = 95, hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    ROGUE_COMBAT = {
        weights = {
            AGILITY      = 0.78,
            STRENGTH     = 0.43,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 1.02,
            CRIT_RATING  = 0.64,
            HASTE_RATING = 0.71,
            EXPERTISE    = 0.94,
            ARMOR_PEN    = 0.55,
            STAMINA      = 0.04,
        },
        caps = {
            -- 5/5 Precision = 5% hit from talents, so 79 rating = 9% special cap
            HIT_RATING = { softCap = 79, hardCap = 363, overCapWeight = 0.30 },
            EXPERTISE  = { softCap = 95, hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    ROGUE_SUBTLETY = {
        weights = {
            AGILITY      = 0.78,
            STRENGTH     = 0.43,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 0.98,
            CRIT_RATING  = 0.63,
            HASTE_RATING = 0.59,
            EXPERTISE    = 0.90,
            ARMOR_PEN    = 0.47,
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 79, hardCap = 363, overCapWeight = 0.30 },
            EXPERTISE  = { softCap = 95, hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- PRIEST
    ---------------------------------------------------------------------------

    PRIEST_DISC = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.71,
            SPELL_POWER  = 0.67,
            MP5          = 0.63,
            SPIRIT       = 0.51,
            HASTE_RATING = 0.47,
            CRIT_RATING  = 0.43,
            STAMINA      = 0.08,
        },
        caps = {},
    },

    PRIEST_HOLY = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.71,
            SPELL_POWER  = 0.67,
            SPIRIT       = 0.59,
            MP5          = 0.55,
            HASTE_RATING = 0.51,
            CRIT_RATING  = 0.43,
            STAMINA      = 0.08,
        },
        caps = {},
    },

    PRIEST_SHADOW = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            HASTE_RATING = 0.63,
            CRIT_RATING  = 0.51,
            INTELLECT    = 0.39,
            SPIRIT       = 0.31,
            STAMINA      = 0.04,
            MP5          = 0.24,
        },
        caps = {
            -- Shadow: 10% from Shadow Focus, need 6% from gear = 76 rating
            HIT_RATING = { softCap = 76, hardCap = 76, overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- SHAMAN
    ---------------------------------------------------------------------------

    SHAMAN_ELE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.06,
            CRIT_RATING  = 0.63,
            HASTE_RATING = 0.67,
            INTELLECT    = 0.43,
            MP5          = 0.35,
            STAMINA      = 0.04,
        },
        caps = {
            -- Elemental: 3% from Elemental Precision, need 13% from gear = 164 rating
            HIT_RATING = { softCap = 164, hardCap = 164, overCapWeight = 0.0 },
        },
    },

    SHAMAN_ENH = {
        weights = {
            AGILITY      = 0.71,
            STRENGTH     = 0.74,
            ATTACK_POWER = 0.39,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.67,
            HASTE_RATING = 0.59,
            EXPERTISE    = 0.86,
            INTELLECT    = 0.20,
            STAMINA      = 0.04,
        },
        caps = {
            -- DW: 142 for specials, higher for white hits with Nature's Guidance
            HIT_RATING = { softCap = 95, hardCap = 363, overCapWeight = 0.25 },
            EXPERTISE  = { softCap = 95, hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    SHAMAN_RESTO = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.67,
            SPELL_POWER  = 0.63,
            MP5          = 0.71,
            HASTE_RATING = 0.51,
            CRIT_RATING  = 0.47,
            SPIRIT       = 0.16,
            STAMINA      = 0.08,
        },
        caps = {},
    },

    ---------------------------------------------------------------------------
    -- MAGE
    ---------------------------------------------------------------------------

    MAGE_ARCANE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            HASTE_RATING = 0.71,
            CRIT_RATING  = 0.55,
            INTELLECT    = 0.59,
            SPIRIT       = 0.24,
            STAMINA      = 0.04,
        },
        caps = {
            -- Arcane: 6% from Arcane Focus, need 10% from gear = 126 rating
            HIT_RATING = { softCap = 126, hardCap = 126, overCapWeight = 0.0 },
        },
    },

    MAGE_FIRE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            CRIT_RATING  = 0.63,
            HASTE_RATING = 0.67,
            INTELLECT    = 0.47,
            SPIRIT       = 0.12,
            STAMINA      = 0.04,
        },
        caps = {
            -- Fire: 3% from Elemental Precision, need 13% from gear = 164 rating
            HIT_RATING = { softCap = 164, hardCap = 164, overCapWeight = 0.0 },
        },
    },

    MAGE_FROST = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            CRIT_RATING  = 0.55,
            HASTE_RATING = 0.67,
            INTELLECT    = 0.51,
            SPIRIT       = 0.16,
            STAMINA      = 0.04,
        },
        caps = {
            -- Frost: 3% from Elemental Precision, need 13% from gear = 164 rating
            HIT_RATING = { softCap = 164, hardCap = 164, overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- WARLOCK
    ---------------------------------------------------------------------------

    WARLOCK_AFFLIC = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.06,
            HASTE_RATING = 0.67,
            CRIT_RATING  = 0.43,
            INTELLECT    = 0.39,
            SPIRIT       = 0.31,
            STAMINA      = 0.08,
        },
        caps = {
            -- Affliction: 2% from Suppression, need 14% from gear = 177 rating
            HIT_RATING = { softCap = 177, hardCap = 177, overCapWeight = 0.0 },
        },
    },

    WARLOCK_DEMO = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.06,
            HASTE_RATING = 0.63,
            CRIT_RATING  = 0.51,
            INTELLECT    = 0.43,
            STAMINA      = 0.12,
            SPIRIT       = 0.24,
        },
        caps = {
            -- Demo: no hit talents, need full 16% from gear = 202 rating
            HIT_RATING = { softCap = 202, hardCap = 202, overCapWeight = 0.0 },
        },
    },

    WARLOCK_DESTRO = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.06,
            CRIT_RATING  = 0.63,
            HASTE_RATING = 0.67,
            INTELLECT    = 0.39,
            STAMINA      = 0.08,
            SPIRIT       = 0.20,
        },
        caps = {
            -- Destro: no hit talents (or 1% from Cataclysm), need ~15% = 190 rating
            HIT_RATING = { softCap = 190, hardCap = 190, overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- DRUID
    ---------------------------------------------------------------------------

    DRUID_BALANCE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.06,
            CRIT_RATING  = 0.59,
            HASTE_RATING = 0.67,
            INTELLECT    = 0.47,
            SPIRIT       = 0.27,
            MP5          = 0.31,
            STAMINA      = 0.04,
        },
        caps = {
            -- Balance: 4% from Balance of Power, need 12% from gear = 152 rating
            HIT_RATING = { softCap = 152, hardCap = 152, overCapWeight = 0.0 },
        },
    },

    DRUID_FERAL = {
        weights = {
            AGILITY      = 0.78,
            STRENGTH     = 0.63,
            ATTACK_POWER = 0.35,
            HIT_RATING   = 0.94,
            CRIT_RATING  = 0.67,
            HASTE_RATING = 0.43,
            EXPERTISE    = 0.86,
            ARMOR_PEN    = 0.55,
            ARMOR        = 0.02,
            STAMINA      = 0.08,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    DRUID_RESTO = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.71,
            SPELL_POWER  = 0.67,
            SPIRIT       = 0.63,
            MP5          = 0.59,
            HASTE_RATING = 0.51,
            CRIT_RATING  = 0.39,
            STAMINA      = 0.08,
        },
        caps = {},
    },
}

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------

function addon.StatWeights:GetSpecWeights(specKey)
    return self.SPECS[specKey]
end

function addon.StatWeights:GetSpecCap(specKey, statName)
    local spec = self.SPECS[specKey]
    return spec and spec.caps and spec.caps[statName]
end
