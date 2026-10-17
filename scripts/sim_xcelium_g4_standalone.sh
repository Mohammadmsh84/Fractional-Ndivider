#!/usr/bin/env bash
# Re-run Group-4's own standalone SDM regression in this package.
# Set FULL_SIM=1 for their one-million-cycle tests.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p sim/rtl

DEFINES=()
LOG=sim/rtl/g4_standalone_fast.log
if [[ "${FULL_SIM:-0}" == "1" ]]; then
  LOG=sim/rtl/g4_standalone_full.log
else
  DEFINES+=(+define+FAST_SIM)
fi

xrun -clean -sv -access +rwc -timescale 1ns/1ps \
  -top tb_sdm_mash11_week3 \
  "${DEFINES[@]}" \
  -l "$LOG" \
  external/g4_sdm/rtl_sources/sdm_mash11_B.sv \
  external/g4_sdm/rtl_sources/tb_sdm_mash11_week3.sv

grep -q "WEEK3_SIM_PASS" "$LOG" || {
  echo "ERROR: Group-4 standalone regression did not report WEEK3_SIM_PASS"
  exit 2
}
echo "PASS: Group-4 standalone SDM regression"