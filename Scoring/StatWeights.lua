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

    -- Arms Warrior: Deep Wounds + Impale make crit core. Moderate haste value.
    -- 1 STR = 2.2 AP (w/ BoK). Weapon Mastery reduces expertise cap.
    -- Sources: Landsoul spreadsheet, Warcraft Tavern, WoWSims
    WARRIOR_ARMS = {
        weights = {
            STRENGTH     = 0.78,   -- Primary; 1 STR = 2.2 AP w/ BoK
            AGILITY      = 0.24,   -- 33 AGI = 1% crit; poor scaling for warrior
            ATTACK_POWER = 0.35,
            HIT_RATING   = 0.67,   -- High value up to 9% cap
            CRIT_RATING  = 0.64,   -- Core: Deep Wounds, Impale, Flurry
            HASTE_RATING = 0.41,   -- Moderate; boosts white DPS + rage
            EXPERTISE    = 0.89,   -- Very high until cap
            ARMOR_PEN    = 0.39,   -- Grows in later tiers
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            -- Weapon Mastery: softCap 57 (with 2/2), full cap 95 without
            EXPERTISE  = { softCap = 57,  hardCap = 95,  overCapWeight = 0.15 },
        },
    },

    -- Fury Warrior: DW spec. Hit has value past special cap for white hits.
    -- Haste more valuable than Arms due to DW + Flurry interaction.
    -- Sources: Landsoul spreadsheet, Warcraft Tavern, WoWSims
    WARRIOR_FURY = {
        weights = {
            STRENGTH     = 0.78,
            AGILITY      = 0.24,
            ATTACK_POWER = 0.35,
            HIT_RATING   = 0.71,   -- Higher than Arms: DW white hit value
            CRIT_RATING  = 0.62,   -- Flurry, Rampage, Deep Wounds
            HASTE_RATING = 0.47,   -- DW benefits more from haste
            EXPERTISE    = 0.89,
            ARMOR_PEN    = 0.37,
            STAMINA      = 0.04,
        },
        caps = {
            -- DW: 142 for specials (soft), ~363 for white hits
            HIT_RATING = { softCap = 142, hardCap = 363, overCapWeight = 0.25 },
            EXPERTISE  = { softCap = 57,  hardCap = 95,  overCapWeight = 0.15 },
        },
    },

    -- Prot Warrior: Shield Block + uncrittable. Block Value = threat (Shield Slam) + mitigation.
    -- Sources: Fight Club discord, Wowhead, WoWSims Prot Warrior
    WARRIOR_PROT = {
        weights = {
            STAMINA      = 0.78,
            ARMOR        = 0.12,   -- Primary EH stat alongside STA
            DEFENSE      = 0.63,
            DODGE        = 0.59,
            PARRY        = 0.55,
            BLOCK_RATING = 0.47,
            BLOCK_VALUE  = 0.20,   -- Shield Slam damage + damage reduction on blocks
            EXPERTISE    = 0.67,
            HIT_RATING   = 0.39,
            STRENGTH     = 0.31,   -- AP + block value via talents
            AGILITY      = 0.31,   -- Dodge + armor + crit
            ATTACK_POWER = 0.12,
            RESILIENCE   = 0.12,   -- Path to uncrittable
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

    -- Holy Paladin: Flash of Light / Holy Light focused. Intellect is primary:
    -- Holy Guidance (35% Int → +heal), mana pool, crit chance.
    -- Crit very strong: Illumination returns 60% base mana cost on crit heals
    -- (mana regen AND throughput stat). MP5 solid consistent regen.
    -- Haste grows in value T5+ (faster Holy Lights). Spirit near-worthless
    -- (no Spirit-based talents, 5SR kills Spirit regen).
    -- Sources: Icy Veins TBC Holy Paladin, Wowhead TBC Holy Paladin guide,
    --   Warcraft Tavern TBC Holy Paladin
    PALADIN_HOLY = {
        weights = {
            INTELLECT    = 0.78,  -- primary: Holy Guidance 35% → +heal, mana, crit
            CRIT_RATING  = 0.67,  -- Illumination 60% mana refund on crit heal
            MP5          = 0.63,  -- consistent regen; Paladin's main regen stat
            HEAL_POWER   = 0.59,  -- throughput (FoL has lower coefficient than HL)
            SPELL_POWER  = 0.55,
            HASTE_RATING = 0.47,  -- faster HL casts; grows in T5+
            STAMINA      = 0.08,
            SPIRIT       = 0.08,  -- near-worthless (no Spirit talents, 5SR dependent)
        },
        caps = {},
    },

    -- Prot Paladin: Uncrushable (102.4% avoidance) via Holy Shield. Spell-based threat.
    -- Hit cap for spells is 202 (not 142). Block Rating cheapest path to 102.4%.
    -- Sources: Maintankadin, Wowhead, WoWSims Prot Paladin
    PALADIN_PROT = {
        weights = {
            STAMINA      = 0.78,
            ARMOR        = 0.12,
            DEFENSE      = 0.63,
            DODGE        = 0.51,
            PARRY        = 0.47,
            BLOCK_RATING = 0.55,   -- Cheapest path to 102.4%
            BLOCK_VALUE  = 0.12,   -- Holy Shield damage scales with it
            SPELL_POWER  = 0.35,   -- #1 threat stat (Consecration, Holy Shield, SoR)
            HIT_RATING   = 0.43,   -- Spell-based threat; cap is 202, not 142
            EXPERTISE    = 0.55,
            INTELLECT    = 0.24,
            STRENGTH     = 0.16,
            RESILIENCE   = 0.12,   -- Path to uncrittable
        },
        caps = {
            DEFENSE    = { softCap = 332, hardCap = 400, overCapWeight = 0.30 },
            -- Spell hit cap: 202 (Prot threat is spell-based). 142 is minor soft cap (melee specials).
            HIT_RATING = { softCap = 142, hardCap = 202, overCapWeight = 0.50 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    -- Ret Paladin: Seal of Blood makes haste very strong. Only 1.5x crit multiplier (not 2x).
    -- Spell Power has value (Consecration, Judgment, seals). 3/3 Precision = 3% hit.
    -- Sources: RetSim (Sulis/Pride), Wowhead, Icy Veins
    PALADIN_RET = {
        weights = {
            STRENGTH     = 0.78,   -- Primary; 2.2 AP/STR w/ Divine Strength
            ATTACK_POWER = 0.35,
            HIT_RATING   = 0.74,   -- High until 9% (6% from gear w/ Precision)
            CRIT_RATING  = 0.48,   -- Reduced: only 1.5x crit multiplier
            HASTE_RATING = 0.66,   -- Seal of Blood scales with swing speed
            EXPERTISE    = 0.92,   -- Extremely valuable + scarce in TBC
            AGILITY      = 0.16,   -- Minimal value for Ret
            ARMOR_PEN    = 0.34,   -- Decent in later phases
            SPELL_POWER  = 0.20,   -- Seals + Consecration + Judgment
            STAMINA      = 0.04,
        },
        caps = {
            -- 3/3 Precision = 3% hit; need 95 rating for 9%
            HIT_RATING = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
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

    -- Assassination (Mutilate): Dagger-based. Seal Fate gives crit value.
    -- Poisons are magic damage → ArPen nearly worthless.
    -- Sources: Simonize spreadsheet (adjusted for Mut), Icy Veins
    ROGUE_ASSASSIN = {
        weights = {
            AGILITY      = 0.78,   -- Primary: AP + crit, Sinister Calling + BoK
            STRENGTH     = 0.36,
            ATTACK_POWER = 0.33,
            HIT_RATING   = 0.76,   -- Very high below cap
            CRIT_RATING  = 0.61,   -- Seal Fate procs
            HASTE_RATING = 0.57,   -- Good for energy via white hits
            EXPERTISE    = 0.84,   -- Highest per-point value
            ARMOR_PEN    = 0.07,   -- Low: poisons ignore armor
            STAMINA      = 0.04,
        },
        caps = {
            -- 5/5 Precision = 5%; need 79 rating for 9% special cap
            HIT_RATING = { softCap = 79, hardCap = 363, overCapWeight = 0.30 },
            EXPERTISE  = { softCap = 64, hardCap = 64,  overCapWeight = 0.0 },
        },
    },

    -- Combat Swords: Haste very strong (Combat Potency + Sword Spec).
    -- EP from Simonize spreadsheet T5: AGI 2.19, HIT 2.42, HASTE 2.13,
    -- CRIT 1.72, EXP 2.65, STR 1.10, AP 1.00, ArPen 0.30
    -- Sources: Simonize spreadsheet via Icy Veins (primary)
    ROGUE_COMBAT = {
        weights = {
            AGILITY      = 0.78,   -- 2.19 EP → primary
            STRENGTH     = 0.39,   -- 1.10 EP
            ATTACK_POWER = 0.36,   -- 1.00 EP
            HIT_RATING   = 0.86,   -- 2.42 EP; highest non-expertise
            CRIT_RATING  = 0.61,   -- 1.72 EP
            HASTE_RATING = 0.76,   -- 2.13 EP; Combat Potency
            EXPERTISE    = 0.94,   -- 2.65 EP; top stat
            ARMOR_PEN    = 0.11,   -- 0.30 EP; grows in later tiers
            STAMINA      = 0.04,
        },
        caps = {
            HIT_RATING = { softCap = 79, hardCap = 363, overCapWeight = 0.30 },
            EXPERTISE  = { softCap = 64, hardCap = 64,  overCapWeight = 0.0 },
        },
    },

    -- Subtlety (Hemo): Lower PvE scaling than Combat. No Combat Potency.
    -- No Precision talent → full 142 hit cap.
    -- Sources: Warcraft Tavern, community consensus (limited PvE sim data)
    ROGUE_SUBTLETY = {
        weights = {
            AGILITY      = 0.78,
            STRENGTH     = 0.39,
            ATTACK_POWER = 0.36,
            HIT_RATING   = 0.82,
            CRIT_RATING  = 0.60,   -- Lethality gives value
            HASTE_RATING = 0.55,   -- No Combat Potency
            EXPERTISE    = 0.89,
            ARMOR_PEN    = 0.09,
            STAMINA      = 0.04,
        },
        caps = {
            -- No Precision talent; full 142 for special cap
            HIT_RATING = { softCap = 142, hardCap = 363, overCapWeight = 0.25 },
            EXPERTISE  = { softCap = 64,  hardCap = 64,  overCapWeight = 0.0 },
        },
    },

    ---------------------------------------------------------------------------
    -- PRIEST
    ---------------------------------------------------------------------------

    -- Disc Priest: shields + Flash Heal focused. Intellect strong for mana pool
    -- and crit (Illumination-like returns via Improved Divine Spirit party buff).
    -- Spirit converts to +heal/+dmg via Spiritual Guidance (25% of Spirit).
    -- MP5 less valuable than Spirit due to Spirit's dual role.
    -- Haste good for faster shields/Flash Heals.
    -- Sources: Wowhead TBC Priest Healing guide, PlusHeal forums, Dwarf Priest blog
    PRIEST_DISC = {
        weights = {
            INTELLECT    = 0.78,
            HEAL_POWER   = 0.71,
            SPELL_POWER  = 0.67,
            SPIRIT       = 0.55,  -- Spiritual Guidance (25% Spirit → +heal) + regen
            MP5          = 0.51,  -- consistent regen but Spirit has throughput component
            HASTE_RATING = 0.47,
            CRIT_RATING  = 0.39,  -- less crit synergy than Holy (no Surge of Light)
            STAMINA      = 0.08,
        },
        caps = {},
    },

    -- Holy Priest: CoH / Greater Heal focused. Spirit exceptionally strong:
    -- Spiritual Guidance (25% Spirit → +heal) + Meditation (30% regen while casting)
    -- + Spirit of Redemption (+5% Spirit). Haste is top throughput stat (faster GH/CoH).
    -- Crit enables Surge of Light procs and Holy Concentration.
    -- Sources: Icy Veins TBC Holy Priest, Wowhead TBC Priest Healing guide,
    --   Dwarf Priest blog stat weight analysis
    PRIEST_HOLY = {
        weights = {
            HEAL_POWER   = 0.78,
            SPELL_POWER  = 0.74,
            HASTE_RATING = 0.71,  -- top throughput after raw +heal (faster GH/CoH/PoH)
            SPIRIT       = 0.63,  -- throughput (Spiritual Guidance) + regen (Meditation)
            INTELLECT    = 0.59,  -- mana pool + crit + Spirit regen formula
            CRIT_RATING  = 0.51,  -- Surge of Light, Holy Concentration, Inspiration
            MP5          = 0.47,  -- flat regen, weaker than Spirit for Holy
            STAMINA      = 0.08,
        },
        caps = {},
    },

    -- Shadow Priest: DoTs (SW:P, VT) can't crit and don't scale with haste in TBC.
    -- Spell damage is king. Haste only speeds up Mind Flay/Mind Blast casts.
    -- Crit weak because SW:P and VT (large portion of damage) cannot crit.
    -- Hit cap very low: Shadow Focus 10% → only 76 rating needed (6% from gear).
    -- Spirit has value via Meditation (15% regen while casting) and mana sustain.
    -- Sources: Icy Veins TBC Shadow Priest, Wowhead TBC Shadow Priest guide,
    --   WoWSims TBC Shadow Priest simulator
    PRIEST_SHADOW = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.21,  -- ~1.55× SP value (very high but low cap makes it short-lived)
            HASTE_RATING = 0.67,  -- only affects MB/MF casts, not DoT ticks
            CRIT_RATING  = 0.39,  -- SW:P/VT can't crit; only MB/MF/SW:D benefit
            INTELLECT    = 0.35,  -- mana pool + minor crit; less throughput than lock
            SPIRIT       = 0.27,  -- Meditation regen, mana sustain for long fights
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

    -- Elemental Shaman: Lightning Bolt / Chain Lightning / Lava Burst rotation.
    -- Elemental Fury makes crits deal 200% damage. Crit very strong (~0.70× SP).
    -- Haste is best throughput stat in T6+ (fit 4 LB in CL cooldown at ~10% haste).
    -- Hit cap: 3% from Elemental Precision → 164 rating from gear.
    -- Int gives crit (80 Int = 1%) + mana via Nature's Blessing → some +heal.
    -- Sources: Egregious TBC Elemental Shaman DPS Calculator (T5/T6/Sunwell EP),
    --   Icy Veins TBC Ele Shaman, WoWSims TBC Elemental Shaman
    SHAMAN_ELE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,  -- ~1.41× SP; very high value until 164 cap
            HASTE_RATING = 0.82,  -- ~1.05× SP in T6; enables 4-LB rotation (huge)
            CRIT_RATING  = 0.55,  -- ~0.70× SP; Elemental Fury 200% crits, strong early
            INTELLECT    = 0.35,  -- ~0.18-0.20× SP raw; crit + mana pool
            MP5          = 0.27,  -- mana sustain for long fights
            STAMINA      = 0.04,
            SPELL_PEN    = 0.08,  -- minor PvE value (trash resists)
        },
        caps = {
            -- Elemental: 3% from Elemental Precision, need 13% from gear = 164 rating
            HIT_RATING   = { softCap = 164, hardCap = 164, overCapWeight = 0.0 },
            -- Haste: ~10% (158 rating) soft cap for 4-LB rotation, still useful beyond
            HASTE_RATING = { softCap = 158, hardCap = 505, overCapWeight = 0.40 },
        },
    },

    -- Enhancement Shaman: Expertise #1 stat (Windfury dodges = huge DPS loss).
    -- Haste strong (more WF procs). Spell Power has minor value (shocks, WF).
    -- EP from EnhanceShaman.com T5: EXP 2.87, STR 2.20, HASTE 1.94,
    -- HIT 1.67, CRIT 1.36, AGI 1.32, AP 1.00, SP 0.43, ArPen 0.28
    -- Sources: EnhanceShaman.com (primary — exact sim values)
    SHAMAN_ENH = {
        weights = {
            STRENGTH     = 0.74,   -- 2.20 EP; near-primary
            AGILITY      = 0.44,   -- 1.32 EP
            ATTACK_POWER = 0.34,   -- 1.00 EP baseline
            HIT_RATING   = 0.56,   -- 1.67 EP
            CRIT_RATING  = 0.46,   -- 1.36 EP
            HASTE_RATING = 0.65,   -- 1.94 EP; strong for WF
            EXPERTISE    = 0.97,   -- 2.87 EP; top stat by far
            ARMOR_PEN    = 0.09,   -- 0.28 EP
            SPELL_POWER  = 0.14,   -- 0.43 EP; shocks + WF
            INTELLECT    = 0.16,   -- Mana sustain
            STAMINA      = 0.04,
        },
        caps = {
            -- DW: 142 for Stormstrike (soft); ~363 for white hits
            -- Nature's Guidance gives 3% spell hit (separate, not melee)
            HIT_RATING = { softCap = 142, hardCap = 363, overCapWeight = 0.20 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    -- Resto Shaman: Chain Heal machine. MP5 is strongest stat per point
    -- (Pawn weight 2.0 vs Healing 1.0). Haste very strong in T6+
    -- (faster Chain Heals, reduced GCD). Crit gives Ancestral Healing armor buff
    -- and mana return via Improved Water Shield. Int → crit + mana pool.
    -- Spirit nearly worthless (no Spirit-based talents).
    -- Sources: Icy Veins TBC Resto Shaman (had explicit Pawn weights:
    --   Healing=1.0, Haste=1.5, MP5=2.0, Crit=0.6, Int=0.5, Stam=0.2),
    --   Egregious TBC Resto Shaman guide
    SHAMAN_RESTO = {
        weights = {
            MP5          = 0.78,  -- highest value per point (Pawn: 2.0× healing)
            HEAL_POWER   = 0.59,  -- baseline (Pawn: 1.0)
            SPELL_POWER  = 0.55,
            HASTE_RATING = 0.71,  -- faster Chain Heals (Pawn: 1.5× healing)
            INTELLECT    = 0.47,  -- mana pool + crit (Pawn: 0.5× healing)
            CRIT_RATING  = 0.43,  -- Ancestral Healing, mana return (Pawn: 0.6× healing)
            SPIRIT       = 0.08,  -- near-worthless for shaman (no Spirit talents)
            STAMINA      = 0.12,
        },
        caps = {},
    },

    ---------------------------------------------------------------------------
    -- MAGE
    ---------------------------------------------------------------------------

    -- Arcane Mage: Arcane Blast spam. Intellect is THE primary stat:
    -- Mind Mastery (25% Int → SP), Arcane Mind (+15% Int), huge mana pool needed.
    -- DrClaw's sim (100k iterations): Int=1.09, Haste=1.29, SP=0.79, Spirit=0.53, Crit=0.48
    -- Normalized to SP=1.0: Int=1.38, Haste=1.63, Spirit=0.67, Crit=0.61
    -- Spirit very strong: Arcane Meditation + Mage Armor = 60% regen while casting.
    -- Hit cap low: 6% from Arcane Focus → only 126 rating needed.
    -- Sources: DrClaw's TBC Arcane Mage guide (Tumblr, 100k sim per gem),
    --   MageSim TBC (cheesehyvel), Icy Veins TBC Arcane Mage
    MAGE_ARCANE = {
        weights = {
            INTELLECT    = 0.78,  -- primary stat (Mind Mastery + Arcane Mind)
            HASTE_RATING = 0.74,  -- ~1.63× SP; fastest AB stacks
            HIT_RATING   = 1.10,  -- still highest per-point until 126 cap
            SPELL_POWER  = 0.59,  -- ~1.0× baseline; lower than Int for Arcane
            SPIRIT       = 0.43,  -- ~0.67× SP; 60% casting regen + Innervate scaling
            CRIT_RATING  = 0.39,  -- ~0.61× SP; Arcane crits only 175-182% (low multiplier)
            STAMINA      = 0.04,
        },
        caps = {
            -- Arcane: 6% from Arcane Focus, need 10% from gear = 126 rating
            HIT_RATING = { softCap = 126, hardCap = 126, overCapWeight = 0.0 },
        },
    },

    -- Fire Mage: Fireball spam with Scorch weaving. Crit is exceptional:
    -- Ignite (40% of crit damage over 4s) + Master of Elements (30% mana refund)
    -- + Fire crits deal 210-216% damage. Haste also very strong (faster Fireballs).
    -- Int weaker than Arcane (no Mind Mastery). Spirit minimal (no casting regen talents).
    -- Hit cap: 3% from Elemental Precision → 164 rating.
    -- Sources: MageSim TBC, Icy Veins TBC Fire Mage (crit multiplier: 216.3% w/ CSD),
    --   Wowhead TBC Mage guide
    MAGE_FIRE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            CRIT_RATING  = 0.71,  -- Ignite + Master of Elements; Fire's core stat
            HASTE_RATING = 0.67,  -- faster Fireballs, good but slightly below crit
            INTELLECT    = 0.39,  -- mana pool + minor crit (80 Int = 1%)
            SPIRIT       = 0.12,  -- minimal value (no casting regen for Fire)
            STAMINA      = 0.04,
        },
        caps = {
            -- Fire: 3% from Elemental Precision, need 13% from gear = 164 rating
            HIT_RATING = { softCap = 164, hardCap = 164, overCapWeight = 0.0 },
        },
    },

    -- Frost Mage: Frostbolt spam. Crit weaker than Fire (Ice Shards gives 200%
    -- crits but no Ignite equivalent). Haste strong for fitting more Frostbolts
    -- into Icy Veins windows. Shatter combo (pet freeze + Frostbolt) devalues
    -- passive crit somewhat. Int more valuable than Fire (longer fights, mana).
    -- Hit cap: 3% from Elemental Precision → 164 rating.
    -- Sources: MageSim TBC, Icy Veins TBC Frost Mage, Wowhead TBC Mage guide
    MAGE_FROST = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,
            HASTE_RATING = 0.67,  -- more Frostbolts in Icy Veins window
            CRIT_RATING  = 0.55,  -- Ice Shards 200% crits but no Ignite; Shatter devalues
            INTELLECT    = 0.47,  -- better than Fire; longer fights need mana
            SPIRIT       = 0.16,  -- minimal but slightly better than Fire (longer fights)
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

    -- Affliction Warlock (UA build): DoTs (Corruption, UA, CoA, Immolate) can't crit
    -- in TBC and don't tick faster with haste. Spell damage is by far the best stat.
    -- Haste helps Shadow Bolt filler but doesn't affect DoT ticks.
    -- Crit very weak (DoTs can't crit; only Shadow Bolt filler benefits).
    -- Spirit has value: Fel Armor converts 30% of Spirit to spell damage directly.
    -- Suppression: 2% hit from talents → 177 rating cap.
    -- Sources: Icy Veins TBC Affliction Warlock (UA build EP values:
    --   SP=1.0, Hit=1.930, Haste=1.362, Crit=0.528, Int=0.156, Spirit=0.110),
    --   Zephan/Leulier Warlock spreadsheet, WarlockSimulatorTBC
    WARLOCK_AFFLIC = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.17,  -- EP 1.93× SP → calibrated; high but burns through fast
            HASTE_RATING = 0.71,  -- EP 1.36× SP; only affects SB filler, not DoTs
            CRIT_RATING  = 0.35,  -- EP 0.53× SP; DoTs can't crit in TBC (very weak)
            INTELLECT    = 0.27,  -- EP 0.16× SP; mana pool for long fights
            SPIRIT       = 0.24,  -- EP 0.11× SP; Fel Armor: 30% Spirit → spell damage
            STAMINA      = 0.08,  -- Life Tap returns mana from health → slight value
            MP5          = 0.16,  -- less useful (Life Tap > passive regen)
        },
        caps = {
            -- Affliction: 2% from Suppression, need 14% from gear = 177 rating
            HIT_RATING = { softCap = 177, hardCap = 177, overCapWeight = 0.0 },
        },
    },

    -- Demonology Warlock (Felguard build): Pet does significant damage.
    -- SP feeds pet via Demonic Knowledge (12% of Stam+Int → pet SP).
    -- Stamina has real DPS value: feeds pet + Life Tap.
    -- Hit cap full 202 (no hit talents in Demo tree).
    -- Sources: Icy Veins TBC Demo Warlock (Felguard EP values:
    --   SP=1.0, Hit=1.596, Haste=1.362, Crit=0.596, Int=0.220, Stam=0.058, Spirit=0.094),
    --   WarlockSimulatorTBC
    WARLOCK_DEMO = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,  -- EP 1.60× SP; high value, need full 202
            HASTE_RATING = 0.67,  -- EP 1.36× SP; speeds up Shadow Bolt
            CRIT_RATING  = 0.47,  -- EP 0.60× SP; moderate (SB crits, not DoTs)
            INTELLECT    = 0.35,  -- EP 0.22× SP; mana pool + Demonic Knowledge synergy
            STAMINA      = 0.12,  -- EP 0.06× SP; Life Tap + Demonic Knowledge
            SPIRIT       = 0.20,  -- EP 0.094× SP; Fel Armor 30% Spirit → spell damage
            MP5          = 0.16,
        },
        caps = {
            -- Demo: no hit talents, need full 16% from gear = 202 rating
            HIT_RATING = { softCap = 202, hardCap = 202, overCapWeight = 0.0 },
        },
    },

    -- Destruction Warlock: Shadow Bolt / Incinerate spam. Ruin talent makes crits
    -- deal 200% damage (huge crit scaling). Haste is strongest throughput stat
    -- (faster Shadow Bolts). Crit excellent with Ruin.
    -- Two sub-builds: Shadow Destro (SB spam) and Fire Destro (Incinerate).
    -- Using Shadow Destro as reference (more common):
    --   SP=1.0, Hit=1.956, Crit=0.882, Haste=1.350, Int=0.261, Spirit=0.094
    -- Hit cap: ~190 rating (1% from Cataclysm talent, or 202 without).
    -- Sources: Icy Veins TBC Destro Warlock (Shadow Destro EP values),
    --   WarlockSimulatorTBC, Zephan's spreadsheet
    WARLOCK_DESTRO = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.17,  -- EP 1.96× SP; highest hit value of any warlock spec
            HASTE_RATING = 0.74,  -- EP 1.35× SP; faster SB/Incinerate = huge DPS
            CRIT_RATING  = 0.63,  -- EP 0.88× SP; Ruin 200% crits make crit excellent
            INTELLECT    = 0.35,  -- EP 0.26× SP; mana pool for sustained DPS
            STAMINA      = 0.08,  -- Life Tap value
            SPIRIT       = 0.20,  -- EP 0.094× SP; Fel Armor 30% Spirit → spell damage
            MP5          = 0.16,
        },
        caps = {
            -- Destro: 1% from Cataclysm (common), need ~15% = 190 rating
            -- Without Cataclysm: 202 rating
            HIT_RATING = { softCap = 190, hardCap = 202, overCapWeight = 0.10 },
        },
    },

    ---------------------------------------------------------------------------
    -- DRUID
    ---------------------------------------------------------------------------

    -- Balance Druid (Moonkin): Starfire / Wrath rotation. Starfire crits deal
    -- 200% damage (Vengeance talent) making crit very strong. Haste enables
    -- more Starfires per fight. Mana is Balance's biggest weakness.
    -- Spirit has decent value: Dreamstate (10% Int → MP5 while casting) +
    -- Intensity (30% Spirit regen while casting).
    -- Hit cap: 4% from Balance of Power → 152 rating.
    -- Sources: Keftenk's ClassicBalanceDruid spreadsheet (GitHub),
    --   WoWSims TBC Balance Druid, Icy Veins TBC Balance Druid,
    --   Wowhead TBC Balance Druid guide
    DRUID_BALANCE = {
        weights = {
            SPELL_POWER  = 0.78,
            HIT_RATING   = 1.10,  -- highest per-point until 152 cap
            HASTE_RATING = 0.67,  -- more Starfires per fight; strong throughput
            CRIT_RATING  = 0.63,  -- Vengeance 200% Starfire crits; very strong
            INTELLECT    = 0.47,  -- mana pool (critical for Boomkin) + minor crit
            SPIRIT       = 0.31,  -- Intensity 30% casting regen + Innervate scaling
            MP5          = 0.27,  -- consistent regen, but Spirit slightly better
            STAMINA      = 0.04,
            SPELL_PEN    = 0.08,  -- minor PvE value
        },
        caps = {
            -- Balance: 4% from Balance of Power, need 12% from gear = 152 rating
            HIT_RATING = { softCap = 152, hardCap = 152, overCapWeight = 0.0 },
        },
    },

    -- Feral Cat DPS: 1 AGI = 1 AP + 0.04% crit (best stat by far).
    -- 1 STR = 2.4 AP w/ Heart of the Wild. Haste lower due to powershifting.
    -- ArPen grows significantly in later tiers.
    -- Sources: WoWSims, Icy Veins, Warcraft Tavern
    DRUID_FERAL = {
        weights = {
            AGILITY      = 0.78,   -- Primary: AP + crit, scales w/ SotF + BoK
            STRENGTH     = 0.65,   -- 2.4 AP/STR w/ HotW; strong
            ATTACK_POWER = 0.33,
            HIT_RATING   = 0.69,   -- High until 9% cap
            CRIT_RATING  = 0.54,   -- Predatory Instincts, Primal Fury
            HASTE_RATING = 0.39,   -- Lower: powershifting reduces white hit uptime
            EXPERTISE    = 0.82,   -- High value until 6.5% cap
            ARMOR_PEN    = 0.18,   -- Low early/mid; grows late
            STAMINA      = 0.06,   -- Slight value: bear form survivability
        },
        caps = {
            HIT_RATING = { softCap = 142, hardCap = 142, overCapWeight = 0.0 },
            EXPERTISE  = { softCap = 95,  hardCap = 95,  overCapWeight = 0.0 },
        },
    },

    -- Resto Druid: HoT-focused healer (Lifebloom, Rejuvenation, Regrowth).
    -- Healing Power is king. Spirit is exceptionally strong for Resto:
    -- Tree of Life aura (25% Spirit → party healing received), Intensity (30%
    -- Spirit regen while casting), Innervate scales with Spirit.
    -- Haste has a hard cap at 242 rating (reduces GCD to allow Lifebloom rolling).
    -- MP5 solid but Spirit is better (throughput via ToL aura + regen).
    -- Crit weakest stat (HoTs can't crit in TBC).
    -- Sources: Icy Veins TBC Resto Druid (haste cap 242),
    --   Wowhead TBC Resto Druid guide, DruidWiki, Ask Mr. Robot forums
    DRUID_RESTO = {
        weights = {
            HEAL_POWER   = 0.78,
            SPELL_POWER  = 0.74,
            SPIRIT       = 0.67,  -- ToL aura (25% Spirit → party healing) + regen + Innervate
            HASTE_RATING = 0.63,  -- faster GCD for Lifebloom rolling; hard cap 242
            INTELLECT    = 0.55,  -- mana pool (critical) + minor crit
            MP5          = 0.47,  -- solid regen but Spirit has throughput component
            CRIT_RATING  = 0.31,  -- weak: HoTs can't crit in TBC; only Regrowth direct
            STAMINA      = 0.08,
        },
        caps = {
            -- Haste: 242 rating to reduce GCD for Lifebloom rolling
            HASTE_RATING = { softCap = 242, hardCap = 400, overCapWeight = 0.15 },
        },
    },
}

---------------------------------------------------------------------------
-- Per-spec calibration scale factors
-- Ensures cross-class score parity: a Kara-geared mage scores the same
-- as a Kara-geared priest with equivalent quality gear.
-- Computed from reference BIS sets: each spec's P1 base score is scaled
-- to match the calibration target (Priest Disc P1 base ≈ 1740).
-- Run /tgs calibrate in-game to recompute these.
---------------------------------------------------------------------------

addon.StatWeights.SPEC_SCALE = {
    -- Computed from /tgs calibrate: each spec's P1 BIS base score normalized
    -- to PRIEST_DISC P1 base (1741). Run /tgs calibrate to recompute.
    -- IMPORTANT: Recalibrate after any stat mapping changes in Constants.lua!
    -- (e.g., adding ITEM_MOD_SPELL_POWER mapping changes caster raw scores)
    -- Healers/tanks have low scale (their gear has many weighted stats).
    -- DPS specs have high scale (gear concentrates into fewer stats).

    -- Healers
    ["PRIEST_DISC"]     = 1.000,  -- P1 base=1741 (anchor)
    ["PRIEST_HOLY"]     = 1.000,  -- same gear as Disc, similar weights
    ["DRUID_RESTO"]     = 0.979,  -- P1 base=1778
    ["PALADIN_HOLY"]    = 1.279,  -- P1 base=1361
    ["SHAMAN_RESTO"]    = 1.325,  -- P1 base=1314

    -- Tanks
    ["WARRIOR_PROT"]    = 1.114,  -- P1 base=1563
    ["PALADIN_PROT"]    = 1.200,  -- estimated (no P1 ref set scored; between Holy and Warrior)
    ["DRUID_FERAL_BEAR"]= 1.100,  -- estimated (bear gear similar stat spread to plate tanks)

    -- Melee DPS
    ["HUNTER_BM"]       = 3.414,  -- P1 base=510
    ["HUNTER_MM"]       = 3.414,  -- same gear as BM
    ["HUNTER_SURV"]     = 3.414,  -- same gear as BM
    ["ROGUE_COMBAT"]    = 3.575,  -- P1 base=487
    ["ROGUE_ASSASSIN"]  = 3.575,  -- same gear type
    ["ROGUE_SUBTLETY"]  = 3.575,  -- same gear type
    ["DRUID_FERAL"]     = 3.878,  -- P1 base=449
    ["PALADIN_RET"]     = 4.693,  -- P1 base=371
    ["SHAMAN_ENH"]      = 4.877,  -- P1 base=357
    ["WARRIOR_ARMS"]    = 5.182,  -- same gear as Fury
    ["WARRIOR_FURY"]    = 5.182,  -- P1 base=336

    -- Caster DPS
    ["DRUID_BALANCE"]   = 3.605,  -- P1 base=483
    ["MAGE_FIRE"]       = 4.408,  -- P1 base=395
    ["MAGE_ARCANE"]     = 4.408,  -- same gear type as Fire
    ["MAGE_FROST"]      = 4.408,  -- same gear type as Fire
    ["WARLOCK_DESTRO"]  = 4.558,  -- P1 base=382
    ["WARLOCK_AFFLIC"]  = 4.558,  -- same gear type
    ["WARLOCK_DEMO"]    = 4.558,  -- same gear type
    ["PRIEST_SHADOW"]   = 4.000,  -- estimated (shadow priest gear is caster DPS cloth)
    ["SHAMAN_ELE"]      = 4.500,  -- estimated (12.9x was broken; use caster DPS range)
}

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------

function addon.StatWeights:GetSpecWeights(specKey)
    return self.SPECS[specKey]
end

function addon.StatWeights:GetSpecScale(specKey)
    return self.SPEC_SCALE[specKey] or 1.0
end

function addon.StatWeights:GetSpecCap(specKey, statName)
    local spec = self.SPECS[specKey]
    return spec and spec.caps and spec.caps[statName]
end
