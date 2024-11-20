//wraps top_chip ; no external memory used
//bandwidth to be counted is all bandwidth in and out of top_chip
module top_system #(
    // these initial values are overwritten by tbench_top
    parameter int IO_DATA_WIDTH = 16,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int FEATURE_MAP_WIDTH = 1024,
    parameter int FEATURE_MAP_HEIGHT = 1024,
    parameter int INPUT_NB_CHANNELS = 64,
    parameter int OUTPUT_NB_CHANNELS = 64
) (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    input logic [1:0] conv_stride_mode,
    // Currently support 3 modes:
    // 0: step = 1, 1: step = 2, 2: step = 4

    //bidirectional data lines
    inout wire [IO_DATA_WIDTH-1:0] bus_1, 
    inout wire [IO_DATA_WIDTH-1:0] bus_2, 
    inout wire [IO_DATA_WIDTH-1:0] bus_3, 
    
    // handshake signals
    input logic bus_valid,
    output logic bus_ready,
    
    // is dut driving cons?
    output logic driving_busses,
    
    // output control signals
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch,


    input  logic start,
    output logic running
);


  top_chip #(
      .IO_DATA_WIDTH(IO_DATA_WIDTH),
      .ACCUMULATION_WIDTH(ACCUMULATION_WIDTH),
      .FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
      .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
      .INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
      .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS)
  ) top_chip_i (
      .clk(clk),
      .arst_n_in(arst_n_in),

      .conv_stride_mode(conv_stride_mode),

      .bus_1(bus_1),
      .bus_2(bus_2),
      .bus_3(bus_3),

      .bus_valid(bus_valid),
      .bus_ready(bus_ready),
      
      .driving_busses(driving_busses),

      .output_valid(output_valid),
      .output_x(output_x),
      .output_y(output_y),
      .output_ch(output_ch),

      .start  (start),
      .running(running)
  );

endmodule
