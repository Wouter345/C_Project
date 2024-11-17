module tbench_top;
  //change this according to your critical path length.
  //The code will error* if it too short, but you will get no feedback if it is longer than necessary
  //* if 1) you use the adder and multiplier modules for datapath adders and multipliers and not the plain verilog + and * operators
  // and 2) enough calculations are going on, with non-x data (this will be the case for functionally working code)
  localparam int CONV_STEP = 1;
  
  localparam int CLK_PERIOD = 2;

  localparam int DATA_WIDTH = 16;
  localparam int ACCUMULATION_WIDTH = 16;  //----> changed to 16
  localparam int FEATURE_MAP_WIDTH = 128;
  localparam int FEATURE_MAP_HEIGHT = 128;


  localparam int INPUT_NB_CHANNELS = 2;
  localparam int OUTPUT_NB_CHANNELS = 16;
  localparam int KERNEL_SIZE = 3;
  
    // initialize config_t structure, which is used to parameterize all other classes of the testbench (common.sv)
  localparam config_t cfg = '{
      DATA_WIDTH,
      ACCUMULATION_WIDTH,
      FEATURE_MAP_WIDTH,
      FEATURE_MAP_HEIGHT,
      INPUT_NB_CHANNELS,
      OUTPUT_NB_CHANNELS,
      KERNEL_SIZE,
      CONV_STEP
  };

  initial $timeformat(-9, 0, "ns", 1); //time unit -9=1ns; precision= #fractional digits for current timescale

  //clock
  bit clk;
  always #(CLK_PERIOD * 1.0 / 2.0) clk = !clk;

  //interface
  intf #(cfg) intf_i (clk);

  testprogram #(cfg) t1 (intf_i.tb);

  //DUT
  top_system #(
      .IO_DATA_WIDTH     (DATA_WIDTH),
      .ACCUMULATION_WIDTH(ACCUMULATION_WIDTH),
      .FEATURE_MAP_WIDTH (FEATURE_MAP_WIDTH),
      .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
      .INPUT_NB_CHANNELS (INPUT_NB_CHANNELS),
      .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS)
  ) dut (
      .clk      (intf_i.clk),
      .arst_n_in(intf_i.arst_n),

      .conv_stride_mode(intf_i.conv_stride_mode),

      .a_input(intf_i.a_input),
      .b_input(intf_i.b_input),
      .a_valid(intf_i.a_valid),
      .a_ready(intf_i.a_ready),

      .out         (intf_i.output_data),
      .output_valid(intf_i.output_valid),
      .output_x    (intf_i.output_x),
      .output_y    (intf_i.output_y),
      .output_ch   (intf_i.output_ch),

      .start  (intf_i.start),
      .running(intf_i.running)
  );


  //area logging init
  longint area;
  initial begin
    area = 0;
    #0;
    #0;
    $display("\n\n------------\nAREA: %0d\n------------\n\n", area);
  end
  //energy loggin init;
  real energy;
  initial begin
    energy = 0;
  end
  
  



endmodule