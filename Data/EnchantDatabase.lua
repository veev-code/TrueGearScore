---------------------------------------------------------------------------
-- TrueGearScore Enchant Database
-- Maps enchant IDs (from item link field 2) to stat contributions
-- Format: [enchantID] = { STAT_NAME = value, ... }
-- Stat names match canonical keys in Constants.STAT_KEYS / STAT_REVERSE
--
-- NOTE: Enchant IDs are the numeric values in the item link, NOT spell IDs.
-- Example link: |Hitem:28830:ENCHANT_ID:gem1:gem2:gem3:...|h
--
-- TBC has separate SPELL_POWER (damage) and HEAL_POWER (healing) stats.
-- Many enchants give both at different ratios (e.g., +81 Healing / +27 SD).
-- When an enchant gives unified "spell damage and healing", we record the
-- damage component as SPELL_POWER. The scoring engine handles the fact that
-- healing enchants are worth HEAL_POWER × healing_value + SPELL_POWER × damage_value.
--
-- For proc-based enchants (Mongoose, Crusader, etc.), the values represent
-- estimated average stat equivalents assuming typical raid uptime.
--
-- WEAPON_DAMAGE entries are raw weapon DPS additions (not a stat weight key).
-- The scoring engine converts these using a per-spec melee/ranged coefficient.
---------------------------------------------------------------------------

