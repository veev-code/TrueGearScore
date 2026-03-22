# TrueGearScore — Addon Context

TrueGearScore is a gear score addon for World of Warcraft (TBC Classic / Anniversary Edition) that measures **actual character power** — not just item level. Unlike traditional GearScore which uses an ilvl × rarity formula, TrueGearScore accounts for gems, enchants, item procs/equip effects, set bonuses, and stat caps. A Dragonspine Trophy scores like BIS because it *is* BIS.

## Key Principles

- **Stat-weight-based scoring**: Every stat point is multiplied by a per-spec weight. The sum across all items is the score.
- **Cap-aware**: Hit rating (and other capped stats) diminish in value as the player approaches cap. No double-counting past breakpoints.
- **PvE / PvP dual scoring**: Auto-detects context (BG/arena → PvP weights, otherwise PvE).
- **Calibrated to TacoTip**: Fully BIS characters with proper gems/enchants score roughly the same as TacoTip GearScore. Scores diverge when players are missing gems/enchants (lower) or have low-ilvl BIS items like DST (higher).
- **Works on everyone**: Scores any player via inspect — no addon required on their end. Addon-to-addon communication provides instant scores without inspect range.
- **Hardcoded weights**: No user-configurable weights for the main score. Everyone sees the same number for the same gear. Consistent, comparable, no debates.

## Stat Weight Rules (MUST follow)

Stat weights are the foundation of TrueGearScore's accuracy. These rules are non-negotiable:

1. **Data-driven, not guessed.** Every spec's weights MUST be sourced from established community simulations, spreadsheets, or theorycrafting (ClassicSim, WoWSims, Simonize spreadsheet, EnhanceShaman.com, RetSim, Landsoul spreadsheet, Zephan/Leulier warlock spreadsheet, class Discord pins, Elitist Jerks archives). Cite sources in code comments. Never invent weights without a reference.

2. **Cross-spec normalization via SPEC_SCALE.** A Kara-geared mage must score the same as a Kara-geared warrior with equivalent quality gear. This is enforced by `SPEC_SCALE[specKey]` — a per-spec multiplier computed from reference BIS gear sets. Every spec that has a SPEC_SCALE value MUST have a corresponding P1 reference BIS set in `Data/ReferenceSets.lua`. **Never estimate SPEC_SCALE** — always compute it from `/tgs calibrate` with real item data.

3. **Calibration anchor.** PRIEST_DISC P1 BIS base score is the anchor (SPEC_SCALE = 1.000). All other specs' P1 BIS base scores are normalized to match this anchor. The formula: `SPEC_SCALE[spec] = PRIEST_DISC_P1_base / spec_P1_base`.

4. **Reference BIS sets required.** Every spec that appears in SPEC_SCALE must have at least a P1 BIS reference set in `Data/ReferenceSets.lua`. If a spec shares gear with another (e.g., MAGE_ARCANE uses same items as MAGE_FIRE), it can share the scale factor, but this must be documented.

5. **Recalibrate after any change.** When stat weights, stat key mappings, or the scoring pipeline change, ALL SPEC_SCALE values must be recomputed via `/tgs calibrate`. Stale SPEC_SCALE values produce incorrect cross-class comparisons.

6. **Stat key mappings must be exhaustive.** Anniversary Edition uses variant key names from `GetItemStats()` (e.g., `ITEM_MOD_HIT_RATING` without `_SHORT`, `ITEM_MOD_HIT_SPELL_RATING` for spell hit, `ITEM_MOD_MELEE_ATTACK_POWER_SHORT` for melee AP). All variants must be mapped in `Constants.STAT_REVERSE`. Missing mappings silently drop stats and corrupt scores. Run `/tgs statkeys` to audit.

## Scoring Formula

```
Score = Σ (stat_value × stat_weight) across all sources per item, for all equipped items
```

