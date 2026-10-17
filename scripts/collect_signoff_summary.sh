#!/usr/bin/env bash
# Summarize generated Week-4 evidence after server execution.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

status=0
check_marker() {
  local label="$1" file="$2" marker="$3"
  if [[ -f "$file" ]] && grep -q "$marker" "$file"; then
    printf '[PASS] %-34s %s\n' "$label" "$file"
  else
    printf '[MISS] %-34s %s\n' "$label" "$file"
    status=1
  fi
}
check_file() {
  local label="$1" file="$2"
  if [[ -s "$file" ]]; then
    printf '[PASS] %-34s %s\n' "$label" "$file"
  else
    printf '[MISS] %-34s %s\n' "$label" "$file"
    status=1
  fi
}

check_marker 'G4 standalone RTL'       sim/rtl/g4_standalone_fast.log WEEK3_SIM_PASS
check_marker 'Divider RTL'             sim/rtl/tb_frac_div_system.log 'FAIL=0'
check_marker 'G4 RTL integration'      sim/rtl/tb_system_g4.log 'FAIL=0'
check_file   'Divider netlist'         netlist/fractional_n_divider_postsyn.v
check_file   'Divider SDF'             netlist/fractional_n_divider_postsyn.sdf
check_file   'Area report'             sim/gate/fractional_n_divider_area.rpt
check_file   'Timing report'           sim/gate/fractional_n_divider_timing.rpt
check_marker 'Divider gate/SDF'        sim/gate/tb_frac_div_system_gate.log 'FAIL=0'
check_marker 'G4 postsyn integration'  sim/gate/tb_system_g4_postsyn.log 'FAIL=0'
check_marker 'Divider postsyn integ.'  sim/gate/tb_system_divider_postsyn.log 'FAIL=0'
check_marker 'Both postsyn integration' sim/gate/tb_system_both_postsyn.log 'FAIL=0'

if [[ "$status" == 0 ]]; then
  echo 'WEEK4_SERVER_EVIDENCE_COMPLETE'
else
  echo 'WEEK4_SERVER_EVIDENCE_INCOMPLETE'
fi
exit "$status"