# TrueGearScore

A gear score addon for World of Warcraft (Anniversary Edition) that measures **actual character power** — not just item level.

## The Problem with GearScore

GearScore has been one of the most divisive addons in WoW's history. The concept is useful — a quick shorthand for gear quality — but the original implementation is so flawed that the number it produces is often *wrong*, and the community behaviors it enables are actively harmful.

### What traditional GearScore gets wrong

**It ignores everything that matters.** Classic GearScore uses an `item level × rarity` formula. That's it. It doesn't look at gems, enchants, stat caps, proc effects, or set bonuses. A player in full epics with empty sockets and no enchants scores identically to one who spent thousands of gold optimizing every slot. The enchant scoring feature, added late in development, [never actually worked](https://github.com/Arcitec/GearScoreLite_Reborn).

**It penalizes BiS items.** Some of the best items in the game have low item levels. Dragonspine Trophy, Darkmoon Card: Greatness, class relics and librams — all genuine best-in-slot picks that GearScore undervalues because it only sees ilvl. Players avoid equipping their best gear because it *lowers* their score. That's a system working against itself.

**It has no concept of spec.** A frost mage in fire gear, a holy paladin wearing ret pieces, a warrior with a spell power trinket — all invisible to the formula. The addon's own creator admitted he "dropped any hope of determining if a player was using the correct stats" after dual spec was added.

**It doesn't understand stat caps.** Stacking 300 hit rating when you only need 142? GearScore counts every point at full value. Players can increase their score through upgrades that actively *hurt* their performance.

**PvP gear inflates PvE scores.** Resilience contributes to item level but is worthless in raids. Full Relentless PvP gear reads as 5300 GearScore — numbers that get you into progression content you're not actually geared for.

### What GearScore does to the community

The deeper problem isn't technical — it's behavioral. When an inaccurate number becomes the gating mechanism for group content:

- **The catch-22**: Groups demand scores higher than what the content drops. You need ICC gear to get into ICC.
- **Alts and returning players are frozen out**: Same skilled player, different character, suddenly can't find a group.
- **Score replaces evaluation**: Raid leaders use the number as a shortcut instead of inspecting gear, checking spec, or looking at enchants. The one thing GearScore was supposed to automate — it doesn't even do well.
- **Players game the system**: Equipping wrong-spec high-ilvl gear, avoiding low-ilvl BiS items, wearing PvP gear to PvE — all rational responses to a broken metric.
- **The number becomes identity**: "Pugs would rather take a 6k gearscored DPS doing 4k DPS than a 5.2k doing 7-8k." The community internalizes the score as a proxy for competence when it's barely a proxy for *gear quantity*.

## What TrueGearScore Does Differently

TrueGearScore can't fix human behavior. But it can make the number *honest* — so that when people use it to make decisions, those decisions are based on something real.

### Every stat point is weighted by spec

The scoring formula isn't `ilvl × rarity`. It's:

```
Score = Σ (stat_value × spec_weight) across all stat sources, for all equipped items
```

Each of the 27 class/specs has its own weight table sourced from established community simulations and theorycrafting (ClassicSim, WoWSims, class Discord pins, Elitist Jerks archives). Agility is worth more to a Combat Rogue than a Holy Paladin. Spell power matters for a Shadow Priest but not a Fury Warrior. The score reflects what the stats *mean* for the character wearing them.

### Gems and enchants count

TrueGearScore reads the full item link — base stats, socketed gems, and applied enchants — and scores all of it. A player with 151 gem cuts and 282 enchants in the database gets credit for the gold and effort they invested. Miss your enchants? Your score reflects the missing power. This is the single biggest accuracy improvement over traditional GearScore.

### Stat caps have diminishing returns

Hit rating past cap is nearly worthless. Expertise past the dodge cap is wasted. TrueGearScore's cap engine reduces the effective weight of stats as they approach or exceed their breakpoints. Over-capping *lowers* your score relative to someone who itemized correctly — as it should.

### Proc effects and trinkets are valued

Dragonspine Trophy isn't a low-ilvl blue to TrueGearScore. It's scored based on its average proc uptime converted to equivalent stat budget (~40 haste rating average). Twelve raid trinkets and proc items are currently valued, with coverage expanding to heroic dungeon trinkets, badge items, weapon procs, and on-use effects.

### PvE and PvP are scored separately

The addon auto-detects context (battleground/arena = PvP, otherwise PvE) and applies the appropriate weight set. Resilience counts in PvP. It doesn't inflate your PvE score. Manual toggle via `/tgs pvp`.

### Calibrated to existing expectations

Raid leaders already have mental benchmarks ("4500+ for Hyjal"). TrueGearScore is calibrated so that a fully optimized character lands at roughly the same number as TacoTip would give them. The scores diverge where they *should* — lower for missing gems/enchants, higher for correctly valued BiS items like DST. No recalibrating your mental model.

### Same number for everyone

Stat weights are hardcoded. There are no user-configurable weight overrides for the main score. When you see `[TGS: 2400]`, it means exactly the same thing regardless of who computed it. No version fragmentation, no "which GearScore addon are you using?" confusion.

### Works on everyone

TrueGearScore scores any player you can inspect — no addon required on their end. It captures full item links (with gems and enchants) directly from the inspect API. Players who also run TGS share scores instantly via addon messaging, no inspect range needed.

## What TrueGearScore Can't Fix

Honesty about limitations:

**Score is not skill.** A perfectly geared player who stands in fire will wipe your raid. TrueGearScore measures gear optimization, not encounter awareness, rotation execution, or cooldown management. It's one signal among many — treat it that way.

**Gatekeeping is a social problem.** A better number won't stop people from setting arbitrary thresholds. But when the number actually reflects gear quality, the threshold at least *means something*.

**Carried gear is invisible.** There's no way for any addon to distinguish between gear earned through skilled play and gear obtained through carries. The score reflects what's equipped, not how it got there.

## Commands

| Command | Description |
|---|---|
| `/tgs` | Print your PvE and PvP scores |
| `/tgs report [channel]` | Share score to party/raid/guild chat |
| `/tgs pvp` | Toggle PvP score display |
| `/tgs config` | Open options panel |
| `/tgs inspect` | Force score lookup on target |
| `/tgs help` | Command list |

## Display

- **Unit tooltips** — score shown on player mouseover
- **Character panel** — your own score on the paperdoll
- **Inspect frame** — score when inspecting another player
- **LFG integration** — scores shown in LFGBulletinBoard tooltips (soft dependency, no requirement)

## Installation

Download from [CurseForge](https://www.curseforge.com/wow/addons/truegearscore) or extract to your `Interface/AddOns/` directory.

No configuration required. Scores appear automatically on tooltips after login.

## Technical Details

- **27 spec-specific weight tables** sourced from community simulations
- **282 enchants**, **151 gem cuts**, **12 proc items** in curated databases
- **Cap-aware scoring** with soft and hard cap diminishing returns
- **Cross-spec calibration** anchored to reference BiS gear sets per content phase
- **AceComm-3.0** addon messaging for instant score sharing (GUILD/PARTY/RAID channels)
- **Anti-fake protection** — rejects scores above theoretical maximum for current content

## License

MIT — see [LICENSE](LICENSE).
