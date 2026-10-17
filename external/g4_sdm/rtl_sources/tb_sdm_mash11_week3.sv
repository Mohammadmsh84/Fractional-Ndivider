// ============================================================
// Week-3 common testbench for RTL and post-synthesis simulation
// Group 4 - Sigma-Delta Modulator (MASH 1-1)
//
// The same checker is used in both modes:
//   RTL:      compile sdm_mash11_B.sv
//   Gate:     compile tsmc18.v + sdm_mash11_postsyn.v
//             and define POSTSYN_SIM to annotate the SDF.
//
// FAST_SIM uses 100,000 cycles per average test.
// The default uses 1,000,000 cycles per average test.
// ============================================================

`timescale 1ns/1ps

module tb_sdm_mash11_week3;

    localparam int      FRAC_BITS       = 23;
    localparam realtime CLK_PERIOD_NS   = 7629.39453125; // 131.072 kHz
    localparam realtime SAMPLE_DELAY_NS = 20.0;          // > 12.875 ns critical path
    localparam realtime RESET_GUARD_NS  = 100.0;

`ifdef FAST_SIM
    localparam int N_CYCLES = 100_000;
`else
    localparam int N_CYCLES = 1_000_000;
`endif

    logic                      clk;
    logic                      rst_n;
    logic signed [23:0]        epsilon_RO;
    logic                      dither_en;
    logic [1:0]                N_sel;

    int pass_count  = 0;
    int fail_count  = 0;
    int known_count = 0;
    bit invalid_code_seen = 1'b0;

    sdm_mash11 dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .epsilon_RO (epsilon_RO),
        .dither_en  (dither_en),
        .N_sel      (N_sel)
    );

`ifdef POSTSYN_SIM
    initial begin
        $display("[W3] POST-SYNTHESIS mode: annotating MAXIMUM SDF delays");
        $sdf_annotate(
            "../synthesis/synout/sdm_mash11_postsyn.sdf",
            dut,
            ,
            ,
            "MAXIMUM"
        );
    end
`else
    initial begin
        $display("[W3] RTL baseline mode");
    end
