#!/usr/bin/env bash
# Complete regression after our final Divider netlist and SDF are generated.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

bash scripts/sim_xcelium_gate.sh
bash scripts/sim_xcelium_g4_postsyn.sh
bash scripts/sim_xcelium_divider_postsyn_integration.sh
bash scripts/sim_xcelium_both_postsyn.sh

echo "All post-synthesis Week-4 regressions passed."
