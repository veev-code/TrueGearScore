---------------------------------------------------------------------------
-- TrueGearScore Set Bonus Database
-- Maps setID + piece count to equivalent stat budgets
--
-- Structure:
--   addon.SetBonusDatabase[setID] = {
--       name = "Set Name",
--       bonuses = {
--           [pieceCount] = { STAT = value, ... },
--       },
--   }
--
-- Stat values are APPROXIMATE equivalent budgets — converting the
-- qualitative set bonus effect into a stat-weight-compatible number.
-- These are intentionally conservative: we'd rather slightly undervalue
-- a hard-to-quantify bonus than wildly overvalue it.
--
-- Set IDs sourced from Wowhead TBC Classic (wowhead.com/tbc/item-set=XXX).
-- Detection: GetItemInfo(itemLink) return #16 = setID,
--            GetItemSetInfo(setID) = setName.
--
-- Stat names match canonical keys in Constants.STAT_KEYS / StatWeights.
---------------------------------------------------------------------------

local _, addon = ...
addon.SetBonusDatabase = {

    ---------------------------------------------------------------------------
    -- WARRIOR
    ---------------------------------------------------------------------------

    -- T4 DPS: Warbringer Battlegear
    -- 2pc: Whirlwind costs 5 less rage ≈ minor DPS uptime gain
    -- 4pc: +2 rage on parry/dodge ≈ minor rage gen
    [655] = {
        name = "Warbringer Battlegear",
        bonuses = {
            [2] = { ATTACK_POWER = 10 },
            [4] = { ATTACK_POWER = 8 },
        },
    },

    -- T4 Tank: Warbringer Armor
    -- 2pc: Parry → absorb 200 dmg shield ≈ minor mitigation
    -- 4pc: Revenge → next ability +10% dmg ≈ threat boost
    [654] = {
        name = "Warbringer Armor",
        bonuses = {
            [2] = { STAMINA = 5 },
            [4] = { ATTACK_POWER = 15 },
        },
    },

    -- T5 DPS: Destroyer Battlegear
    -- 2pc: Overpower grants 100 AP/5s ≈ ~20 AP avg (moderate uptime)
    -- 4pc: BT/MS cost 5 less rage ≈ sustained DPS gain
    [657] = {
        name = "Destroyer Battlegear",
        bonuses = {
            [2] = { ATTACK_POWER = 20 },
            [4] = { ATTACK_POWER = 15 },
        },
    },

    -- T5 Tank: Destroyer Armor
    -- 2pc: Shield Block → +100 block value/6s ≈ moderate mitigation
    -- 4pc: On-hit → 200 haste/10s proc ≈ ~20 haste avg
    [656] = {
        name = "Destroyer Armor",
        bonuses = {
            [2] = { BLOCK_RATING = 15 },
            [4] = { HASTE_RATING = 20 },
        },
    },

    -- T6 DPS: Onslaught Battlegear
    -- 2pc: +5 dmg on MS/BT ≈ small per-hit boost
    -- 4pc: +5 dmg on Execute ≈ execute phase boost
    [672] = {
        name = "Onslaught Battlegear",
        bonuses = {
            [2] = { ATTACK_POWER = 20 },
            [4] = { ATTACK_POWER = 15 },
        },
    },

    -- T6 Tank: Onslaught Armor
    -- 2pc: Commanding Shout +170 HP ≈ minor raid HP
    -- 4pc: Shield Slam +10% dmg ≈ solid threat
    [673] = {
        name = "Onslaught Armor",
        bonuses = {
            [2] = { STAMINA = 8 },
            [4] = { ATTACK_POWER = 20 },
        },
    },

    ---------------------------------------------------------------------------
    -- PRIEST
    ---------------------------------------------------------------------------

    -- T4 Heal: Incarnate Raiment
    -- 2pc: Prayer of Healing +150 HoT/9s ≈ small heal boost
    -- 4pc: Flash Heal → faster Greater Heal (stacking) ≈ throughput
    [663] = {
        name = "Incarnate Raiment",
        bonuses = {
            [2] = { HEAL_POWER = 20 },
            [4] = { HEAL_POWER = 30 },
        },
    },

    -- T4 Shadow: Incarnate Regalia
    -- 2pc: Shadowfiend +75 stam, +3s duration ≈ minor mana return
    -- 4pc: Mind Flay/Smite +5% dmg ≈ solid DPS boost
    [664] = {
        name = "Incarnate Regalia",
        bonuses = {
            [2] = { MP5 = 4 },
            [4] = { SPELL_POWER = 30 },
        },
    },

    -- T5 Heal: Avatar Raiment
    -- 2pc: Greater Heal to full → 100 mana ≈ small mana savings
    -- 4pc: Renew +3s duration ≈ extra ticks of healing
    [665] = {
        name = "Avatar Raiment",
        bonuses = {
            [2] = { MP5 = 5 },
            [4] = { HEAL_POWER = 35 },
        },
    },

    -- T5 Shadow: Avatar Regalia
    -- 2pc: 6% chance offensive spell → next spell costs 150 less mana
    -- 4pc: SW:P tick → 40% chance → +100 dmg/heal next spell
    [666] = {
        name = "Avatar Regalia",
        bonuses = {
            [2] = { MP5 = 6 },
            [4] = { SPELL_POWER = 35 },
        },
    },

    -- T6 Shadow: Absolution Regalia
    -- 2pc: SW:P +3s duration ≈ extra tick
    -- 4pc: Mind Blast +10% dmg ≈ solid DPS
    [674] = {
        name = "Absolution Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 15 },
            [4] = { SPELL_POWER = 35 },
        },
    },

    -- T6 Heal: Vestments of Absolution
    -- 2pc: Prayer of Healing -10% mana ≈ mana savings
    -- 4pc: Greater Heal +5% healing ≈ strong throughput
    [675] = {
        name = "Vestments of Absolution",
        bonuses = {
            [2] = { MP5 = 8 },
            [4] = { HEAL_POWER = 40 },
        },
    },

    ---------------------------------------------------------------------------
    -- MAGE
    ---------------------------------------------------------------------------

    -- T4: Aldor Regalia
    -- 2pc: 100% pushback resist on Fireball/Frostbolt ≈ effective DPS gain
    -- 4pc: Reduced CD on PoM/Blast Wave/Ice Block ≈ utility/DPS
    [648] = {
        name = "Aldor Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 15 },
            [4] = { SPELL_POWER = 15 },
        },
    },

    -- T5: Tirisfal Regalia
    -- 2pc: Arcane Blast +20% dmg (and cost) ≈ Arcane-specific DPS
    -- 4pc: Spell crits → +70 SP/6s ≈ ~25 SP avg
    [649] = {
        name = "Tirisfal Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 20 },
            [4] = { SPELL_POWER = 25 },
        },
    },

    -- T6: Tempest Regalia
    -- 2pc: Evocation +2s duration ≈ mana sustain
    -- 4pc: Fireball/Frostbolt/Arcane Missiles +5% dmg ≈ strong
    [671] = {
        name = "Tempest Regalia",
        bonuses = {
            [2] = { MP5 = 10 },
            [4] = { SPELL_POWER = 45 },
        },
    },

    ---------------------------------------------------------------------------
    -- WARLOCK
    ---------------------------------------------------------------------------

    -- T4: Voidheart Raiment
    -- 2pc: 5% chance → +135 shadow/fire SP for 15s ≈ ~10 SP avg
    -- 4pc: Corruption/Immolate +3s ≈ extra tick of each
    [645] = {
        name = "Voidheart Raiment",
        bonuses = {
            [2] = { SPELL_POWER = 10 },
            [4] = { SPELL_POWER = 25 },
        },
    },

    -- T5: Corruptor Raiment
    -- 2pc: Pet healed for 15% of your dmg ≈ pet survivability
    -- 4pc: SB hits → Corruption +10%, Incinerate → Immolate +10% ≈ strong
    [646] = {
        name = "Corruptor Raiment",
        bonuses = {
            [2] = { STAMINA = 5 },
            [4] = { SPELL_POWER = 40 },
        },
    },

    -- T6: Malefic Raiment
    -- 2pc: Corruption/Immolate tick → heal 70 ≈ survivability
    -- 4pc: Shadowbolt/Incinerate +6% dmg ≈ very strong
    [670] = {
        name = "Malefic Raiment",
        bonuses = {
            [2] = { STAMINA = 5 },
            [4] = { SPELL_POWER = 50 },
        },
    },

    ---------------------------------------------------------------------------
    -- PALADIN
    ---------------------------------------------------------------------------

    -- T4 Holy: Justicar Raiment
    -- 2pc: JoL +20 healing ≈ minor heal boost
    -- 4pc: Divine Favor -15s CD ≈ more crit heals
    [624] = {
        name = "Justicar Raiment",
        bonuses = {
            [2] = { HEAL_POWER = 10 },
            [4] = { CRIT_RATING = 15 },
        },
    },

    -- T4 Prot: Justicar Armor
    -- 2pc: Seal dmg +10% ≈ threat boost
    -- 4pc: Holy Shield +15 dmg ≈ threat/mitigation
    [625] = {
        name = "Justicar Armor",
        bonuses = {
            [2] = { SPELL_POWER = 10 },
            [4] = { BLOCK_RATING = 10 },
        },
    },

    -- T4 Ret: Justicar Battlegear
    -- 2pc: JotC +15% dmg ≈ raid DPS buff
    -- 4pc: JoC +10% dmg ≈ personal DPS
    [626] = {
        name = "Justicar Battlegear",
        bonuses = {
            [2] = { SPELL_POWER = 15 },
            [4] = { SPELL_POWER = 20 },
        },
    },

    -- T5 Holy: Crystalforge Raiment
    -- 2pc: Judgement → party +50 mana ≈ mana utility
    -- 4pc: Crit heal → -0.5s next HL (1min ICD) ≈ minor throughput
    [627] = {
        name = "Crystalforge Raiment",
        bonuses = {
            [2] = { MP5 = 6 },
            [4] = { HEAL_POWER = 15 },
        },
    },

    -- T5 Prot: Crystalforge Armor
    -- 2pc: Retribution Aura +15 dmg ≈ minor threat
    -- 4pc: Holy Shield → +100 block value/6s ≈ mitigation
    [628] = {
        name = "Crystalforge Armor",
        bonuses = {
            [2] = { SPELL_POWER = 5 },
            [4] = { BLOCK_RATING = 15 },
        },
    },

    -- T5 Ret: Crystalforge Battlegear
    -- 2pc: Judgement -35 mana cost ≈ mana sustain
    -- 4pc: Judgement 6% → heal party ~250 ≈ minor utility
    [629] = {
        name = "Crystalforge Battlegear",
        bonuses = {
            [2] = { MP5 = 5 },
            [4] = { HEAL_POWER = 10 },
        },
    },

    -- T6 Prot: Lightbringer Armor
    -- 2pc: Spiritual Attunement +10% mana ≈ mana sustain
    -- 4pc: Consecration +10% dmg ≈ threat
    [679] = {
        name = "Lightbringer Armor",
        bonuses = {
            [2] = { MP5 = 8 },
            [4] = { SPELL_POWER = 20 },
        },
    },

    -- T6 Ret: Lightbringer Battlegear
    -- 2pc: Melee hit → 20% chance +50 mana ≈ mana sustain
    -- 4pc: Hammer of Wrath +10% dmg ≈ execute phase
    [680] = {
        name = "Lightbringer Battlegear",
        bonuses = {
            [2] = { MP5 = 8 },
            [4] = { ATTACK_POWER = 15 },
        },
    },

    -- T6 Holy: Lightbringer Raiment
    -- 2pc: Holy Light +5% crit ≈ strong
    -- 4pc: Flash of Light +5% healing ≈ strong
    [681] = {
        name = "Lightbringer Raiment",
        bonuses = {
            [2] = { CRIT_RATING = 20 },
            [4] = { HEAL_POWER = 40 },
        },
    },

    ---------------------------------------------------------------------------
    -- DRUID
    ---------------------------------------------------------------------------

    -- T4 Resto: Malorne Raiment
    -- 2pc: Helpful spells → chance to restore 120 mana (~4% proc)
    -- 4pc: Nature's Swiftness -24s CD ≈ more instant heals
    [638] = {
        name = "Malorne Raiment",
        bonuses = {
            [2] = { MP5 = 6 },
            [4] = { HEAL_POWER = 15 },
        },
    },

    -- T4 Balance: Malorne Regalia
    -- 2pc: Harmful spells → chance to restore 120 mana
    -- 4pc: Innervate -48s CD ≈ mana sustain
    [639] = {
        name = "Malorne Regalia",
        bonuses = {
            [2] = { MP5 = 6 },
            [4] = { MP5 = 12 },
        },
    },

    -- T4 Feral: Malorne Harness
    -- 2pc: Bear → chance +10 rage, Cat → chance +20 energy ≈ resource gen
    -- 4pc: Bear → +1400 armor, Cat → +30 STR ≈ solid
    [640] = {
        name = "Malorne Harness",
        bonuses = {
            [2] = { ATTACK_POWER = 15 },
            [4] = { STRENGTH = 20 },
        },
    },

    -- T5 Feral: Nordrassil Harness
    -- 2pc: Shift out → instant Regrowth ≈ minor healing utility
    -- 4pc: Shred +75 dmg, Lacerate +15/app ≈ DPS/threat boost
    [641] = {
        name = "Nordrassil Harness",
        bonuses = {
            [2] = { HEAL_POWER = 10 },
            [4] = { ATTACK_POWER = 30 },
        },
    },

    -- T5 Resto: Nordrassil Raiment
    -- 2pc: Regrowth +6s duration ≈ extra HoT ticks
    -- 4pc: Lifebloom bloom +150 ≈ heal throughput
    [642] = {
        name = "Nordrassil Raiment",
        bonuses = {
            [2] = { HEAL_POWER = 20 },
            [4] = { HEAL_POWER = 30 },
        },
    },

    -- T5 Balance: Nordrassil Regalia
    -- 2pc: Moonkin shift out → Regrowth -450 mana ≈ utility
    -- 4pc: Starfire +10% dmg vs Moonfire/IS targets ≈ strong
    [643] = {
        name = "Nordrassil Regalia",
        bonuses = {
            [2] = { MP5 = 5 },
            [4] = { SPELL_POWER = 40 },
        },
    },

    -- T6 Feral: Thunderheart Harness
    -- 2pc: Mangle -5 energy/-10 rage ≈ resource savings
    -- 4pc: Rip/Swipe +15% dmg ≈ strong DPS/threat
    [676] = {
        name = "Thunderheart Harness",
        bonuses = {
            [2] = { ATTACK_POWER = 15 },
            [4] = { ATTACK_POWER = 40 },
        },
    },

    -- T6 Balance: Thunderheart Regalia
    -- 2pc: Moonfire +3s duration ≈ extra tick
    -- 4pc: Starfire +5% crit ≈ strong
    [677] = {
        name = "Thunderheart Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 15 },
            [4] = { CRIT_RATING = 22 },
        },
    },

    -- T6 Resto: Thunderheart Raiment
    -- 2pc: Swiftmend -2s CD ≈ more instant heals
    -- 4pc: Healing Touch +5% healing ≈ throughput
    [678] = {
        name = "Thunderheart Raiment",
        bonuses = {
            [2] = { HEAL_POWER = 20 },
            [4] = { HEAL_POWER = 35 },
        },
    },

    ---------------------------------------------------------------------------
    -- ROGUE
    ---------------------------------------------------------------------------

    -- T4: Netherblade
    -- 2pc: Slice and Dice +3s ≈ better uptime
    -- 4pc: Finishing moves 15% chance → combo point ≈ DPS gain
    [621] = {
        name = "Netherblade",
        bonuses = {
            [2] = { HASTE_RATING = 10 },
            [4] = { ATTACK_POWER = 25 },
        },
    },

    -- T5: Deathmantle
    -- 2pc: Eviscerate/Envenom +40 dmg per CP ≈ ~200 per finisher
    -- 4pc: Chance → free finishing move ≈ energy savings
    [622] = {
        name = "Deathmantle",
        bonuses = {
            [2] = { ATTACK_POWER = 20 },
            [4] = { ATTACK_POWER = 30 },
        },
    },

    -- T6: Slayer's Armor
    -- 2pc: SnD +5% haste (30% → 35%) ≈ strong
    -- 4pc: BS/SS/Mutilate/Hemo +6% dmg ≈ very strong
    [668] = {
        name = "Slayer's Armor",
        bonuses = {
            [2] = { HASTE_RATING = 25 },
            [4] = { ATTACK_POWER = 50 },
        },
    },

    ---------------------------------------------------------------------------
    -- HUNTER
    ---------------------------------------------------------------------------

    -- T4: Demon Stalker Armor
    -- 2pc: Feign Death -5% resist ≈ utility only
    -- 4pc: Multi-Shot -10% mana ≈ minor mana savings
    [651] = {
        name = "Demon Stalker Armor",
        bonuses = {
            [2] = { AGILITY = 3 },
            [4] = { MP5 = 4 },
        },
    },

    -- T5: Rift Stalker Armor
    -- 2pc: Pet healed for 15% of your dmg ≈ pet survivability
    -- 4pc: Steady Shot +5% crit ≈ strong for BM/MM
    [652] = {
        name = "Rift Stalker Armor",
        bonuses = {
            [2] = { STAMINA = 5 },
            [4] = { CRIT_RATING = 22 },
        },
    },

    -- T6: Gronnstalker's Armor
    -- 2pc: Aspect of Viper +5% INT as mana ≈ mana sustain
    -- 4pc: Steady Shot +10% dmg ≈ very strong
    [669] = {
        name = "Gronnstalker's Armor",
        bonuses = {
            [2] = { MP5 = 8 },
            [4] = { ATTACK_POWER = 50 },
        },
    },

    ---------------------------------------------------------------------------
    -- SHAMAN
    ---------------------------------------------------------------------------

    -- T4 Resto: Cyclone Raiment
    -- 2pc: Mana Spring +3 mp2s ≈ party mana
    -- 4pc: Nature's Swiftness -24s CD ≈ more instant heals
    [631] = {
        name = "Cyclone Raiment",
        bonuses = {
            [2] = { MP5 = 7 },
            [4] = { HEAL_POWER = 15 },
        },
    },

    -- T4 Elemental: Cyclone Regalia
    -- 2pc: Wrath of Air Totem +20 SP ≈ party SP buff
    -- 4pc: Offensive spell crits → chance -270 mana on next spell
    [632] = {
        name = "Cyclone Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 20 },
            [4] = { MP5 = 8 },
        },
    },

    -- T4 Enhancement: Cyclone Harness
    -- 2pc: SoE Totem +12 STR ≈ party STR buff
    -- 4pc: Stormstrike +30 dmg per weapon ≈ minor DPS
    [633] = {
        name = "Cyclone Harness",
        bonuses = {
            [2] = { STRENGTH = 8 },
            [4] = { ATTACK_POWER = 15 },
        },
    },

    -- T5 Resto: Cataclysm Raiment
    -- 2pc: LHW -5% cost ≈ mana savings
    -- 4pc: Crit heal → -0.5s next HW (1min ICD) ≈ minor throughput
    [634] = {
        name = "Cataclysm Raiment",
        bonuses = {
            [2] = { MP5 = 6 },
            [4] = { HEAL_POWER = 15 },
        },
    },

    -- T5 Elemental: Cataclysm Regalia
    -- 2pc: Offensive spell → chance LHW -380 mana ≈ minor
    -- 4pc: LB crits → chance +120 mana ≈ ~24 MP5 equiv
    [635] = {
        name = "Cataclysm Regalia",
        bonuses = {
            [2] = { MP5 = 4 },
            [4] = { MP5 = 15 },
        },
    },

    -- T5 Enhancement: Cataclysm Harness
    -- 2pc: Melee → chance instant LHW ≈ healing utility
    -- 4pc: Flurry +5% haste ≈ strong DPS
    [636] = {
        name = "Cataclysm Harness",
        bonuses = {
            [2] = { HEAL_POWER = 10 },
            [4] = { HASTE_RATING = 25 },
        },
    },

    -- T6 Enhancement: Skyshatter Harness
    -- 2pc: Shocks -10% mana ≈ mana sustain
    -- 4pc: Stormstrike → +70 AP/12s ≈ ~35 AP avg (high uptime)
    [682] = {
        name = "Skyshatter Harness",
        bonuses = {
            [2] = { MP5 = 5 },
            [4] = { ATTACK_POWER = 35 },
        },
    },

    -- T6 Resto: Skyshatter Raiment
    -- 2pc: Chain Heal -10% mana ≈ strong mana savings
    -- 4pc: Chain Heal +5% healing ≈ strong throughput
    [683] = {
        name = "Skyshatter Raiment",
        bonuses = {
            [2] = { MP5 = 10 },
            [4] = { HEAL_POWER = 40 },
        },
    },

    -- T6 Elemental: Skyshatter Regalia
    -- 2pc: 4 totems active → +15 MP5, +35 spell crit, +45 SP ≈ strong
    -- 4pc: Lightning Bolt +5% dmg ≈ solid DPS
    [684] = {
        name = "Skyshatter Regalia",
        bonuses = {
            [2] = { SPELL_POWER = 45, CRIT_RATING = 35, MP5 = 15 },
            [4] = { SPELL_POWER = 30 },
        },
    },

    ---------------------------------------------------------------------------
    -- CRAFTED SETS
    ---------------------------------------------------------------------------

    -- Wrath of Spellfire (3pc tailoring)
    -- 3pc: +7% of INT as spell damage ≈ ~30-40 SP at typical INT levels
    [552] = {
        name = "Wrath of Spellfire",
        bonuses = {
            [3] = { SPELL_POWER = 35 },
        },
    },

    -- Shadow's Embrace / Frozen Shadoweave (3pc tailoring)
    -- 2pc: +5% spell pushback resist ≈ minor
    -- 3pc: Frost/Shadow spells heal 2% of dmg dealt ≈ survivability
    [553] = {
        name = "Frozen Shadoweave",
        bonuses = {
            [2] = { STAMINA = 3 },
            [3] = { STAMINA = 10 },
        },
    },

    -- Primal Mooncloth (3pc tailoring)
    -- 3pc: 5% mana regen while casting ≈ ~15 MP5 for a healer
    [554] = {
        name = "Primal Mooncloth",
        bonuses = {
            [3] = { MP5 = 15 },
        },
    },

    -- Spellstrike Infusion (2pc tailoring)
    -- 2pc: Harmful spells → 5% chance +92 SP for 10s ≈ ~9 SP avg
    [559] = {
        name = "Spellstrike Infusion",
        bonuses = {
            [2] = { SPELL_POWER = 9 },
        },
    },

    -- Windhawk Armor (3pc leatherworking)
    -- 3pc: Restores 8 MP5
    [618] = {
        name = "Windhawk Armor",
        bonuses = {
            [3] = { MP5 = 8 },
        },
    },
}
