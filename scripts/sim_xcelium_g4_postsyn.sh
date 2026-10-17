#!/usr/bin/env bash
# Group-4 post-synthesis SDM/SDF + our RTL divider + external T-FF.
# Set FULL_SIM=1 for the longer integration run.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p sim/gate

TECH_V="${TECH_V:-/home/cad/TECH.D/TSMC180/Verilog/tsmc18.v}"
G4_NETLIST="external/g4_sdm/synthesis/synout/sdm_mash11_postsyn.v"
G4_SDF="external/g4_sdm/synthesis/synout/sdm_mash11_postsyn.sdf"

for file in "$TECH_V" "$G4_NETLIST" "$G4_SDF"; do
  [[ -f "$file" ]] || { echo "ERROR: missing $file"; exit 1; }
done

DEFINES=(+define+G4_POSTSYN)
if [[ "${FULL_SIM:-0}" == "1" ]]; then
  DEFINES+=(+define+FULL_SIM)
fi

xrun -clean -sv -access +rwc -timescale 1ns/1ps \
  -top tb_system_g4 \
  "${DEFINES[@]}" \
  -l sim/gate/xrun_g4_postsyn_integration.log \
  -v "$TECH_V" \
  "$G4_NETLIST" \
  rtl/fractional_n_divider.v \
  rtl/t_flip_flop.v \
  rtl/frac_div_system.v \
  rtl/frac_div_g4_top.sv \
  tb/tb_system_g4.sv

grep -q "FAIL=0" sim/gate/tb_system_g4_postsyn.log || {
  echo "ERROR: G4 post-synthesis integration did not finish with FAIL=0"
  exit 2
}
echo "PASS: G4 post-synthesis SDM integration"