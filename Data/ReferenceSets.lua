---------------------------------------------------------------------------
-- TrueGearScore Reference Gear Sets
-- Used for calibration: score hypothetical BIS sets to tune color brackets.
-- Each set is a table of { [slotID] = itemID }.
-- Sourced from Wowhead TBC Classic BIS guides (Priest Healer, Warlock Destro,
-- Mage Fire, Paladin Holy/Ret, Shaman Resto/Enh/Ele, Druid Resto/Feral/Balance,
-- Rogue Combat, Hunter BM).
--
-- Slot IDs: 1=Head, 2=Neck, 3=Shoulder, 5=Chest, 6=Waist, 7=Legs,
-- 8=Feet, 9=Wrist, 10=Hands, 11=Finger1, 12=Finger2, 13=Trinket1,
-- 14=Trinket2, 15=Back, 16=MainHand, 17=OffHand, 18=Ranged/Wand
---------------------------------------------------------------------------

local _, addon = ...
addon.ReferenceSets = {

    -- Full ilvl 115 blues: every slot is a heroic dungeon blue drop (no epics)
    -- This represents the "raid-ready with effort" milestone
    PRIEST_HEAL_HEROIC_BLUES = {
        name = "Priest Healer Full Heroic Blues (ilvl 115 rares only)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 28413,  -- Hallowed Crown (Arcatraz)
            [2]  = 28233,  -- Necklace of Resplendent Hope (H Old Hillsbrad)
            [3]  = 27775,  -- Hallowed Pauldrons (Shadow Labyrinth)
            [5]  = 28230,  -- Hallowed Garments (Shadow Labyrinth)
            [6]  = 29250,  -- Cord of Sanctification (H Old Hillsbrad)
            [7]  = 27875,  -- Hallowed Trousers (H Sethekk Halls)
            [8]  = 27411,  -- Slippers of Serenity (Auchenai Crypts)
            [9]  = 29249,  -- Bands of the Benevolent (H Sethekk Halls)
            [10] = 27536,  -- Hallowed Handwraps (H Blood Furnace)
            [11] = 29168,  -- Ancestral Band (Thrallmar Revered)
            [12] = 29322,  -- Keeper's Ring of Piety (Quest)
            [13] = 28190,  -- Scarab of the Infinite Cycle (H Black Morass)
            [14] = 30841,  -- Lower City Prayerbook (Lower City Revered)
            [15] = 28373,  -- Cloak of Scintillating Auras (Steamvault)
            [16] = 27543,  -- Stormcaller (Heroic Underbog — rare 1H mace for healers)
            [17] = 27477,  -- Faol's Signet of Cleansing (H Shattered Halls — offhand)
            [18] = 27885,  -- Soul-Wand of the Aldor (Shadow Labyrinth)
        },
    },

    -- Pre-Raid BIS (heroic dungeons, badge gear, crafted)
    PRIEST_HEAL_PRERAID = {
        name = "Priest Healer Pre-Raid BIS",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 32090,  -- Cowl of Naaru Blessings
            [2]  = 30377,  -- Karja's Medallion
            [3]  = 21874,  -- Primal Mooncloth Shoulders
            [5]  = 21875,  -- Primal Mooncloth Robe
            [6]  = 21873,  -- Primal Mooncloth Belt
            [7]  = 24261,  -- Whitemend Pants
            [8]  = 29251,  -- Boots of the Pious
            [9]  = 29183,  -- Bindings of the Timewalker
            [10] = 27536,  -- Hallowed Handwraps
            [11] = 29373,  -- Band of Halos
            [12] = 29168,  -- Ancestral Band
            [13] = 29376,  -- Essence of the Martyr
            [14] = 21625,  -- Scarab Brooch
            [15] = 29354,  -- Light-Touched Stole of Altruism
            [16] = 23556,  -- Hand of Eternity
            [17] = 29170,  -- Windcaller's Orb
            [18] = 27885,  -- Soul-Wand of the Aldor
        },
    },

    -- Phase 1: Karazhan / Gruul / Mag BIS
    PRIEST_HEAL_P1 = {
        name = "Priest Healer Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 29049,  -- Light-Collar of the Incarnate
            [2]  = 30726,  -- Archaic Charm of Presence
            [3]  = 21874,  -- Primal Mooncloth Shoulders
            [5]  = 21875,  -- Primal Mooncloth Robe
            [6]  = 21873,  -- Primal Mooncloth Belt
            [7]  = 30727,  -- Gilded Trousers of Benediction
            [8]  = 28663,  -- Boots of the Incorrupt
            [9]  = 29183,  -- Bindings of the Timewalker
            [10] = 28508,  -- Gloves of Saintly Blessings
            [11] = 30736,  -- Ring of Flowing Light
            [12] = 29290,  -- Violet Signet of the Grand Restorer
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28823,  -- Eye of Gruul
            [15] = 28765,  -- Stainless Cloak of the Pure Hearted
            [16] = 28771,  -- Light's Justice
            [17] = 29170,  -- Windcaller's Orb
            [18] = 28588,  -- Blue Diamond Witchwand
        },
    },

    -- Phase 2: SSC / TK BIS
    PRIEST_HEAL_P2 = {
        name = "Priest Healer Phase 2 BIS (SSC/TK)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 30152,  -- Cowl of the Avatar
            [2]  = 30018,  -- Lord Sanguinar's Claim
            [3]  = 30154,  -- Mantle of the Avatar
            [5]  = 30150,  -- Vestments of the Avatar
            [6]  = 30036,  -- Belt of the Long Road
            [7]  = 30153,  -- Breeches of the Avatar
            [8]  = 30100,  -- Soul-Strider Boots
            [9]  = 32980,  -- Veteran's Mooncloth Cuffs
            [10] = 30151,  -- Gloves of the Avatar
            [11] = 30110,  -- Coral Band of the Revived
            [12] = 29290,  -- Violet Signet of the Grand Restorer
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28823,  -- Eye of Gruul
            [15] = 29989,  -- Sunshower Light Cloak
            [16] = 30108,  -- Lightfathom Scepter
            [17] = 29923,  -- Talisman of the Sun King
            [18] = 30080,  -- Luminescent Rod of the Naaru
        },
    },

    -- Phase 3: BT / Hyjal BIS
    PRIEST_HEAL_P3 = {
        name = "Priest Healer Phase 3 BIS (BT/Hyjal)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 31063,  -- Cowl of Absolution
            [2]  = 32370,  -- Nadina's Pendant of Purity
            [3]  = 31069,  -- Mantle of Absolution
            [5]  = 31066,  -- Vestments of Absolution
            [6]  = 30895,  -- Angelista's Sash
            [7]  = 30912,  -- Leggings of Eternity
            [8]  = 32609,  -- Boots of the Divine Light
            [9]  = 32584,  -- Swiftheal Wraps
            [10] = 31060,  -- Gloves of Absolution
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 29309,  -- Band of the Eternal Restorer
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28823,  -- Eye of Gruul
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32500,  -- Crystal Spire of Karabor
            [17] = 30911,  -- Scepter of Purification
            [18] = 32363,  -- Naaru-Blessed Life Rod
        },
    },

    -- Phase 4: ZA BIS
    PRIEST_HEAL_P4 = {
        name = "Priest Healer Phase 4 BIS (ZA)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 31063,  -- Cowl of Absolution
            [2]  = 33281,  -- Brooch of Nature's Mercy
            [3]  = 31069,  -- Mantle of Absolution
            [5]  = 31066,  -- Vestments of Absolution
            [6]  = 30895,  -- Angelista's Sash
            [7]  = 33585,  -- Achromic Trousers of the Naaru
            [8]  = 32609,  -- Boots of the Divine Light
            [9]  = 32584,  -- Swiftheal Wraps
            [10] = 31060,  -- Gloves of Absolution
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 33498,  -- Signet of the Quiet Forest
            [13] = 29376,  -- Essence of the Martyr
            [14] = 19288,  -- Darkmoon Card: Blue Dragon
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32500,  -- Crystal Spire of Karabor
            [17] = 30911,  -- Scepter of Purification
            [18] = 32363,  -- Naaru-Blessed Life Rod
        },
    },

    -- Phase 5: Sunwell BIS
    PRIEST_HEAL_P5 = {
        name = "Priest Healer Phase 5 BIS (Sunwell)",
        spec = "PRIEST_DISC",
        items = {
            [1]  = 34339,  -- Cowl of Light's Purity
            [2]  = 33281,  -- Brooch of Nature's Mercy
            [3]  = 34202,  -- Shawl of Wonderment
            [5]  = 34233,  -- Robes of Faltered Light
            [6]  = 34527,  -- Belt of Absolution
            [7]  = 34170,  -- Pantaloons of Calming Strife
            [8]  = 34562,  -- Boots of Absolution
            [9]  = 34435,  -- Cuffs of Absolution
            [10] = 34342,  -- Handguards of the Dawn
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 34363,  -- Ring of Flowing Life
            [13] = 29376,  -- Essence of the Martyr
            [14] = 19288,  -- Darkmoon Card: Blue Dragon
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 34335,  -- Hammer of Sanctification
            [17] = 34206,  -- Book of Highborne Hymns
            [18] = 34348,  -- Wand of Cleansing Light
        },
    },

    ---------------------------------------------------------------------------
    -- Warlock (Destruction) — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    WARLOCK_DESTRO_PRERAID = {
        name = "Warlock Destro Pre-Raid BIS",
        spec = "WARLOCK_DESTRO",
        items = {
            [1]  = 24266,  -- Spellstrike Hood
            [2]  = 28134,  -- Brooch of Heightened Potential
            [3]  = 21869,  -- Frozen Shadoweave Shoulders
            [5]  = 21871,  -- Frozen Shadoweave Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 21870,  -- Frozen Shadoweave Boots
            [9]  = 21186,  -- Rockfury Bracers
            [10] = 21847,  -- Spellfire Gloves
            [11] = 29172,  -- Ashyen's Gift
            [12] = 28227,  -- Sparking Arcanite Ring
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 23050,  -- Cloak of the Necropolis
            [16] = 31336,  -- Blade of Wizardry
            [17] = 29270,  -- Flametongue Seal
            [18] = 22128,  -- Master Firestone
        },
    },

    WARLOCK_DESTRO_P1 = {
        name = "Warlock Destro Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "WARLOCK_DESTRO",
        items = {
            [1]  = 28963,  -- Voidheart Crown
            [2]  = 28530,  -- Brooch of Unquenchable Fury
            [3]  = 28967,  -- Voidheart Mantle
            [5]  = 28964,  -- Voidheart Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 21870,  -- Frozen Shadoweave Boots
            [9]  = 24250,  -- Bracers of Havok
            [10] = 21847,  -- Spellfire Gloves
            [11] = 28793,  -- Band of Crimson Fury
            [12] = 29172,  -- Ashyen's Gift
            [13] = 27683,  -- Quagmirran's Eye
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 28766,  -- Ruby Drape of the Mysticant
            [16] = 28770,  -- Nathrezim Mindblade
            [17] = 29270,  -- Flametongue Seal
            [18] = 28673,  -- Tirisfal Wand of Ascendancy
        },
    },

    WARLOCK_DESTRO_P2 = {
        name = "Warlock Destro Phase 2 BIS (SSC/TK)",
        spec = "WARLOCK_DESTRO",
        items = {
            [1]  = 32494,  -- Destruction Holo-gogs
            [2]  = 24116,  -- Eye of the Night
            [3]  = 28967,  -- Voidheart Mantle
            [5]  = 30107,  -- Vestments of the Sea-Witch
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 30213,  -- Leggings of the Corruptor
            [8]  = 30037,  -- Boots of Blasting
            [9]  = 29918,  -- Mindstorm Wristbands
            [10] = 28968,  -- Voidheart Gloves
            [11] = 30109,  -- Ring of Endless Coils
            [12] = 29302,  -- Band of Eternity
            [13] = 27683,  -- Quagmirran's Eye
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 28766,  -- Ruby Drape of the Mysticant
            [16] = 32053,  -- Merciless Gladiator's Spellblade
            [17] = 30049,  -- Fathomstone
            [18] = 29982,  -- Wand of the Forgotten Star
        },
    },

    WARLOCK_DESTRO_P3 = {
        name = "Warlock Destro Phase 3 BIS (BT/Hyjal)",
        spec = "WARLOCK_DESTRO",
        items = {
            [1]  = 31051,  -- Hood of the Malefic
            [2]  = 32349,  -- Translucent Spellthread Necklace
            [3]  = 31054,  -- Mantle of the Malefic
            [5]  = 30107,  -- Vestments of the Sea-Witch
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 30916,  -- Leggings of Channeled Elements
            [8]  = 32239,  -- Slippers of the Seacaller
            [9]  = 32586,  -- Bracers of Nimble Thought
            [10] = 31050,  -- Gloves of the Malefic
            [11] = 32527,  -- Ring of Ancient Knowledge
            [12] = 32247,  -- Ring of Captured Storms
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 32590,  -- Nethervoid Cloak
            [16] = 32374,  -- Zhar'doom, Greatstaff of the Devourer
            [17] = 30872,  -- Chronicle of Dark Secrets
            [18] = 32343,  -- Wand of Prismatic Focus
        },
    },

    WARLOCK_DESTRO_P5 = {
        name = "Warlock Destro Phase 5 BIS (Sunwell)",
        spec = "WARLOCK_DESTRO",
        items = {
            [1]  = 34340,  -- Dark Conjuror's Collar
            [2]  = 34678,  -- Shattered Sun Pendant of Acumen
            [3]  = 34210,  -- Amice of the Convoker
            [5]  = 34364,  -- Sunfire Robe
            [6]  = 34541,  -- Belt of the Malefic
            [7]  = 34181,  -- Leggings of Calamity
            [8]  = 34564,  -- Boots of the Malefic
            [9]  = 34436,  -- Bracers of the Malefic
            [10] = 34344,  -- Handguards of Defiled Worlds
            [11] = 34362,  -- Loop of Forged Power
            [12] = 34230,  -- Ring of Omnipotence
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 34429,  -- Shifting Naaru Sliver
            [15] = 34242,  -- Tattered Cape of Antonidas
            [16] = 34182,  -- Grand Magister's Staff of Torrents
            [17] = 34179,  -- Heart of the Pit
            [18] = 34347,  -- Wand of the Demonsoul
        },
    },

    ---------------------------------------------------------------------------
    -- Mage (Fire) — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    MAGE_FIRE_PRERAID = {
        name = "Mage Fire Pre-Raid BIS",
        spec = "MAGE_FIRE",
        items = {
            [1]  = 28193,  -- Mana-Etched Crown
            [2]  = 28134,  -- Brooch of Heightened Potential
            [3]  = 27796,  -- Mana-Etched Spaulders
            [5]  = 21848,  -- Spellfire Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 28406,  -- Sigil-Laced Boots
            [9]  = 28411,  -- General's Silk Cuffs
            [10] = 21847,  -- Spellfire Gloves
            [11] = 28555,  -- Seal of the Exorcist
            [12] = 29367,  -- Ring of Cryptic Dreams
            [13] = 27683,  -- Quagmirran's Eye
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 23050,  -- Cloak of the Necropolis
            [16] = 23554,  -- Eternium Runed Blade
            [17] = 29270,  -- Flametongue Seal
            [18] = 28386,  -- Nether Core's Control Rod
        },
    },

    MAGE_FIRE_P1 = {
        name = "Mage Fire Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "MAGE_FIRE",
        items = {
            [1]  = 29076,  -- Collar of the Aldor
            [2]  = 28530,  -- Brooch of Unquenchable Fury
            [3]  = 29079,  -- Pauldrons of the Aldor
            [5]  = 21848,  -- Spellfire Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 28585,  -- Ruby Slippers
            [9]  = 28515,  -- Bands of Nefarious Deeds
            [10] = 21847,  -- Spellfire Gloves
            [11] = 28793,  -- Band of Crimson Fury
            [12] = 29287,  -- Violet Signet of the Archmage
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 28766,  -- Ruby Drape of the Mysticant
            [16] = 28802,  -- Bloodmaw Magus-Blade
            [17] = 28781,  -- Karaborian Talisman
            [18] = 28783,  -- Eredar Wand of Obliteration
        },
    },

    MAGE_FIRE_P2 = {
        name = "Mage Fire Phase 2 BIS (SSC/TK)",
        spec = "MAGE_FIRE",
        items = {
            [1]  = 32494,  -- Destruction Holo-gogs
            [2]  = 30015,  -- The Sun King's Talisman
            [3]  = 30024,  -- Mantle of the Elven Kings
            [5]  = 30107,  -- Vestments of the Sea-Witch
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 30207,  -- Leggings of Tirisfal
            [8]  = 30037,  -- Boots of Blasting
            [9]  = 29918,  -- Mindstorm Wristbands
            [10] = 29987,  -- Gauntlets of the Sun King
            [11] = 29302,  -- Band of Eternity
            [12] = 29922,  -- Band of Al'ar
            [13] = 27683,  -- Quagmirran's Eye
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 28766,  -- Ruby Drape of the Mysticant
            [16] = 29988,  -- The Nexus Key
            [17] = 30049,  -- Fathomstone
            [18] = 29982,  -- Wand of the Forgotten Star
        },
    },

    MAGE_FIRE_P3 = {
        name = "Mage Fire Phase 3 BIS (BT/Hyjal)",
        spec = "MAGE_FIRE",
        items = {
            [1]  = 32525,  -- Cowl of the Illidari High Lord
            [2]  = 32589,  -- Hellfire-Encased Pendant
            [3]  = 31059,  -- Mantle of the Tempest
            [5]  = 31057,  -- Robes of the Tempest
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 31058,  -- Leggings of the Tempest
            [8]  = 32239,  -- Slippers of the Seacaller
            [9]  = 32586,  -- Bracers of Nimble Thought
            [10] = 31055,  -- Gloves of the Tempest
            [11] = 32527,  -- Ring of Ancient Knowledge
            [12] = 32247,  -- Ring of Captured Storms
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 30720,  -- Serpent-Coil Braid
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32374,  -- Zhar'doom, Greatstaff of the Devourer
            [17] = 30872,  -- Chronicle of Dark Secrets
            [18] = 29982,  -- Wand of the Forgotten Star
        },
    },

    MAGE_FIRE_P5 = {
        name = "Mage Fire Phase 5 BIS (Sunwell)",
        spec = "MAGE_FIRE",
        items = {
            [1]  = 34340,  -- Dark Conjuror's Collar
            [2]  = 34204,  -- Amulet of Unfettered Magics
            [3]  = 31059,  -- Mantle of the Tempest
            [5]  = 34364,  -- Sunfire Robe
            [6]  = 34557,  -- Belt of the Tempest
            [7]  = 34181,  -- Leggings of Calamity
            [8]  = 34574,  -- Boots of the Tempest
            [9]  = 34447,  -- Bracers of the Tempest
            [10] = 34344,  -- Handguards of Defiled Worlds
            [11] = 34362,  -- Loop of Forged Power
            [12] = 33497,  -- Mana Attuned Band
            [13] = 34429,  -- Shifting Naaru Sliver
            [14] = 32483,  -- The Skull of Gul'dan
            [15] = 34242,  -- Tattered Cape of Antonidas
            [16] = 34336,  -- Sunflare
            [17] = 34179,  -- Heart of the Pit
            [18] = 34347,  -- Wand of the Demonsoul
        },
    },

    ---------------------------------------------------------------------------
    -- Warrior Fury DPS — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    -- Pre-Raid BIS (heroics, badge gear, crafted, world drops)
    WARRIOR_FURY_PRERAID = {
        name = "Warrior Fury Pre-Raid BIS",
        spec = "WARRIOR_FURY",
        items = {
            [1]  = 32087,  -- Mask of the Deceiver
            [2]  = 29349,  -- Adamantine Chain of the Unbroken
            [3]  = 33173,  -- Ragesteel Shoulders
            [5]  = 31320,  -- Chestguard of Exile
            [6]  = 27985,  -- Deathforge Girdle
            [7]  = 30538,  -- Midnight Legguards
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 23537,  -- Black Felsteel Bracers
            [10] = 25685,  -- Fel Leather Gloves
            [11] = 29379,  -- Ring of Arathi Warlords
            [12] = 30834,  -- Shapeshifter's Signet
            [13] = 21670,  -- Badge of the Swarmguard
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28438,  -- Dragonmaw
            [17] = 31332,  -- Blinkstrike
            [18] = 30279,  -- Mama's Insurance
        },
    },

    -- Phase 1: Karazhan / Gruul / Mag BIS
    WARRIOR_FURY_P1 = {
        name = "Warrior Fury Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "WARRIOR_FURY",
        items = {
            [1]  = 29021,  -- Warbringer Battle-Helm
            [2]  = 29349,  -- Adamantine Chain of the Unbroken
            [3]  = 30740,  -- Ripfiend Shoulderplates
            [5]  = 30730,  -- Terrorweave Tunic
            [6]  = 28779,  -- Girdle of the Endless Pit
            [7]  = 30739,  -- Scaled Greaves of the Marksman
            [8]  = 28608,  -- Ironstriders of Urgency
            [9]  = 28795,  -- Bladespire Warbands
            [10] = 28824,  -- Gauntlets of Martial Perfection
            [11] = 30738,  -- Ring of Reciprocity
            [12] = 28757,  -- Ring of a Thousand Marks
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 21670,  -- Badge of the Swarmguard
            [15] = 30729,  -- Black-Iron Battlecloak
            [16] = 28438,  -- Dragonmaw
            [17] = 28295,  -- Gladiator's Slicer
            [18] = 30724,  -- Barrel-Blade Longrifle
        },
    },

    -- Phase 2: SSC / TK BIS
    WARRIOR_FURY_P2 = {
        name = "Warrior Fury Phase 2 BIS (SSC/TK)",
        spec = "WARRIOR_FURY",
        items = {
            [1]  = 30120,  -- Destroyer Battle-Helm
            [2]  = 30022,  -- Pendant of the Perilous
            [3]  = 30122,  -- Destroyer Shoulderblades
            [5]  = 30118,  -- Destroyer Breastplate
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 29995,  -- Leggings of Murderous Intent
            [8]  = 30081,  -- Warboots of Obliteration
            [9]  = 30057,  -- Bracers of Eradication
            [10] = 30119,  -- Destroyer Gauntlets
            [11] = 29997,  -- Band of the Ranger-General
            [12] = 30738,  -- Ring of Reciprocity
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 21670,  -- Badge of the Swarmguard
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28439,  -- Dragonstrike
            [17] = 30082,  -- Talon of Azshara
            [18] = 30105,  -- Serpent Spine Longbow
        },
    },

    -- Phase 3: BT / Hyjal BIS
    WARRIOR_FURY_P3 = {
        name = "Warrior Fury Phase 3 BIS (BT/Hyjal)",
        spec = "WARRIOR_FURY",
        items = {
            [1]  = 32235,  -- Cursed Vision of Sargeras
            [2]  = 32260,  -- Choker of Endless Nightmares
            [3]  = 30979,  -- Onslaught Shoulderblades
            [5]  = 30975,  -- Onslaught Breastplate
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 32341,  -- Leggings of Divine Retribution
            [8]  = 32345,  -- Dreadboots of the Legion
            [9]  = 30863,  -- Deadly Cuffs
            [10] = 32278,  -- Grips of Silent Justice
            [11] = 32497,  -- Stormrage Signet Ring
            [12] = 32335,  -- Unstoppable Aggressor's Ring
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 32505,  -- Madness of the Betrayer
            [15] = 32323,  -- Shadowmoon Destroyer's Drape
            [16] = 32837,  -- Warglaive of Azzinoth
            [17] = 32838,  -- Warglaive of Azzinoth (OH)
            [18] = 32326,  -- Twisted Blades of Zarak
        },
    },

    -- Phase 5: Sunwell BIS
    WARRIOR_FURY_P5 = {
        name = "Warrior Fury Phase 5 BIS (Sunwell)",
        spec = "WARRIOR_FURY",
        items = {
            [1]  = 34333,  -- Coif of Alleria
            [2]  = 34358,  -- Hard Khorium Choker
            [3]  = 34388,  -- Pauldrons of Berserking
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34546,  -- Onslaught Belt
            [7]  = 34180,  -- Felfury Legplates
            [8]  = 34569,  -- Onslaught Treads
            [9]  = 34441,  -- Onslaught Bracers
            [10] = 34343,  -- Thalassian Ranger Gauntlets
            [11] = 34189,  -- Band of Ruinous Delight
            [12] = 34361,  -- Hard Khorium Band
            [13] = 34427,  -- Blackened Naaru Sliver
            [14] = 34472,  -- Shard of Contempt
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 32837,  -- Warglaive of Azzinoth
            [17] = 32838,  -- Warglaive of Azzinoth (OH)
            [18] = 34196,  -- Golden Bow of Quel'Thalas
        },
    },

    ---------------------------------------------------------------------------
    -- Warrior Protection Tank — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    -- Pre-Raid BIS (heroics, badge gear, crafted, rep)
    WARRIOR_PROT_PRERAID = {
        name = "Warrior Prot Pre-Raid BIS",
        spec = "WARRIOR_PROT",
        items = {
            [1]  = 28180,  -- Myrmidon's Headdress
            [2]  = 29386,  -- Necklace of the Juggernaut
            [3]  = 32073,  -- Spaulders of Dementia
            [5]  = 28205,  -- Breastplate of the Bold
            [6]  = 28995,  -- Marshal's Plate Belt
            [7]  = 29184,  -- Timewarden's Leggings
            [8]  = 28997,  -- Marshal's Plate Greaves
            [9]  = 28996,  -- Marshal's Plate Bracers
            [10] = 27475,  -- Gauntlets of the Bold
            [11] = 29384,  -- Ring of Unyielding Force
            [12] = 28553,  -- Band of the Exorcist
            [13] = 29387,  -- Gnomeregan Auto-Blocker 600
            [14] = 19406,  -- Drake Fang Talisman
            [15] = 27804,  -- Devilshark Cape
            [16] = 29362,  -- The Sun Eater
            [17] = 29176,  -- Crest of the Sha'tar
            [18] = 27817,  -- Starbolt Longbow
        },
    },

    -- Phase 1: Karazhan / Gruul / Mag BIS
    WARRIOR_PROT_P1 = {
        name = "Warrior Prot Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "WARRIOR_PROT",
        items = {
            [1]  = 29011,  -- Warbringer Greathelm
            [2]  = 29386,  -- Necklace of the Juggernaut
            [3]  = 29023,  -- Warbringer Shoulderplates
            [5]  = 29012,  -- Warbringer Chestguard
            [6]  = 28995,  -- Marshal's Plate Belt
            [7]  = 28621,  -- Wrynn Dynasty Greaves
            [8]  = 28997,  -- Marshal's Plate Greaves
            [9]  = 28502,  -- Vambraces of Courage
            [10] = 30741,  -- Topaz-Studded Battlegrips
            [11] = 29279,  -- Violet Signet of the Great Protector
            [12] = 30834,  -- Shapeshifter's Signet
            [13] = 23836,  -- Goblin Rocket Launcher
            [14] = 29387,  -- Gnomeregan Auto-Blocker 600
            [15] = 28672,  -- Drape of the Dark Reavers
            [16] = 28438,  -- Dragonmaw
            [17] = 28825,  -- Aldori Legacy Defender
            [18] = 30724,  -- Barrel-Blade Longrifle
        },
    },

    -- Phase 2: SSC / TK BIS
    WARRIOR_PROT_P2 = {
        name = "Warrior Prot Phase 2 BIS (SSC/TK)",
        spec = "WARRIOR_PROT",
        items = {
            [1]  = 32473,  -- Tankatronic Goggles
            [2]  = 30099,  -- Frayed Tether of the Drowned
            [3]  = 30117,  -- Destroyer Shoulderguards
            [5]  = 30113,  -- Destroyer Chestguard
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 30116,  -- Destroyer Legguards
            [8]  = 32793,  -- Veteran's Plate Greaves
            [9]  = 32818,  -- Veteran's Plate Bracers
            [10] = 30114,  -- Destroyer Handguards
            [11] = 29294,  -- Band of Eternity
            [12] = 30834,  -- Shapeshifter's Signet
            [13] = 23836,  -- Goblin Rocket Launcher
            [14] = 23835,  -- Gnomish Poultryizer
            [15] = 28529,  -- Royal Cloak of Arathi Kings
            [16] = 30058,  -- Mallet of the Tides
            [17] = 28825,  -- Aldori Legacy Defender
            [18] = 32756,  -- Gyro-Balanced Khorium Destroyer
        },
    },

    -- Phase 3: BT / Hyjal BIS
    WARRIOR_PROT_P3 = {
        name = "Warrior Prot Phase 3 BIS (BT/Hyjal)",
        spec = "WARRIOR_PROT",
        items = {
            [1]  = 32521,  -- Faceplate of the Impenetrable
            [2]  = 32362,  -- Pendant of Titans
            [3]  = 33732,  -- Vengeful Gladiator's Plate Shoulders
            [5]  = 33728,  -- Vengeful Gladiator's Plate Chestpiece
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 33731,  -- Vengeful Gladiator's Plate Legguards
            [8]  = 33812,  -- Vindicator's Plate Greaves
            [9]  = 33813,  -- Vindicator's Plate Bracers
            [10] = 32280,  -- Gauntlets of Enforcement
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 32266,  -- Ring of Deceitful Intent
            [13] = 31858,  -- Darkmoon Card: Vengeance
            [14] = 37127,  -- Brightbrew Charm
            [15] = 34010,  -- Pepe's Shroud of Pacification
            [16] = 32254,  -- The Brutalizer
            [17] = 32375,  -- Bulwark of Azzinoth
            [18] = 32253,  -- Legionkiller
        },
    },

    -- Phase 5: Sunwell BIS
    WARRIOR_PROT_P5 = {
        name = "Warrior Prot Phase 5 BIS (Sunwell)",
        spec = "WARRIOR_PROT",
        items = {
            [1]  = 34400,  -- Crown of Dath'Remar
            [2]  = 34178,  -- Collar of the Pit Lord
            [3]  = 35070,  -- Brutal Gladiator's Plate Shoulders
            [5]  = 35066,  -- Brutal Gladiator's Plate Chestpiece
            [6]  = 34547,  -- Onslaught Waistguard
            [7]  = 34381,  -- Felstrength Legplates
            [8]  = 34568,  -- Onslaught Boots
            [9]  = 34442,  -- Onslaught Wristguards
            [10] = 32280,  -- Gauntlets of Enforcement
            [11] = 34213,  -- Ring of Hardened Resolve
            [12] = 34888,  -- Ring of the Stalwart Protector
            [13] = 34473,  -- Commendation of Kael'thas
            [14] = 33830,  -- Ancient Aqir Artifact
            [15] = 34190,  -- Crimson Paragon's Cover
            [16] = 34164,  -- Dragonscale-Encrusted Longblade
            [17] = 32375,  -- Bulwark of Azzinoth
            [18] = 32253,  -- Legionkiller
        },
    },

    ---------------------------------------------------------------------------
    -- Rogue (Combat) — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    ROGUE_COMBAT_PRERAID = {
        name = "Rogue Combat Pre-Raid BIS",
        spec = "ROGUE_COMBAT",
        items = {
            [1]  = 28224,  -- Wastewalker Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 27797,  -- Wastewalker Shoulderpads
            [5]  = 28264,  -- Wastewalker Tunic
            [6]  = 29247,  -- Girdle of the Deathdealer
            [7]  = 27837,  -- Wastewalker Leggings
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 29246,  -- Nightfall Wristguards
            [10] = 25685,  -- Fel Leather Gloves
            [11] = 31920,  -- Shaffar's Band of Brutality
            [12] = 30834,  -- Shapeshifter's Signet
            [13] = 23206,  -- Mark of the Champion
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28438,  -- Dragonmaw
            [17] = 28189,  -- Latro's Shifting Sword
            [18] = 29152,  -- Marksman's Bow
        },
    },

    ROGUE_COMBAT_P1 = {
        name = "Rogue Combat Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "ROGUE_COMBAT",
        items = {
            [1]  = 29044,  -- Netherblade Facemask
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 27797,  -- Wastewalker Shoulderpads
            [5]  = 29045,  -- Netherblade Chestpiece
            [6]  = 29247,  -- Girdle of the Deathdealer
            [7]  = 28741,  -- Skulker's Greaves
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29246,  -- Nightfall Wristguards
            [10] = 27531,  -- Wastewalker Gloves
            [11] = 28757,  -- Ring of a Thousand Marks
            [12] = 28649,  -- Garona's Signet Ring
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 23206,  -- Mark of the Champion
            [15] = 28672,  -- Drape of the Dark Reavers
            [16] = 28438,  -- Dragonmaw
            [17] = 28307,  -- Gladiator's Quickblade
            [18] = 29152,  -- Marksman's Bow
        },
    },

    ROGUE_COMBAT_P2 = {
        name = "Rogue Combat Phase 2 BIS (SSC/TK)",
        spec = "ROGUE_COMBAT",
        items = {
            [1]  = 30146,  -- Deathmantle Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 30149,  -- Deathmantle Shoulderpads
            [5]  = 30101,  -- Bloodsea Brigand's Vest
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 30148,  -- Deathmantle Legguards
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29966,  -- Vambraces of Ending
            [10] = 30145,  -- Deathmantle Handguards
            [11] = 30052,  -- Ring of Lethality
            [12] = 29997,  -- Band of the Ranger-General
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 30450,  -- Warp-Spring Coil
            [15] = 28672,  -- Drape of the Dark Reavers
            [16] = 30082,  -- Talon of Azshara
            [17] = 32027,  -- Merciless Gladiator's Quickblade
            [18] = 29949,  -- Arcanite Steam-Pistol
        },
    },

    ROGUE_COMBAT_P3 = {
        name = "Rogue Combat Phase 3 BIS (BT/Hyjal)",
        spec = "ROGUE_COMBAT",
        items = {
            [1]  = 32235,  -- Cursed Vision of Sargeras
            [2]  = 32260,  -- Choker of Endless Nightmares
            [3]  = 31030,  -- Slayer's Shoulderpads
            [5]  = 31028,  -- Slayer's Chestguard
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 31029,  -- Slayer's Legguards
            [8]  = 32366,  -- Shadowmaster's Boots
            [9]  = 32324,  -- Insidious Bands
            [10] = 31026,  -- Slayer's Handguards
            [11] = 32497,  -- Stormrage Signet Ring
            [12] = 29301,  -- Band of the Eternal Champion
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 30450,  -- Warp-Spring Coil
            [15] = 32323,  -- Shadowmoon Destroyer's Drape
            [16] = 32837,  -- Warglaive of Azzinoth (MH)
            [17] = 32838,  -- Warglaive of Azzinoth (OH)
            [18] = 29949,  -- Arcanite Steam-Pistol
        },
    },

    ROGUE_COMBAT_P5 = {
        name = "Rogue Combat Phase 5 BIS (Sunwell)",
        spec = "ROGUE_COMBAT",
        items = {
            [1]  = 34244,  -- Duplicitous Guise
            [2]  = 34358,  -- Hard Khorium Choker
            [3]  = 31030,  -- Slayer's Shoulderpads
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34558,  -- Slayer's Belt
            [7]  = 34188,  -- Leggings of the Immortal Night
            [8]  = 34575,  -- Slayer's Boots
            [9]  = 34448,  -- Slayer's Bracers
            [10] = 34370,  -- Gloves of Immortal Dusk
            [11] = 32497,  -- Stormrage Signet Ring
            [12] = 34189,  -- Band of Ruinous Delight
            [13] = 34427,  -- Blackened Naaru Sliver
            [14] = 28830,  -- Dragonspine Trophy
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 32837,  -- Warglaive of Azzinoth (MH)
            [17] = 32838,  -- Warglaive of Azzinoth (OH)
            [18] = 34196,  -- Golden Bow of Quel'Thalas
        },
    },

    ---------------------------------------------------------------------------
    -- Hunter (Beast Mastery) — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    HUNTER_BM_PRERAID = {
        name = "Hunter BM Pre-Raid BIS",
        spec = "HUNTER_BM",
        items = {
            [1]  = 28275,  -- Beast Lord Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 27801,  -- Beast Lord Mantle
            [5]  = 28228,  -- Beast Lord Cuirass
            [6]  = 29526,  -- Primalstrike Belt
            [7]  = 27874,  -- Beast Lord Leggings
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 29527,  -- Primalstrike Bracers
            [10] = 27474,  -- Beast Lord Handguards
            [11] = 30860,  -- Kaylaan's Signet
            [12] = 31077,  -- Slayer's Mark of the Redemption
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28288,  -- Abacus of Violent Odds
            [15] = 24259,  -- Vengeance Wrap
            [16] = 27846,  -- Claw of the Watcher
            [17] = 28315,  -- Stormreaver Warblades
            [18] = 29351,  -- Wrathtide Longbow
        },
    },

    HUNTER_BM_P1 = {
        name = "Hunter BM Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "HUNTER_BM",
        items = {
            [1]  = 28275,  -- Beast Lord Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 27801,  -- Beast Lord Mantle
            [5]  = 28228,  -- Beast Lord Cuirass
            [6]  = 28828,  -- Gronn-Stitched Girdle
            [7]  = 30739,  -- Scaled Greaves of the Marksman
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29246,  -- Nightfall Wristguards
            [10] = 27474,  -- Beast Lord Handguards
            [11] = 28791,  -- Ring of the Recalcitrant
            [12] = 28757,  -- Ring of a Thousand Marks
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 27846,  -- Claw of the Watcher
            [17] = 28572,  -- Blade of the Unrequited
            [18] = 28772,  -- Sunfury Bow of the Phoenix
        },
    },

    HUNTER_BM_P2 = {
        name = "Hunter BM Phase 2 BIS (SSC/TK)",
        spec = "HUNTER_BM",
        items = {
            [1]  = 30141,  -- Rift Stalker Helm
            [2]  = 30017,  -- Telonicus's Pendant of Mayhem
            [3]  = 30143,  -- Rift Stalker Mantle
            [5]  = 30139,  -- Rift Stalker Hauberk
            [6]  = 30040,  -- Belt of Deep Shadow
            [7]  = 29995,  -- Leggings of Murderous Intent
            [8]  = 30104,  -- Cobra-Lash Boots
            [9]  = 29966,  -- Vambraces of Ending
            [10] = 30140,  -- Rift Stalker Gauntlets
            [11] = 29997,  -- Band of the Ranger-General
            [12] = 30052,  -- Ring of Lethality
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 29994,  -- Thalassian Wildercloak
            [16] = 29948,  -- Claw of the Phoenix
            [17] = 32944,  -- Talon of the Phoenix
            [18] = 30318,  -- Netherstrand Longbow
        },
    },

    HUNTER_BM_P3 = {
        name = "Hunter BM Phase 3 BIS (BT/Hyjal)",
        spec = "HUNTER_BM",
        items = {
            [1]  = 31003,  -- Gronnstalker's Helmet
            [2]  = 32260,  -- Choker of Endless Nightmares
            [3]  = 31006,  -- Gronnstalker's Spaulders
            [5]  = 31004,  -- Gronnstalker's Chestguard
            [6]  = 32346,  -- Boneweave Girdle
            [7]  = 31005,  -- Gronnstalker's Leggings
            [8]  = 32510,  -- Softstep Boots of Tracking
            [9]  = 32324,  -- Insidious Bands
            [10] = 31001,  -- Gronnstalker's Gloves
            [11] = 29301,  -- Band of the Eternal Champion
            [12] = 29997,  -- Band of the Ranger-General
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28830,  -- Dragonspine Trophy
            [15] = 29994,  -- Thalassian Wildercloak
            [16] = 32248,  -- Halberd of Desolation
            [17] = 32946,  -- Claw of Molten Fury
            [18] = 32336,  -- Black Bow of the Betrayer
        },
    },

    HUNTER_BM_P5 = {
        name = "Hunter BM Phase 5 BIS (Sunwell)",
        spec = "HUNTER_BM",
        items = {
            [1]  = 34333,  -- Coif of Alleria
            [2]  = 34358,  -- Hard Khorium Choker
            [3]  = 31006,  -- Gronnstalker's Spaulders
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34549,  -- Gronnstalker's Belt
            [7]  = 34188,  -- Leggings of the Immortal Night
            [8]  = 34570,  -- Gronnstalker's Boots
            [9]  = 34443,  -- Gronnstalker's Bracers
            [10] = 34370,  -- Gloves of Immortal Dusk
            [11] = 34189,  -- Band of Ruinous Delight
            [12] = 34361,  -- Hard Khorium Band
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 34427,  -- Blackened Naaru Sliver
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 34331,  -- Hand of the Deceiver
            [17] = 34893,  -- Vanir's Right Fist of Brutality
            [18] = 34334,  -- Thori'dal, the Stars' Fury
        },
    },

    ---------------------------------------------------------------------------
    -- Druid Restoration Healer — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    DRUID_RESTO_PRERAID = {
        name = "Druid Resto Pre-Raid BIS",
        spec = "DRUID_RESTO",
        items = {
            [1]  = 24264,  -- Whitemend Hood
            [2]  = 30377,  -- Karja's Medallion
            [3]  = 21874,  -- Primal Mooncloth Shoulders
            [5]  = 21875,  -- Primal Mooncloth Robe
            [6]  = 21873,  -- Primal Mooncloth Belt
            [7]  = 24261,  -- Whitemend Pants
            [8]  = 27411,  -- Slippers of Serenity
            [9]  = 29183,  -- Bindings of the Timewalker
            [10] = 29506,  -- Gloves of the Living Touch
            [11] = 27780,  -- Ring of Fabled Hope
            [12] = 31383,  -- Spiritualist's Mark of the Sha'tar
            [13] = 29376,  -- Essence of the Martyr
            [14] = 30841,  -- Lower City Prayerbook
            [15] = 31329,  -- Lifegiving Cloak
            [16] = 29133,  -- Seer's Cane
            [17] = 29170,  -- Windcaller's Orb
            [18] = 27886,  -- Idol of the Emerald Queen
        },
    },

    DRUID_RESTO_P1 = {
        name = "Druid Resto Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "DRUID_RESTO",
        items = {
            [1]  = 24264,  -- Whitemend Hood
            [2]  = 30726,  -- Archaic Charm of Presence
            [3]  = 21874,  -- Primal Mooncloth Shoulders
            [5]  = 21875,  -- Primal Mooncloth Robe
            [6]  = 21873,  -- Primal Mooncloth Belt
            [7]  = 24261,  -- Whitemend Pants
            [8]  = 30737,  -- Gold-Leaf Wildboots
            [9]  = 29183,  -- Bindings of the Timewalker
            [10] = 28521,  -- Mitts of the Treemender
            [11] = 29290,  -- Violet Signet of the Grand Restorer
            [12] = 28763,  -- Jade Ring of the Everliving
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28590,  -- Ribbon of Sacrifice
            [15] = 28765,  -- Stainless Cloak of the Pure Hearted
            [16] = 28771,  -- Light's Justice
            [17] = 29274,  -- Tears of Heaven
            [18] = 28568,  -- Idol of the Avian Heart
        },
    },

    DRUID_RESTO_P2 = {
        name = "Druid Resto Phase 2 BIS (SSC/TK)",
        spec = "DRUID_RESTO",
        items = {
            [1]  = 30219,  -- Nordrassil Headguard
            [2]  = 30018,  -- Lord Sanguinar's Claim
            [3]  = 30221,  -- Nordrassil Life-Mantle
            [5]  = 30216,  -- Nordrassil Chestguard
            [6]  = 21873,  -- Primal Mooncloth Belt
            [7]  = 30727,  -- Gilded Trousers of Benediction
            [8]  = 30737,  -- Gold-Leaf Wildboots
            [9]  = 30062,  -- Grove-Bands of Remulos
            [10] = 28521,  -- Mitts of the Treemender
            [11] = 30110,  -- Coral Band of the Revived
            [12] = 28763,  -- Jade Ring of the Everliving
            [13] = 29376,  -- Essence of the Martyr
            [14] = 38288,  -- Direbrew Hops
            [15] = 29989,  -- Sunshower Light Cloak
            [16] = 30108,  -- Lightfathom Scepter
            [17] = 29274,  -- Tears of Heaven
            [18] = 27886,  -- Idol of the Emerald Queen
        },
    },

    DRUID_RESTO_P3 = {
        name = "Druid Resto Phase 3 BIS (BT/Hyjal)",
        spec = "DRUID_RESTO",
        items = {
            [1]  = 31037,  -- Thunderheart Headguard
            [2]  = 30018,  -- Lord Sanguinar's Claim
            [3]  = 31047,  -- Thunderheart Pauldrons
            [5]  = 31041,  -- Thunderheart Chestguard
            [6]  = 30895,  -- Angelista's Sash
            [7]  = 30912,  -- Leggings of Eternity
            [8]  = 30737,  -- Gold-Leaf Wildboots
            [9]  = 30868,  -- Blessed Bands of Karabor
            [10] = 32328,  -- Botanist's Gloves of Growth
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 30110,  -- Coral Band of the Revived
            [13] = 29376,  -- Essence of the Martyr
            [14] = 32496,  -- Memento of Tyrande
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32500,  -- Crystal Spire of Karabor
            [17] = 30911,  -- Scepter of Purification
            [18] = 27886,  -- Idol of the Emerald Queen
        },
    },

    DRUID_RESTO_P5 = {
        name = "Druid Resto Phase 5 BIS (Sunwell)",
        spec = "DRUID_RESTO",
        items = {
            [1]  = 34339,  -- Cowl of Light's Purity
            [2]  = 33281,  -- Brooch of Nature's Mercy
            [3]  = 34209,  -- Shawl of Wonderment
            [5]  = 34212,  -- Gown of Spiritual Wonder
            [6]  = 34554,  -- Thunderheart Waistguard
            [7]  = 34384,  -- Breeches of Natural Splendor
            [8]  = 34571,  -- Thunderheart Treads
            [9]  = 34445,  -- Thunderheart Wristguards
            [10] = 34342,  -- Handguards of the Dawn
            [11] = 34166,  -- Band of Lucent Beams
            [12] = 29309,  -- Band of the Eternal Restorer
            [13] = 29376,  -- Essence of the Martyr
            [14] = 34430,  -- Glimmering Naaru Sliver
            [15] = 32337,  -- Shroud of the Highborne
            [16] = 34335,  -- Hammer of Sanctification
            [17] = 34206,  -- Book of Highborne Hymns
            [18] = 27886,  -- Idol of the Emerald Queen
        },
    },

    ---------------------------------------------------------------------------
    -- Druid Feral DPS (Cat) — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    DRUID_FERAL_PRERAID = {
        name = "Druid Feral DPS Pre-Raid BIS",
        spec = "DRUID_FERAL",
        items = {
            [1]  = 8345,   -- Wolfshead Helm
            [2]  = 24114,  -- Braided Eternium Chain
            [3]  = 27797,  -- Wastewalker Shoulderpads
            [5]  = 29525,  -- Primalstrike Vest
            [6]  = 29247,  -- Girdle of the Deathdealer
            [7]  = 31544,  -- Clefthoof Leggings
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 29246,  -- Nightfall Wristguards
            [10] = 28396,  -- Gloves of Dexterous Manipulation
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 31920,  -- Shaffar's Band of Brutality
            [13] = 23206,  -- Mark of the Champion
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 31255,  -- Cloak of Malice
            [16] = 31334,  -- Staff of Natural Fury
            [18] = 29390,  -- Everbloom Idol
        },
    },

    DRUID_FERAL_P1 = {
        name = "Druid Feral DPS Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "DRUID_FERAL",
        items = {
            [1]  = 8345,   -- Wolfshead Helm
            [2]  = 24114,  -- Braided Eternium Chain
            [3]  = 29100,  -- Shoulderpads of Assassination
            [5]  = 29096,  -- Nether Shadow Tunic
            [6]  = 29247,  -- Girdle of the Deathdealer
            [7]  = 28741,  -- Skulker's Greaves
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29246,  -- Nightfall Wristguards
            [10] = 28506,  -- Gloves of Dexterous Manipulation
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 28649,  -- Ring of the Recalcitrant
            [13] = 23206,  -- Mark of the Champion
            [14] = 28830,  -- Dragonspine Trophy
            [15] = 28672,  -- Drape of the Dark Reavers
            [16] = 28658,  -- Terestian's Stranglestaff
            [18] = 29390,  -- Everbloom Idol
        },
    },

    DRUID_FERAL_P2 = {
        name = "Druid Feral DPS Phase 2 BIS (SSC/TK)",
        spec = "DRUID_FERAL",
        items = {
            [1]  = 8345,   -- Wolfshead Helm
            [2]  = 24114,  -- Braided Eternium Chain
            [3]  = 30055,  -- Shoulderpads of the Stranger
            [5]  = 30101,  -- Nether Shadow Tunic
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 28741,  -- Skulker's Greaves
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29966,  -- Vambraces of Ending
            [10] = 29947,  -- Gloves of the Searing Grip
            [11] = 30052,  -- Ring of Lethality
            [12] = 29997,  -- Band of the Ranger-General
            [13] = 30627,  -- Tsunami Talisman
            [14] = 23206,  -- Mark of the Champion
            [15] = 28672,  -- Drape of the Dark Reavers
            [16] = 32014,  -- Staff of the Forest Lord
            [18] = 29390,  -- Everbloom Idol
        },
    },

    DRUID_FERAL_P3 = {
        name = "Druid Feral DPS Phase 3 BIS (BT/Hyjal)",
        spec = "DRUID_FERAL",
        items = {
            [1]  = 8345,   -- Wolfshead Helm
            [2]  = 32260,  -- Choker of Endless Nightmares
            [3]  = 31048,  -- Thunderheart Pauldrons
            [5]  = 31042,  -- Thunderheart Chestguard
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 31044,  -- Thunderheart Leggings
            [8]  = 32366,  -- Shadowmaster's Boots
            [9]  = 32324,  -- Insidious Bands
            [10] = 31034,  -- Thunderheart Gauntlets
            [11] = 32497,  -- Stormrage Signet Ring
            [12] = 29301,  -- Band of the Eternal Champion
            [13] = 30627,  -- Tsunami Talisman
            [14] = 32505,  -- Madness of the Betrayer
            [15] = 32323,  -- Shadowmoon Destroyer's Drape
            [16] = 33716,  -- Vengeful Gladiator's Staff
            [18] = 29390,  -- Everbloom Idol
        },
    },

    DRUID_FERAL_P5 = {
        name = "Druid Feral DPS Phase 5 BIS (Sunwell)",
        spec = "DRUID_FERAL",
        items = {
            [1]  = 34244,  -- Duplicitous Guise
            [2]  = 34358,  -- Hard Khorium Choker
            [3]  = 34392,  -- Demontooth Shoulderpads
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34556,  -- Thunderheart Waistguard
            [7]  = 34188,  -- Leggings of the Immortal Night
            [8]  = 33222,  -- Nyn'jah's Tabi Boots
            [9]  = 34444,  -- Thunderheart Wristguards
            [10] = 34370,  -- Gloves of Immortal Dusk
            [11] = 34189,  -- Band of Ruinous Delight
            [12] = 34887,  -- Angelista's Revenge
            [13] = 34472,  -- Shard of Contempt
            [14] = 34427,  -- Blackened Naaru Sliver
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 34198,  -- Stanchion of Primal Instinct
            [18] = 29390,  -- Everbloom Idol
        },
    },

    ---------------------------------------------------------------------------
    -- Druid Balance DPS — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    DRUID_BALANCE_PRERAID = {
        name = "Druid Balance DPS Pre-Raid BIS",
        spec = "DRUID_BALANCE",
        items = {
            [1]  = 24266,  -- Spellstrike Hood
            [2]  = 28134,  -- Brooch of Heightened Potential
            [3]  = 27796,  -- Mana-Etched Spaulders
            [5]  = 21848,  -- Spellfire Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 27821,  -- Satin Slippers
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 21847,  -- Spellfire Gloves
            [11] = 29172,  -- Ashyen's Gift
            [12] = 28227,  -- Sparking Arcanite Ring
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 27981,  -- Sethekk Oracle Cloak
            [16] = 23554,  -- Eternium Runed Blade
            [17] = 29271,  -- Talisman of Kalecgos
            [18] = 27518,  -- Ivory Idol of the Moongoddess
        },
    },

    DRUID_BALANCE_P1 = {
        name = "Druid Balance DPS Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "DRUID_BALANCE",
        items = {
            [1]  = 29093,  -- Antlers of Malorne
            [2]  = 28530,  -- Brooch of Unquenchable Fury
            [3]  = 29095,  -- Pauldrons of Malorne
            [5]  = 21848,  -- Spellfire Robe
            [6]  = 21846,  -- Spellfire Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 28517,  -- Boots of Foretelling
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 21847,  -- Spellfire Gloves
            [11] = 28793,  -- Band of Crimson Fury
            [12] = 28753,  -- Ring of Recurrence
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 28766,  -- Ruby Drape of the Mysticant
            [16] = 28633,  -- Staff of Infinite Mysteries
            [17] = 29271,  -- Talisman of Kalecgos
            [18] = 27518,  -- Ivory Idol of the Moongoddess
        },
    },

    DRUID_BALANCE_P2 = {
        name = "Druid Balance DPS Phase 2 BIS (SSC/TK)",
        spec = "DRUID_BALANCE",
        items = {
            [1]  = 30233,  -- Nordrassil Headpiece
            [2]  = 30015,  -- The Sun King's Talisman
            [3]  = 30235,  -- Nordrassil Wrath-Mantle
            [5]  = 30231,  -- Nordrassil Chestpiece
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 30037,  -- Boots of Blasting
            [9]  = 29918,  -- Mindstorm Wristbands
            [10] = 30232,  -- Nordrassil Gauntlets
            [11] = 30109,  -- Ring of Endless Coils
            [12] = 28753,  -- Ring of Recurrence
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 30735,  -- Ancient Spellcloak of the Highborne
            [16] = 30723,  -- Talon of the Tempest
            [17] = 30049,  -- Crystal of the Void
            [18] = 27518,  -- Ivory Idol of the Moongoddess
        },
    },

    DRUID_BALANCE_P3 = {
        name = "Druid Balance DPS Phase 3 BIS (BT/Hyjal)",
        spec = "DRUID_BALANCE",
        items = {
            [1]  = 31040,  -- Thunderheart Cover
            [2]  = 30015,  -- The Sun King's Talisman
            [3]  = 31049,  -- Thunderheart Shoulderpads
            [5]  = 31043,  -- Thunderheart Vest
            [6]  = 30888,  -- Anetheron's Noose
            [7]  = 30916,  -- Leggings of Channeled Elements
            [8]  = 32239,  -- The Footsteps of Illidan
            [9]  = 32586,  -- Bracers of Nimble Thought
            [10] = 31035,  -- Thunderheart Handguards
            [11] = 32527,  -- Ring of Ancient Knowledge
            [12] = 29305,  -- Band of the Eternal Sage
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 32486,  -- Ashtongue Talisman of Equilibrium
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32374,  -- Zhar'doom, Greatstaff of the Devourer
            [17] = 30872,  -- Chronicle of Dark Secrets
            [18] = 27518,  -- Ivory Idol of the Moongoddess
        },
    },

    DRUID_BALANCE_P5 = {
        name = "Druid Balance DPS Phase 5 BIS (Sunwell)",
        spec = "DRUID_BALANCE",
        items = {
            [1]  = 34340,  -- Dark Conjuror's Collar
            [2]  = 34678,  -- Shattered Sun Pendant of Acumen
            [3]  = 34210,  -- Amice of the Convoker
            [5]  = 34364,  -- Sunfire Robe
            [6]  = 34555,  -- Thunderheart Cord
            [7]  = 34181,  -- Leggings of Calamity
            [8]  = 34572,  -- Thunderheart Footwraps
            [9]  = 34446,  -- Thunderheart Bracers
            [10] = 34344,  -- Handguards of Defiled Worlds
            [11] = 34362,  -- Loop of Forged Deeds
            [12] = 34230,  -- Ring of Omnipotence
            [13] = 34429,  -- Shifting Naaru Sliver
            [14] = 32483,  -- The Skull of Gul'dan
            [15] = 34242,  -- Cloak of Entropy
            [16] = 34182,  -- Grand Magister's Staff of Torrents
            [17] = 34179,  -- Heart of the Pit
            [18] = 33510,  -- Idol of the Unseen Moon
        },
    },

    ---------------------------------------------------------------------------
    -- Paladin Holy — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    PALADIN_HOLY_PRERAID = {
        name = "Paladin Holy Pre-Raid BIS",
        spec = "PALADIN_HOLY",
        items = {
            [1]  = 32084,  -- Helmet of the Steadfast Champion
            [2]  = 29374,  -- Necklace of Eternal Hope
            [3]  = 27775,  -- Hallowed Pauldrons
            [5]  = 29522,  -- Windhawk Hauberk
            [6]  = 29524,  -- Windhawk Belt
            [7]  = 30543,  -- Pontifex Kilt
            [8]  = 29251,  -- Boots of the Pious
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 27457,  -- Life Bearer's Gauntlets
            [11] = 29373,  -- Band of Halos
            [12] = 29169,  -- Ring of Convalescence
            [13] = 29376,  -- Essence of the Martyr
            [14] = 30841,  -- Lower City Prayerbook
            [15] = 29354,  -- Light-Touched Stole of Altruism
            [16] = 29175,  -- Gavel of Pure Light
            [17] = 29267,  -- Light-Bearer's Faith Shield
            [18] = 23006,  -- Libram of Light
        },
    },

    PALADIN_HOLY_P1 = {
        name = "Paladin Holy Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "PALADIN_HOLY",
        items = {
            [1]  = 29061,  -- Justicar Diadem
            [2]  = 30726,  -- Archaic Charm of Presence
            [3]  = 29064,  -- Justicar Pauldrons
            [5]  = 29062,  -- Justicar Chestpiece
            [6]  = 29524,  -- Windhawk Belt
            [7]  = 28748,  -- Legplates of the Innocent
            [8]  = 28569,  -- Boots of Valiance
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 29065,  -- Justicar Gloves
            [11] = 28790,  -- Naaru Lightwarden's Band
            [12] = 29290,  -- Violet Signet of the Grand Restorer
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28727,  -- Pendant of the Violet Eye
            [15] = 28765,  -- Stainless Cloak of the Pure Hearted
            [16] = 28771,  -- Light's Justice
            [17] = 29458,  -- Aegis of the Vindicator
            [18] = 28592,  -- Libram of Souls Redeemed
        },
    },

    PALADIN_HOLY_P2 = {
        name = "Paladin Holy Phase 2 BIS (SSC/TK)",
        spec = "PALADIN_HOLY",
        items = {
            [1]  = 30136,  -- Crystalforge Greathelm
            [2]  = 30018,  -- Lord Sanguinar's Claim
            [3]  = 30138,  -- Crystalforge Pauldrons
            [5]  = 30134,  -- Crystalforge Chestpiece
            [6]  = 30030,  -- Girdle of Fallen Stars
            [7]  = 29991,  -- Sunhawk Leggings
            [8]  = 30027,  -- Boots of Courage Unending
            [9]  = 30047,  -- Blackfathom Warbands
            [10] = 30112,  -- Glorious Gauntlets of Crestfall
            [11] = 30110,  -- Coral Band of the Revived
            [12] = 30736,  -- Ring of Flowing Light
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28590,  -- Ribbon of Sacrifice
            [15] = 29989,  -- Sunshower Light Cloak
            [16] = 30108,  -- Lightfathom Scepter
            [17] = 29923,  -- Talisman of the Sun King
            [18] = 28592,  -- Libram of Souls Redeemed
        },
    },

    PALADIN_HOLY_P3 = {
        name = "Paladin Holy Phase 3 BIS (BT/Hyjal)",
        spec = "PALADIN_HOLY",
        items = {
            [1]  = 30988,  -- Lightbringer Greathelm
            [2]  = 32370,  -- Nadina's Pendant of Purity
            [3]  = 30996,  -- Lightbringer Pauldrons
            [5]  = 30992,  -- Lightbringer Chestpiece
            [6]  = 30897,  -- Girdle of Hope
            [7]  = 30994,  -- Lightbringer Leggings
            [8]  = 32243,  -- Pearl Inlaid Boots
            [9]  = 30862,  -- Blessed Adamantite Bracers
            [10] = 30112,  -- Glorious Gauntlets of Crestfall
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 32238,  -- Ring of Calming Waves
            [13] = 32496,  -- Memento of Tyrande
            [14] = 29376,  -- Essence of the Martyr
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32500,  -- Crystal Spire of Karabor
            [17] = 32255,  -- Felstone Bulwark
            [18] = 28592,  -- Libram of Souls Redeemed
        },
    },

    PALADIN_HOLY_P5 = {
        name = "Paladin Holy Phase 5 BIS (Sunwell)",
        spec = "PALADIN_HOLY",
        items = {
            [1]  = 34243,  -- Helm of Burning Righteousness
            [2]  = 32370,  -- Nadina's Pendant of Purity
            [3]  = 34193,  -- Spaulders of the Thalassian Savior
            [5]  = 34229,  -- Garments of Serene Shores
            [6]  = 34487,  -- Lightbringer Belt
            [7]  = 34167,  -- Legplates of the Holy Juggernaut
            [8]  = 34559,  -- Lightbringer Treads
            [9]  = 34432,  -- Lightbringer Bracers
            [10] = 34380,  -- Sunblessed Gauntlets
            [11] = 34363,  -- Ring of Flowing Life
            [12] = 32528,  -- Blessed Band of Karabor
            [13] = 34430,  -- Glimmering Naaru Sliver
            [14] = 32496,  -- Memento of Tyrande
            [15] = 34205,  -- Shroud of Redeemed Souls
            [16] = 34335,  -- Hammer of Sanctification
            [17] = 34231,  -- Aegis of Angelic Fortune
            [18] = 28592,  -- Libram of Souls Redeemed
        },
    },

    ---------------------------------------------------------------------------
    -- Paladin Retribution — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    PALADIN_RET_PRERAID = {
        name = "Paladin Ret Pre-Raid BIS",
        spec = "PALADIN_RET",
        items = {
            [1]  = 32087,  -- Mask of the Deceiver
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 33173,  -- Ragesteel Shoulders
            [5]  = 23522,  -- Ragesteel Breastplate
            [6]  = 27985,  -- Deathforge Girdle
            [7]  = 30257,  -- Shattrath Leggings
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 23537,  -- Black Felsteel Bracers
            [10] = 30341,  -- Flesh Handler's Gauntlets
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 29177,  -- A'dal's Command
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28288,  -- Abacus of Violent Odds
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28429,  -- Lionheart Champion
            [18] = 27484,  -- Libram of Avengement
        },
    },

    PALADIN_RET_P1 = {
        name = "Paladin Ret Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "PALADIN_RET",
        items = {
            [1]  = 29073,  -- Justicar Crown
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 30740,  -- Ripfiend Shoulderplates
            [5]  = 28484,  -- Bulwark of Kings
            [6]  = 28779,  -- Girdle of the Endless Pit
            [7]  = 30257,  -- Shattrath Leggings
            [8]  = 28608,  -- Ironstriders of Urgency
            [9]  = 28795,  -- Bladespire Warbands
            [10] = 30644,  -- Grips of Deftness
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 28757,  -- Ring of a Thousand Marks
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28429,  -- Lionheart Champion
            [18] = 29388,  -- Libram of Repentance
        },
    },

    PALADIN_RET_P2 = {
        name = "Paladin Ret Phase 2 BIS (SSC/TK)",
        spec = "PALADIN_RET",
        items = {
            [1]  = 32461,  -- Furious Gizmatic Goggles
            [2]  = 30022,  -- Pendant of the Perilous
            [3]  = 30055,  -- Shoulderpads of the Stranger
            [5]  = 30129,  -- Crystalforge Breastplate
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 29950,  -- Greaves of the Bloodwarder
            [8]  = 30081,  -- Warboots of Obliteration
            [9]  = 30057,  -- Bracers of Eradication
            [10] = 29947,  -- Gloves of the Searing Grip
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 29997,  -- Band of the Ranger-General
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28830,  -- Dragonspine Trophy
            [15] = 30098,  -- Razor-Scale Battlecloak
            [16] = 28430,  -- Lionheart Executioner
            [18] = 27484,  -- Libram of Avengement
        },
    },

    PALADIN_RET_P3 = {
        name = "Paladin Ret Phase 3 BIS (BT/Hyjal)",
        spec = "PALADIN_RET",
        items = {
            [1]  = 32235,  -- Cursed Vision of Sargeras
            [2]  = 30022,  -- Pendant of the Perilous
            [3]  = 30055,  -- Shoulderpads of the Stranger
            [5]  = 30905,  -- Midnight Chestguard
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 30900,  -- Bow-stitched Leggings
            [8]  = 32366,  -- Shadowmaster's Boots
            [9]  = 32574,  -- Bindings of Lightning Reflexes
            [10] = 29947,  -- Gloves of the Searing Grip
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 32526,  -- Band of Devastation
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28830,  -- Dragonspine Trophy
            [15] = 33122,  -- Cloak of Darkness
            [16] = 32332,  -- Torch of the Damned
            [18] = 27484,  -- Libram of Avengement
        },
    },

    PALADIN_RET_P5 = {
        name = "Paladin Ret Phase 5 BIS (Sunwell)",
        spec = "PALADIN_RET",
        items = {
            [1]  = 34244,  -- Duplicitous Guise
            [2]  = 34177,  -- Clutch of Demise
            [3]  = 34388,  -- Pauldrons of Berserking
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34485,  -- Lightbringer Girdle
            [7]  = 34180,  -- Felfury Legplates
            [8]  = 34561,  -- Lightbringer Boots
            [9]  = 34431,  -- Lightbringer Bands
            [10] = 34343,  -- Thalassian Ranger Gauntlets
            [11] = 34189,  -- Band of Ruinous Delight
            [12] = 34361,  -- Hard Khorium Band
            [13] = 34472,  -- Shard of Contempt
            [14] = 34427,  -- Blackened Naaru Sliver
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 34247,  -- Apolyon, the Soul-Render
            [18] = 33503,  -- Libram of Divine Judgement
        },
    },

    ---------------------------------------------------------------------------
    -- Shaman Restoration — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    SHAMAN_RESTO_PRERAID = {
        name = "Shaman Resto Pre-Raid BIS",
        spec = "SHAMAN_RESTO",
        items = {
            [1]  = 24264,  -- Whitemend Hood
            [2]  = 29374,  -- Necklace of Eternal Hope
            [3]  = 21874,  -- Primal Mooncloth Shoulders
            [5]  = 21875,  -- Primal Mooncloth Robe
            [6]  = 29524,  -- Windhawk Belt
            [7]  = 30543,  -- Pontifex Kilt
            [8]  = 29251,  -- Boots of the Pious
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 29506,  -- Gloves of the Living Touch
            [11] = 29373,  -- Band of Halos
            [12] = 29169,  -- Ring of Convalescence
            [13] = 29376,  -- Essence of the Martyr
            [14] = 30841,  -- Lower City Prayerbook
            [15] = 31329,  -- Lifegiving Cloak
            [16] = 29353,  -- Shockwave Truncheon
            [17] = 29267,  -- Light-Bearer's Faith Shield
            [18] = 27544,  -- Totem of Spontaneous Regrowth
        },
    },

    SHAMAN_RESTO_P1 = {
        name = "Shaman Resto Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "SHAMAN_RESTO",
        items = {
            [1]  = 24264,  -- Whitemend Hood
            [2]  = 30726,  -- Archaic Charm of Presence
            [3]  = 29031,  -- Cyclone Shoulderpads
            [5]  = 29522,  -- Windhawk Hauberk
            [6]  = 29524,  -- Windhawk Belt
            [7]  = 28751,  -- Heart-Flame Leggings
            [8]  = 30737,  -- Gold-Leaf Wildboots
            [9]  = 29523,  -- Windhawk Bracers
            [10] = 28520,  -- Gloves of Centering
            [11] = 28763,  -- Jade Ring of the Everliving
            [12] = 28790,  -- Naaru Lightwarden's Band
            [13] = 29376,  -- Essence of the Martyr
            [14] = 28590,  -- Ribbon of Sacrifice
            [15] = 28765,  -- Stainless Cloak of the Pure Hearted
            [16] = 28771,  -- Light's Justice
            [17] = 29458,  -- Aegis of the Vindicator
            [18] = 28523,  -- Totem of Healing Rains
        },
    },

    SHAMAN_RESTO_P2 = {
        name = "Shaman Resto Phase 2 BIS (SSC/TK)",
        spec = "SHAMAN_RESTO",
        items = {
            [1]  = 30166,  -- Cataclysm Headguard
            [2]  = 30018,  -- Lord Sanguinar's Claim
            [3]  = 30168,  -- Cataclysm Shoulderguards
            [5]  = 30164,  -- Cataclysm Chestguard
            [6]  = 30030,  -- Girdle of Fallen Stars
            [7]  = 29991,  -- Sunhawk Leggings
            [8]  = 30737,  -- Gold-Leaf Wildboots
            [9]  = 30047,  -- Blackfathom Warbands
            [10] = 29976,  -- Worldstorm Gauntlets
            [11] = 29920,  -- Phoenix-Ring of Rebirth
            [12] = 28790,  -- Naaru Lightwarden's Band
            [13] = 29376,  -- Essence of the Martyr
            [14] = 38288,  -- Direbrew Hops
            [15] = 29989,  -- Sunshower Light Cloak
            [16] = 30108,  -- Lightfathom Scepter
            [17] = 29458,  -- Aegis of the Vindicator
            [18] = 28523,  -- Totem of Healing Rains
        },
    },

    SHAMAN_RESTO_P3 = {
        name = "Shaman Resto Phase 3 BIS (BT/Hyjal)",
        spec = "SHAMAN_RESTO",
        items = {
            [1]  = 31012,  -- Skyshatter Helmet
            [2]  = 32370,  -- Nadina's Pendant of Purity
            [3]  = 31022,  -- Skyshatter Shoulderpads
            [5]  = 31016,  -- Skyshatter Chestguard
            [6]  = 32258,  -- Naturalist's Preserving Cinch
            [7]  = 31019,  -- Skyshatter Leggings
            [8]  = 30873,  -- Stillwater Boots
            [9]  = 32577,  -- Living Earth Bindings
            [10] = 32328,  -- Botanist's Gloves of Growth
            [11] = 32528,  -- Blessed Band of Karabor
            [12] = 29309,  -- Band of the Eternal Restorer
            [13] = 32496,  -- Memento of Tyrande
            [14] = 29376,  -- Essence of the Martyr
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 32500,  -- Crystal Spire of Karabor
            [17] = 30882,  -- Bastion of Light
            [18] = 28523,  -- Totem of Healing Rains
        },
    },

    SHAMAN_RESTO_P5 = {
        name = "Shaman Resto Phase 5 BIS (Sunwell)",
        spec = "SHAMAN_RESTO",
        items = {
            [1]  = 34402,  -- Shroud of Chieftain Ner'zhul
            [2]  = 34360,  -- Amulet of Flowing Life
            [3]  = 34208,  -- Equilibrium Epaulets
            [5]  = 34212,  -- Sunglow Vest
            [6]  = 34932,  -- Clutch of the Soothing Breeze
            [7]  = 34383,  -- Kilt of Spiritual Reconstruction
            [8]  = 33324,  -- Treads of the Life Path
            [9]  = 34438,  -- Skyshatter Bracers
            [10] = 34372,  -- Leather Gauntlets of the Sun
            [11] = 34363,  -- Ring of Flowing Life
            [12] = 34166,  -- Band of Lucent Beams
            [13] = 34430,  -- Glimmering Naaru Sliver
            [14] = 32496,  -- Memento of Tyrande
            [15] = 32524,  -- Shroud of the Highborne
            [16] = 34335,  -- Hammer of Sanctification
            [17] = 34206,  -- Book of Highborne Hymns
            [18] = 33505,  -- Totem of Living Water
        },
    },

    ---------------------------------------------------------------------------
    -- Shaman Enhancement — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    SHAMAN_ENH_PRERAID = {
        name = "Shaman Enh Pre-Raid BIS",
        spec = "SHAMAN_ENH",
        items = {
            [1]  = 28224,  -- Wastewalker Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 27797,  -- Wastewalker Shoulderpads
            [5]  = 29525,  -- Primalstrike Vest
            [6]  = 29526,  -- Primalstrike Belt
            [7]  = 31544,  -- Clefthoof Hide Leggings
            [8]  = 25686,  -- Fel Leather Boots
            [9]  = 29527,  -- Primalstrike Bracers
            [10] = 25685,  -- Fel Leather Gloves
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 31920,  -- Shaffar's Band of Brutality
            [13] = 29383,  -- Bloodlust Brooch
            [14] = 28288,  -- Abacus of Violent Odds
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28313,  -- Gladiator's Right Ripper
            [17] = 28308,  -- Gladiator's Cleaver
            [18] = 27815,  -- Totem of the Astral Winds
        },
    },

    SHAMAN_ENH_P1 = {
        name = "Shaman Enh Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "SHAMAN_ENH",
        items = {
            [1]  = 29040,  -- Cyclone Helm
            [2]  = 29381,  -- Choker of Vile Intent
            [3]  = 29043,  -- Cyclone Shoulderplates
            [5]  = 30730,  -- Terrorweave Tunic
            [6]  = 29516,  -- Ebon Netherscale Belt
            [7]  = 28741,  -- Skulker's Greaves
            [8]  = 28545,  -- Edgewalker Longboots
            [9]  = 29517,  -- Ebon Netherscale Bracers
            [10] = 28776,  -- Liar's Tongue Gloves
            [11] = 30834,  -- Shapeshifter's Signet
            [12] = 28757,  -- Ring of a Thousand Marks
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 28313,  -- Gladiator's Right Ripper
            [17] = 28308,  -- Gladiator's Cleaver
            [18] = 27815,  -- Totem of the Astral Winds
        },
    },

    SHAMAN_ENH_P2 = {
        name = "Shaman Enh Phase 2 BIS (SSC/TK)",
        spec = "SHAMAN_ENH",
        items = {
            [1]  = 30190,  -- Cataclysm Helm
            [2]  = 30017,  -- Telonicus's Pendant of Mayhem
            [3]  = 30055,  -- Shoulderpads of the Stranger
            [5]  = 30185,  -- Cataclysm Chestplate
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 30192,  -- Cataclysm Legplates
            [8]  = 30039,  -- Boots of Utter Darkness
            [9]  = 30091,  -- True-Aim Stalker Bands
            [10] = 30189,  -- Cataclysm Gauntlets
            [11] = 29997,  -- Band of the Ranger-General
            [12] = 30052,  -- Ring of Lethality
            [13] = 28830,  -- Dragonspine Trophy
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 24259,  -- Vengeance Wrap
            [16] = 29996,  -- Rod of the Sun King
            [17] = 29996,  -- Rod of the Sun King
            [18] = 27815,  -- Totem of the Astral Winds
        },
    },

    SHAMAN_ENH_P3 = {
        name = "Shaman Enh Phase 3 BIS (BT/Hyjal)",
        spec = "SHAMAN_ENH",
        items = {
            [1]  = 32235,  -- Cursed Vision of Sargeras
            [2]  = 32260,  -- Choker of Endless Nightmares
            [3]  = 32581,  -- Swiftstrike Shoulders
            [5]  = 30905,  -- Midnight Chestguard
            [6]  = 30106,  -- Belt of One-Hundred Deaths
            [7]  = 30900,  -- Bow-stitched Leggings
            [8]  = 32366,  -- Shadowmaster's Boots
            [9]  = 30863,  -- Deadly Cuffs
            [10] = 32234,  -- Fists of Mukoa
            [11] = 32497,  -- Stormrage Signet Ring
            [12] = 29301,  -- Band of the Eternal Champion
            [13] = 32505,  -- Madness of the Betrayer
            [14] = 29383,  -- Bloodlust Brooch
            [15] = 32323,  -- Shadowmoon Destroyer's Drape
            [16] = 32262,  -- Syphon of the Nathrezim
            [17] = 32262,  -- Syphon of the Nathrezim
            [18] = 27815,  -- Totem of the Astral Winds
        },
    },

    SHAMAN_ENH_P5 = {
        name = "Shaman Enh Phase 5 BIS (Sunwell)",
        spec = "SHAMAN_ENH",
        items = {
            [1]  = 34244,  -- Duplicitous Guise
            [2]  = 34358,  -- Hard Khorium Choker
            [3]  = 34392,  -- Demontooth Shoulderpads
            [5]  = 34397,  -- Bladed Chaos Tunic
            [6]  = 34545,  -- Skyshatter Girdle
            [7]  = 34188,  -- Leggings of the Immortal Night
            [8]  = 34567,  -- Skyshatter Greaves
            [9]  = 34439,  -- Skyshatter Wristguards
            [10] = 34343,  -- Thalassian Ranger Gauntlets
            [11] = 34189,  -- Band of Ruinous Delight
            [12] = 32497,  -- Stormrage Signet Ring
            [13] = 34427,  -- Blackened Naaru Sliver
            [14] = 34472,  -- Shard of Contempt
            [15] = 34241,  -- Cloak of Unforgivable Sin
            [16] = 34331,  -- Hand of the Deceiver
            [17] = 34346,  -- Mounting Vengeance
            [18] = 33507,  -- Stonebreaker's Totem
        },
    },

    ---------------------------------------------------------------------------
    -- Shaman Elemental — Wowhead TBC Classic BIS guides
    ---------------------------------------------------------------------------

    SHAMAN_ELE_PRERAID = {
        name = "Shaman Ele Pre-Raid BIS",
        spec = "SHAMAN_ELE",
        items = {
            [1]  = 32086,  -- Storm Master's Helmet
            [2]  = 28134,  -- Brooch of Heightened Potential
            [3]  = 32078,  -- Pauldrons of Wild Magic
            [5]  = 29519,  -- Netherstrike Breastplate
            [6]  = 29520,  -- Netherstrike Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 28406,  -- Sigil-Laced Boots
            [9]  = 29521,  -- Netherstrike Bracers
            [10] = 27465,  -- Mana-Etched Gloves
            [11] = 29126,  -- Seer's Signet
            [12] = 29367,  -- Ring of Cryptic Dreams
            [13] = 29370,  -- Icon of the Silver Crescent
            [14] = 27683,  -- Quagmirran's Eye
            [15] = 29369,  -- Shawl of Shifting Probabilities
            [16] = 32450,  -- Gladiator's Gavel
            [17] = 29273,  -- Khadgar's Knapsack
            [18] = 28248,  -- Totem of the Void
        },
    },

    SHAMAN_ELE_P1 = {
        name = "Shaman Ele Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "SHAMAN_ELE",
        items = {
            [1]  = 29035,  -- Cyclone Faceguard
            [2]  = 28762,  -- Adornment of Stolen Souls
            [3]  = 29037,  -- Cyclone Shoulderguards
            [5]  = 29519,  -- Netherstrike Breastplate
            [6]  = 29520,  -- Netherstrike Belt
            [7]  = 24262,  -- Spellstrike Pants
            [8]  = 28517,  -- Boots of Foretelling
            [9]  = 29521,  -- Netherstrike Bracers
            [10] = 28780,  -- Soul-Eater's Handwraps
            [11] = 30667,  -- Ring of Unrelenting Storms
            [12] = 28753,  -- Ring of Recurrence
            [13] = 28785,  -- The Lightning Capacitor
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 28797,  -- Brute Cloak of the Ogre-Magi
            [16] = 30723,  -- Talon of the Tempest
            [17] = 29273,  -- Khadgar's Knapsack
            [18] = 28248,  -- Totem of the Void
        },
    },

    SHAMAN_ELE_P2 = {
        name = "Shaman Ele Phase 2 BIS (SSC/TK)",
        spec = "SHAMAN_ELE",
        items = {
            [1]  = 29035,  -- Cyclone Faceguard
            [2]  = 30015,  -- The Sun King's Talisman
            [3]  = 29037,  -- Cyclone Shoulderguards
            [5]  = 30169,  -- Cataclysm Chestpiece
            [6]  = 30038,  -- Belt of Blasting
            [7]  = 30172,  -- Cataclysm Leggings
            [8]  = 30067,  -- Velvet Boots of the Guardian
            [9]  = 29918,  -- Mindstorm Wristbands
            [10] = 28780,  -- Soul-Eater's Handwraps
            [11] = 30667,  -- Ring of Unrelenting Storms
            [12] = 29302,  -- Band of Eternity
            [13] = 28785,  -- The Lightning Capacitor
            [14] = 29370,  -- Icon of the Silver Crescent
            [15] = 28797,  -- Brute Cloak of the Ogre-Magi
            [16] = 29988,  -- The Nexus Key
            [17] = 30049,  -- Fathomstone
            [18] = 28248,  -- Totem of the Void
        },
    },

    SHAMAN_ELE_P3 = {
        name = "Shaman Ele Phase 3 BIS (BT/Hyjal)",
        spec = "SHAMAN_ELE",
        items = {
            [1]  = 31014,  -- Skyshatter Headguard
            [2]  = 30015,  -- The Sun King's Talisman
            [3]  = 31023,  -- Skyshatter Mantle
            [5]  = 31017,  -- Skyshatter Breastplate
            [6]  = 32276,  -- Flashfire Girdle
            [7]  = 30916,  -- Leggings of Channeled Elements
            [8]  = 32239,  -- Slippers of the Seacaller
            [9]  = 32586,  -- Bracers of Nimble Thought
            [10] = 31008,  -- Skyshatter Gauntlets
            [11] = 32527,  -- Ring of Ancient Knowledge
            [12] = 29305,  -- Band of the Eternal Sage
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 28785,  -- The Lightning Capacitor
            [15] = 32331,  -- Cloak of the Illidari Council
            [16] = 32374,  -- Zhar'doom, Greatstaff of the Devourer
            [18] = 32330,  -- Totem of Ancestral Guidance
        },
    },

    SHAMAN_ELE_P5 = {
        name = "Shaman Ele Phase 5 BIS (Sunwell)",
        spec = "SHAMAN_ELE",
        items = {
            [1]  = 34332,  -- Cowl of Gul'dan
            [2]  = 34359,  -- Pendant of Sunfire
            [3]  = 31023,  -- Skyshatter Mantle
            [5]  = 34396,  -- Garments of Crashing Shores
            [6]  = 34542,  -- Skyshatter Cord
            [7]  = 34186,  -- Chain Links of the Tumultuous Storm
            [8]  = 34566,  -- Skyshatter Treads
            [9]  = 32586,  -- Bracers of Nimble Thought
            [10] = 34350,  -- Gauntlets of the Ancient Shadowmoon
            [11] = 34362,  -- Loop of Forged Power
            [12] = 34230,  -- Ring of Omnipotence
            [13] = 32483,  -- The Skull of Gul'dan
            [14] = 34429,  -- Shifting Naaru Sliver
            [15] = 34242,  -- Tattered Cape of Antonidas
            [16] = 32374,  -- Zhar'doom, Greatstaff of the Devourer
            [17] = 34179,  -- Heart of the Pit
            [18] = 33506,  -- Skycall Totem
        },
    },

    ---------------------------------------------------------------------------
    -- Paladin Protection (Tank)
    ---------------------------------------------------------------------------

    -- Pre-Raid BIS (heroic dungeons, badge gear, crafted)
    PALADIN_PROT_PRERAID = {
        name = "Paladin Prot Pre-Raid BIS",
        spec = "PALADIN_PROT",
        items = {
            [1]  = 32083,  -- Faceguard of Determination
            [2]  = 28245,  -- Pendant of Dominance
            [3]  = 27706,  -- Gladiator's Lamellar Shoulders
            [5]  = 28203,  -- Breastplate of the Righteous
            [6]  = 29253,  -- Girdle of Valorous Deeds
            [7]  = 29184,  -- Timewarden's Leggings
            [8]  = 29254,  -- Boots of the Righteous Path
            [9]  = 29252,  -- Bracers of Dignity
            [10] = 30741,  -- Topaz-Studded Battlegrips
            [11] = 29172,  -- Ashyen's Gift
            [12] = 31319,  -- Band of Impenetrable Defenses
            [13] = 29387,  -- Gnomeregan Auto-Blocker 600
            [14] = 27529,  -- Figurine of the Colossus
            [15] = 27804,  -- Devilshark Cape
            [16] = 32450,  -- Gladiator's Gavel
            [17] = 29176,  -- Crest of the Sha'tar
            [18] = 29388,  -- Libram of Repentance
        },
    },

    -- Phase 1: Karazhan / Gruul / Mag BIS
    PALADIN_PROT_P1 = {
        name = "Paladin Prot Phase 1 BIS (Kara/Gruul/Mag)",
        spec = "PALADIN_PROT",
        items = {
            [1]  = 29068,  -- Justicar Faceguard
            [2]  = 28516,  -- Barbed Choker of Discipline
            [3]  = 29070,  -- Justicar Shoulderguards
            [5]  = 29066,  -- Justicar Chestguard
            [6]  = 29253,  -- Girdle of Valorous Deeds
            [7]  = 29069,  -- Justicar Legguards
            [8]  = 29254,  -- Boots of the Righteous Path
            [9]  = 29252,  -- Bracers of Dignity
            [10] = 29067,  -- Justicar Handguards
            [11] = 29279,  -- Violet Signet of the Great Protector
            [12] = 28792,  -- A'dal's Signet of Defense
            [13] = 28528,  -- Moroes' Lucky Pocket Watch
            [14] = 27529,  -- Figurine of the Colossus
            [15] = 29385,  -- Farstrider Defender's Cloak
            [16] = 28749,  -- King's Defender
            [17] = 29266,  -- Azure-Shield of Coldarra
            [18] = 29388,  -- Libram of Repentance
        },
    },

    -- Phase 2: SSC / TK BIS
    PALADIN_PROT_P2 = {
        name = "Paladin Prot Phase 2 BIS (SSC/TK)",
        spec = "PALADIN_PROT",
        items = {
            [1]  = 29068,  -- Justicar Faceguard
            [2]  = 30007,  -- The Darkener's Grasp
            [3]  = 29070,  -- Justicar Shoulderguards
            [5]  = 29066,  -- Justicar Chestguard
            [6]  = 30034,  -- Belt of the Guardian
            [7]  = 29069,  -- Justicar Legguards
            [8]  = 30033,  -- Boots of the Protector
            [9]  = 32515,  -- Wristguards of Determination
            [10] = 29067,  -- Justicar Handguards
            [11] = 30083,  -- Ring of Sundered Souls
            [12] = 29172,  -- Ashyen's Gift
            [13] = 28528,  -- Moroes' Lucky Pocket Watch
            [14] = 30629,  -- Scarab of Displacement
            [15] = 29925,  -- Phoenix-Wing Cloak
            [16] = 30095,  -- Fang of the Leviathan
            [17] = 29176,  -- Crest of the Sha'tar
            [18] = 29388,  -- Libram of Repentance
        },
    },

    -- Phase 3: BT / Hyjal BIS
    PALADIN_PROT_P3 = {
        name = "Paladin Prot Phase 3 BIS (BT/Hyjal)",
        spec = "PALADIN_PROT",
        items = {
            [1]  = 32521,  -- Faceplate of the Impenetrable
            [2]  = 32362,  -- Pendant of Titans
            [3]  = 30998,  -- Lightbringer Shoulderguards
            [5]  = 30991,  -- Lightbringer Chestguard
            [6]  = 32342,  -- Girdle of Mighty Resolve
            [7]  = 30995,  -- Lightbringer Legguards
            [8]  = 32245,  -- Tide-stomper's Greaves
            [9]  = 32279,  -- The Seeker's Wristguards
            [10] = 30985,  -- Lightbringer Handguards
            [11] = 30083,  -- Ring of Sundered Souls
            [12] = 29172,  -- Ashyen's Gift
            [13] = 32501,  -- Shadowmoon Insignia
            [14] = 31858,  -- Darkmoon Card: Vengeance
            [15] = 34010,  -- Pepe's Shroud of Pacification
            [16] = 30910,  -- Tempest of Chaos
            [17] = 32375,  -- Bulwark of Azzinoth
            [18] = 29388,  -- Libram of Repentance
        },
    },

    -- Phase 5: Sunwell BIS
    PALADIN_PROT_P5 = {
        name = "Paladin Prot Phase 5 BIS (Sunwell)",
        spec = "PALADIN_PROT",
        items = {
            [1]  = 34401,  -- Helm of Uther's Resolve
            [2]  = 34178,  -- Collar of the Pit Lord
            [3]  = 34389,  -- Spaulders of the Thalassian Defender
            [5]  = 34216,  -- Heroic Judicator's Chestguard
            [6]  = 34488,  -- Lightbringer Waistguard
            [7]  = 34382,  -- Judicator's Legguards
            [8]  = 34560,  -- Lightbringer Stompers
            [9]  = 34433,  -- Lightbringer Wristguards
            [10] = 34352,  -- Borderland Fortress Grips
            [11] = 34213,  -- Ring of Hardened Resolve
            [12] = 34888,  -- Ring of the Stalwart Protector
            [13] = 32501,  -- Shadowmoon Insignia
            [14] = 31858,  -- Darkmoon Card: Vengeance
            [15] = 34190,  -- Crimson Paragon's Cover
            [16] = 34176,  -- Reign of Misery
            [17] = 34185,  -- Sword Breaker's Bulwark
            [18] = 33504,  -- Libram of Divine Purpose
        },
    },
}
