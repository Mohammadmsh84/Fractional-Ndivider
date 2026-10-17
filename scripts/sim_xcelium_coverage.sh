#!/usr/bin/env bash
# RTL coverage runs for the final Divider TB and actual Group-4 integration TB.
# The coverage databases are written under cov_work/. Use IMC on the course
# server to export HTML/text reports after these runs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p sim/rtl

rm -rf cov_work

xrun -clean -sv -access +rwc -timescale 1ns/1ps \
  -coverage all -covoverwrite \
  -covtest divider_rtl \
  -top tb_frac_div_system \
  -l sim/rtl/xrun_divider_coverage.log \
  rtl/fractional_n_divider.v \
  rtl/t_flip_flop.v \
  rtl/frac_div_system.v \
  tb/tb_frac_div_system.v

grep -q "FAIL=0" sim/rtl/tb_frac_div_system.log || {
  echo "ERROR: Divider coverage run did not finish with FAIL=0"
  exit 2
}

xrun -clean -sv -access +rwc -timescale 1ns/1ps \
  -coverage all \
  -covtest g4_integration_rtl \
  -top tb_system_g4 \
  -l sim/rtl/xrun_g4_coverage.log \
  external/g4_sdm/rtl_sources/sdm_mash11_B.sv \
  rtl/fractional_n_divider.v \
  rtl/t_flip_flop.v \
  rtl/frac_div_system.v \
  rtl/frac_div_g4_top.sv \
  tb/tb_system_g4.sv

grep -q "FAIL=0" sim/rtl/tb_system_g4.log || {
  echo "ERROR: G4 integration coverage run did not finish with FAIL=0"
  exit 2
}

echo "Coverage simulations passed. Open cov_work with IMC and export reports."
