#!/usr/bin/env bash
# All simulations that can be run before synthesizing our final divider.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

bash scripts/sim_xcelium_g4_standalone.sh
bash scripts/sim_xcelium_rtl.sh
bash scripts/sim_xcelium_sdm.sh

echo "All pre-synthesis Week-4 regressions passed."
