// Instantiates 32 mac units working in parallel
module super_mac #(
  parameter int A_WIDTH = 16,
  parameter int B_WIDTH = 16,
  parameter int ACCUMULATOR_WIDTH = 32,
  parameter int OUTPUT_WIDTH = 16,
  parameter int OUTPUT_SCALE = 0
  )
  (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    // global inputs
    input logic input_valid,
    input logic p_valid,
    input logic accumulate_internal, 
    
    // input a, this is the feature value, same for all mac units working in parallel
    input logic signed [A_WIDTH-1:0] aa, // for input channel 1
    input logic signed [A_WIDTH-1:0] ab, // for input channel 2

  // inputs b, these are the kernel coefficients for each output channel
    // for input channel a
    input logic signed [B_WIDTH-1:0] b0a,
    input logic signed [B_WIDTH-1:0] b1a,
    input logic signed [B_WIDTH-1:0] b2a,
    input logic signed [B_WIDTH-1:0] b3a,
    input logic signed [B_WIDTH-1:0] b4a,
    input logic signed [B_WIDTH-1:0] b5a,
    input logic signed [B_WIDTH-1:0] b6a,
    input logic signed [B_WIDTH-1:0] b7a,
    input logic signed [B_WIDTH-1:0] b8a,
    input logic signed [B_WIDTH-1:0] b9a,
    input logic signed [B_WIDTH-1:0] b10a,
    input logic signed [B_WIDTH-1:0] b11a,
    input logic signed [B_WIDTH-1:0] b12a,
    input logic signed [B_WIDTH-1:0] b13a,
    input logic signed [B_WIDTH-1:0] b14a,
    input logic signed [B_WIDTH-1:0] b15a,
    
    // for input channel b
    input logic signed [B_WIDTH-1:0] b0b,
    input logic signed [B_WIDTH-1:0] b1b,
    input logic signed [B_WIDTH-1:0] b2b,
    input logic signed [B_WIDTH-1:0] b3b,
    input logic signed [B_WIDTH-1:0] b4b,
    input logic signed [B_WIDTH-1:0] b5b,
    input logic signed [B_WIDTH-1:0] b6b,
    input logic signed [B_WIDTH-1:0] b7b,
    input logic signed [B_WIDTH-1:0] b8b,
    input logic signed [B_WIDTH-1:0] b9b,
    input logic signed [B_WIDTH-1:0] b10b,
    input logic signed [B_WIDTH-1:0] b11b,
    input logic signed [B_WIDTH-1:0] b12b,
    input logic signed [B_WIDTH-1:0] b13b,
    input logic signed [B_WIDTH-1:0] b14b,
    input logic signed [B_WIDTH-1:0] b15b,
    
    
    // outputs
    output logic signed [OUTPUT_WIDTH-1:0] out0a,
    output logic signed [OUTPUT_WIDTH-1:0] out1a,
    output logic signed [OUTPUT_WIDTH-1:0] out2a,
    output logic signed [OUTPUT_WIDTH-1:0] out3a,
    output logic signed [OUTPUT_WIDTH-1:0] out4a,
    output logic signed [OUTPUT_WIDTH-1:0] out5a,
    output logic signed [OUTPUT_WIDTH-1:0] out6a,
    output logic signed [OUTPUT_WIDTH-1:0] out7a,
    output logic signed [OUTPUT_WIDTH-1:0] out8a,
    output logic signed [OUTPUT_WIDTH-1:0] out9a,
    output logic signed [OUTPUT_WIDTH-1:0] out10a,
    output logic signed [OUTPUT_WIDTH-1:0] out11a,
    output logic signed [OUTPUT_WIDTH-1:0] out12a,
    output logic signed [OUTPUT_WIDTH-1:0] out13a,
    output logic signed [OUTPUT_WIDTH-1:0] out14a,
    output logic signed [OUTPUT_WIDTH-1:0] out15a,
    
    output logic signed [OUTPUT_WIDTH-1:0] out0b,
    output logic signed [OUTPUT_WIDTH-1:0] out1b,
    output logic signed [OUTPUT_WIDTH-1:0] out2b,
    output logic signed [OUTPUT_WIDTH-1:0] out3b,
    output logic signed [OUTPUT_WIDTH-1:0] out4b,
    output logic signed [OUTPUT_WIDTH-1:0] out5b,
    output logic signed [OUTPUT_WIDTH-1:0] out6b,
    output logic signed [OUTPUT_WIDTH-1:0] out7b,
    output logic signed [OUTPUT_WIDTH-1:0] out8b,
    output logic signed [OUTPUT_WIDTH-1:0] out9b,
    output logic signed [OUTPUT_WIDTH-1:0] out10b,
    output logic signed [OUTPUT_WIDTH-1:0] out11b,
    output logic signed [OUTPUT_WIDTH-1:0] out12b,
    output logic signed [OUTPUT_WIDTH-1:0] out13b,
    output logic signed [OUTPUT_WIDTH-1:0] out14b,
    output logic signed [OUTPUT_WIDTH-1:0] out15b
    
    );
    
    
    // MAC_unit 0a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit0a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b0a),
        .out(out0a)
    );
    
    // MAC_unit 0b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit0b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b0b),
        .out(out0b)
    );
    
    // MAC_unit 1a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit1a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b1a),
        .out(out1a)
    );
    
    // MAC_unit 1b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit1b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b1b),
        .out(out1b)
    );
    
    // MAC_unit 2a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit2a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b2a),
        .out(out2a)
    );
    
    // MAC_unit 2b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit2b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b2b),
        .out(out2b)
    );
    
    // MAC_unit 3a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit3a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b3a),
        .out(out3a)
    );
    
    // MAC_unit 3b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit3b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b3b),
        .out(out3b)
    );
    
    // MAC_unit 4a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit4a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b4a),
        .out(out4a)
    );
    
    // MAC_unit 4b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit4b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b4b),
        .out(out4b)
    );
    
    // MAC_unit 5a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit5a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b5a),
        .out(out5a)
    );
    
    // MAC_unit 5b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit5b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b5b),
        .out(out5b)
    );
    
    // MAC_unit 6a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit6a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b6a),
        .out(out6a)
    );
    
    // MAC_unit 6b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit6b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b6b),
        .out(out6b)
    );
    
    // MAC_unit 7a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit7a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b7a),
        .out(out7a)
    );
    
    // MAC_unit 7b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit7b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b7b),
        .out(out7b)
    );
    
    // MAC_unit 8a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit8a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b8a),
        .out(out8a)
    );
    
    // MAC_unit 8b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit8b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b8b),
        .out(out8b)
    );
    
    // MAC_unit 9a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit9a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b9a),
        .out(out9a)
    );
    
    // MAC_unit 9b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit9b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b9b),
        .out(out9b)
    );
    
    // MAC_unit 10a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit10a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b10a),
        .out(out10a)
    );
    
    // MAC_unit 10b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit10b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b10b),
        .out(out10b)
    );
    
    // MAC_unit 11a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit11a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b11a),
        .out(out11a)
    );
    
    // MAC_unit 11b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit11b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b11b),
        .out(out11b)
    );
    
    // MAC_unit 12a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit12a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b12a),
        .out(out12a)
    );
    
    // MAC_unit 12b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit12b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b12b),
        .out(out12b)
    );
    
    // MAC_unit 13a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit13a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b13a),
        .out(out13a)
    );
    
    // MAC_unit 13b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit13b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b13b),
        .out(out13b)
    );
    
    // MAC_unit 14a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit14a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b14a),
        .out(out14a)
    );
    
    // MAC_unit 14b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit14b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b14b),
        .out(out14b)
    );
    
    // MAC_unit 15a
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit15a (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(aa),
        
        .b(b15a),
        .out(out15a)
    );
    
    // MAC_unit 15b
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit15b (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .p_valid(p_valid),
        .accumulate_internal(accumulate_internal),

        .a(ab),
        
        .b(b15b),
        .out(out15b)
    );


endmodule
