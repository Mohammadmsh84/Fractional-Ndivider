# Reproduction notes

## Scope of the package

The source, testbenches, report, netlists, SDF, and archived logs come from `G2_Fractional_N_Divider_Final.zip`. README documentation, the architecture illustration, and ignore rules were added for repository presentation. Shell-script line endings were normalized from CRLF to LF; hardware source and testbench contents were not changed.

Documentation preparation did not rerun Xcelium or Genus. Results quoted in the README were checked against the supplied evidence. Those tools and the required technology libraries were not available in the documentation environment.

## Working directory and dependencies

Run the documented commands from the repository root. The shell scripts locate the root through their own paths, but testbench output files and SDF references assume the directory arrangement shown in the README. Use Bash, not a direct PowerShell invocation of `.sh` files.

The original logs identify:

| Component | Archived setting |
| --- | --- |
| Cadence Xcelium | `22.03-s001` |
| Cadence Genus | `21.10-p002_1` |
| Target technology | TSMC 180 nm, typical library |
| Liberty search directory | `/home/cad/TECH.D/TSMC180/lib` |
| Liberty file | `typical.lib` |
| Gate-level cell models | `/home/cad/TECH.D/TSMC180/Verilog/tsmc18.v` |

These are paths from the original academic server, not files included in this repository. Set your own library paths in `scripts/synth_genus.tcl` and set `TECH_V` for gate-level runs. Use a cell-model library compatible with the archived netlists and SDF files.

The synthesis script reports only `fractional_n_divider`. The SDM netlist/SDF were supplied with the Group 4 handoff. No Group 4 synthesis script is present in this archive.

## Useful runs

| Purpose | Command |
| --- | --- |
| Divider RTL | `bash scripts/sim_xcelium_rtl.sh` |
| Integrated SDM + divider RTL | `bash scripts/sim_xcelium_sdm.sh` |
| Standalone Group 4 SDM | `bash scripts/sim_xcelium_g4_standalone.sh` |
| All pre-synthesis tests | `bash scripts/run_week4_pre_synth.sh` |
| Divider gate-level + SDF | `bash scripts/sim_xcelium_gate.sh` |
| SDM post-synthesis + RTL divider | `bash scripts/sim_xcelium_g4_postsyn.sh` |
| RTL SDM + divider post-synthesis | `bash scripts/sim_xcelium_divider_postsyn_integration.sh` |
| Both blocks post-synthesis | `bash scripts/sim_xcelium_both_postsyn.sh` |
| All post-synthesis tests | `bash scripts/run_week4_post_synth.sh` |
| Evidence-file summary | `bash scripts/collect_signoff_summary.sh` |

`FULL_SIM=1` selects longer runs in the standalone SDM and integrated-system scripts. The standalone default defines `FAST_SIM` and uses 100,000 cycles per average test; full mode uses 1,000,000. The integrated testbench uses 2,000 samples for large inputs and 10,000 for ppm cases by default, versus 20,000 and 100,000 with `FULL_SIM`.

The supplied evidence-summary script expects the default fast standalone log. If only the full standalone run is performed, the summary may report the fast log missing even though the full run passed.

The tools regenerate output files in `sim/` and `netlist/`. Preserve archived evidence separately before rerunning if you want a clean comparison.

## Coverage

```bash
bash scripts/sim_xcelium_coverage.sh
```

This existing script removes the repository-local `cov_work` directory before collecting a fresh database. Retain an earlier database elsewhere if needed. Use Cadence IMC to inspect/export results after collection.

The archive contains coverage-run logs under `coverage/`, but does not contain the coverage databases or exported percentage reports. Passing checks in a coverage-enabled simulation are not a coverage percentage. The README therefore does not claim 100% or any other numerical coverage figure.

## Timing interpretation

The SDC sets an input-clock period of 7629.39 in the original flow's units. The archived clock report shows 7,629,390 ps, equivalent to 7,629.39 ns. Verify units when moving to another library/tool setup.

The smallest slack among the 10 listed paths is +3,714,094 ps. This value comes from the specific low-frequency constraint set; it is not an estimate of maximum clock frequency or a post-layout signoff result.

Comments referring to `latch_out1`, `latch_out2`, or an intentional clock-mux latch are leftovers from an earlier architecture in the SDC/Genus script. The final `rtl/fractional_n_divider.v` does not instantiate those latches. The optional generated-clock comment is also not a general model of a dynamically changing divide ratio. Review constraints if extending STA to the integrated system.

## SDF warnings

The gate-level logs include `SDFNET` warnings for reset recovery/removal or combined `RECREM` timing checks absent from the chosen cell models. The testbenches report passing functional and pulse-width checks with maximum SDF delays requested. This should not be described as complete, warning-free timing annotation.

## Known SDM boundary case

The standalone Group 4 fast log records:

```text
Plus_0.5, dither=1: average=2.997000, expected=3.000000
WEEK-3 RESULT: 22 PASS, 1 KNOWN, 0 FAIL
```

This case is categorized as `KNOWN` by the inherited standalone testbench. It is distinct from the later integration tests, which use zero, +/-0.25, and approximately +/-50 ppm settings. No internal SDM change is included in this presentation package.

## Clock and reset behavior

`N_sel` changes are accepted only at an output-period boundary. The integrated SDM runs on `INT65K_CLK`, not directly on the input clock. Reset forces the divider output and T-FF output low.

The 50% final-clock duty-cycle result is checked at the constant, nominal divide-by-2 setting. Arbitrary changing divide sequences can give different adjacent high/low durations. The final output's average frequency remains one half of the divider output's average rising-edge rate.

## Repository presentation

The project is hosted at `Mohammadmsh84/Ftactional-Ndivider`. Use the final files under `rtl/` and `tb/` as the active implementation. The repository was populated from the final project archive, with the initial one-line repository README replaced by the project documentation. Do not compile additional older copies of the divider module alongside the final implementation.

Do not include foundry Liberty/Verilog libraries just to make the default server paths work. They are external dependencies. Keep the archived project netlists and SDF as project evidence, subject to the team's and library provider's applicable redistribution terms.

The included `.gitattributes` keeps shell scripts, Tcl, SDC, Markdown, and SVG files on LF line endings and treats PDFs as binary. The Bash scripts in this upload were normalized to LF before uploading; hardware source and testbench contents match the final archive.
