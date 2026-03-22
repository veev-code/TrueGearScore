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
--
-- Sources: WoWSims, ClassicSim, Simonize spreadsheet, Wowhead comments,
--          Elitist Jerks archives, class Discord theorycrafting.
--
-- ONLY proc/on-use/equip-effect contributions are listed here.
-- Base item stats visible on the tooltip are already captured by
-- GetItemStats() and must NOT be double-counted.
---------------------------------------------------------------------------

local _, addon = ...
addon.ProcDatabase = {

    ---------------------------------------------------------------------------
    -- TRINKETS — Karazhan
    ---------------------------------------------------------------------------

    -- Dragonspine Trophy (Gruul's Lair — but drops from Gruul, listed here for T4)
    -- 325 haste/10s, ~1 PPM ≈ ~12% uptime → 40 haste avg
    [28830] = { HASTE_RATING = 40 },

    -- Moroes' Lucky Pocket Watch (Karazhan — Moroes)
    -- On-use: 300 dodge/10s, 2min CD → 300*10/120 = 25 dodge avg
    [28528] = { DODGE = 25 },

    -- Ribbon of Sacrifice (Karazhan — Opera)
    -- Equip: heals land grant 81 healing to target for 10s, ~25% uptime → ~20 SP avg
    [28590] = { SPELL_POWER = 20 },

    -- Romulo's Poison Vial (Karazhan — Opera)
    -- ~3% proc, no ICD, 222 nature dmg. ~7 DPS avg ≈ ~35 AP equivalent
    [28579] = { ATTACK_POWER = 35 },

    -- Pipe of Insight (Karazhan — Shade of Aran)
    -- On-use: Restores 955 mana over 15s, 3min CD. ~5.3 MP5 avg
    [28727] = { MP5 = 5 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Gruul's Lair / Magtheridon
    ---------------------------------------------------------------------------

    -- Eye of Gruul (Gruul's Lair — Gruul)
    -- 10% on harmful spell, 258 healing/10s, 45s ICD → ~22% uptime → 57 SP avg
    [28823] = { SPELL_POWER = 57 },

    -- Eye of Magtheridon (Magtheridon's Lair)
    -- 170 SP/10s on spell crit, ~25% uptime → 43 SP avg
    [28789] = { SPELL_POWER = 43 },

    ---------------------------------------------------------------------------
    -- TRINKETS — SSC / TK (Tier 5)
    ---------------------------------------------------------------------------

    -- Tsunami Talisman (SSC — Leotheras)
    -- 340 AP/10s, ~10% uptime → 34 AP avg
    [30627] = { ATTACK_POWER = 34 },

    -- Sextant of Unstable Currents (SSC — Hydross)
    -- 190 SP/15s, 20% on crit, 45s ICD → ~33% uptime → 63 SP avg
    -- (commonly measured ~38-63 depending on crit rate; use mid-high value)
    [30626] = { SPELL_POWER = 50 },

    -- Serpent-Coil Braid (SSC — Morogrim) [Mage only]
    -- Mana gem grants 25% more mana + 92 SP/15s. Avg ~1 gem/2min → ~12 SP avg
    [30720] = { SPELL_POWER = 12 },

    -- Void Star Talisman (TK — Solarian) [Warlock only]
    -- +130 pet resistances (not scoring-relevant). Passive 48 SP in GetItemStats.
    -- Pet resist ≈ ~15 effective stamina for pet survivability
    [30449] = { STAMINA = 15 },

    -- The Lightning Capacitor (TK — The Eye trash)
    -- 3 charges (on crit) → 694 nature dmg. ~15-25 DPS avg ≈ ~50 SP equiv
    [28785] = { SPELL_POWER = 50 },

    -- Darkmoon Card: Wrath (world drop / crafted)
    -- Non-crit gives +17 crit for 10s, stacks up. Avg ~80 crit at decent crit rates
    [31857] = { CRIT_RATING = 80 },

    ---------------------------------------------------------------------------
    -- TRINKETS — BT / Hyjal (Tier 6)
    ---------------------------------------------------------------------------

    -- Skull of Gul'dan (Black Temple — Illidan)
    -- On-use: 175 haste/20s, 2min CD → 175*20/120 = 29 haste avg
    [32483] = { HASTE_RATING = 29 },

    -- Madness of the Betrayer (Black Temple — High Nethermancer)
    -- Melee/ranged ignore 300 armor/10s, ~1 PPM → ~17% uptime
    -- 300 ArP at ~17% ≈ 51 ArP avg
    [32505] = { ARMOR_PEN = 51 },

    -- Memento of Tyrande (Black Temple — Illidan)
    -- On-use: 170 SP/20s, 2min CD → 170*20/120 = 28 SP avg
    [32496] = { SPELL_POWER = 28 },

    -- The Skull of Gul'dan already listed above (32483)

    -- Commendation of Kael'thas (Magisters' Terrace)
    -- 152 dodge/10s, ~30% uptime → ~46 dodge avg
    [34473] = { DODGE = 46 },

    -- Ashtongue Talisman of Valor (BT — Warrior)
    -- MS/BT/SS 25% → 200 AP/10s. ~20% uptime → 40 AP avg
    [32485] = { ATTACK_POWER = 40 },

    -- Ashtongue Talisman of Equilibrium (BT — Druid)
    -- Mangle: 40% → 140 STR/8s; Starfire: 25% → 150 SP/8s; Rejuv: 25% → 112 SP/8s
    -- Feral: ~35 STR avg; Balance: ~25 SP avg. Score both partially.
    [32486] = { STRENGTH = 20, SPELL_POWER = 15 },

    -- Ashtongue Talisman of Swiftness (BT — Hunter)
    -- Steady Shot 15% → 150 AP/8s. ~15% uptime → 23 AP avg
    [32487] = { ATTACK_POWER = 23 },

    -- Ashtongue Talisman of Insight (BT — Mage)
    -- Spell crit 50% → 145 haste/5s. ~15% uptime → 22 haste avg
    [32488] = { HASTE_RATING = 22 },

    -- Ashtongue Talisman of Zeal (BT — Paladin)
    -- JoC/SoC: 50% → 200 SP/5s. ~20% uptime → 40 SP avg
    [32489] = { SPELL_POWER = 40 },

    -- Ashtongue Talisman of Acumen (BT — Priest)
    -- PW:Shield: 10% → 220 SP/5s. ~8% uptime → 18 SP avg
    [32490] = { SPELL_POWER = 18 },

    -- Ashtongue Talisman of Vision (BT — Shaman)
    -- Stormstrike: 50% → mana return. Enhancement only. ~30 MP5 equiv
    [32491] = { MP5 = 30 },

    -- Ashtongue Talisman of Lethality (BT — Rogue)
    -- Finishing move: 20%/cp → 145 crit/10s. ~30% uptime → 44 crit avg
    [32492] = { CRIT_RATING = 44 },

    -- Ashtongue Talisman of Shadows (BT — Warlock)
    -- Corruption ticks: 25% → 220 SP/5s. ~20% uptime → 44 SP avg
    [32493] = { SPELL_POWER = 44 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Sunwell Plateau
    ---------------------------------------------------------------------------

    -- Blackened Naaru Sliver (Sunwell — Felmyst)
    -- On-use: 55 AP to party/20s, 2min CD → 55*20/120 = 9 AP avg (self only)
    [34427] = { ATTACK_POWER = 9 },

    -- Steely Naaru Sliver (Sunwell — M'uru)
    -- On-use: 2400 max HP/20s, 2min CD → ~20% uptime
    -- Health ≈ stamina: 2400/10*0.17 = ~41 stam avg
    [34428] = { STAMINA = 41 },

    -- Shifting Naaru Sliver (Sunwell — M'uru)
    -- On-use: 320 SP/15s (stand in circle), 90s CD → 320*15/90 = 53 SP avg
    [34429] = { SPELL_POWER = 53 },

    -- Shard of Contempt (Magisters' Terrace — Heroic)
    -- 230 AP/20s, ~30% uptime → 69 AP avg
    [34472] = { ATTACK_POWER = 69 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Zul'Aman
    ---------------------------------------------------------------------------

    -- Hex Shrunken Head (Zul'Aman — Hex Lord)
    -- On-use: 211 SP/20s, 2min CD → 211*20/120 = 35 SP avg
    [33829] = { SPELL_POWER = 35 },

    -- Berserker's Call (Zul'Aman — Hex Lord)
    -- On-use: 360 AP/20s, 2min CD → 360*20/120 = 60 AP avg
    [33831] = { ATTACK_POWER = 60 },

    -- Tiny Voodoo Mask (Zul'Aman — Hex Lord)
    -- Heals proc 320 haste/6s, 45s ICD. ~13% uptime → 42 haste avg
    [34029] = { HASTE_RATING = 42 },

    -- Ancient Aqir Artifact (Zul'Aman — Akil'zon)
    -- On-use: 108 haste/20s, 2min CD → 108*20/120 = 18 haste avg
    [33830] = { HASTE_RATING = 18 },

    -- Dagger of Bad Mojo (Zul'Aman — timed chest)
    -- Equip: chance to poison for 136 nature/4s. ~2 PPM → ~4.5 DPS → ~22 AP
    [33827] = { ATTACK_POWER = 22 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Badge of Justice
    ---------------------------------------------------------------------------

    -- Icon of the Silver Crescent (Badge of Justice)
    -- On-use: 155 SP/20s, 2min CD → 155*20/120 = 26 SP avg
    [29370] = { SPELL_POWER = 26 },

    -- Bloodlust Brooch (Badge of Justice)
    -- On-use: 278 AP/20s, 2min CD → 278*20/120 = 46 AP avg
    [29383] = { ATTACK_POWER = 46 },

    -- Essence of the Martyr (Badge of Justice)
    -- On-use: 91 SP/20s, 2min CD → 91*20/120 = 15 SP avg
    [29376] = { SPELL_POWER = 15 },

    -- Figurine of the Colossus (Badge of Justice — Tank)
    -- On-use: absorb 1440 dmg/20s, 2min CD → ~20% uptime → ~24 stamina equiv
    [30300] = { STAMINA = 24 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Heroic Dungeons / World Drops
    ---------------------------------------------------------------------------

    -- Hourglass of the Unraveller (Black Morass)
    -- 300 AP/10s, ~10% uptime → 30 AP avg
    [28034] = { ATTACK_POWER = 30 },

    -- Quagmirran's Eye (Heroic Slave Pens)
    -- 320 haste/6s, 10% on cast, 45s ICD. ~13% uptime → 43 haste avg
    [27683] = { HASTE_RATING = 43 },

    -- Scarab of the Infinite Cycle (Black Morass)
    -- 190 haste/6s, 10% on cast, 45s ICD. ~13% uptime → 25 haste avg
    [28190] = { HASTE_RATING = 25 },

    -- Lower City Prayerbook (Lower City Exalted)
    -- On-use: reduce cast time by 22% (heals)/5s, 2min CD → ~4% uptime ≈ 15 haste avg
    [30841] = { HASTE_RATING = 15 },

    -- Bangle of Endless Blessings (Botanica — Warp Splinter)
    -- Heals proc: restores 120 mana to party, 15% chance, ICD. ~15 MP5 avg
    [28370] = { MP5 = 15 },

    -- Figurine - Living Ruby Serpent (JC BoP)
    -- On-use: 150 SP/20s, 2min CD → 150*20/120 = 25 SP avg
    [24126] = { SPELL_POWER = 25 },

    -- Figurine - Nightseye Panther (JC BoP)
    -- On-use: 320 AP/12s, 3min CD → 320*12/180 = 21 AP avg
    [24128] = { ATTACK_POWER = 21 },

    -- Abacus of Violent Odds (Mechanar — Pathaleon)
    -- On-use: 260 haste/10s, 2min CD → 260*10/120 = 22 haste avg
    [28288] = { HASTE_RATING = 22 },

    -- Arcanist's Stone (Heroic Mech — Cache)
    -- On-use: 167 SP/20s, 2min CD → 167*20/120 = 28 SP avg
    [28223] = { SPELL_POWER = 28 },

    -- Mark of Defiance (Heroic Auchindoun quest)
    -- Melee/range attacks proc ~16 HP heal. Minor → ~8 SP/stam hybrid
    [27924] = { STAMINA = 8 },

    -- Core of Ar'kelos (Arcatraz quest)
    -- On-use: 131 SP/20s, 2min CD → 131*20/120 = 22 SP avg
    [29132] = { SPELL_POWER = 22 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Darkmoon Cards
    ---------------------------------------------------------------------------

    -- Darkmoon Card: Crusade (Darkmoon Blessings deck)
    -- Melee: 6 AP/stack × 20 stacks = 120 AP at full. ~80% avg stacks → 96 AP
    -- Caster: 8 SP/stack × 10 stacks = 80 SP at full. ~80% avg stacks → 64 SP
    -- Use higher (melee) value; casters rarely use this anyway
    [31856] = { ATTACK_POWER = 96 },

    -- Darkmoon Card: Blue Dragon (Darkmoon Beasts deck)
    -- 2% on cast → regen continues while casting for 15s. ~15% uptime
    -- Worth ~25-40 MP5 depending on spirit. Estimate 30 MP5 avg
    [19288] = { MP5 = 30 },

    -- Darkmoon Card: Wrath (Darkmoon Storms deck)
    -- Non-crit grants +17 crit × stacks for 10s. At ~30% crit, avg ~80 crit rating
    -- Already listed above in T5 section
    -- [31857] = { CRIT_RATING = 80 },  -- defined above

    -- Darkmoon Card: Madness (Darkmoon Lunacy deck)
    -- Random debuff (inconsistent value). ~20 stat avg across procs
    [31859] = { SPIRIT = 20 },

    -- Darkmoon Card: Vengeance (Classic — Darkmoon Portals deck)
    -- 1-99 shadow dmg to attacker, ~3 PPM. ~4.5 DPS ≈ ~14 SP avg for tanks
    [19289] = { SPELL_POWER = 14 },

    ---------------------------------------------------------------------------
    -- TRINKETS — PvP
    ---------------------------------------------------------------------------

    -- Battlemaster's Audacity (PvP — Season 3/4) [Warrior]
    -- On-use: 1750 max HP/15s, 3min CD → 1750/10*15/180 = ~15 stam avg
    [34579] = { STAMINA = 15 },

    -- Battlemaster's Cruelty (PvP — Season 3) [Rogue]
    -- On-use: 1750 max HP/15s, 3min CD
    [34163] = { STAMINA = 15 },

    -- Battlemaster's Depravity (PvP — Season 3/4) [Caster]
    -- On-use: 1750 max HP/15s, 3min CD
    [34577] = { STAMINA = 15 },

    -- Battlemaster's Perseverance (PvP — Season 3/4) [Healer]
    -- On-use: 1750 max HP/15s, 3min CD
    [34580] = { STAMINA = 15 },

    -- Battlemaster's Determination (PvP — Season 4) [All]
    -- On-use: 1750 max HP/15s, 3min CD
    [34578] = { STAMINA = 15 },

    -- Medallion of the Alliance (Season 4 — all classes)
    -- CC break on-use only (no stat proc). Passive resilience in GetItemStats.
    -- The on-use has no stat equivalent for scoring
    [37864] = { RESILIENCE = 0 },

    -- Medallion of the Horde (Season 4 — all classes)
    [37865] = { RESILIENCE = 0 },

    ---------------------------------------------------------------------------
    -- TRINKETS — Misc Notable
    ---------------------------------------------------------------------------

    -- Figurine - Crimson Serpent (JC BoP Tank)
    -- On-use: 500 dodge/12s, 2min CD → 500*12/120 = 50 dodge avg
    [24125] = { DODGE = 50 },

    -- Pendant of the Violet Eye (Karazhan exalted ring effect — not a trinket)
    -- Listed for completeness: not scored here (it's a ring).

    -- Alchemist's Stone (Alch BoP)
    -- +40% potion effect. Hard to quantify as proc. Passive stats in GetItemStats.
    -- Estimate ~10 SP equivalent from potion boost in raid context
    [13503] = { SPELL_POWER = 10 },

    -- Redeemer's Alchemist Stone (Alch BoP — Sunwell)
    -- +40% potion effect. Passive stats in GetItemStats.
    [35749] = { SPELL_POWER = 10 },

    -- Assassin's Alchemist Stone (Alch BoP — Sunwell)
    -- +40% potion effect. Passive stats in GetItemStats.
    [35748] = { ATTACK_POWER = 20 },

    -- Guardian's Alchemist Stone (Alch BoP — Sunwell)
    -- +40% potion effect. Passive stats in GetItemStats.
    [35750] = { STAMINA = 10 },

    -- Tome of Diabolic Remedy (Karazhan — Illhoof)
    -- Heals proc: 173 SP/15s, ~20% uptime → 35 SP avg
    [28585] = { SPELL_POWER = 35 },

    -- Direbrew Hops / Brightbrew Charm (Brewfest)
    -- On-use: 297 AP/20s, 2min CD → 297*20/120 = 50 AP avg
    [38288] = { ATTACK_POWER = 50 },

    ---------------------------------------------------------------------------
    -- WEAPON PROCS (non-enchant built-in procs)
    ---------------------------------------------------------------------------

    -- Talon of Azshara (SSC — Lady Vashj)
    -- Equip: melee attacks proc 230 AP/10s, ~2 PPM → ~33% uptime → 77 AP avg
    -- BUT this is a dagger with slow speed. Real uptime ~20% → 46 AP
    [30082] = { ATTACK_POWER = 46 },

    -- Torch of the Damned (Hyjal trash)
    -- Equip: melee attacks proc fire dmg. ~5 DPS avg → ~25 AP
    [30886] = { ATTACK_POWER = 25 },

    -- The Decapitator (Prince Malchezaar — Karazhan)
    -- On-use: 513-567 thrown, 3min CD → ~3 DPS avg → 15 AP
    [28767] = { ATTACK_POWER = 15 },

    -- Dragonspine Trophy already listed above (28830)

    -- Rod of the Sun King (Kael'thas — TK)
    -- Equip: melee attacks restore 10 mana/swing to group. ~8 MP5 party avg
    [29996] = { MP5 = 8 },

    -- Blade of Harbingers (Hyjal — Archimonde)
    -- Equip: 198 shadow dmg proc. ~1 PPM → ~3 DPS → 15 SP
    [30881] = { SPELL_POWER = 15 },

    -- Spiteblade (Karazhan — Netherspite)
    -- Equip: chance on hit +45 AP/30s, stacks 3×. ~50% uptime at 2 stacks → 45 AP avg
    [28729] = { ATTACK_POWER = 45 },

    -- Vanir's Right Fist of Brutality (BT — Council)
    -- Equip: chance on hit haste proc. ~3% → 212 haste/10s → ~15 haste avg
    [32945] = { HASTE_RATING = 15 },

    -- Tracker's Blade (Zul'Aman — Nalorakk)
    -- Equip: 18 mana per 5 sec to wearer (passive, in GetItemStats)
    -- Proc: attacks restore 30 mana. ~2 PPM → ~1 MP5 (negligible)

    -- Cataclysm's Edge (Hyjal — Archimonde)
    -- No proc. Passive stats only → already in GetItemStats.

    -- Warglaive of Azzinoth (Illidan — BT) MH
    -- Equip: 200 haste/10s, ~1 PPM → ~17% uptime → 33 haste avg
    [32837] = { HASTE_RATING = 33 },

    -- Warglaive of Azzinoth (Illidan — BT) OH
    -- Same proc as MH
    [32838] = { HASTE_RATING = 33 },

    -- Sunflare (Sunwell — Kil'jaeden)
    -- Equip: 160 SP/10s on spell hit. ~15% uptime → 24 SP avg
    [34336] = { SPELL_POWER = 24 },

    -- Grand Magister's Staff of Torrents (Sunwell — Kil'jaeden)
    -- Equip: 250 SP/10s on spell damage. ~10% uptime → 25 SP avg
    [34182] = { SPELL_POWER = 25 },

    -- Golden Staff of the Sin'dorei (Sunwell — Eredar Twins)
    -- Equip: heals proc 190 SP/10s. ~15% uptime → 29 SP avg
    [34337] = { SPELL_POWER = 29 },

    -- Muramasa (BT — Gurtogg Bloodboil)
    -- Equip: chance on melee to gain 200 haste/10s. ~1 PPM → ~17% uptime → 33 haste avg
    [32946] = { HASTE_RATING = 33 },

    -- Blade of Infamy (BT — Supremus)
    -- Equip: chance to wound for 140-160 dmg. ~1 PPM → ~2.5 DPS → 12 AP
    [32526] = { ATTACK_POWER = 12 },

    -- Black Bow of the Betrayer (BT — Illidan)
    -- Equip: 185 shadow dmg proc + mana drain. ~1 PPM → ~3 DPS → 15 AP
    [32336] = { ATTACK_POWER = 15 },

    -- Zhar'doom, Greatstaff of the Devourer (BT — Illhoof)
    -- Equip: spell hit → 150 SP/10s. ~15% uptime → 23 SP avg
    [32500] = { SPELL_POWER = 23 },

    -- Hammer of Judgement (Hyjal — Kazrogal)
    -- Equip: melee hit → 110 SP/10s. ~15% uptime → 17 SP avg (Ret paladin)
    [30889] = { SPELL_POWER = 17 },

    ---------------------------------------------------------------------------
    -- RINGS WITH PROCS (non-visible equip effects)
    ---------------------------------------------------------------------------

    -- Ring of a Thousand Marks (Prince Malchezaar)
    -- Equip: melee attacks proc 160 AP/10s, ~1 PPM → ~17% uptime → 27 AP avg
    [28757] = { ATTACK_POWER = 27 },

    -- Band of the Eternal Champion (Hyjal honored)
    -- Equip: melee attacks proc 160 AP/10s, ~1 PPM → ~17% uptime → 27 AP avg
    [29301] = { ATTACK_POWER = 27 },

    -- Band of the Eternal Sage (Hyjal honored)
    -- Equip: spell casts proc 95 SP/10s, ~15% uptime → 14 SP avg
    [29305] = { SPELL_POWER = 14 },

    -- Band of the Eternal Restorer (Hyjal honored)
    -- Equip: heals proc 120 SP/10s, ~15% uptime → 18 SP avg
    [29309] = { SPELL_POWER = 18 },

    -- Band of the Eternal Defender (Hyjal honored)
    -- Equip: blocks proc 100 dodge/10s, ~15% uptime → 15 dodge avg
    [29297] = { DODGE = 15 },

    ---------------------------------------------------------------------------
    -- RANGED WEAPONS WITH PROCS
    ---------------------------------------------------------------------------

    -- Sunfury Bow of the Phoenix (Kael'thas — TK)
    -- Equip: ranged attacks proc 180 ArP/5s. ~15% uptime → 27 ArP avg
    [29993] = { ARMOR_PEN = 27 },

    -- Serpentshrine Shuriken (SSC — random drop)
    -- Equip: thrown attacks proc 112 AP/10s. ~15% uptime → 17 AP avg
    [30279] = { ATTACK_POWER = 17 },

    ---------------------------------------------------------------------------
    -- META GEM TRACKING (scored via GemDatabase, listed for reference only)
    -- NOT scored here — these are handled by GemDatabase.lua
    ---------------------------------------------------------------------------
}