local _, addon = ...
addon.EnchantDatabase = {

    ---------------------------------------------------------------------------
    -- HEAD ENCHANTS (reputation augments) — TBC
    ---------------------------------------------------------------------------

    -- Sha'tar (Revered)
    [3002] = { SPELL_POWER = 22, HIT_RATING = 14 },            -- Glyph of Power (+22 SD, +14 Spell Hit)

    -- Cenarion Expedition (Revered)
    [3003] = { ATTACK_POWER = 34, HIT_RATING = 16 },           -- Glyph of Ferocity (+34 AP, +16 Hit)

    -- Honor Hold / Thrallmar (Revered)
    [3001] = { HEAL_POWER = 35, SPELL_POWER = 12, MP5 = 7 },   -- Glyph of Renewal (+35 Heal, +12 SD, +7 MP5)

    -- Keepers of Time (Revered)
    [2999] = { DEFENSE = 16, DODGE = 17 },                      -- Glyph of the Defender (+16 Defense, +17 Dodge)

    -- Lower City (Revered)
    [3004] = { STAMINA = 18, RESILIENCE = 20 },                 -- Glyph of the Gladiator (+18 STA, +20 Resilience)

    -- Sha'tari Skyguard (revered) / SSO
    [3095] = { RESIST_ALL = 8 },                                -- Glyph of Chromatic Warding (+8 All Resist)

    -- Inscription of Endurance (Lower City Honored)
    [2998] = { RESIST_ALL = 7 },                                -- Inscription of Endurance (+7 All Resist)

    ---------------------------------------------------------------------------
    -- HEAD/LEG ENCHANTS — Classic (Librams from Dire Maul)
    ---------------------------------------------------------------------------

    [1503] = { STAMINA = 7 },                                   -- Lesser Arcanum of Constitution (+100 HP ≈ 7 STA)
    [1504] = { ARMOR = 125 },                                   -- Lesser Arcanum of Tenacity (+125 Armor)
    [1505] = { FIRE_RESIST = 20 },                              -- Lesser Arcanum of Resilience (+20 Fire Resist)
    [1483] = { INTELLECT = 10 },                                -- Lesser Arcanum of Rumination (+150 Mana ≈ 10 INT)
    [1506] = { STRENGTH = 8 },                                  -- Lesser Arcanum of Voracity (+8 STR)
    [1507] = { STAMINA = 8 },                                   -- Lesser Arcanum of Voracity (+8 STA)
    [1508] = { AGILITY = 8 },                                   -- Lesser Arcanum of Voracity (+8 AGI)
    [1509] = { INTELLECT = 8 },                                 -- Lesser Arcanum of Voracity (+8 INT)
    [1510] = { SPIRIT = 8 },                                    -- Lesser Arcanum of Voracity (+8 SPI)

    ---------------------------------------------------------------------------
    -- HEAD/LEG ENCHANTS — Classic (Arcanums from Dire Maul)
    ---------------------------------------------------------------------------

    [2543] = { HASTE_RATING = 10 },                             -- Arcanum of Rapidity (+1% Haste ≈ 10 Haste Rating)
    [2544] = { SPELL_POWER = 8 },                               -- Arcanum of Focus (+8 Spell Damage and Healing)
    [2545] = { DODGE = 12 },                                    -- Arcanum of Protection (+1% Dodge ≈ 12 Dodge Rating)

    ---------------------------------------------------------------------------
    -- HEAD/LEG ENCHANTS — Classic (ZG class-specific)
    ---------------------------------------------------------------------------

    -- Warrior: Presence of Might (+10 STA, +7 Defense, +15 Block Value)
    [2583] = { STAMINA = 10, DEFENSE = 7, BLOCK_VALUE = 15 },

    -- Paladin: Syncretist's Sigil (+10 STA, +7 Defense, +24 Healing)
    [2584] = { STAMINA = 10, DEFENSE = 7, HEAL_POWER = 24 },

    -- Rogue: Death's Embrace (+28 AP, +1% Dodge)
    [2585] = { ATTACK_POWER = 28, DODGE = 12 },

    -- Hunter: Falcon's Call (+24 Ranged AP, +10 STA, +1% Hit)
    [2586] = { ATTACK_POWER = 24, STAMINA = 10, HIT_RATING = 10 },

    -- Shaman: Vodouisant's Vigilant Embrace (+15 INT, +13 SD/Heal)
    [2587] = { INTELLECT = 15, SPELL_POWER = 13 },

    -- Mage: Presence of Sight (+18 SD/Heal, +1% Spell Hit)
    [2588] = { SPELL_POWER = 18, HIT_RATING = 10 },

    -- Warlock: Hoodoo Hex (+10 STA, +18 SD/Heal)
    [2589] = { STAMINA = 10, SPELL_POWER = 18 },

    -- Priest: Prophetic Aura (+10 STA, +4 MP5, +24 Healing)
    [2590] = { STAMINA = 10, MP5 = 4, HEAL_POWER = 24 },

    -- Druid: Animist's Caress (+10 STA, +10 INT, +24 Healing)
    [2591] = { STAMINA = 10, INTELLECT = 10, HEAL_POWER = 24 },

    ---------------------------------------------------------------------------
    -- HEAD/LEG ENCHANTS — Classic (ZG all-class)
    ---------------------------------------------------------------------------

    -- Savage Guard (+10 Nature Resist)
    [2681] = { NATURE_RESIST = 10 },

    ---------------------------------------------------------------------------
    -- SHOULDER ENCHANTS — TBC (Aldor)
    ---------------------------------------------------------------------------

    -- Aldor (Honored)
    [2979] = { HEAL_POWER = 29, SPELL_POWER = 10 },            -- Inscription of Faith (+29 Heal, +10 SD)
    [2981] = { SPELL_POWER = 15 },                              -- Inscription of Discipline (+15 SD)
    [2983] = { ATTACK_POWER = 26 },                             -- Inscription of Vengeance (+26 AP)
    [2990] = { DEFENSE = 13 },                                  -- Inscription of Warding (+13 Defense)

    -- Aldor (Exalted)
    [2980] = { HEAL_POWER = 33, SPELL_POWER = 11, MP5 = 4 },   -- Greater Inscription of Faith (+33 Heal, +11 SD, +4 MP5)
    [2982] = { SPELL_POWER = 18, CRIT_RATING = 10 },           -- Greater Inscription of Discipline (+18 SD, +10 Spell Crit)
    [2986] = { ATTACK_POWER = 30, CRIT_RATING = 10 },          -- Greater Inscription of Vengeance (+30 AP, +10 Crit)
    [2978] = { DODGE = 15, DEFENSE = 10 },                      -- Greater Inscription of Warding (+15 Dodge, +10 Defense)

    -- Scryer (Honored)
    [2992] = { MP5 = 6 },                                       -- Inscription of the Oracle (+6 MP5)
    [2994] = { CRIT_RATING = 13 },                              -- Inscription of the Orb (+13 Spell Crit)
    [2996] = { CRIT_RATING = 13 },                              -- Inscription of the Blade (+13 Crit)

    -- Scryer (Exalted)
    [2993] = { HEAL_POWER = 22, MP5 = 6 },                      -- Greater Inscription of the Oracle (+22 Heal, +6 MP5)
    [2995] = { SPELL_POWER = 12, CRIT_RATING = 15 },           -- Greater Inscription of the Orb (+12 SD, +15 Spell Crit)
    [2997] = { ATTACK_POWER = 20, CRIT_RATING = 15 },          -- Greater Inscription of the Blade (+20 AP, +15 Crit)
    [2991] = { DEFENSE = 15, DODGE = 10 },                      -- Greater Inscription of the Knight (+15 Defense, +10 Dodge)

    ---------------------------------------------------------------------------
    -- SHOULDER ENCHANTS — Classic (ZG Signets)
    ---------------------------------------------------------------------------

    [2604] = { HEAL_POWER = 33 },                               -- Zandalar Signet of Serenity (+33 Healing)
    [2605] = { SPELL_POWER = 18 },                              -- Zandalar Signet of Mojo (+18 SD/Heal)
    [2606] = { ATTACK_POWER = 30 },                             -- Zandalar Signet of Might (+30 AP)

    ---------------------------------------------------------------------------
    -- SHOULDER ENCHANTS — Classic (Argent Dawn Mantles)
    ---------------------------------------------------------------------------

    [2483] = { FIRE_RESIST = 5 },                               -- Flame Mantle of the Dawn (+5 Fire Resist)
    [2484] = { FROST_RESIST = 5 },                              -- Frost Mantle of the Dawn (+5 Frost Resist)
    [2485] = { ARCANE_RESIST = 5 },                             -- Arcane Mantle of the Dawn (+5 Arcane Resist)
    [2486] = { NATURE_RESIST = 5 },                             -- Nature Mantle of the Dawn (+5 Nature Resist)
    [2487] = { SHADOW_RESIST = 5 },                             -- Shadow Mantle of the Dawn (+5 Shadow Resist)
    [2488] = { RESIST_ALL = 5 },                                -- Chromatic Mantle of the Dawn (+5 All Resist)

    ---------------------------------------------------------------------------
    -- CHEST ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [2661] = { STRENGTH = 6, AGILITY = 6, STAMINA = 6,
               INTELLECT = 6, SPIRIT = 6 },                     -- Enchant Chest - Exceptional Stats (+6 All Stats)
    [2659] = { STAMINA = 10 },                                  -- Enchant Chest - Exceptional Health (+150 Health ≈ 10 STA equiv)
    [2660] = { INTELLECT = 10 },                                -- Enchant Chest - Exceptional Mana (+150 Mana ≈ 10 INT equiv)
    [2933] = { RESILIENCE = 15 },                               -- Enchant Chest - Major Resilience (+15 Resilience)
    [2662] = { ARMOR = 120 },                                   -- Enchant Chest - Defense (+120 Armor) [TBC]

    ---------------------------------------------------------------------------
    -- CHEST ENCHANTS — Classic
    ---------------------------------------------------------------------------

    [1891] = { STRENGTH = 4, AGILITY = 4, STAMINA = 4,
               INTELLECT = 4, SPIRIT = 4 },                     -- Enchant Chest - Greater Stats (+4 All Stats)
    [928]  = { STRENGTH = 3, AGILITY = 3, STAMINA = 3,
               INTELLECT = 3, SPIRIT = 3 },                     -- Enchant Chest - Stats (+3 All Stats)
    [866]  = { STRENGTH = 2, AGILITY = 2, STAMINA = 2,
               INTELLECT = 2, SPIRIT = 2 },                     -- Enchant Chest - Lesser Stats (+2 All Stats)
    [847]  = { STRENGTH = 1, AGILITY = 1, STAMINA = 1,
               INTELLECT = 1, SPIRIT = 1 },                     -- Enchant Chest - Minor Stats (+1 All Stats)

    [1892] = { STAMINA = 7 },                                   -- Enchant Chest - Major Health (+100 HP ≈ 7 STA)
    [908]  = { STAMINA = 3 },                                   -- Enchant Chest - Superior Health (+50 HP ≈ 3 STA)
    [850]  = { STAMINA = 2 },                                   -- Enchant Chest - Greater Health (+35 HP ≈ 2 STA)
    [254]  = { STAMINA = 2 },                                   -- Enchant Chest - Health (+25 HP ≈ 2 STA)
    [242]  = { STAMINA = 1 },                                   -- Enchant Chest - Lesser Health (+15 HP ≈ 1 STA)
    [41]   = {},                                                 -- Enchant Chest - Minor Health (+5 HP, negligible)

    [1893] = { INTELLECT = 7 },                                 -- Enchant Chest - Major Mana (+100 Mana ≈ 7 INT)
    [913]  = { INTELLECT = 4 },                                 -- Enchant Chest - Superior Mana (+65 Mana ≈ 4 INT)
    [857]  = { INTELLECT = 3 },                                 -- Enchant Chest - Greater Mana (+50 Mana ≈ 3 INT)
    [843]  = { INTELLECT = 2 },                                 -- Enchant Chest - Mana (+30 Mana ≈ 2 INT)
    [246]  = { INTELLECT = 1 },                                 -- Enchant Chest - Lesser Mana (+20 Mana ≈ 1 INT)
    [24]   = {},                                                 -- Enchant Chest - Minor Mana (+5 Mana, negligible)

    [1144] = { SPIRIT = 15 },                                   -- Enchant Chest - Major Spirit (+15 Spirit) [often used TBC]
    [44]   = {},                                                 -- Enchant Chest - Minor Absorption (absorb 10, negligible)
    [63]   = {},                                                 -- Enchant Chest - Absorption (absorb 25, negligible)
    [253]  = {},                                                 -- Enchant Chest - Lesser Absorption (absorb 50, negligible)

    ---------------------------------------------------------------------------
    -- CLOAK ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [2938] = { SPELL_PEN = 20 },                                -- Enchant Cloak - Spell Penetration (+20 Spell Pen)
    [2664] = { RESIST_ALL = 7 },                                -- Enchant Cloak - Major Resistance (+7 All Resist)
    [2621] = { THREAT_REDUCTION = 2 },                          -- Enchant Cloak - Subtlety (2% Reduced Threat)
    [2648] = { DEFENSE = 12 },                                  -- Enchant Cloak - Steelweave (+12 Defense Rating)
    [910]  = {},                                                 -- Enchant Cloak - Stealth (stealth bonus, no combat stats)

    ---------------------------------------------------------------------------
    -- CLOAK ENCHANTS — Classic
    ---------------------------------------------------------------------------

    [368]  = { AGILITY = 12 },                                  -- Enchant Cloak - Greater Agility (+12 AGI) [TBC-era but commonly listed]
    [883]  = { AGILITY = 15 },                                  -- Enchant Cloak - Greater Agility (+15 AGI) [TBC phase 5]
    [1889] = { ARMOR = 70 },                                    -- Enchant Cloak - Superior Defense (+70 Armor)
    [884]  = { ARMOR = 50 },                                    -- Enchant Cloak - Greater Defense (+50 Armor)
    [848]  = { ARMOR = 30 },                                    -- Enchant Cloak - Defense (+30 Armor) [same ID as Shield - Lesser Protection]
    [744]  = { ARMOR = 20 },                                    -- Enchant Cloak - Lesser Protection (+20 Armor)
    [1888] = { RESIST_ALL = 5 },                                -- Enchant Cloak - Greater Resistance (+5 All Resist)
    [903]  = { RESIST_ALL = 3 },                                -- Enchant Cloak - Resistance (+3 All Resist)
    [65]   = { RESIST_ALL = 1 },                                -- Enchant Cloak - Minor Resistance (+1 All Resist)
    [256]  = { FIRE_RESIST = 5 },                               -- Enchant Cloak - Fire Resistance (+5 Fire Resist)
    [2463] = { FIRE_RESIST = 7 },                               -- Enchant Cloak - Greater Fire Resistance (+7 Fire Resist)
    [2619] = { FIRE_RESIST = 15 },                              -- Enchant Cloak - Greater Fire Resistance (+15 Fire Resist) [AQ era]
    [2620] = { NATURE_RESIST = 15 },                            -- Enchant Cloak - Greater Nature Resistance (+15 Nature Resist)
    [849]  = { AGILITY = 3 },                                   -- Enchant Cloak - Lesser Agility (+3 AGI)
    [247]  = { AGILITY = 1 },                                   -- Enchant Cloak - Minor Agility (+1 AGI)
    [2622] = { DODGE = 12 },                                    -- Enchant Cloak - Dodge (+1% Dodge ≈ 12 Dodge Rating)

    ---------------------------------------------------------------------------
    -- BRACER / WRIST ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [2617] = { HEAL_POWER = 30, SPELL_POWER = 10 },            -- Enchant Bracer - Superior Healing (+30 Heal, +10 SD)
    [2650] = { SPELL_POWER = 15 },                              -- Enchant Bracer - Spellpower (+15 Spell Damage)
    [1593] = { ATTACK_POWER = 24 },                             -- Enchant Bracer - Assault (+24 AP)
    [2647] = { STRENGTH = 12 },                                 -- Enchant Bracer - Brawn (+12 Strength)
    [2649] = { STAMINA = 12 },                                  -- Enchant Bracer - Fortitude (+12 Stamina)
    [369]  = { INTELLECT = 12 },                                -- Enchant Bracer - Major Intellect (+12 Intellect)
    [2679] = { MP5 = 6 },                                       -- Enchant Bracer - Restore Mana Prime (+6 MP5)

    ---------------------------------------------------------------------------
    -- BRACER / WRIST ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- Healing / Mana Regen
    [2566] = { HEAL_POWER = 24 },                               -- Enchant Bracer - Healing Power (+24 Healing)
    [2565] = { MP5 = 4 },                                       -- Enchant Bracer - Mana Regeneration (+4 MP5)

    -- Stamina
    [1886] = { STAMINA = 9 },                                   -- Enchant Bracer - Superior Stamina (+9 STA)
    [929]  = { STAMINA = 7 },                                   -- Enchant Bracer - Greater Stamina (+7 STA)
    [852]  = { STAMINA = 5 },                                   -- Enchant Bracer - Stamina (+5 STA)
    [724]  = { STAMINA = 3 },                                   -- Enchant Bracer - Lesser Stamina (+3 STA)
    [66]   = { STAMINA = 1 },                                   -- Enchant Bracer - Minor Stamina (+1 STA)

    -- Strength
    [1885] = { STRENGTH = 9 },                                  -- Enchant Bracer - Superior Strength (+9 STR)
    [927]  = { STRENGTH = 7 },                                  -- Enchant Bracer - Greater Strength (+7 STR)
    [856]  = { STRENGTH = 5 },                                  -- Enchant Bracer - Strength (+5 STR)
    [823]  = { STRENGTH = 3 },                                  -- Enchant Bracer - Lesser Strength (+3 STR)
    [248]  = { STRENGTH = 1 },                                  -- Enchant Bracer - Minor Strength (+1 STR)

    -- Intellect
    [1883] = { INTELLECT = 7 },                                 -- Enchant Bracer - Greater Intellect (+7 INT)
    [905]  = { INTELLECT = 5 },                                 -- Enchant Bracer - Intellect (+5 INT)
    [723]  = { INTELLECT = 3 },                                 -- Enchant Bracer - Lesser Intellect (+3 INT)
    [251]  = { INTELLECT = 1 },                                 -- Enchant Bracer - Minor Intellect (+1 INT)

    -- Spirit
    [1884] = { SPIRIT = 9 },                                    -- Enchant Bracer - Superior Spirit (+9 SPI)
    [907]  = { SPIRIT = 7 },                                    -- Enchant Bracer - Greater Spirit (+7 SPI)
    [851]  = { SPIRIT = 5 },                                    -- Enchant Bracer - Spirit (+5 SPI)
    [255]  = { SPIRIT = 3 },                                    -- Enchant Bracer - Lesser Spirit (+3 SPI)
    [243]  = { SPIRIT = 1 },                                    -- Enchant Bracer - Minor Spirit (+1 SPI)

    -- Agility
    [1887] = { AGILITY = 7 },                                   -- Enchant Bracer - Greater Agility (Shared w/ Boots/Gloves — +7 AGI)
    [904]  = { AGILITY = 5 },                                   -- Enchant Bracer - (unused directly; Boots - Agility uses this ID)

    -- Defense
    [923]  = { DEFENSE = 3 },                                   -- Enchant Bracer - Deflection (+3 Defense)
    [925]  = { DEFENSE = 2 },                                   -- Enchant Bracer - Lesser Deflection (+2 Defense)
    [924]  = { DEFENSE = 2 },                                   -- Enchant Bracer - Minor Deflection (+2 Defense)

    ---------------------------------------------------------------------------
    -- GLOVE ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [2322] = { HEAL_POWER = 35, SPELL_POWER = 12 },            -- Enchant Gloves - Major Healing (+35 Heal, +12 SD)
    [2937] = { SPELL_POWER = 20 },                              -- Enchant Gloves - Major Spellpower (+20 Spell Damage)
    [1594] = { ATTACK_POWER = 26 },                             -- Enchant Gloves - Assault (+26 AP)
    [684]  = { STRENGTH = 15 },                                 -- Enchant Gloves - Major Strength (+15 Strength)
    [2564] = { AGILITY = 15 },                                  -- Enchant Gloves - Superior Agility (+15 AGI)
    [2935] = { HIT_RATING = 15 },                               -- Enchant Gloves - Spell Strike (+15 Spell Hit)
    [2934] = { CRIT_RATING = 10 },                              -- Enchant Gloves - Blasting (+10 Spell Crit)
    [2614] = { SPELL_POWER = 20 },                              -- Enchant Gloves - Shadow Power (+20 Shadow SD)
    [2616] = { SPELL_POWER = 20 },                              -- Enchant Gloves - Fire Power (+20 Fire SD)
    [2615] = { SPELL_POWER = 20 },                              -- Enchant Gloves - Frost Power (+20 Frost SD)
    [2613] = { THREAT = 2 },                                    -- Enchant Gloves - Threat (+2% Threat)

    ---------------------------------------------------------------------------
    -- GLOVE ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- Stats
    -- [1887] = +7 AGI (Enchant Gloves - Greater Agility, shares ID with bracer)
    -- [927]  = +7 STR (Enchant Gloves - Greater Strength, shares ID with bracer)
    -- [856] shares ID with Bracer - Strength (+5 STR)
    [931]  = { HASTE_RATING = 10 },                             -- Enchant Gloves - Minor Haste (+1% Haste ≈ 10 Haste Rating)
    [930]  = {},                                                 -- Enchant Gloves - Riding Skill (minor mount speed, no combat stats)
    -- [2617] shares ID with Bracer - Superior Healing (+30 Heal, +10 SD)

    -- Profession enchants (no combat stats)
    [865]  = {},                                                 -- Enchant Gloves - Skinning (+5 Skinning)
    [844]  = {},                                                 -- Enchant Gloves - Mining (+2 Mining)
    [906]  = {},                                                 -- Enchant Gloves - Mining (+5 Mining)
    [845]  = {},                                                 -- Enchant Gloves - Herbalism (+2 Herbalism)
    [909]  = {},                                                 -- Enchant Gloves - Herbalism (+5 Herbalism)
    [846]  = {},                                                 -- Enchant Gloves - Fishing (+2 Fishing)
    [2603] = {},                                                 -- Enchant Gloves - Fishing (+5 Fishing)

    ---------------------------------------------------------------------------
    -- LEG ENCHANTS — TBC (Leatherworking armor kits)
    ---------------------------------------------------------------------------

    [3012] = { ATTACK_POWER = 50, CRIT_RATING = 12 },          -- Nethercobra Leg Armor (+50 AP, +12 Crit)
    [3010] = { ATTACK_POWER = 40, CRIT_RATING = 10 },          -- Cobrahide Leg Armor (+40 AP, +10 Crit)
    [3013] = { STAMINA = 40, AGILITY = 12 },                   -- Nethercleft Leg Armor (+40 STA, +12 AGI)
    [3011] = { STAMINA = 30, AGILITY = 10 },                   -- Clefthide Leg Armor (+30 STA, +10 AGI)

    -- TBC Tailoring spellthread
    [2748] = { SPELL_POWER = 35, STAMINA = 20 },               -- Runic Spellthread (+35 SD, +20 STA)
    [2747] = { SPELL_POWER = 25, STAMINA = 15 },               -- Mystic Spellthread (+25 SD, +15 STA)
    [2746] = { HEAL_POWER = 66, SPELL_POWER = 22, STAMINA = 20 }, -- Golden Spellthread (+66 Heal, +22 SD, +20 STA)
    [2745] = { HEAL_POWER = 46, SPELL_POWER = 15, STAMINA = 15 }, -- Silver Spellthread (+46 Heal, +15 SD, +15 STA)

    ---------------------------------------------------------------------------
    -- BOOT ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [2940] = { STAMINA = 9 },                                   -- Enchant Boots - Boar's Speed (+9 STA + Minor Speed)
    [2939] = { AGILITY = 6 },                                   -- Enchant Boots - Cat's Swiftness (+6 AGI + Minor Speed)
    [2656] = { MP5 = 4 },                                       -- Enchant Boots - Vitality (+4 HP5, +4 MP5)
    [2657] = { AGILITY = 12 },                                  -- Enchant Boots - Dexterity (+12 AGI)
    [2658] = { HIT_RATING = 10 },                               -- Enchant Boots - Surefooted (+10 Hit + 5% Snare Resist)

    ---------------------------------------------------------------------------
    -- BOOT ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- [1887] = +7 AGI (Enchant Boots - Greater Agility, same ID)
    -- [904]  = +5 AGI (Enchant Boots - Agility, same ID)
    [911]  = {},                                                 -- Enchant Boots - Minor Speed (speed only, no stats)
    -- [852]  = +5 STA (Enchant Boots - Stamina, same ID as Bracer - Stamina)
    -- [929]  = +7 STA (Enchant Boots - Greater Stamina, same ID as Bracer - Greater Stamina)
    -- [851]  = +5 SPI (Enchant Boots - Spirit, same ID as Bracer - Spirit)

    ---------------------------------------------------------------------------
    -- WEAPON ENCHANTS — TBC
    ---------------------------------------------------------------------------

    -- Proc-based (average stat equivalents)
    [2673] = { AGILITY = 28 },                                  -- Mongoose (proc: 120 AGI/15s, ~1 PPM ≈ 28 AGI avg)
    [3225] = { ARMOR_PEN = 60 },                                -- Executioner (proc: 840 ArPen/15s)
    [3273] = {},                                                 -- Deathfrost (150 Frost dmg + slow)
    [2675] = { STAMINA = 12 },                                  -- Battlemaster (proc: heals party)
    [2674] = { MP5 = 10 },                                      -- Spellsurge (proc: 100 mana to party)

    -- Static weapon enchants — TBC
    [2669] = { SPELL_POWER = 40 },                              -- Enchant Weapon - Major Spellpower (+40 SD)
    [2343] = { HEAL_POWER = 81, SPELL_POWER = 27 },            -- Enchant Weapon - Major Healing (+81 Heal, +27 SD)
    [2667] = { ATTACK_POWER = 70 },                             -- Enchant 2H Weapon - Savagery (+70 AP)
    [2670] = { AGILITY = 35 },                                  -- Enchant 2H Weapon - Major Agility (+35 AGI)
    [3222] = { AGILITY = 20 },                                  -- Enchant Weapon - Greater Agility (+20 AGI)
    [2671] = { SPELL_POWER = 50 },                              -- Enchant Weapon - Sunfire (+50 Arcane/Fire SD)
    [2672] = { SPELL_POWER = 54 },                              -- Enchant Weapon - Soulfrost (+54 Shadow/Frost SD)
    [2666] = { INTELLECT = 30 },                                -- Enchant Weapon - Major Intellect (+30 INT)
    [2668] = { STRENGTH = 20 },                                 -- Enchant Weapon - Potency (+20 STR)

    -- Weapon chains / spikes
    [3223] = {},                                                 -- Adamantite Weapon Chain (disarm duration -50%)
    [2714] = {},                                                 -- Felsteel Spike (dmg reflect)

    ---------------------------------------------------------------------------
    -- WEAPON ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- Proc-based Classic
    [1900] = { STRENGTH = 10 },                                 -- Crusader (proc: 100 STR/15s ≈ 10 STR avg)
    [1898] = {},                                                 -- Lifestealing (proc: 30 HP drain, negligible stat equiv)
    [803]  = {},                                                 -- Fiery Weapon (proc: 40 fire damage, negligible stat equiv)
    [1899] = {},                                                 -- Unholy Weapon (proc: curse reduces melee damage)
    [1894] = {},                                                 -- Icy Chill (proc: slow movement+attack speed)
    [912]  = {},                                                 -- Demonslaying (proc: stun + heavy damage to demons)

    -- Static Classic weapon enchants
    [2504] = { SPELL_POWER = 30 },                              -- Enchant Weapon - Spell Power (+30 SD)
    [2505] = { HEAL_POWER = 55 },                               -- Enchant Weapon - Healing Power (+55 Healing)
    [2563] = { STRENGTH = 15 },                                 -- Enchant Weapon - Strength (+15 STR)
    -- [2564] shares ID with Gloves - Superior Agility (+15 AGI)
    [2567] = { SPIRIT = 20 },                                   -- Enchant Weapon - Mighty Spirit (+20 SPI)
    [2568] = { INTELLECT = 22 },                                -- Enchant Weapon - Mighty Intellect (+22 INT)

    [1897] = { WEAPON_DAMAGE = 5 },                             -- Enchant Weapon - Superior Striking (+5 Damage)
    [805]  = { WEAPON_DAMAGE = 4 },                             -- Enchant Weapon - Greater Striking (+4 Damage)
    [943]  = { WEAPON_DAMAGE = 3 },                             -- Enchant Weapon - Striking (+3 Damage)
    [241]  = { WEAPON_DAMAGE = 2 },                             -- Enchant Weapon - Minor Striking (+2 Damage)
    [250]  = { WEAPON_DAMAGE = 1 },                             -- Enchant Weapon - Minor Damage (+1 Damage)

    [2506] = { CRIT_RATING = 28 },                              -- Enchant Weapon - Major Striking [AQ] (+2% Crit ≈ 28 Crit Rating)

    -- 2H Weapon enchants — Classic
    [2646] = { AGILITY = 25 },                                  -- Enchant 2H Weapon - Agility (+25 AGI)
    [2665] = { SPIRIT = 35 },                                   -- Enchant 2H Weapon - Major Spirit (+35 SPI)
    [1903] = { SPIRIT = 9 },                                    -- Enchant 2H Weapon - Major Spirit [Classic rank] (+9 SPI)
    [1904] = { INTELLECT = 9 },                                 -- Enchant 2H Weapon - Major Intellect (+9 INT)
    [1896] = { WEAPON_DAMAGE = 9 },                             -- Enchant 2H Weapon - Superior Impact (+9 Damage)
    [963]  = { WEAPON_DAMAGE = 7 },                             -- Enchant 2H Weapon - Greater Impact (+7 Damage)
    [1895] = { WEAPON_DAMAGE = 7 },                             -- Enchant 2H Weapon - Impact (+5 Damage) [mid-level]
    [864]  = { WEAPON_DAMAGE = 4 },                             -- Enchant 2H Weapon - Lesser Impact (+3 Damage)

    -- Sharpening Stones / Weightstones (temporary but commonly found in links)
    [2712] = { WEAPON_DAMAGE = 12, CRIT_RATING = 14 },         -- Adamantite Sharpening Stone (+12 Dmg, +14 Crit)
    [2713] = { WEAPON_DAMAGE = 12 },                            -- Adamantite Weightstone (+12 Dmg)
    [1643] = { WEAPON_DAMAGE = 8 },                             -- Elemental Sharpening Stone (+2% Crit ≈ 28 Crit)
    [483]  = { WEAPON_DAMAGE = 6 },                             -- Dense Sharpening Stone (+6 Damage)
    [484]  = { WEAPON_DAMAGE = 6 },                             -- Dense Weightstone (+6 Damage)

    ---------------------------------------------------------------------------
    -- SHIELD ENCHANTS — TBC
    ---------------------------------------------------------------------------

    [1071] = { STAMINA = 18 },                                  -- Enchant Shield - Major Stamina (+18 STA) [TBC phase 5]
    [2654] = { INTELLECT = 12 },                                -- Enchant Shield - Intellect (+12 INT)
    [3229] = { RESILIENCE = 12 },                               -- Enchant Shield - Resilience (+12 Resilience)
    [2655] = { BLOCK_RATING = 15 },                             -- Enchant Shield - Shield Block (+15 Block Rating)
    [2653] = { BLOCK_VALUE = 18 },                              -- Enchant Shield - Tough Shield (+18 Block Value)

    ---------------------------------------------------------------------------
    -- SHIELD ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- [929]  = +7 STA (Enchant Shield - Greater Stamina, same ID as bracer)
    [1890] = { SPIRIT = 9 },                                    -- Enchant Shield - Superior Spirit (+9 SPI)
    -- [907] shares ID with Bracer - Greater Spirit (+7 SPI)
    -- [851]  = +5 SPI (Enchant Shield - Spirit, same ID as bracer)
    [64]   = { SPIRIT = 3 },                                    -- Enchant Shield - Lesser Spirit (+3 SPI)

    [863]  = { BLOCK_RATING = 10 },                             -- Enchant Shield - Lesser Block (+2% Block ≈ 10 Block Rating)
    [1952] = { BLOCK_RATING = 20 },                             -- Enchant Shield - Greater Block (+20 Block Rating) [AQ era]

    [1950] = { DEFENSE = 15 },                                  -- Enchant Shield - Defense [TBC] (reused in TBC; Classic had lower)
    -- [848]  = +30 Armor (Enchant Shield - Lesser Protection, same ID as Cloak - Defense)
    [926]  = { FROST_RESIST = 8 },                              -- Enchant Shield - Frost Resistance (+8 Frost Resist)

    [28]   = { RESIST_ALL = 4 },                                -- Enchant Shield - Resistance (+4 All Resist)

    ---------------------------------------------------------------------------
    -- RING ENCHANTS — TBC (Enchanting-only, BoP)
    ---------------------------------------------------------------------------

    [2930] = { HEAL_POWER = 20, SPELL_POWER = 7 },             -- Enchant Ring - Healing Power (+20 Heal, +7 SD)
    [2928] = { SPELL_POWER = 12 },                              -- Enchant Ring - Spellpower (+12 SD)
    [2929] = { WEAPON_DAMAGE = 2 },                             -- Enchant Ring - Striking (+2 Weapon Damage)
    [2931] = { STRENGTH = 4, AGILITY = 4, STAMINA = 4,
               INTELLECT = 4, SPIRIT = 4 },                     -- Enchant Ring - Stats (+4 All Stats)

    ---------------------------------------------------------------------------
    -- RANGED ENCHANTS (Scopes — Engineering)
    ---------------------------------------------------------------------------

    -- TBC Scopes
    [2724] = { CRIT_RATING = 28 },                              -- Stabilized Eternium Scope (+28 Crit Rating)
    [2723] = { WEAPON_DAMAGE = 12 },                            -- Khorium Scope (+12 Damage)
    [2722] = { WEAPON_DAMAGE = 10 },                            -- Adamantite Scope (+10 Damage)

    -- Classic Scopes
    [664]  = { WEAPON_DAMAGE = 7 },                             -- Sniper Scope (+7 Damage)
    [663]  = { WEAPON_DAMAGE = 5 },                             -- Accurate Scope (+5 Damage)
    [33]   = { WEAPON_DAMAGE = 3 },                             -- Deadly Scope (+3 Damage)
    [32]   = { WEAPON_DAMAGE = 2 },                             -- Standard Scope (+2 Damage)
    [30]   = { WEAPON_DAMAGE = 1 },                             -- Crude Scope (+1 Damage)

    ---------------------------------------------------------------------------
    -- ENGINEERING — Classic (non-scope)
    ---------------------------------------------------------------------------

    [34]   = { HASTE_RATING = 20 },                             -- Counterweight (+3% Haste ≈ 20 Haste Rating)
    [37]   = {},                                                 -- Steel Weapon Chain (immune to disarm)
    [463]  = {},                                                 -- Mithril Spurs (+4% Mount Speed — boots)
    [464]  = {},                                                 -- Mithril Spurs variant (+4% Mount Speed)

    ---------------------------------------------------------------------------
    -- BLACKSMITHING — Classic (Spikes / Chains)
    ---------------------------------------------------------------------------

    [43]   = {},                                                 -- Iron Spike (8-12 dmg on block)
    [1704] = {},                                                 -- Thorium Spike (20-30 dmg on block)

    ---------------------------------------------------------------------------
    -- ARMOR KITS — Classic (Leatherworking)
    ---------------------------------------------------------------------------

    -- Armor kits provide flat armor
    [18]   = { ARMOR = 32 },                                    -- Heavy Armor Kit (+32 Armor)
    [17]   = { ARMOR = 24 },                                    -- Medium Armor Kit (+24 Armor) [chest/legs/hands/feet]
    [16]   = { ARMOR = 16 },                                    -- Light Armor Kit (+16 Armor)
    [15]   = { ARMOR = 8 },                                     -- Light Armor Kit (+8 Armor)
    [1843] = { ARMOR = 40 },                                    -- Rugged Armor Kit (+40 Armor)
    -- TBC Knothide
    [2841] = { STAMINA = 8 },                                   -- Knothide Armor Kit (+8 STA)
    [2793] = { STAMINA = 10 },                                  -- Heavy Knothide Armor Kit (+10 STA)

    -- Magister's Armor Kit
    [2652] = { SPIRIT = 8 },                                    -- Magister's Armor Kit (+8 Spirit) [TBC]
    -- Vindicator's Armor Kit
    [2651] = { DODGE = 8 },                                     -- Vindicator's Armor Kit (+8 Dodge Rating) [TBC]
    -- Core Armor Kit
    -- [1503] already mapped above (Lesser Arcanum of Constitution)

    ---------------------------------------------------------------------------
    -- RESISTANCE HEAD/LEG ENCHANTS (TBC reputation)
    ---------------------------------------------------------------------------

    [3005] = { NATURE_RESIST = 20 },                            -- +20 Nature Resistance (head/leg)
    [3006] = { ARCANE_RESIST = 20 },                            -- +20 Arcane Resistance (head/leg)
    [3007] = { FIRE_RESIST = 20 },                              -- +20 Fire Resistance (head/leg)
    [3008] = { FROST_RESIST = 20 },                             -- +20 Frost Resistance (head/leg)
    [3009] = { SHADOW_RESIST = 20 },                            -- +20 Shadow Resistance (head/leg)

    -- Resistance patches (enchanting, various slots)
    [2984] = { SHADOW_RESIST = 8 },                             -- +8 Shadow Resistance
    [2985] = { FIRE_RESIST = 8 },                               -- +8 Fire Resistance
    [2987] = { FROST_RESIST = 8 },                              -- +8 Frost Resistance
    [2988] = { NATURE_RESIST = 8 },                             -- +8 Nature Resistance
    [2989] = { ARCANE_RESIST = 8 },                             -- +8 Arcane Resistance

    ---------------------------------------------------------------------------
    -- NAXX ENCHANTS — Classic (Undead Slaying)
    ---------------------------------------------------------------------------

    [2684] = { ATTACK_POWER = 100 },                            -- +100 AP vs Undead (Consecrated Sharpening Stone)
    [2685] = { SPELL_POWER = 60 },                              -- +60 SD vs Undead (Blessed Wizard Oil)

    ---------------------------------------------------------------------------
    -- WEAPON OILS — Classic (temporary, but may appear in item links)
    ---------------------------------------------------------------------------

    [2623] = { SPELL_POWER = 8 },                               -- Minor Wizard Oil (+8 SD)
    [2626] = { SPELL_POWER = 16 },                              -- Lesser Wizard Oil (+16 SD)
    [2627] = { SPELL_POWER = 24 },                              -- Wizard Oil (+24 SD)
    [2628] = { SPELL_POWER = 36, CRIT_RATING = 14 },           -- Brilliant Wizard Oil (+36 SD, +1% Spell Crit ≈ 14 Crit)
    [2624] = { MP5 = 4 },                                       -- Minor Mana Oil (+4 MP5)
    [2625] = { MP5 = 8 },                                       -- Lesser Mana Oil (+8 MP5)
    [2629] = { MP5 = 12, HEAL_POWER = 25 },                    -- Brilliant Mana Oil (+12 MP5, +25 Healing)
    [2677] = { SPELL_POWER = 42, CRIT_RATING = 14 },           -- Superior Wizard Oil (+42 SD) [TBC]
    [2678] = { MP5 = 14 },                                      -- Superior Mana Oil (+14 MP5) [TBC]

    ---------------------------------------------------------------------------
    -- MISC ENCHANTS — Classic
    ---------------------------------------------------------------------------

    -- Fishing (no combat value)
    [263]  = {},                                                 -- Fishing Lure (+25 Fishing)
    [264]  = {},                                                 -- Fishing Lure (+50 Fishing)
    [265]  = {},                                                 -- Fishing Lure (+75 Fishing)
    [266]  = {},                                                 -- Fishing Lure (+100 Fishing)

    -- Beast Slaying
    [853]  = {},                                                 -- +6 Beastslaying (niche, not a combat rating)
    [854]  = {},                                                 -- +6 Elemental Slayer

    -- Shadow Oil / Frost Oil (temporary weapon enchants)
    [25]   = {},                                                 -- Shadow Oil
    [26]   = {},                                                 -- Frost Oil

    ---------------------------------------------------------------------------
    -- COMBO ENCHANTS — Classic (head/leg from AQ era and ZG)
    ---------------------------------------------------------------------------

    -- These are multi-stat enchants with unique enchant IDs

    -- Libram combo enchants (from AQ rep vendors / quests)
    [2523] = { HIT_RATING = 10 },                               -- +30 Ranged Hit (Biznicks 247x128 Accurascope)
    [2503] = { DEFENSE = 5 },                                   -- +5 Defense Rating

    -- AQ/ZG-era combo enchants that appear in the 2583-2591 range
    -- (already listed above in ZG class-specific section)

    ---------------------------------------------------------------------------
    -- Additional Classic enchants from Random Suffix items
    -- (These enchant IDs appear on green "of the Bear", "of the Eagle" etc. items
    --  but are intrinsic to the item and handled by GetItemStats, so they are
    --  NOT scored here. Included as empty entries to suppress "unknown enchant" warnings.)
    ---------------------------------------------------------------------------

    -- Common random suffix enchant IDs are in ranges like 66-109, 343-412, 583-592
    -- These are built into the item stats already, no need to add them here.
}
