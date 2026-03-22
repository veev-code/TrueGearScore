#!/usr/bin/env python3
"""
TrueGearScore Data Validator
Validates GemDatabase.lua, EnchantDatabase.lua, ProcDatabase.lua, and SetBonusDatabase.lua for:
  - Duplicate IDs within each database
  - Invalid stat key names
  - Non-positive stat values
  - ID range sanity (gems: 20000-40000, enchants: 1-4000)
  - Empty stat tables (warning only)

Exit code 0 = clean, 1 = errors found.

Usage:
    python Tools/validate_data.py              # run from addon root
    python Tools/validate_data.py --verbose    # show per-file summaries
"""

import re
import sys
import os
from pathlib import Path

# ---------------------------------------------------------------------------
# Valid stat keys (from Constants.lua STAT_KEYS + STAT_REVERSE extras)
# ---------------------------------------------------------------------------

VALID_STAT_KEYS = {
    "STRENGTH", "AGILITY", "STAMINA", "INTELLECT", "SPIRIT",
    "HIT_RATING", "CRIT_RATING", "HASTE_RATING",
    "SPELL_POWER", "HEAL_POWER", "ATTACK_POWER",
    "DEFENSE", "DODGE", "PARRY",
    "BLOCK_RATING", "BLOCK_VALUE",
    "RESILIENCE", "EXPERTISE",
    "ARMOR_PEN", "SPELL_PEN",
    "MP5", "ARMOR",
}

# Additional keys that appear in data files but aren't scored stats.
# These are allowed without error (warnings only if --verbose).
KNOWN_NON_STAT_KEYS = {
    "WEAPON_DAMAGE",       # raw weapon DPS, converted by scoring engine
    "RESIST_ALL",          # resistance enchants
    "FIRE_RESIST",
    "FROST_RESIST",
    "NATURE_RESIST",
    "ARCANE_RESIST",
    "SHADOW_RESIST",
    "THREAT",              # threat enchants (gloves)
    "THREAT_REDUCTION",    # subtlety cloak
}

ALL_ALLOWED_KEYS = VALID_STAT_KEYS | KNOWN_NON_STAT_KEYS

# ---------------------------------------------------------------------------
# Lua table parser (regex-based, handles flat [ID] = { K = V, ... } entries)
# ---------------------------------------------------------------------------

# Matches: [12345] = { ... },  or  [12345] = {},
ENTRY_RE = re.compile(
    r'^\s*\[(\d+)\]\s*=\s*\{([^}]*)\}',
    re.MULTILINE
)

# Matches: KEY = NUMBER inside a stat table (keys may contain digits, e.g. MP5)
STAT_RE = re.compile(
    r'([A-Z][A-Z0-9_]*)\s*=\s*(-?\d+(?:\.\d+)?)'
)


def parse_lua_database(filepath):
    """Parse a Lua data file and return list of (line_number, id, stats_dict) tuples."""
    entries = []
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Build a line-number index: for each match in the full text, find its line
    full_text = "".join(lines)

    for match in ENTRY_RE.finditer(full_text):
        entry_id = int(match.group(1))
        stats_str = match.group(2)

        # Compute line number from character offset
        char_offset = match.start()
        line_num = full_text[:char_offset].count("\n") + 1

        stats = {}
        for stat_match in STAT_RE.finditer(stats_str):
            key = stat_match.group(1)
            value = float(stat_match.group(2))
            # Convert to int if it's a whole number
            if value == int(value):
                value = int(value)
            stats[key] = value

        entries.append((line_num, entry_id, stats))

    return entries


# ---------------------------------------------------------------------------
# Validation rules
# ---------------------------------------------------------------------------

def validate_database(filepath, db_name, id_range=None, verbose=False):
    """Validate a single database file. Returns list of error strings."""
    errors = []
    warnings = []

    if not os.path.isfile(filepath):
        errors.append(f"{db_name}: File not found: {filepath}")
        return errors, warnings

    entries = parse_lua_database(filepath)

    if not entries:
        errors.append(f"{db_name}: No entries found (parsing may have failed)")
        return errors, warnings

    # Check for duplicate IDs
    seen_ids = {}
    for line_num, entry_id, stats in entries:
        if entry_id in seen_ids:
            errors.append(
                f"{db_name} line {line_num}: Duplicate ID [{entry_id}] "
                f"(first seen at line {seen_ids[entry_id]})"
            )
        else:
            seen_ids[entry_id] = line_num

        # Check stat keys
        for key, value in stats.items():
            if key not in ALL_ALLOWED_KEYS:
                errors.append(
                    f"{db_name} line {line_num}: [{entry_id}] unknown stat key '{key}'"
                )

            # Check values are positive numbers
            if value <= 0:
                errors.append(
                    f"{db_name} line {line_num}: [{entry_id}] stat '{key}' has "
                    f"non-positive value {value}"
                )

        # Check ID range (if specified)
        if id_range is not None:
            lo, hi = id_range
            if not (lo <= entry_id <= hi):
                warnings.append(
                    f"{db_name} line {line_num}: [{entry_id}] ID outside expected "
                    f"range [{lo}-{hi}]"
                )

        # Warn on empty stat tables (not an error — some enchants intentionally have no stats)
        if not stats:
            if verbose:
                warnings.append(
                    f"{db_name} line {line_num}: [{entry_id}] empty stat table"
                )

    if verbose:
        print(f"  {db_name}: {len(entries)} entries, {len(errors)} errors, {len(warnings)} warnings")

    return errors, warnings


