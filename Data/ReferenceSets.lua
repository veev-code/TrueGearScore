---------------------------------------------------------------------------
-- TrueGearScore Reference Gear Sets
-- Used for calibration: score hypothetical BIS sets to tune color brackets.
-- Each set is a table of { [slotID] = itemID }.
-- Sourced from Wowhead TBC Classic BIS guides (Priest Healer).
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
}
