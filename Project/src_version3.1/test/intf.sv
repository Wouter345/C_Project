interface intf #(
    config_t cfg
  )
  (
    input logic clk
  );
  logic arst_n;

  /*#############################
  WHEN ADJUSTING THIS INTERFACE, ADJUST THE ENERGY ADDITIONS AT THE BOTTOM ACCORDINGLY!
  ################################*/
  
  logic [1:0] conv_stride_mode;
  
  // bidirectional connections 
  wire [cfg.DATA_WIDTH - 1 : 0] bus_1;
  wire [cfg.DATA_WIDTH - 1 : 0] bus_2;
  wire [cfg.DATA_WIDTH - 1 : 0] bus_3;

  
  logic bus_valid; // set by driver side
  logic bus_ready; // set by dut side

  logic dut_driving_busses;

  logic [cfg.DATA_WIDTH-1:0] to_bus_1;   //to_bidir_bus; set by DRIVER
  logic [cfg.DATA_WIDTH-1:0] to_bus_2;
  logic [cfg.DATA_WIDTH-1:0] to_bus_3;
  
  logic [cfg.DATA_WIDTH-1:0] from_bus_1; //from_bidir_bus; used for MONITOR
  logic [cfg.DATA_WIDTH-1:0] from_bus_2;
  logic [cfg.DATA_WIDTH-1:0] from_bus_3;

  // output control signals (DUT --> monitor)
  logic output_valid;
  logic [$clog2(cfg.FEATURE_MAP_WIDTH)-1:0] output_x;
  logic [$clog2(cfg.FEATURE_MAP_HEIGHT)-1:0] output_y;
  logic [$clog2(cfg.OUTPUT_NB_CHANNELS)-1:0] output_ch;

  logic start;
  logic running;

  default clocking cb @(posedge clk);
    default input #0.01 output #0.01;
    output arst_n;
    output conv_stride_mode;
    
    output to_bus_1;
    input  from_bus_1;

    output to_bus_2;
    input  from_bus_2;

    output to_bus_3;
    input  from_bus_3;

    output bus_valid;
    input  bus_ready;
    
    input dut_driving_busses;

    input output_valid;
    input output_x;
    input output_y;
    input output_ch;

    output start;
    input  running;
   
  endclocking

  modport tb (clocking cb); // testbench's view of the interface

  assign bus_1 = (dut_driving_busses) ? 'Z : to_bus_1;
  assign bus_2 = (dut_driving_busses) ? 'Z : to_bus_2;
  assign bus_3 = (dut_driving_busses) ? 'Z : to_bus_3;

  assign from_bus_1 = bus_1;
  assign from_bus_2 = bus_2;
  assign from_bus_3 = bus_3;

  //ENERGY ESTIMATION:
  always @ (posedge clk) begin
    if(bus_valid && bus_ready) begin
      tbench_top.energy += 3*(cfg.DATA_WIDTH);
    end
  end
  always @ (posedge clk) begin
    if(output_valid) begin
      tbench_top.energy += 3*(cfg.DATA_WIDTH);
    end
  end

endinterface