**Sources per item:**
1. Base item stats (`GetItemStats()`)
2. Socketed gem stats
3. Enchant stats (from EnchantDatabase)
4. Proc/equip effect equivalent stats (from ProcDatabase — e.g., DST proc ≈ 40 haste avg)
5. Set bonus equivalent stats (from SetBonusDatabase — e.g., T6 4pc value per spec)

**Weight adjustments:**
- Stats below cap: full weight
- Stats at/above cap: reduced weight (near-zero for hard caps like hit, soft diminishment for others)

**Feral Druid dual-role scoring:**
Feral is the only spec with two distinct roles (cat DPS / bear tank) under one talent tree. Talent detection returns `DRUID_FERAL`, but the weight tables are split into `DRUID_FERAL_CAT` and `DRUID_FERAL_BEAR`. When `ScoreCharacter` receives `DRUID_FERAL`, it scores with both weight tables and returns whichever produces the higher score. The gear self-selects: tank gear (STAM/DEF/DODGE) → bear weights win, DPS gear (AGI/CRIT/AP) → cat weights win. The resolved sub-spec (`specKey`) is propagated through the result, SelfScanner, AddonChannel broadcast, and ScoreCache. Display modules can distinguish "Feral (Cat)" from "Feral (Bear)" via the cached `specKey`.

## File Structure

### Root
- `TrueGearScore.toc` — TOC file
- `CLAUDE.md`, `README.md`, `CHANGELOG.md`, `PLAN.md`
- `LICENSE` — MIT license
- `.pkgmeta` — CurseForge packaging
- `.github/workflows/release.yml` — CI release workflow
- `.githooks/pre-commit` — Pre-commit hook running `Tools/validate_data.py`

### Core (`Core/`)
- `Core.lua` — Addon init, module registration, spec detection, logging
- `SlashCommands.lua` — All `/tgs` subcommands including calibration
- `Constants.lua` — Score brackets, color tables, expansion-wide score cap, timing constants, `C.DEFAULTS.profile`
- `Database.lua` — AceDB wrapper: profiles, saved variables, settings
- `ScoreValidation.lua` — Shared anti-fake validation utilities (plausibility checks, suspicious rapid-change detection) used by AddonChannel and GossipProtocol

### Scoring (`Scoring/`)
- `StatWeights.lua` — Per-class/spec stat weight tables (PvE + PvP sets), stat cap thresholds
- `ItemScoring.lua` — Core scoring engine: takes item link → computes score from base stats + gems + enchants + procs + set bonuses
- `CapEngine.lua` — Stat cap / diminishing returns logic. Given current total stats, returns effective weight for next point of each stat.
- `ScoreCache.lua` — Per-player score cache with TTL expiry

### Data (`Data/`)
- `ProcDatabase.lua` — Item ID → equivalent stat budget for procs/equip effects (~92 items)
- `EnchantDatabase.lua` — Enchant ID → stat contributions (~282 TBC enchants)
- `GemDatabase.lua` — Gem item ID → stat contributions (~151 gem cuts)
- `SetBonusDatabase.lua` — Set ID + piece count (2pc/4pc) → equivalent stat budget per spec (~57 sets)
- `ReferenceSets.lua` — Per-spec BIS gear sets for calibration (~138 sets across P1/P2/heroic variants)

### Inspect (`Inspect/`)
- `InspectHandler.lua` — Hooks `INSPECT_READY` to capture full item links via `GetInventoryItemLink(unit, slot)` (includes gems/enchants). Caches results.
- `SelfScanner.lua` — Scans player's own gear, triggers on equip change (`PLAYER_EQUIPMENT_CHANGED`)

### Communication (`Communication/`)
- `AddonChannel.lua` — AceComm-3.0 broadcast/receive. Prefix `"TGS"`. Broadcasts own score to GUILD/PARTY/RAID on login, group join, gear change. Receives and caches other TGS users' scores.
- `GossipProtocol.lua` — Phase 2: share cached third-party scores via query/response protocol

