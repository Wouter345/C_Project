interface intf #(
    config_t cfg
) (
    input logic clk
);
  logic arst_n;

  /*#############################
  WHEN ADJUSTING THIS INTERFACE, ADJUST THE ENERGY ADDITIONS AT THE BOTTOM ACCORDINGLY!
  ################################*/

  // input interface
  logic [1:0] conv_stride_mode;
  logic [cfg.DATA_WIDTH - 1 : 0] a_input;
  logic [cfg.DATA_WIDTH - 1 : 0] b_input;
  logic a_valid; 
  logic a_ready;

 
  // output interface
  logic signed [cfg.DATA_WIDTH-1:0] output_data;
  logic output_valid;
  logic [$clog2(cfg.FEATURE_MAP_WIDTH)-1:0] output_x; //x-coordinate output
  logic [$clog2(cfg.FEATURE_MAP_HEIGHT)-1:0] output_y; //y-coordinate output
  logic [$clog2(cfg.OUTPUT_NB_CHANNELS)-1:0] output_ch; //channel select output

  logic start;
  logic running;

  default clocking cb @(posedge clk); // avoids race conditions
    default input #0.01 output #0.01; //input comes from the DUT; output goes to DUT

    output conv_stride_mode;
    output arst_n;
    
    
    output a_input;
    output b_input;
    output a_valid;
    input a_ready;

   

    input output_data;
    input output_valid;
    input output_x;
    input output_y;
    input output_ch;


    output start;
    input running;
  endclocking

  modport tb(clocking cb); // defines directionality
  // testbench's view of the interface

  //ENERGY ESTIMATION:
  always @(posedge clk) begin
    if (a_valid && a_ready) begin
      tbench_top.energy += 2 * (cfg.DATA_WIDTH); //read 2 signals input_a and input_b: 32 bits total
    end
  end

  always @(posedge clk) begin
    if (output_valid && 1) begin  //no ready here, set to 1 
      tbench_top.energy += 1 * (cfg.DATA_WIDTH); // write OUT is 1 energy per bit
    end
  end


endinterface
