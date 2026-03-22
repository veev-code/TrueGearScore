# TrueGearScore

**A gear score addon that measures actual character power — not just item level.**

Accounts for gems, enchants, proc effects, set bonuses, and stat caps. Spec-aware, cap-aware, and calibrated to the numbers you already know.

- **Accurate** — Stat-weight scoring means the number reflects real power, not ilvl
- **Ungameable** — Wrong-spec gear, over-capped stats, and empty sockets all hurt your score
- **Zero setup** — Install and scores appear on tooltips automatically
- **Universal** — Scores any player you can inspect, no addon required on their end

---

## Features

### Spec-Aware Stat Weights

Every class/spec has its own weight table sourced from community simulations and theorycrafting (ClassicSim, WoWSims, Elitist Jerks archives, class Discord pins). A warrior equipping a spell power trinket to inflate ilvl gets near-zero credit for those stats — the score reflects what actually helps your character.

Feral druids are automatically scored as both cat DPS and bear tank — whichever role the equipped gear scores higher with is used.

### Gems, Enchants, and Set Bonuses

TrueGearScore reads the full item link — base stats, socketed gems, applied enchants — and scores all of it. Missing enchants? Empty sockets? Bad gem choices? Your score reflects the missing power.

Set bonuses (tier sets and notable non-tier sets) are valued as equivalent stat budgets, so wearing 4pc T6 is reflected in the number.

### Cap-Aware Scoring

Hit rating past cap is nearly worthless. Expertise past the dodge cap is wasted. The cap engine reduces the effective weight of stats as they approach breakpoints. Over-capping lowers your score relative to someone who itemized correctly.

### Proc Effects and Trinkets

Dragonspine Trophy scores like BiS because it *is* BiS — valued by its average proc uptime converted to equivalent stat budget, not its item level. A curated database of ~92 raid trinkets, dungeon trinkets, and weapon procs ensures that low-ilvl powerhouses are scored for what they actually contribute.

### PvE and PvP Scoring

Auto-detects context — battleground or arena uses PvP weights, otherwise PvE. Resilience counts where it matters and doesn't inflate your raid score.

### Calibrated to Existing Benchmarks

TrueGearScore is calibrated so that a fully optimized character lands at roughly the same number as TacoTip GearScore. Scores diverge where they *should* — lower for missing gems and enchants, higher for correctly valued BiS items.

### Consistent Across Players

Stat weights are hardcoded. There are no user-configurable weight overrides for the main score. When you see a TrueGearScore number, it means exactly the same thing regardless of who computed it.

### Instant Scores via Addon Messaging

Players who also run TrueGearScore share scores automatically via guild, party, and raid channels — no inspect range needed. For everyone else, a standard inspect captures full item data.

---

## Display

- **Unit tooltips** — Score shown on player mouseover
- **Character panel** — Your own score on the paperdoll
- **Inspect frame** — Score when inspecting another player
- **Item tooltips** — Per-item score on item mouseover (optional, default off)
- **LFG integration** — Scores shown in LFGBulletinBoard tooltips (soft dependency, works without it)

---

## Installation

1. Download and extract into your `Interface/AddOns/` folder
2. The folder should be named `TrueGearScore`
3. Restart WoW or `/reload` if already logged in

No configuration required — scores appear on tooltips immediately. Customize display options via `/tgs config` or the Interface > AddOns panel.

---

## Commands

| Command | Description |
|---|---|
| `/tgs` | Print your score |
| `/tgs report [channel]` | Share score to party/raid/guild/say chat |
| `/tgs breakdown` | Per-slot score breakdown |
| `/tgs config` | Open options panel |
| `/tgs rescan` | Force gear rescan |
| `/tgs debug` | Toggle debug mode |
| `/tgs help` | Full command list |

---

## How Scoring Works

Every stat on every equipped item is multiplied by a weight specific to your class and spec. Gems, enchants, proc effects, and set bonuses are all included. Stats approaching their cap (like hit rating) are progressively devalued. The result is a single number that reflects actual gearing quality.

All 27 class/specs have dedicated weight tables. Cross-spec normalization ensures a well-geared mage and a well-geared warrior with equivalent quality gear land at comparable scores.

---

## Current Status

TrueGearScore supports **TBC Anniversary Edition**. All 27 class/specs have stat weights, and the curated databases cover 282 enchants, 151 gems, 92 proc items, and 57 set bonus sets. Active development is ongoing.

---

## Feedback & Contributions

If you find scoring issues, missing items, or have suggestions, please report them. Stat weight corrections with sim data or theorycrafting sources are especially welcome.

Join the **Veev Addons Discord**: [https://discord.gg/HuSXTa5XNq](https://discord.gg/HuSXTa5XNq)

---

## License

MIT — see [LICENSE](LICENSE).
