#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDON_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIBS_DIR="$ADDON_DIR/Libs"

# Ace3 repo with all modules
ACE3_REPO="https://github.com/WoWUIDev/Ace3.git"
ACE3_MODULES=(
    LibStub CallbackHandler-1.0 AceAddon-3.0 AceConsole-3.0 AceConfig-3.0
    AceDB-3.0 AceDBOptions-3.0 AceEvent-3.0 AceGUI-3.0 AceHook-3.0
)

# Cleanup on exit
TMPDIR=""
cleanup() {
    if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
        rm -rf "$TMPDIR"
    fi
}
trap cleanup EXIT

fetch_ace3() {
    echo "Fetching Ace3 modules..."
    local ace3_tmp="$TMPDIR/Ace3"
    git clone --depth 1 --quiet "$ACE3_REPO" "$ace3_tmp"

    for module in "${ACE3_MODULES[@]}"; do
        local dest="$LIBS_DIR/$module"
        rm -rf "$dest"
        cp -r "$ace3_tmp/$module" "$dest"
        echo "  $module"
    done
}

main() {
    echo "TrueGearScore Library Fetcher"
    echo "============================="
    echo ""

    TMPDIR="$(mktemp -d)"

    fetch_ace3

    echo ""
    echo "Done! All libraries fetched into $LIBS_DIR"
}

main
