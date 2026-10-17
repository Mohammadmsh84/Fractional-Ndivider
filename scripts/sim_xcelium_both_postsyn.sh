#!/usr/bin/env bash
# Both neighboring blocks at post-synthesis level with MAXIMUM SDF:
#   G4 SDM netlist/SDF + our Divider netlist/SDF + RTL T-FF
# Set FULL_SIM=1 for the longer integration run.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p sim/gate

TECH_V="${TECH_V:-/home/cad/TECH.D/TSMC180/Verilog/tsmc18.v}"
G4_NETLIST="external/g4_sdm/synthesis/synout/sdm_mash11_postsyn.v"
G4_SDF="external/g4_sdm/synthesis/synout/sdm_mash11_postsyn.sdf"
DIV_NETLIST="netlist/fractional_n_divider_postsyn.v"
DIV_SDF="netlist/fractional_n_divider_postsyn.sdf"

for file in "$TECH_V" "$G4_NETLIST" "$G4_SDF" "$DIV_NETLIST" "$DIV_SDF"; do
  [[ -f "$file" ]] || { echo "ERROR: missing $file"; exit 1; }
done

DEFINES=(+define+G4_POSTSYN +define+DIVIDER_POSTSYN)
if [[ "${FULL_SIM:-0}" == "1" ]]; then
  DEFINES+=(+define+FULL_SIM)
fi

xrun -clean -sv -access +rwc -timescale 1ns/1ps \
  -top tb_system_g4 \
  "${DEFINES[@]}" \
  -l sim/gate/xrun_both_postsyn_integration.log \
  -v "$TECH_V" \
  "$G4_NETLIST" \
  "$DIV_NETLIST" \
  rtl/t_flip_flop.v \
  rtl/frac_div_system.v \
  rtl/frac_div_g4_top.sv \
  tb/tb_system_g4.sv

grep -q "FAIL=0" sim/gate/tb_system_both_postsyn.log || {
  echo "ERROR: both-post-synthesis integration did not finish with FAIL=0"
  exit 2
}
echo "PASS: both-post-synthesis integration"