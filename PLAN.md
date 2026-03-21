# TrueGearScore — Addon Plan

## Vision

A gear score addon that measures **actual character power** — not just item level. Accounts for gems, enchants, item procs/equip effects, stat caps, and spec context. A Dragonspine Trophy should score like BIS because it *is* BIS, not like a low-ilvl blue.

## Name

**TrueGearScore** — keeps "GearScore"/"GS" in the name for community familiarity. Slash command: `/tgs`. Addon message prefix: `"TGS"`.

---

## Scoring Formula

```
Score = Σ (stat_value × stat_weight) across all sources per item
```

**Sources per item:**
1. Base item stats (via `GetItemStats()`)
2. Socketed gem stats
3. Enchant stats (from curated enchant database)
4. Proc/equip effect equivalent stats (from curated proc database)

**Stat weights:**
- Hardcoded per class/spec — consistent between all players (no user overrides for the main score)
- **Cap-aware**: Stats like hit rating diminish in value once the player approaches or exceeds cap. Haste breakpoints respected.
- **PvE vs PvP aware**: Resilience/stamina valued differently in PvP context. The addon should be able to produce both a PvE score and a PvP score.
- Sourced from established sim data, class Discord consensus, and community research (ClassicSim, Guybrush spreadsheets, Fight Club, etc.)

---

## Data Files (shipped with addon)

### Stat Weights (`StatWeights.lua`)
- Per-class, per-spec weight tables
- PvE and PvP weight sets
- Cap thresholds per stat (e.g., hit cap = 142 for melee vs casters)

### Proc Database (`ProcDatabase.lua`)
- Maps item IDs → equivalent stat budget from proc/equip effects
- Launch scope: raid trinkets + weapons with notable procs (~30-50 items)
- Goal: expand to dungeon/world trinkets, crafted items (~100-150)
- Research-driven: based on proc uptime sims and community data
- Example: `[28830] = { class = "PHYSICAL", stats = { HASTE_RATING = 40 } } -- DST avg uptime`

### Enchant Database (`EnchantDatabase.lua`)
- Maps enchant IDs → stat contributions
- ~60-80 entries for all relevant TBC enchants
- Needed because `GetItemStats()` doesn't include enchant stats in Classic

### Gem Database (`GemDatabase.lua`)
- Maps gem item IDs → stat contributions
- ~100 entries for all gem cuts
- Fallback if API doesn't expose gem stats directly

### Set Bonus Database (`SetBonusDatabase.lua`)
- Maps set ID + piece count (2pc/4pc) → equivalent stat budget
- Per-spec valuations (e.g., T6 4pc valued differently for Shadow vs Holy Priest)
- Covers tier sets and notable non-tier sets (e.g., Spellstrike)

---

## Score Calibration

TacoTip's GearScore is the current community standard — everyone has those numbers as mental context ("4500+ for Hyjal"). TrueGearScore should produce **roughly proportional numbers** to TacoTip for well-geared players.

**Calibration strategy**: Assume TacoTip's score implicitly reflects full gems/enchants (since it ignores them, it neither rewards nor penalizes). Tune TrueGearScore weights so that a fully BIS character with proper gems/enchants lands at approximately the same number as TacoTip would give them.

**Where scores diverge**:
- **Lower than TacoTip**: Player has empty sockets, missing enchants, bad gem choices → TrueGearScore correctly reflects the missing power
- **Higher than TacoTip**: Player has a low-ilvl BIS item (e.g., DST) that TacoTip undervalues → TrueGearScore correctly reflects the real power

This means raid leaders don't need to recalibrate their benchmarks, and adoption is frictionless.

**Calibration method**: For each content phase, take reference characters (full BIS per spec, properly gemmed/enchanted), compute both TacoTip and TrueGearScore numbers, and adjust weight scaling factors until they roughly align.

---

## Display Surfaces