# ---------------------------------------------------------------------------
# SetBonusDatabase validator
# ---------------------------------------------------------------------------

# Matches set entries: [12345] = { name = "...", bonuses = { ... } },
SET_ENTRY_RE = re.compile(
    r'^\s*\[(\d+)\]\s*=\s*\{',
    re.MULTILINE
)

# Matches bonus threshold entries: [2] = { STAT = val }, or [4] = { STAT = val },
BONUS_THRESHOLD_RE = re.compile(
    r'\[([24])\]\s*=\s*\{([^}]*)\}'
)


def validate_set_bonus_database(filepath, verbose=False):
    """Validate SetBonusDatabase.lua for duplicate IDs and invalid stat keys."""
    errors = []
    warnings = []
    db_name = "SetBonusDatabase"

    if not os.path.isfile(filepath):
        errors.append(f"{db_name}: File not found: {filepath}")
        return errors, warnings

    with open(filepath, "r", encoding="utf-8") as f:
        full_text = f.read()

    # Find all set entries
    seen_ids = {}
    entry_count = 0

    for match in SET_ENTRY_RE.finditer(full_text):
        entry_id = int(match.group(1))
        char_offset = match.start()
        line_num = full_text[:char_offset].count("\n") + 1
        entry_count += 1

        if entry_id in seen_ids:
            errors.append(
                f"{db_name} line {line_num}: Duplicate setID [{entry_id}] "
                f"(first seen at line {seen_ids[entry_id]})"
            )
        else:
            seen_ids[entry_id] = line_num

        # Find the bonuses within this entry (look ahead ~500 chars)
        entry_text = full_text[match.start():match.start() + 500]
        for bonus_match in BONUS_THRESHOLD_RE.finditer(entry_text):
            stats_str = bonus_match.group(2)
            for stat_match in STAT_RE.finditer(stats_str):
                key = stat_match.group(1)
                value = float(stat_match.group(2))
                if key not in ALL_ALLOWED_KEYS:
                    errors.append(
                        f"{db_name} line {line_num}: [{entry_id}] unknown stat key '{key}'"
                    )
                if value <= 0:
                    errors.append(
                        f"{db_name} line {line_num}: [{entry_id}] stat '{key}' has "
                        f"non-positive value {value}"
                    )

    if entry_count == 0:
        errors.append(f"{db_name}: No entries found (parsing may have failed)")

    if verbose:
        print(f"  {db_name}: {entry_count} entries, {len(errors)} errors, {len(warnings)} warnings")

    return errors, warnings


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    verbose = "--verbose" in sys.argv or "-v" in sys.argv

    # Determine addon root (script lives in Tools/)
    script_dir = Path(__file__).resolve().parent
    addon_root = script_dir.parent

    data_dir = addon_root / "Data"

    all_errors = []
    all_warnings = []

    print(f"Validating TrueGearScore data files in: {data_dir}")
    print()

    # --- GemDatabase ---
    errors, warnings = validate_database(
        data_dir / "GemDatabase.lua",
        "GemDatabase",
        id_range=(20000, 40000),
        verbose=verbose,
    )
    all_errors.extend(errors)
    all_warnings.extend(warnings)

    # --- EnchantDatabase ---
    errors, warnings = validate_database(
        data_dir / "EnchantDatabase.lua",
        "EnchantDatabase",
        id_range=(1, 4000),
        verbose=verbose,
    )
    all_errors.extend(errors)
    all_warnings.extend(warnings)

    # --- ProcDatabase ---
    errors, warnings = validate_database(
        data_dir / "ProcDatabase.lua",
        "ProcDatabase",
        id_range=None,  # proc IDs are item IDs, wide range
        verbose=verbose,
    )
    all_errors.extend(errors)
    all_warnings.extend(warnings)

    # --- SetBonusDatabase ---
    errors, warnings = validate_set_bonus_database(
        data_dir / "SetBonusDatabase.lua",
        verbose=verbose,
    )
    all_errors.extend(errors)
    all_warnings.extend(warnings)

    # --- Report ---
    if all_warnings:
        print(f"Warnings ({len(all_warnings)}):")
        for w in all_warnings:
            print(f"  WARN: {w}")
        print()

    if all_errors:
        print(f"ERRORS ({len(all_errors)}):")
        for e in all_errors:
            print(f"  ERROR: {e}")
        print()
        print("Validation FAILED.")
        return 1
    else:
        print("All data files passed validation.")
        return 0


if __name__ == "__main__":
    sys.exit(main())
