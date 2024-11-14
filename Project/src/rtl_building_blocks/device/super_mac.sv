// Defines 16 mac units working in parallel
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
    input logic accumulate_internal, 
    
    // input a, this is the feature value, same for all mac units working in parallel
    input logic signed [A_WIDTH-1:0] a,

    // inputs b
    input logic signed [B_WIDTH-1:0] b0,
    input logic signed [B_WIDTH-1:0] b1,
    input logic signed [B_WIDTH-1:0] b2,
    input logic signed [B_WIDTH-1:0] b3,
    input logic signed [B_WIDTH-1:0] b4,
    input logic signed [B_WIDTH-1:0] b5,
    input logic signed [B_WIDTH-1:0] b6,
    input logic signed [B_WIDTH-1:0] b7,
    input logic signed [B_WIDTH-1:0] b8,
    input logic signed [B_WIDTH-1:0] b9,
    input logic signed [B_WIDTH-1:0] b10,
    input logic signed [B_WIDTH-1:0] b11,
    input logic signed [B_WIDTH-1:0] b12,
    input logic signed [B_WIDTH-1:0] b13,
    input logic signed [B_WIDTH-1:0] b14,
    input logic signed [B_WIDTH-1:0] b15,
    
    
    // outputs
    output logic signed [OUTPUT_WIDTH-1:0] out0,
    output logic signed [OUTPUT_WIDTH-1:0] out1,
    output logic signed [OUTPUT_WIDTH-1:0] out2,
    output logic signed [OUTPUT_WIDTH-1:0] out3,
    output logic signed [OUTPUT_WIDTH-1:0] out4,
    output logic signed [OUTPUT_WIDTH-1:0] out5,
    output logic signed [OUTPUT_WIDTH-1:0] out6,
    output logic signed [OUTPUT_WIDTH-1:0] out7,
    output logic signed [OUTPUT_WIDTH-1:0] out8,
    output logic signed [OUTPUT_WIDTH-1:0] out9,
    output logic signed [OUTPUT_WIDTH-1:0] out10,
    output logic signed [OUTPUT_WIDTH-1:0] out11,
    output logic signed [OUTPUT_WIDTH-1:0] out12,
    output logic signed [OUTPUT_WIDTH-1:0] out13,
    output logic signed [OUTPUT_WIDTH-1:0] out14,
    output logic signed [OUTPUT_WIDTH-1:0] out15
    
    );
    
    
    // MAC_unit 0
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit0 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b0),
        .out(mac_out0)
    );
    
    // MAC_unit 1
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit1 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b1),
        .out(mac_out1)
    );
    
    // MAC_unit 2
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit2 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b2),
        .out(mac_out2)
    );
    
    // MAC_unit 3
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit3 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b3),
        .out(mac_out3)
    );
    
    // MAC_unit 4
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit4 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b4),
        .out(mac_out4)
    );
    
    // MAC_unit 5
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit5 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b5),
        .out(mac_out5)
    );
    
    // MAC_unit 6
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit6 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b6),
        .out(mac_out6)
    );
    
    // MAC_unit 0
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit7 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b7),
        .out(mac_out7)
    );
    
    // MAC_unit 8
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit8 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b8),
        .out(mac_out8)
    );
    
    // MAC_unit 9
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit9 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b9),
        .out(mac_out9)
    );
    
    // MAC_unit 10
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit10 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b10),
        .out(mac_out10)
    );
    
    // MAC_unit 0
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit11 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b11),
        .out(mac_out11)
    );
    
    // MAC_unit 12
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit12 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b12),
        .out(mac_out12)
    );
    
    // MAC_unit 13
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit13 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b13),
        .out(mac_out13)
    );
    
    // MAC_unit 14
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit14 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b14),
        .out(mac_out14)
    );
    
    // MAC_unit 15
    mac #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .OUTPUT_SCALE(0)
    ) mac_unit15 (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),

        .a(a),
        
        .b(b15),
        .out(mac_out15)
    );


endmodule
