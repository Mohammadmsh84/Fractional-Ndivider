// ============================================================
// Sigma-Delta Modulator MASH 1-1
// For Fractional-N Divider Control
//
// Function:
//   epsilon_RO  -> SDM -> N_sel
//
// Output encoding:
//   N_sel = 2'b00 : divide-by-1
//   N_sel = 2'b01 : divide-by-2
//   N_sel = 2'b10 : divide-by-3
//   N_sel = 2'b11 : invalid, never generated
//
// Assumption:
//   epsilon_RO is signed Q1.23, 24-bit.
//   Target average divider ratio:
//      N_avg = 2 * (1 + epsilon_RO)
//   Therefore correction average:
//      correction_avg = 2 * epsilon_RO
// ============================================================

module sdm_mash11 (
    input  wire               clk,        // 131.072 kHz
    input  wire               rst_n,      // active-low async reset
    input  wire signed [23:0] epsilon_RO, // signed Q1.23
    input  wire               dither_en,  // enable LFSR dithering
    output reg  [1:0]         N_sel       // 0: div1, 1: div2, 2: div3
);

    // ------------------------------------------------------------
    // Parameters
    // ------------------------------------------------------------
    localparam signed [25:0] ONE_Q23_WIDE = 26'sd8388608;   // 1.0 in Q1.23 = 2^23
    localparam signed [25:0] NEG_ONE_Q23  = -26'sd8388608;

    localparam [1:0] DIV_BY_1 = 2'b00;
    localparam [1:0] DIV_BY_2 = 2'b01;
    localparam [1:0] DIV_BY_3 = 2'b10;

    // ------------------------------------------------------------
    // Internal registers
    // ------------------------------------------------------------
    reg signed [24:0] acc1;
    reg signed [24:0] acc2;

    reg signed [2:0] q2_delay;

    reg [7:0] lfsr;

    // ------------------------------------------------------------
    // LFSR Dither
    // Polynomial:
    //   x^8 + x^6 + x^5 + x^4 + 1
    //
    // Feedback:
    //   lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]
    // ------------------------------------------------------------
    wire lfsr_feedback;

    assign lfsr_feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    // Generate zero-mean dither:
    //   00 ->  0
    //   01 -> +1 LSB
    //   10 -> -1 LSB
    //   11 ->  0
    reg signed [24:0] dither_value;

    always @(*) begin
        if (dither_en) begin
            case (lfsr[7:6])
                2'b00: dither_value = 25'sd0;
                2'b01: dither_value = 25'sd1;
                2'b10: dither_value = -25'sd1;
                2'b11: dither_value = 25'sd0;
                default: dither_value = 25'sd0;
            endcase
        end else begin
            dither_value = 25'sd0;
        end
    end

    // ------------------------------------------------------------
    // Input scaling
    //
    // epsilon_RO is Q1.23.
    // Required correction average is 2 * epsilon_RO.
    //
    // Use one extra bit to avoid overflow during scaling.
    // ------------------------------------------------------------
    wire signed [24:0] epsilon_ext;
    wire signed [24:0] epsilon_dithered;
    wire signed [25:0] sdm_input_wide;

    reg signed [24:0] sdm_input;

    assign epsilon_ext      = {epsilon_RO[23], epsilon_RO};
    assign epsilon_dithered = epsilon_ext + dither_value;

    // Multiply by 2 using left shift.
    assign sdm_input_wide = {epsilon_dithered[24], epsilon_dithered} <<< 1;

    // Saturate input to [-1.0, +1.0] in Q1.23 scale.
    always @(*) begin
        if (sdm_input_wide > ONE_Q23_WIDE)
            sdm_input = 25'sd8388608;
        else if (sdm_input_wide < NEG_ONE_Q23)
            sdm_input = -25'sd8388608;
        else
            sdm_input = sdm_input_wide[24:0];
    end

    // ------------------------------------------------------------
    // MASH 1-1 combinational next-state logic
    // ------------------------------------------------------------
    reg signed [25:0] sum1;
    reg signed [25:0] sum2;

    reg signed [24:0] acc1_next;
    reg signed [24:0] acc2_next;

    reg signed [2:0] q1;
    reg signed [2:0] q2;

    reg signed [3:0] correction;
    reg signed [3:0] div_value;

    reg [1:0] N_sel_next;

    always @(*) begin
        // Default values
        sum1       = 26'sd0;
        sum2       = 26'sd0;
        acc1_next  = acc1;
        acc2_next  = acc2;
        q1         = 3'sd0;
        q2         = 3'sd0;
        correction = 4'sd0;
        div_value  = 4'sd2;
        N_sel_next = DIV_BY_2;

        // --------------------------------------------------------
        // Stage 1 accumulator
        // --------------------------------------------------------
        sum1 = {acc1[24], acc1} + {sdm_input[24], sdm_input};

        if (sum1 >= ONE_Q23_WIDE) begin
            q1        = 3'sd1;
            acc1_next = sum1 - ONE_Q23_WIDE;
        end else if (sum1 <= NEG_ONE_Q23) begin
            q1        = -3'sd1;
            acc1_next = sum1 + ONE_Q23_WIDE;
        end else begin
            q1        = 3'sd0;
            acc1_next = sum1[24:0];
        end

        // --------------------------------------------------------
        // Stage 2 accumulator
        // Uses residual from stage 1 for second-order shaping.
        // --------------------------------------------------------
        sum2 = {acc2[24], acc2} + {acc1_next[24], acc1_next};

        if (sum2 >= ONE_Q23_WIDE) begin
            q2        = 3'sd1;
            acc2_next = sum2 - ONE_Q23_WIDE;
        end else if (sum2 <= NEG_ONE_Q23) begin
            q2        = -3'sd1;
            acc2_next = sum2 + ONE_Q23_WIDE;
        end else begin
            q2        = 3'sd0;
            acc2_next = sum2[24:0];
        end

        // --------------------------------------------------------
        // MASH 1-1 output combiner
        //
        // Standard MASH 1-1 form:
        //   correction = q1 + q2 - z^-1(q2)
        //
        // The average of q2 - q2_delay is zero.
        // Therefore average correction equals average q1,
        // which tracks 2 * epsilon_RO.
        // --------------------------------------------------------
        correction = q1 + q2 - q2_delay;

        // Nominal divider is 2.
        div_value = 4'sd2 + correction;

        // Clamp divider ratio to valid range: 1, 2, 3.
        if (div_value <= 4'sd1)
            N_sel_next = DIV_BY_1;
        else if (div_value == 4'sd2)
            N_sel_next = DIV_BY_2;
        else
            N_sel_next = DIV_BY_3;
    end

    // ------------------------------------------------------------
    // Sequential registers
    // ------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc1     <= 25'sd0;
            acc2     <= 25'sd0;
            q2_delay <= 3'sd0;
            lfsr     <= 8'h5A;
            N_sel    <= DIV_BY_2;
        end else begin
            acc1     <= acc1_next;
            acc2     <= acc2_next;
            q2_delay <= q2;

            if (dither_en)
                lfsr <= {lfsr[6:0], lfsr_feedback};

            N_sel <= N_sel_next;
        end
    end

endmodule