### Display (`Display/`)
- `UnitTooltip.lua` — `GameTooltip:OnTooltipSetUnit` hook. Shows score on player mouseover.
- `ItemTooltip.lua` — Per-item score on item mouseover (optional, default off)
- `Paperdoll.lua` — Player's own score on character panel
- `InspectFrame.lua` — Score on inspect frame
- `LFGIntegration.lua` — Hooks LFGBulletinBoard tooltips to show scores if LFGBB is loaded (soft dependency, no chat message modification).
- `ScoreColors.lua` — Score → color bracket mapping (gradient from grey → green → blue → purple → orange, calibrated to TacoTip brackets)

### UI (`UI/`)
- `Options.lua` — AceConfig options panel

### Other
- `Libs/embeds.xml` — Library loader (library sources fetched by `.pkgmeta` externals)
- `Tools/fetch-libs.sh` — Fetches all library externals into `Libs/` for local development
- `Tools/validate_data.py` — Data validator for gem/enchant/proc databases (duplicate IDs, invalid stat keys, range checks)

## Architecture

### Scoring Pipeline

```
Item Link
  → Parse: base stats (GetItemStats), enchant ID, gem IDs, item ID
  → Look up: EnchantDatabase[enchantID], GemDatabase[gemID], ProcDatabase[itemID]
  → Sum all stat contributions
  → For each stat: effective_weight = CapEngine:GetEffectiveWeight(stat, currentTotal, specWeights)
  → item_score = Σ (stat_value × effective_weight)

Character Score = Σ item_score + SetBonusDatabase contributions
```

### Inspect Data Flow

```
Mouseover/Inspect target
  → Check ScoreCache (have recent score?)
    → Yes: display cached score
    → No: check AddonChannel cache (TGS user?)
      → Yes: display addon-shared score
      → No: fire NotifyInspect(unit)
        → INSPECT_READY fires
        → GetInventoryItemLink(unit, slot) for all 18 slots (FULL links with gems/enchants)
        → Run scoring pipeline
        → Cache result
        → Display score
```

### Self-Scoring Flow

```
PLAYER_EQUIPMENT_CHANGED / PLAYER_ENTERING_WORLD
  → SelfScanner reads all equipped item links
  → Runs scoring pipeline
  → Updates display (paperdoll, cached score)
  → Broadcasts via AddonChannel
```

### Communication Protocol

- **Prefix**: `"TGS"` via AceComm-3.0
- **Channels**: GUILD, PARTY, RAID
- **Payload**: `{ score = number, guid = string, timestamp = number, pvpScore = number }`
- **Triggers**: Login, group join, gear change
- **Anti-fake**: Reject scores above expansion-wide theoretical maximum (full Sunwell BIS, perfect gems/enchants)

## Data Access Patterns

### Self (full fidelity)
`GetInventoryItemLink("player", slot)` → full item link with gems, enchants, suffixes.

### Inspected Players (full fidelity)
`GetInventoryItemLink(unit, slot)` during active `INSPECT_READY` → full item link. Works for ALL players regardless of addon. Requires inspect range (~30 yards).

**Important**: LibClassicInspector only caches item IDs (line 2842 of its source), NOT full links. TrueGearScore hooks `INSPECT_READY` directly to capture the full links before the inspect session ends.

### TGS Addon Users (score only, no inspect needed)
Score received via addon message channel. Instant, no range limit within channel scope (guild-wide, party/raid-wide).

## Dependencies

All libraries fetched via `.pkgmeta` externals (same pattern as VeevHUD). NOT committed to git — `Libs/*/` is gitignored.

- **LibStub** — library loader
- **CallbackHandler-1.0** — callback/event dispatch for libraries
- **AceAddon-3.0, AceDB-3.0, AceEvent-3.0, AceConsole-3.0** — addon framework
- **AceHook-3.0** — hook management (used by display modules)
- **AceComm-3.0, AceSerializer-3.0** — addon message communication
- **AceConfig-3.0, AceGUI-3.0, AceDBOptions-3.0** — options panel