### Core (launch)
- **Unit tooltip** (mouseover players) — primary display, shows TrueGS score
- **Character panel / paperdoll** — your own score on character sheet
- **Inspect frame** — score shown when inspecting another player

### Item tooltip (optional, default off)
- Per-item score shown on item mouseover
- Toggle in options

### Group formation surfaces (launch)
- **LFG channel auto-append** — when you post in LookingForGroup, addon appends `[TGS: 4850]` to your message. Visible to all players, no extra spam since you're already posting.
- **Raid UI** — score shown alongside raid member frames or tooltips
- **LFGBulletinBoard integration** — hook `EntryFrameMixin:OnEnter` and `GameTooltip:OnTooltipSetUnit` to inject score into request tooltips. No hard dependency on LFGBB — just hooks if it's loaded.

### Chat
- `/tgs` — print your own score
- `/tgs report` — share to party/raid/guild chat

---

## Data Sharing Protocol

### Addon Message Channel (players with TGS)
- **Prefix**: `"TGS"`
- **Library**: AceComm-3.0 (handles serialization, chunking, throttle)
- **Channels**: GUILD, PARTY, RAID
- **Payload**: Score number + player GUID + timestamp
- **Trigger**: Broadcast own score on login, group join, gear change
- **Benefit**: Instant score lookup for other TGS users without needing inspect range

### Inspect Fallback (players without TGS)
- On mouseover/inspect, fire `NotifyInspect(unit)`
- Capture full item links via `GetInventoryItemLink(unit, slot)` during `INSPECT_READY`
- Compute score client-side, cache with TTL
- Works for any player regardless of addon — just requires inspect range (~30 yards)

### Gossip Protocol (phase 2)
- Players share cached scores for *other* players they've previously inspected
- Query-response model: "who knows Player B's score?" → cached response
- Staleness TTL — scores expire after N minutes
- Throttled, batched payloads
- Priority: GUILD for bulk sync, RAID/PARTY for group contexts

---

## Anti-Fake Protection

- **Sanity bounds**: Reject scores above theoretical maximum for current phase (full BIS + perfect gems/enchants)
- **Per-phase caps**: Update max plausible score each content phase
- **Stretch goal**: Block/report players broadcasting consistently impossible scores

---

## Scoring Other Players — Data Availability

- **Self**: `GetInventoryItemLink("player", slot)` → full item link with gems, enchants, everything. Full-fidelity score.
- **Inspected players**: `GetInventoryItemLink(unit, slot)` during active inspect → full item link. Full-fidelity score. Works for ALL players (no addon needed).
- **TGS addon users (not in range)**: Score received via addon message. Trusted but unverifiable.
- **LibClassicInspector note**: LCI only caches item IDs (not full links). TrueGearScore hooks `INSPECT_READY` directly to capture full links.

---

## Architecture

```
TrueGearScore/
├── TrueGearScore.toc
├── CLAUDE.md
├── CHANGELOG.md
├── .pkgmeta
├── .github/workflows/release.yml
├── Core/
│   ├── Core.lua                -- Addon init, module registration, slash commands
│   ├── Constants.lua           -- Score brackets, color tables, phase caps, defaults
│   └── Database.lua            -- AceDB wrapper, saved variables, cache
├── Scoring/
│   ├── StatWeights.lua         -- Per-class/spec stat weight tables (PvE + PvP)
│   ├── ItemScoring.lua         -- Score computation: base stats + gems + enchants + procs
│   ├── CapEngine.lua           -- Stat cap / diminishing returns logic
│   └── ScoreCache.lua          -- Per-player score cache with TTL
├── Data/
│   ├── ProcDatabase.lua        -- Item ID → equivalent stat budget for procs/equip effects
│   ├── EnchantDatabase.lua     -- Enchant ID → stat contributions
│   ├── GemDatabase.lua         -- Gem ID → stat contributions
│   └── SetBonusDatabase.lua    -- Set ID + piece count → equivalent stat budget
├── Inspect/
│   ├── InspectHandler.lua      -- INSPECT_READY hook, full item link capture
│   └── SelfScanner.lua         -- Player's own gear scanning, triggers on equip change
├── Communication/
│   ├── AddonChannel.lua        -- AceComm broadcast/receive own + others' scores
│   └── GossipProtocol.lua      -- Phase 2: query/response for third-party scores
├── Display/
│   ├── UnitTooltip.lua         -- GameTooltip:OnTooltipSetUnit hook
│   ├── ItemTooltip.lua         -- Item tooltip score display (optional)
│   ├── Paperdoll.lua           -- Character panel score display
│   ├── InspectFrame.lua        -- Inspect frame score display
│   ├── RaidFrame.lua           -- Raid UI integration
│   ├── LFGIntegration.lua      -- LFG channel auto-append + LFGBB tooltip hooks
│   └── ScoreColors.lua         -- Score → color bracket mapping
├── UI/
│   └── Options.lua             -- AceConfig options panel
├── Libs/
│   └── embeds.xml              -- Library loader
└── Tools/
    └── fetch-libs.sh           -- Fetch library externals for local dev
```