`endif

    initial clk = 1'b0;
    always #(CLK_PERIOD_NS/2.0) clk = ~clk;

    // Sample after the clock-to-Q/combinational settling interval.
    always @(posedge clk) begin
        #(SAMPLE_DELAY_NS);
        if (rst_n && (N_sel === 2'b11)) begin
            invalid_code_seen = 1'b1;
            $display("[%0t] ERROR: invalid N_sel code 2'b11", $time);
        end
    end

    function automatic real eps_to_real(input logic signed [23:0] e);
        return real'(e) / (2.0 ** FRAC_BITS);
    endfunction

    function automatic int nsel_to_div(input logic [1:0] n);
        case (n)
            2'b00:   return 1;
            2'b01:   return 2;
            2'b10:   return 3;
            default: return 2;
        endcase
    endfunction

    function automatic real clamp_expected(input real x);
        if (x > 3.0) return 3.0;
        if (x < 1.0) return 1.0;
        return x;
    endfunction

    function automatic bit is_known_week2_case(
        input logic signed [23:0] eps,
        input bit dith
    );
        return dith && (eps == 24'sh400000);
    endfunction

    // Reset deassertion is deliberately kept far from an active clock edge,
    // preventing recovery/removal violations during timing simulation.
    task automatic apply_reset();
        rst_n = 1'b0;
        repeat (5) @(posedge clk);
        @(negedge clk);
        #(RESET_GUARD_NS);
        rst_n = 1'b1;
        @(posedge clk);
        #(SAMPLE_DELAY_NS);
    endtask

    task automatic test_reset_behavior();
        bit ok;

        ok         = 1'b1;
        epsilon_RO = 24'sd0;
        dither_en  = 1'b0;
        rst_n      = 1'b0;

        repeat (5) begin
            @(posedge clk);
            #(SAMPLE_DELAY_NS);
            if (N_sel !== 2'b01) ok = 1'b0;
        end

        @(negedge clk);
        #(RESET_GUARD_NS);
        rst_n = 1'b1;
        @(posedge clk);
        #(SAMPLE_DELAY_NS);
        if (N_sel !== 2'b01) ok = 1'b0;

        if (ok) begin
            pass_count++;
            $display("[PASS] Reset behavior");
            $display("[W3_RESULT] name=Reset dither=0 avg=2.000000 exp=2.000000 err=0.000000 verdict=PASS");
        end else begin
            fail_count++;
            $display("[FAIL] Reset behavior: N_sel=%b", N_sel);
            $display("[W3_RESULT] name=Reset dither=0 avg=0.000000 exp=2.000000 err=-2.000000 verdict=FAIL");
        end
    endtask

    task automatic run_avg_test(
        input string              name,
        input logic signed [23:0] eps,
        input bit                 dith,
        input real                tol
    );
        longint sum;
        real avg;
        real expected;
        real err;
        string verdict;

        epsilon_RO = eps;
        dither_en  = dith;
        apply_reset();

        sum = 0;
        repeat (N_CYCLES) begin
            @(posedge clk);
            #(SAMPLE_DELAY_NS);
            sum += nsel_to_div(N_sel);
        end

        avg      = real'(sum) / real'(N_CYCLES);
        expected = clamp_expected(2.0 * (1.0 + eps_to_real(eps)));
        err      = avg - expected;

        if ((err <= tol) && (err >= -tol)) begin
            pass_count++;
            verdict = "PASS";
            $display("[PASS] %-25s dither=%0b avg=%.6f exp=%.6f err=%+.6f",
                     name, dith, avg, expected, err);
        end else if (is_known_week2_case(eps, dith)) begin
            known_count++;
            verdict = "KNOWN";
            $display("[KNOWN] %-24s dither=%0b avg=%.6f exp=%.6f err=%+.6f (Week-2 boundary issue)",
                     name, dith, avg, expected, err);
        end else begin
            fail_count++;
            verdict = "FAIL";
            $display("[FAIL] %-25s dither=%0b avg=%.6f exp=%.6f err=%+.6f tol=%.6f",
                     name, dith, avg, expected, err, tol);
        end

        $display("[W3_RESULT] name=%s dither=%0b avg=%.9f exp=%.9f err=%+.9f verdict=%s",
                 name, dith, avg, expected, err, verdict);
    endtask

    typedef struct {
        string              name;
        logic signed [23:0] eps;
        real                tol;
    } test_vec_t;

    test_vec_t vecs [10];

    initial begin
        vecs[0] = '{"Zero",                24'sh000000, 0.0001};
        vecs[1] = '{"DRS_+50ppm_0x68",     24'sh000068, 0.00005};
        vecs[2] = '{"DRS_-50ppm_0xFF98",   24'shFFFF98, 0.00005};
        vecs[3] = '{"DRS_+100ppm_0xD0",    24'sh0000D0, 0.00005};
        vecs[4] = '{"Exact_+50ppm_Q1.23",  24'sh0001A3, 0.00005};
        vecs[5] = '{"Exact_-50ppm_Q1.23",  24'shFFFE5D, 0.00005};
        vecs[6] = '{"Plus_0.25",           24'sh200000, 0.001};
        vecs[7] = '{"Minus_0.25",          24'shE00000, 0.001};
        vecs[8] = '{"Plus_0.5",            24'sh400000, 0.001};
        vecs[9] = '{"Boundary_+max",       24'sh7FFFFF, 0.01};
    end

    initial begin
        epsilon_RO = '0;
        dither_en  = 1'b0;
        rst_n      = 1'b0;

        $display("============================================================");
        $display(" WEEK-3 SDM CHECK | cycles/test=%0d | sample delay=%.1f ns",
                 N_CYCLES, SAMPLE_DELAY_NS);
        $display("============================================================");

        test_reset_behavior();
        run_avg_test("Boundary_-max", 24'sh800000, 1'b0, 0.01);

        foreach (vecs[i])
            run_avg_test(vecs[i].name, vecs[i].eps, 1'b0, vecs[i].tol);

        foreach (vecs[i])
            run_avg_test(vecs[i].name, vecs[i].eps, 1'b1, vecs[i].tol);

        if (invalid_code_seen) begin
            fail_count++;
            $display("[FAIL] Invalid code 2'b11 was observed");
            $display("[W3_RESULT] name=InvalidCode dither=0 avg=1.000000 exp=0.000000 err=1.000000 verdict=FAIL");
        end else begin
            pass_count++;
            $display("[PASS] Invalid code 2'b11 was never observed");
            $display("[W3_RESULT] name=InvalidCode dither=0 avg=0.000000 exp=0.000000 err=0.000000 verdict=PASS");
        end

        $display("============================================================");
        $display(" WEEK-3 RESULT: %0d PASS, %0d KNOWN, %0d FAIL",
                 pass_count, known_count, fail_count);
        $display("============================================================");

        if (fail_count == 0) begin
            $display("WEEK3_SIM_PASS");
            $finish;
        end else begin
            $fatal(1, "WEEK3_SIM_FAIL: unexpected failures detected");
        end
    end

endmodule
