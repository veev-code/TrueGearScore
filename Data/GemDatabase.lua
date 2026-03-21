---------------------------------------------------------------------------
-- TrueGearScore Gem Database
-- Maps gem item IDs to stat contributions
-- Format: [itemID] = { STAT_NAME = value, ... }
--
-- Sourced from Pawn addon's GemsBurningCrusade.lua (verified data)
-- and cross-referenced with Wowhead TBC Classic.
--
-- TBC splits spell damage and healing:
--   SPELL_POWER = spell damage done
--   HEAL_POWER  = healing done
-- Many gems give both (e.g., Royal Nightseye: +9 healing, +3 spell damage)
--
-- TBC also has separate spell hit/crit ratings, but at level 70 they use
-- the same rating conversion as melee. We map both to HIT_RATING/CRIT_RATING.
---------------------------------------------------------------------------

local _, addon = ...
addon.GemDatabase = {

    ---------------------------------------------------------------------------
    -- LEVEL 60 COMMON (white) VENDOR GEMS
    ---------------------------------------------------------------------------

    -- Red
    [28458] = { STRENGTH = 4 },                                    -- Bold Tourmaline
    [28459] = { AGILITY = 4 },                                     -- Delicate Tourmaline
    [28460] = { HEAL_POWER = 9, SPELL_POWER = 3 },                 -- Teardrop Tourmaline
    [28461] = { SPELL_POWER = 5 },                                 -- Runed Tourmaline
    [28462] = { ATTACK_POWER = 8 },                                -- Bright Tourmaline

    -- Yellow
    [28466] = { INTELLECT = 4 },                                   -- Brilliant Amber
    [28467] = { CRIT_RATING = 4 },                                 -- Smooth Amber
    [28468] = { HIT_RATING = 4 },                                  -- Rigid Amber
    [28469] = { CRIT_RATING = 4 },                                 -- Gleaming Amber (spell crit = crit at 70)
    [28470] = { DEFENSE = 4 },                                     -- Thick Amber

    -- Blue
    [28463] = { STAMINA = 6 },                                     -- Solid Zircon
    [28464] = { SPIRIT = 4 },                                      -- Sparkling Zircon
    [28465] = { MP5 = 1 },                                         -- Lustrous Zircon

    ---------------------------------------------------------------------------
    -- LEVEL 70 UNCOMMON (green) GEMS
    ---------------------------------------------------------------------------

    -- Red
    [23094] = { HEAL_POWER = 13, SPELL_POWER = 5 },                -- Teardrop Blood Garnet
    [23095] = { STRENGTH = 6 },                                    -- Bold Blood Garnet
    [23096] = { SPELL_POWER = 7 },                                 -- Runed Blood Garnet
    [23097] = { AGILITY = 6 },                                     -- Delicate Blood Garnet
    [28595] = { ATTACK_POWER = 12 },                               -- Bright Blood Garnet

    -- Orange
    [23098] = { CRIT_RATING = 3, STRENGTH = 3 },                   -- Inscribed Flame Spessarite
    [23099] = { HEAL_POWER = 7, SPELL_POWER = 3, INTELLECT = 3 },  -- Luminous Flame Spessarite
    [23100] = { HIT_RATING = 3, AGILITY = 3 },                     -- Glinting Flame Spessarite
    [23101] = { CRIT_RATING = 3, SPELL_POWER = 4 },                -- Potent Flame Spessarite
    [31866] = { HIT_RATING = 3, SPELL_POWER = 4 },                 -- Veiled Flame Spessarite
    [31869] = { CRIT_RATING = 3, ATTACK_POWER = 6 },               -- Wicked Flame Spessarite

    -- Yellow
    [23113] = { INTELLECT = 6 },                                   -- Brilliant Golden Draenite
    [23114] = { CRIT_RATING = 6 },                                 -- Gleaming Golden Draenite (spell crit)
    [23115] = { DEFENSE = 6 },                                     -- Thick Golden Draenite
    [23116] = { HIT_RATING = 6 },                                  -- Rigid Golden Draenite
    [28290] = { CRIT_RATING = 6 },                                 -- Smooth Golden Draenite
    [31860] = { HIT_RATING = 6 },                                  -- Great Golden Draenite (spell hit)

    -- Green
    [23103] = { CRIT_RATING = 3, SPELL_PEN = 4 },                  -- Radiant Deep Peridot
    [23104] = { CRIT_RATING = 3, STAMINA = 4 },                    -- Jagged Deep Peridot
    [23105] = { DEFENSE = 3, STAMINA = 4 },                        -- Enduring Deep Peridot
    [23106] = { MP5 = 1, INTELLECT = 3 },                          -- Dazzling Deep Peridot

    -- Blue
    [23118] = { STAMINA = 9 },                                     -- Solid Azure Moonstone
    [23119] = { SPIRIT = 6 },                                      -- Sparkling Azure Moonstone
    [23120] = { SPELL_PEN = 6 },                                   -- Stormy Azure Moonstone
    [23121] = { MP5 = 2 },                                         -- Lustrous Azure Moonstone

    -- Purple
    [23111] = { STRENGTH = 3, STAMINA = 4 },                       -- Sovereign Shadow Draenite
    [23108] = { SPELL_POWER = 4, STAMINA = 4 },                    -- Glowing Shadow Draenite
    [23109] = { HEAL_POWER = 7, SPELL_POWER = 3, MP5 = 1 },        -- Royal Shadow Draenite
    [23110] = { AGILITY = 3, STAMINA = 4 },                        -- Shifting Shadow Draenite
    [31862] = { ATTACK_POWER = 6, STAMINA = 4 },                   -- Balanced Shadow Draenite
    [31864] = { ATTACK_POWER = 6, MP5 = 1 },                       -- Infused Shadow Draenite

    ---------------------------------------------------------------------------
    -- LEVEL 70 RARE (blue) GEMS
    ---------------------------------------------------------------------------

    -- Red
    [24027] = { STRENGTH = 8 },                                    -- Bold Living Ruby
    [24028] = { AGILITY = 8 },                                     -- Delicate Living Ruby
    [24029] = { HEAL_POWER = 18, SPELL_POWER = 6 },                -- Teardrop Living Ruby
    [24030] = { SPELL_POWER = 9 },                                 -- Runed Living Ruby
    [24031] = { ATTACK_POWER = 16 },                               -- Bright Living Ruby
    [24032] = { DODGE = 8 },                                       -- Subtle Living Ruby
    [24036] = { PARRY = 8 },                                       -- Flashing Living Ruby

    -- Orange
    [24058] = { CRIT_RATING = 4, STRENGTH = 4 },                   -- Inscribed Noble Topaz
    [24059] = { CRIT_RATING = 4, SPELL_POWER = 5 },                -- Potent Noble Topaz
    [24060] = { HEAL_POWER = 9, SPELL_POWER = 3, INTELLECT = 4 },  -- Luminous Noble Topaz
    [24061] = { HIT_RATING = 4, AGILITY = 4 },                     -- Glinting Noble Topaz
    [31867] = { HIT_RATING = 4, SPELL_POWER = 5 },                 -- Veiled Noble Topaz
    [31868] = { CRIT_RATING = 4, ATTACK_POWER = 8 },               -- Wicked Noble Topaz
    [35316] = { HASTE_RATING = 4, SPELL_POWER = 5 },               -- Reckless Noble Topaz

    -- Yellow
    [24047] = { INTELLECT = 8 },                                   -- Brilliant Dawnstone
    [24048] = { CRIT_RATING = 8 },                                 -- Smooth Dawnstone
    [24050] = { CRIT_RATING = 8 },                                 -- Gleaming Dawnstone (spell crit)
    [24051] = { HIT_RATING = 8 },                                  -- Rigid Dawnstone
    [24052] = { DEFENSE = 8 },                                     -- Thick Dawnstone
    [24053] = { RESILIENCE = 8 },                                  -- Mystic Dawnstone
    [31861] = { HIT_RATING = 8 },                                  -- Great Dawnstone (spell hit)
    [35315] = { HASTE_RATING = 8 },                                -- Quick Dawnstone

    -- Green
    [24062] = { DEFENSE = 4, STAMINA = 6 },                        -- Enduring Talasite
    [24065] = { INTELLECT = 4, MP5 = 2 },                          -- Dazzling Talasite
    [24066] = { CRIT_RATING = 4, SPELL_PEN = 5 },                  -- Radiant Talasite
    [24067] = { CRIT_RATING = 4, STAMINA = 6 },                    -- Jagged Talasite
    [33782] = { RESILIENCE = 4, STAMINA = 6 },                     -- Steady Talasite
    [35318] = { HASTE_RATING = 4, STAMINA = 6 },                   -- Forceful Talasite

    -- Blue
    [24033] = { STAMINA = 12 },                                    -- Solid Star of Elune
    [24035] = { SPIRIT = 8 },                                      -- Sparkling Star of Elune
    [24037] = { MP5 = 3 },                                         -- Lustrous Star of Elune
    [24039] = { SPELL_PEN = 10 },                                  -- Stormy Star of Elune

    -- Purple
    [24054] = { STRENGTH = 4, STAMINA = 6 },                       -- Sovereign Nightseye
    [24055] = { AGILITY = 4, STAMINA = 6 },                        -- Shifting Nightseye
    [24056] = { SPELL_POWER = 5, STAMINA = 6 },                    -- Glowing Nightseye
    [24057] = { HEAL_POWER = 9, SPELL_POWER = 3, MP5 = 2 },        -- Royal Nightseye
    [31863] = { ATTACK_POWER = 8, STAMINA = 6 },                   -- Balanced Nightseye
    [31865] = { ATTACK_POWER = 8, MP5 = 2 },                       -- Infused Nightseye
    [35707] = { DODGE = 4, STAMINA = 6 },                          -- Regal Nightseye

    ---------------------------------------------------------------------------
    -- LEVEL 70 EPIC (purple) GEMS — Phase 3+
    ---------------------------------------------------------------------------

    -- Red
    [32193] = { STRENGTH = 10 },                                   -- Bold Crimson Spinel
    [32194] = { AGILITY = 10 },                                    -- Delicate Crimson Spinel
    [32195] = { HEAL_POWER = 22, SPELL_POWER = 8 },                -- Teardrop Crimson Spinel
    [32196] = { SPELL_POWER = 12 },                                -- Runed Crimson Spinel
    [32197] = { ATTACK_POWER = 20 },                               -- Bright Crimson Spinel
    [32198] = { DODGE = 10 },                                      -- Subtle Crimson Spinel
    [32199] = { PARRY = 10 },                                      -- Flashing Crimson Spinel

    -- Orange
    [32217] = { CRIT_RATING = 5, STRENGTH = 5 },                   -- Inscribed Pyrestone
    [32218] = { CRIT_RATING = 5, SPELL_POWER = 6 },                -- Potent Pyrestone
    [32219] = { HEAL_POWER = 11, SPELL_POWER = 4, INTELLECT = 5 }, -- Luminous Pyrestone
    [32220] = { HIT_RATING = 5, AGILITY = 5 },                     -- Glinting Pyrestone
    [32221] = { HIT_RATING = 5, SPELL_POWER = 6 },                 -- Veiled Pyrestone
    [32222] = { CRIT_RATING = 5, ATTACK_POWER = 10 },              -- Wicked Pyrestone
    [35760] = { HASTE_RATING = 5, SPELL_POWER = 6 },               -- Reckless Pyrestone

    -- Yellow
    [32204] = { INTELLECT = 10 },                                  -- Brilliant Lionseye
    [32205] = { CRIT_RATING = 10 },                                -- Smooth Lionseye
    [32206] = { HIT_RATING = 10 },                                 -- Rigid Lionseye
    [32207] = { CRIT_RATING = 10 },                                -- Gleaming Lionseye (spell crit)
    [32208] = { DEFENSE = 10 },                                    -- Thick Lionseye
    [32209] = { RESILIENCE = 10 },                                 -- Mystic Lionseye
    [32210] = { HIT_RATING = 10 },                                 -- Great Lionseye (spell hit)
    [35761] = { HASTE_RATING = 10 },                               -- Quick Lionseye

    -- Green
    [32223] = { DEFENSE = 5, STAMINA = 7 },                        -- Enduring Seaspray Emerald
    [32224] = { CRIT_RATING = 5, SPELL_PEN = 6 },                  -- Radiant Seaspray Emerald
    [32225] = { INTELLECT = 5, MP5 = 2 },                          -- Dazzling Seaspray Emerald
    [32226] = { CRIT_RATING = 5, STAMINA = 7 },                    -- Jagged Seaspray Emerald
    [35759] = { HASTE_RATING = 5, STAMINA = 7 },                   -- Forceful Seaspray Emerald
    [35758] = { RESILIENCE = 5, STAMINA = 7 },                     -- Steady Seaspray Emerald

    -- Blue
    [32200] = { STAMINA = 15 },                                    -- Solid Empyrean Sapphire
    [32201] = { SPIRIT = 10 },                                     -- Sparkling Empyrean Sapphire
    [32202] = { MP5 = 4 },                                         -- Lustrous Empyrean Sapphire
    [32203] = { SPELL_PEN = 13 },                                  -- Stormy Empyrean Sapphire

    -- Purple
    [32211] = { STRENGTH = 5, STAMINA = 7 },                       -- Sovereign Shadowsong Amethyst
    [32212] = { AGILITY = 5, STAMINA = 7 },                        -- Shifting Shadowsong Amethyst
    [32213] = { ATTACK_POWER = 10, STAMINA = 7 },                  -- Balanced Shadowsong Amethyst
    [32214] = { ATTACK_POWER = 10, MP5 = 2 },                      -- Infused Shadowsong Amethyst
    [32215] = { SPELL_POWER = 6, STAMINA = 7 },                    -- Glowing Shadowsong Amethyst
    [32216] = { HEAL_POWER = 11, SPELL_POWER = 4, MP5 = 2 },       -- Royal Shadowsong Amethyst
    [37503] = { HEAL_POWER = 11, SPELL_POWER = 4, SPIRIT = 5 },    -- Purified Shadowsong Amethyst

    ---------------------------------------------------------------------------
    -- META GEMS
    ---------------------------------------------------------------------------

    [25896] = { STAMINA = 18 },                                    -- Powerful Earthstorm Diamond (+18 STA)
    [25897] = { HEAL_POWER = 26, SPELL_POWER = 9 },                -- Bracing Earthstorm Diamond (+26 heal, +9 SD, -2% threat)
    [25898] = { DEFENSE = 12 },                                    -- Tenacious Earthstorm Diamond (+12 defense, +5% stun resist)
    [25901] = { INTELLECT = 12 },                                  -- Insightful Earthstorm Diamond (+12 INT, mana proc)
    [32409] = { AGILITY = 12 },                                    -- Relentless Earthstorm Diamond (+12 AGI, +3% crit dmg)
    [25890] = { CRIT_RATING = 14 },                                -- Destructive Skyfire Diamond (+14 spell crit, +1% spell reflect)
    [25894] = { ATTACK_POWER = 24 },                               -- Swift Skyfire Diamond (+24 AP, minor run speed)
    [34220] = { CRIT_RATING = 12 },                                -- Chaotic Skyfire Diamond (+12 crit, +3% crit dmg)
    [35501] = { DEFENSE = 12 },                                    -- Eternal Earthstorm Diamond (+12 defense, +5% block value)
    [35503] = { SPELL_POWER = 14 },                                -- Ember Skyfire Diamond (+14 SD, +2% INT)

    ---------------------------------------------------------------------------
    -- HEROIC DUNGEON BoP EPIC GEMS (unique-equipped)
    ---------------------------------------------------------------------------

    -- Orange (Fire Opal)
    [30593] = { HEAL_POWER = 11, SPELL_POWER = 4, CRIT_RATING = 4 }, -- Iridescent Fire Opal (+11 heal, +4 SD, +4 spell crit)
    [30588] = { CRIT_RATING = 5, STRENGTH = 5 },                   -- Potent Fire Opal
    [30586] = { HIT_RATING = 5, AGILITY = 5 },                     -- Glinting Fire Opal

    -- Purple (Tanzanite / Shadow Pearl)
    [30603] = { HEAL_POWER = 11, SPELL_POWER = 4, MP5 = 2 },       -- Royal Tanzanite
    [30600] = { HEAL_POWER = 11, SPELL_POWER = 4, SPIRIT = 5 },    -- Purified Tanzanite
    [30602] = { AGILITY = 5, STAMINA = 7 },                        -- Shifting Tanzanite
    [32836] = { HEAL_POWER = 9, SPIRIT = 4 },                      -- Purified Shadow Pearl (+9 heal, +4 spirit)
    [32833] = { SPELL_POWER = 5, STAMINA = 6 },                    -- Glowing Shadow Pearl
    [32835] = { STRENGTH = 4, STAMINA = 6 },                       -- Sovereign Shadow Pearl

    ---------------------------------------------------------------------------
    -- CRAFTED / UNIQUE GEMS (not in Pawn, added manually)
    ---------------------------------------------------------------------------

    -- Heroic dungeon gems (BoP, from specific heroics)
    [30553] = { HEAL_POWER = 18, SPELL_POWER = 6 },                -- Teardrop Crimson Spinel (same stats as Living Ruby tier)
    [30551] = { SPELL_POWER = 9 },                                 -- Runed Crimson Spinel (heroic drop variant)

    -- PvP gems (honor-purchased)
    [28118] = { RESILIENCE = 6, STAMINA = 6 },                     -- Runed Ornate Ruby (PvP)

    -- SSO badge gems (Phase 5 — Sunwell)
    [35488] = { STRENGTH = 5, STAMINA = 7 },                       -- Sovereign Shadowsong Amethyst (BoP variant)

    -- Shattered Sun Offensive gems
    [34831] = { HEAL_POWER = 11, SPELL_POWER = 4, INTELLECT = 5 }, -- Eye of the Sea (SSO unique)

    ---------------------------------------------------------------------------
    -- QUEST REWARD / UNIQUE GEMS
    ---------------------------------------------------------------------------

    [33131] = { CRIT_RATING = 6, SPELL_POWER = 6 },                -- Crimson Sun (quest)
    [33133] = { CRIT_RATING = 6, STAMINA = 6 },                    -- Don Julio's Heart (quest)
    [33134] = { HEAL_POWER = 11, INTELLECT = 4 },                  -- Kailee's Rose (quest)
    [33135] = { HIT_RATING = 6, ATTACK_POWER = 10 },               -- Falling Star (quest)
    [33140] = { AGILITY = 6, STAMINA = 6 },                        -- Blood of Amber (quest)
}
