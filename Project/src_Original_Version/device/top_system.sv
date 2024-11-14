//wraps both top_chip and an external memory
//bandwidth to be counted is all bandwidth in and out of top_chip
module top_system #(
    // these initial values are overwritten by tbench_top
    parameter int IO_DATA_WIDTH = 16,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int EXT_MEM_HEIGHT = 1 << 20,
    parameter int EXT_MEM_WIDTH = ACCUMULATION_WIDTH,
    parameter int FEATURE_MAP_WIDTH = 1024,
    parameter int FEATURE_MAP_HEIGHT = 1024,
    parameter int INPUT_NB_CHANNELS = 64,
    parameter int OUTPUT_NB_CHANNELS = 64
) (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    // System Run-time Configuration
    input logic [1:0] conv_kernel_mode,
    // Currently support 3 sizes:
    // 0: 1x1
    // 1: 3x3
    // 2: 5x5
    input logic [1:0] conv_stride_mode,
    // Currently support 3 modes:
    // 0: step = 1
    // 1: step = 2
    // 2: step = 4

    //system inputs and outputs
    input logic [IO_DATA_WIDTH-1:0] a_input, // A is feature word
    input logic a_valid,
    output logic a_ready,
    input logic [IO_DATA_WIDTH-1:0] b_input, // B is kernel word
    input logic b_valid,
    output logic b_ready,

    //output
    output logic signed [IO_DATA_WIDTH-1:0] out,
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch,


    input  logic start,
    output logic running
);
  
  //read port
  logic unsigned [$clog2(EXT_MEM_HEIGHT)-1:0] ext_mem_read_addr;
  logic ext_mem_read_en;
  logic [EXT_MEM_WIDTH-1:0] ext_mem_qout; //read out

  //write port
  logic unsigned [$clog2(EXT_MEM_HEIGHT)-1:0] ext_mem_write_addr;
  logic ext_mem_write_en;
  logic [EXT_MEM_WIDTH-1:0] ext_mem_din; //write in
  


  //a simple pseudo-2 port memory (can read and write simultaneously)
  //Feel free to write a single port memory (inout data, either write or read every cycle) to decrease your bandwidth
  memory #(
      .WIDTH(EXT_MEM_WIDTH),
      .HEIGHT(EXT_MEM_HEIGHT),
      .USED_AS_EXTERNAL_MEM(1)
  ) ext_mem (
      .clk(clk),
      .read_addr(ext_mem_read_addr),
      .read_en(ext_mem_read_en),
      .qout(ext_mem_qout),
      .write_addr(ext_mem_write_addr),
      .din(ext_mem_din),
      .write_en(ext_mem_write_en)
  );

  top_chip #(
      .IO_DATA_WIDTH(IO_DATA_WIDTH),
      .ACCUMULATION_WIDTH(ACCUMULATION_WIDTH),
      .EXT_MEM_HEIGHT(EXT_MEM_HEIGHT),
      .EXT_MEM_WIDTH(EXT_MEM_WIDTH),
      .FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
      .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
      .INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
      .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS)
  ) top_chip_i (
      .clk(clk),
      .arst_n_in(arst_n_in),

      .ext_mem_read_addr(ext_mem_read_addr),
      .ext_mem_read_en(ext_mem_read_en),
      .ext_mem_qout(ext_mem_qout),
      .ext_mem_write_addr(ext_mem_write_addr),
      .ext_mem_write_en(ext_mem_write_en),
      .ext_mem_din(ext_mem_din),

      .conv_kernel_mode(conv_kernel_mode),
      .conv_stride_mode(conv_stride_mode),

      .a_input(a_input),
      .a_valid(a_valid),
      .a_ready(a_ready),
      .b_input(b_input),
      .b_valid(b_valid),
      .b_ready(b_ready),

      .out(out),
      .output_valid(output_valid),
      .output_x(output_x),
      .output_y(output_y),
      .output_ch(output_ch),

      .start  (start),
      .running(running)
  );
endmodule
