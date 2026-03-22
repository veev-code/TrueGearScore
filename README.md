# TrueGearScore

**A gear score addon that measures actual character power — not just item level.**

Accounts for gems, enchants, proc effects, set bonuses, and stat caps. Spec-aware, cap-aware, and calibrated to the numbers you already know.

- **Accurate** — Stat-weight scoring means the number reflects real power, not ilvl
- **Ungameable** — Wrong-spec gear, over-capped stats, and empty sockets all hurt your score
- **Zero setup** — Install and scores appear on tooltips automatically
- **Universal** — Scores any player you can inspect, no addon required on their end

---

## Key Features

### Spec-Aware Stat Weights

Every class/spec has its own weight table sourced from community simulations and theorycrafting (ClassicSim, WoWSims, Elitist Jerks archives, class Discord pins). Agility matters more to a Combat Rogue than a Holy Paladin. A warrior equipping a spell power trinket to inflate ilvl gets near-zero credit for those stats — the score reflects what actually helps your character.

### Gems, Enchants, and Set Bonuses

TrueGearScore reads the full item link — base stats, socketed gems, applied enchants — and scores all of it. Missing enchants? Empty sockets? Bad gem choices? Your score reflects the missing power. Players who invest in optimizing their gear are rewarded with a higher number.

### Cap-Aware Scoring

Hit rating past cap is nearly worthless. Expertise past the dodge cap is wasted. The cap engine reduces the effective weight of stats as they approach breakpoints. Over-capping lowers your score relative to someone who itemized correctly.

### Proc Effects and Trinkets

Dragonspine Trophy scores like BiS because it *is* BiS — valued by its average proc uptime converted to equivalent stat budget, not its item level. A curated database of raid trinkets, dungeon trinkets, and weapon procs ensures that low-ilvl powerhouses are scored for what they actually contribute.

### PvE and PvP Scoring

Auto-detects context — battleground or arena uses PvP weights, otherwise PvE. Resilience counts where it matters and doesn't inflate your raid score. Manual toggle via `/tgs pvp`.

### Calibrated to Existing Benchmarks

Raid leaders already have mental anchors for what scores mean. TrueGearScore is calibrated so that a fully optimized character lands at roughly the same number as TacoTip GearScore. Scores diverge where they *should* — lower for missing gems and enchants, higher for correctly valued BiS items. No need to recalibrate your mental model.

### Consistent Across Players

Stat weights are hardcoded. There are no user-configurable weight overrides for the main score. When you see `[TGS: 2400]`, it means exactly the same thing regardless of who computed it — no version fragmentation, no "which GearScore addon?" confusion.

### Instant Scores via Addon Messaging

Players who also run TrueGearScore share scores automatically via guild, party, and raid channels — no inspect range needed. For everyone else, a standard inspect captures full item data including gems and enchants.

---

## Display

- **Unit tooltips** — Score shown on player mouseover
- **Character panel** — Your own score on the paperdoll
- **Inspect frame** — Score when inspecting another player
- **LFG integration** — Scores shown in LFGBulletinBoard tooltips (soft dependency, works without it)

---

## Commands

| Command | Description |
|---|---|
| `/tgs` | Print your PvE and PvP scores |
| `/tgs report [channel]` | Share score to party/raid/guild chat |
| `/tgs pvp` | Toggle PvP score display |
| `/tgs config` | Open options panel |
| `/tgs inspect` | Force score lookup on target |

---

## How It Compares to Traditional GearScore

Traditional GearScore uses an `item level x rarity` formula. It doesn't look at gems, enchants, stat caps, proc effects, or set bonuses — and it has no concept of spec. This leads to well-documented problems:

- A player in full epics with empty sockets scores the same as one who spent thousands of gold optimizing
- BiS items with low ilvl (DST, Darkmoon cards, relics) are penalized, so players avoid equipping them
- Wrong-spec high-ilvl gear inflates the score, incentivizing players to game the system
- Stats past cap count at full value, rewarding over-capping that hurts actual performance
- PvP gear inflates PvE scores because resilience contributes to ilvl

TrueGearScore addresses each of these at the scoring level — not with warnings or workarounds, but by making the formula itself aware of what matters.

---

## A Tool, Not a Verdict

Gear score is a tool, and TrueGearScore does its best to make it an accurate one — reflecting actual character power and making it difficult to game. But what people do with the number is up to them.

**Score is not skill.** TrueGearScore measures gear optimization, not encounter awareness, rotation execution, or cooldown management. It's one signal among many.

**Gatekeeping is a social problem.** A better number won't stop people from setting arbitrary thresholds. But when the number reflects actual gear quality, the threshold at least *means something*.

---

## Current Status

TrueGearScore currently supports **TBC Anniversary Edition**. All 27 class/specs have stat weights, and the curated databases cover the majority of TBC enchants, gems, proc items, and set bonuses. Active development is ongoing — database coverage and display features are expanding with each release.

---

## Feedback & Contributions

If you find scoring issues, missing items, or have suggestions, please report them. Stat weight corrections with sim data or theorycrafting sources are especially welcome.

Join the **Veev Addons Discord**: [https://discord.gg/HuSXTa5XNq](https://discord.gg/HuSXTa5XNq)

---

## License

MIT — see [LICENSE](LICENSE).