---

## Dependencies

- **LibStub** — library loader
- **AceAddon-3.0, AceDB-3.0, AceEvent-3.0, AceConsole-3.0** — addon framework
- **AceComm-3.0, AceSerializer-3.0** — addon message communication
- **LibClassicInspector** — inspect triggering and unit inventory access (supplemented by our own INSPECT_READY hook for full links)
- **AceConfig-3.0, AceGUI-3.0, AceDBOptions-3.0** — options panel
- **LibDeflate** (optional) — compression for gossip protocol payloads

All libraries fetched via `.pkgmeta` externals (same pattern as VeevHUD).

---

## Release Pipeline

Mirrors VeevHUD: `.pkgmeta` + `.github/workflows/release.yml` using `BigWigsMods/packager@v2`. Tags trigger CurseForge upload. Independent repo, independent release cycle.

---

## Resolved Decisions

- **PvE vs PvP**: Auto-detect (BG/arena → PvP score, else PvE) with manual `/tgs pvp` toggle. Show one score at a time — don't clutter tooltips with both.
- **Set bonuses**: Include. Tier set bonus 2pc/4pc adds equivalent stat budget to score. Requires a set bonus database.
- **Phase detection**: Deferred. Anti-fake uses a single expansion-wide max (full Sunwell BIS) rather than per-phase caps.
- **LibSpellDB**: Not used for scoring data. Proc/enchant/gem/set bonus databases are TrueGearScore-internal. The data is scoring-specific (equivalent stat budgets, proc uptimes) — not general spell metadata.
- **Score calibration**: Tuned proportional to TacoTip GearScore. See "Score Calibration" section above.

## Open Questions

1. **Gossip protocol details**: Deferred to Sprint 5. Needs careful design around bandwidth, staleness, and trust.
2. **Stat weight validation**: Cross-reference our weights against Pawn's `ScaleTemplates.lua` for correctness. Pawn has battle-tested per-spec weights.

---

## Implementation Sprints

### Phase 1 — Core Scoring + Self Display ✅ DONE

Committed and pushed. Working:
- Scoring engine (two-pass, cap-aware, calibrated)
- Static databases: 282 enchants, 151 gems, 12 proc items
- Self-scanner with gear change detection
- Paperdoll display, `/tgs` slash command
- WCLogs-inspired color brackets (Blue=heroic blues naked, Epic=Kara epics naked)
- Structured logging, spec detection for all 27 specs
- Reference gear sets for calibration (Priest Healer, Pre-Raid through Sunwell)

### Sprint 2 — Inspect + Unit Tooltip

Highest user impact — see other players' scores.