**Optional runtime dependency** (not in `.pkgmeta`):
- **LibClassicInspector** — used opportunistically for spec detection on inspected players (via `LibStub:GetLibrary("LibClassicInspector", true)`). Not required — falls back to talent-tab heuristic if absent.

**Local dev**: `bash Tools/fetch-libs.sh` → test → release in same session.

## Slash Commands

`/tgs` or `/truegearscore`:
- *(no args)* — Print your own score (base + bonus breakdown)
- `report [channel]` — Share score to party/raid/guild/say chat (auto-detects channel if omitted)
- `breakdown` — Per-slot score breakdown with stat-level detail in log
- `spec` — Show detected spec
- `rescan` — Force gear rescan
- `statkeys` — Audit `GetItemStats()` keys for unmapped entries
- `diag` — Run full diagnostic (item parse, stat mapping, sample scoring — logs to SavedVariables)
- `calibrate` — Score all reference BIS sets and output SPEC_SCALE factors
- `log [n]` — Show recent log entries (default 30)
- `clearlog` — Clear log
- `config` / `options` — Open options panel
- `debug` — Toggle debug mode
- `help` — Command list

## Constants

### Score Color Brackets
Calibrated to match TacoTip's bracket feel. Exact thresholds TBD after weight tuning.

### Stat Keys
Uses WoW's internal stat keys from `GetItemStats()`:
`ITEM_MOD_AGILITY_SHORT`, `ITEM_MOD_STRENGTH_SHORT`, `ITEM_MOD_INTELLECT_SHORT`, `ITEM_MOD_SPIRIT_SHORT`, `ITEM_MOD_STAMINA_SHORT`, `ITEM_MOD_HIT_RATING_SHORT`, `ITEM_MOD_CRIT_RATING_SHORT`, `ITEM_MOD_HASTE_RATING_SHORT`, `ITEM_MOD_SPELL_POWER_SHORT`, `ITEM_MOD_ATTACK_POWER_SHORT`, `ITEM_MOD_DEFENSE_RATING_SHORT`, `ITEM_MOD_DODGE_RATING_SHORT`, `ITEM_MOD_PARRY_RATING_SHORT`, `ITEM_MOD_BLOCK_RATING_SHORT`, `ITEM_MOD_RESILIENCE_RATING_SHORT`, `ITEM_MOD_EXPERTISE_RATING_SHORT`, `ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT`, `ITEM_MOD_SPELL_PENETRATION_SHORT`, `ITEM_MOD_MANA_REGENERATION_SHORT`

## Code Conventions

- Modules: `local M = {}; M.addon = addon; addon:RegisterModule("Name", M)`
- Events: via AceEvent-3.0 mixin
- Config: AceDB-3.0 with metatable defaults — never use inline fallbacks
- All defaults in `Constants.DEFAULTS.profile`
- Data files are pure Lua tables — easy to diff, review, and community-contribute
- No hardcoded English strings in scoring logic
- Score numbers are always integers (floored)
- **Localization**: The addon must WORK correctly on all WoW client localizations (enUS, deDE, frFR, esES, ruRU, koKR, zhCN, zhTW, etc.) even if UI text/labels haven't been customized per locale. This means: never match against English tooltip text or spell names in logic paths; use WoW API return values (item IDs, stat keys, spell IDs, numeric values) and localized global strings (e.g., `ITEM_SOCKET_BONUS`) instead. Socket bonus detection uses `GetItemStats()` differential, not tooltip parsing. Display strings shown to users (labels, bracket names) are English-only for now but must never appear in logic/scoring code paths.

## Release Pipeline

Independent repo. Mirrors VeevHUD: `.pkgmeta` + `.github/workflows/release.yml` using `BigWigsMods/packager@v2`. Tags trigger CurseForge upload.
