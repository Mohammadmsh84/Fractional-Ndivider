#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p sim/rtl

DEFINE_OPT=""
if [[ "${FULL_SIM:-0}" == "1" ]]; then
    DEFINE_OPT="+define+FULL_SIM"
fi

xrun -clean -sv \
  -access +rwc \
  -timescale 1ns/1ps \
  -top tb_system_g4 \
  ${DEFINE_OPT:+$DEFINE_OPT} \
  -l sim/rtl/xrun_g4_integration_rtl.log \
  external/g4_sdm/rtl_sources/sdm_mash11_B.sv \
  rtl/fractional_n_divider.v \
  rtl/t_flip_flop.v \
  rtl/frac_div_system.v \
  rtl/frac_div_g4_top.sv \
  tb/tb_system_g4.sv

if grep -q "FAIL=0" sim/rtl/tb_system_g4.log; then
    echo "PASS: G4 RTL integration"
else
    echo "ERROR: G4 RTL integration did not finish with FAIL=0"
    exit 2
fi