| Item | Files | Deps | Size |
|---|---|---|---|
| **ScoreCache** | `Scoring/ScoreCache.lua` (new) | None | S |
| **InspectHandler** | `Inspect/InspectHandler.lua` (new) | ScoreCache | M |
| **UnitTooltip** | `Display/UnitTooltip.lua` (new) | ScoreCache, InspectHandler | M |
| **InspectFrame** | `Display/InspectFrame.lua` (new) | InspectHandler | S |
| **Cleanup** | Remove debug auto-run code from `Core/Core.lua` | All above | S |

Key: InspectHandler hooks `INSPECT_READY` directly (NOT LibClassicInspector's cache) to get full item links with gems/enchants. Inspect queue with 1s throttle. Spec detection for inspected players via `GetTalentTabInfo(tab, true, true)`.

### Sprint 3 — Communication + Group Surfaces

Social visibility — scores where groups form.

| Item | Files | Deps | Size |
|---|---|---|---|
| **AceComm setup** | `Libs/embeds.xml`, `.pkgmeta`, `Tools/fetch-libs.sh` | None | S |
| **AddonChannel** | `Communication/AddonChannel.lua` (new) | ScoreCache | M |
| **LFG UI integration** | `Display/LFGIntegration.lua` (new) | ScoreCache | M |
| **`/tgs report`** | `Core/SlashCommands.lua` | SelfScanner | S |

LFG integration: show known scores next to player names in LFG UI elements (Blizzard LFG tool, LFGBulletinBoard if loaded). NOT auto-appending to chat messages. Soft dependency on LFGBB — hooks only if loaded.

AddonChannel: AceComm prefix "TGS", broadcast own score on login/group join/gear change. Anti-fake: reject scores above MAX_PLAUSIBLE_SCORE.

### Sprint 4 — Item Tooltip + Data Quality

| Item | Files | Deps | Size |
|---|---|---|---|
| **ItemTooltip** | `Display/ItemTooltip.lua` (new) | SelfScanner | S |
| **Socket bonus scoring** | `Scoring/ItemScoring.lua` | GemDatabase (needs color field) | M |
| **Data validation script** | `Tools/validate_data.py` (new) | None | S |
| **Pre-commit hook** | `.githooks/pre-commit` (new) | validate_data | S |
| **Stat weight validation** | Cross-ref against Pawn `ScaleTemplates.lua` | None | M |

### Sprint 5 — Set Bonuses + PvP + Options

| Item | Files | Deps | Size |
|---|---|---|---|
| **SetBonusDatabase** | `Data/SetBonusDatabase.lua` (new), `Scoring/ItemScoring.lua` | None | M |
| **PvP stat weights** | `Scoring/StatWeights.lua` | None | L |
| **PvE/PvP auto-detect** | `Core/Core.lua`, `Inspect/SelfScanner.lua` | PvP weights | S |
| **Options panel** | `UI/Options.lua` (new) | All display modules | M |

Set bonus detection uses `GetItemInfo()[16]` for setID (confirmed working). SetBonusDatabase maps `{setID, pieceCount}` to equivalent stat budgets per spec.

### Sprint 6 — Gossip + Polish

| Item | Files | Deps | Size |
|---|---|---|---|
| **GossipProtocol** | `Communication/GossipProtocol.lua` (new) | AddonChannel, ScoreCache | L |
| **Anti-fake hardening** | `Communication/AddonChannel.lua` | GossipProtocol | M |
| **More reference sets** | `Data/ReferenceSets.lua` | None | M |
| **Proc DB expansion** (12 → 80) | `Data/ProcDatabase.lua` | None | L |
| **RaidFrame inline scores** (optional) | `Display/RaidFrame.lua` (new) | ScoreCache | M |

### Pre-Release Cleanup (before any public release)

- Remove `RunAPIDiscovery()` from `Core/Core.lua`
- Remove auto-print/auto-calibrate `C_Timer.After` blocks from `Core/Core.lua`
- Remove `RunCalibration()` auto-run (keep as `/tgs calibrate` command)
- Verify all debug logging is gated behind `debugMode`
