---------------------------------------------------------------------------
-- TrueGearScore Reference Gear Sets
-- Used for calibration: score hypothetical BIS sets to tune color brackets.
-- Each set is a table of { [slotID] = itemID }.
-- Sourced from Wowhead TBC Classic BIS guides (Priest Healer, Warlock Destro,
-- Mage Fire, Paladin Holy/Ret, Shaman Resto/Enh/Ele, Druid Resto/Feral/Balance).
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
}
