module top_chip #(
    //initial values are overwritten by tbench_top
    parameter int IO_DATA_WIDTH = 16,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int FEATURE_MAP_WIDTH = 128,
    parameter int FEATURE_MAP_HEIGHT = 128,
    parameter int INPUT_NB_CHANNELS = 2,
    parameter int OUTPUT_NB_CHANNELS = 32
) (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    input logic [1:0] conv_stride_mode,
    // Currently support 3 modes:
    // 0: step = 1 ; 1: step = 2 ; 2: step = 4

    // Interface data inputs
    input logic [IO_DATA_WIDTH-1:0] a_input,
    input logic [IO_DATA_WIDTH-1:0] b_input,
    input logic a_valid,
    output logic a_ready,
    

    // Interface data outputs
    output logic signed [IO_DATA_WIDTH-1:0] out,
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch,


    input  logic start,
    output logic running
);
  
  // Define MAC outputs
  logic signed [IO_DATA_WIDTH-1:0] mac_out0;
  logic signed [IO_DATA_WIDTH-1:0] mac_out1;
  logic signed [IO_DATA_WIDTH-1:0] mac_out2;
  logic signed [IO_DATA_WIDTH-1:0] mac_out3;
  logic signed [IO_DATA_WIDTH-1:0] mac_out4;
  logic signed [IO_DATA_WIDTH-1:0] mac_out5;
  logic signed [IO_DATA_WIDTH-1:0] mac_out6;
  logic signed [IO_DATA_WIDTH-1:0] mac_out7;
  logic signed [IO_DATA_WIDTH-1:0] mac_out8;
  logic signed [IO_DATA_WIDTH-1:0] mac_out9;
  logic signed [IO_DATA_WIDTH-1:0] mac_out10;
  logic signed [IO_DATA_WIDTH-1:0] mac_out11;
  logic signed [IO_DATA_WIDTH-1:0] mac_out12;
  logic signed [IO_DATA_WIDTH-1:0] mac_out13;
  logic signed [IO_DATA_WIDTH-1:0] mac_out14;
  logic signed [IO_DATA_WIDTH-1:0] mac_out15;
  
  
  // Define KERNEL SRAM outputs
  logic [IO_DATA_WIDTH-1:0] KERNEL_out0;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out1;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out2;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out3;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out4;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out5;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out6;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out7;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out8;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out9;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out10;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out11;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out12;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out13;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out14;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out15;
  
  // Define KERNEL Write Enables
  logic KERNEL_we_0;
  logic KERNEL_we_1;
  logic KERNEL_we_2;
  logic KERNEL_we_3;
  logic KERNEL_we_4;
  logic KERNEL_we_5;
  logic KERNEL_we_6;
  logic KERNEL_we_7;
  logic KERNEL_we_8;
  logic KERNEL_we_9;
  logic KERNEL_we_10;
  logic KERNEL_we_11;
  logic KERNEL_we_12;
  logic KERNEL_we_13;
  logic KERNEL_we_14;
  logic KERNEL_we_15;
  
  

  
  // Define REGs Feature_i (18 regs)
  logic Feature_we; //write enable for all REG Features at the same time
  `REG(IO_DATA_WIDTH, Feature_0); // qout used in super_mac
  `REG(IO_DATA_WIDTH, Feature_1); // din comes from regs Next_Feature_i
  `REG(IO_DATA_WIDTH, Feature_2); // we set by Feature_we which is set by controller
  `REG(IO_DATA_WIDTH, Feature_3); 
  `REG(IO_DATA_WIDTH, Feature_4); 
  `REG(IO_DATA_WIDTH, Feature_5); 
  `REG(IO_DATA_WIDTH, Feature_6); 
  `REG(IO_DATA_WIDTH, Feature_7); 
  `REG(IO_DATA_WIDTH, Feature_8); 
  `REG(IO_DATA_WIDTH, Feature_9); 
  `REG(IO_DATA_WIDTH, Feature_10);
  `REG(IO_DATA_WIDTH, Feature_11); 
  `REG(IO_DATA_WIDTH, Feature_12); 
  `REG(IO_DATA_WIDTH, Feature_13); 
  `REG(IO_DATA_WIDTH, Feature_14); 
  `REG(IO_DATA_WIDTH, Feature_15);  
  `REG(IO_DATA_WIDTH, Feature_16);
  `REG(IO_DATA_WIDTH, Feature_17);
  
  // Defines REGs Next_Feature_i (18 regs)
  `REG(IO_DATA_WIDTH, Next_Feature_0); // qout used as input for regs Feature_i
  `REG(IO_DATA_WIDTH, Next_Feature_1); // din comes from a_input and b_input, from interface
  `REG(IO_DATA_WIDTH, Next_Feature_2); // we set by controller for all 18
  `REG(IO_DATA_WIDTH, Next_Feature_3); 
  `REG(IO_DATA_WIDTH, Next_Feature_4); 
  `REG(IO_DATA_WIDTH, Next_Feature_5); 
  `REG(IO_DATA_WIDTH, Next_Feature_6); 
  `REG(IO_DATA_WIDTH, Next_Feature_7); 
  `REG(IO_DATA_WIDTH, Next_Feature_8); 
  `REG(IO_DATA_WIDTH, Next_Feature_9); 
  `REG(IO_DATA_WIDTH, Next_Feature_10); 
  `REG(IO_DATA_WIDTH, Next_Feature_11); 
  `REG(IO_DATA_WIDTH, Next_Feature_12); 
  `REG(IO_DATA_WIDTH, Next_Feature_13); 
  `REG(IO_DATA_WIDTH, Next_Feature_14);
  `REG(IO_DATA_WIDTH, Next_Feature_15); 
  `REG(IO_DATA_WIDTH, Next_Feature_16); 
  `REG(IO_DATA_WIDTH, Next_Feature_17); 
  
  // Defines REGs Output_i (16 regs)
  logic Output_we;
  `REG(IO_DATA_WIDTH, Output_0); // qout used for output interface
  `REG(IO_DATA_WIDTH, Output_1); // din comes from super_mac
  `REG(IO_DATA_WIDTH, Output_2); // we set by Output_we which is set by controller
  `REG(IO_DATA_WIDTH, Output_3);
  `REG(IO_DATA_WIDTH, Output_4);
  `REG(IO_DATA_WIDTH, Output_5);
  `REG(IO_DATA_WIDTH, Output_6);
  `REG(IO_DATA_WIDTH, Output_7);
  `REG(IO_DATA_WIDTH, Output_8);
  `REG(IO_DATA_WIDTH, Output_9);
  `REG(IO_DATA_WIDTH, Output_10);
  `REG(IO_DATA_WIDTH, Output_11);
  `REG(IO_DATA_WIDTH, Output_12);
  `REG(IO_DATA_WIDTH, Output_13);
  `REG(IO_DATA_WIDTH, Output_14);
  `REG(IO_DATA_WIDTH, Output_15);
  
  // Defines din for REGs Feature_i
  assign Feature_0_next = Next_Feature_0;
  assign Feature_1_next = Next_Feature_1;
  assign Feature_2_next = Next_Feature_2;
  assign Feature_3_next = Next_Feature_3;
  assign Feature_4_next = Next_Feature_4;
  assign Feature_5_next = Next_Feature_5;
  assign Feature_6_next = Next_Feature_6;
  assign Feature_7_next = Next_Feature_7;
  assign Feature_8_next = Next_Feature_8;
  assign Feature_9_next = Next_Feature_9;
  assign Feature_10_next = Next_Feature_10;
  assign Feature_11_next = Next_Feature_11;
  assign Feature_12_next = Next_Feature_12;
  assign Feature_13_next = Next_Feature_13;
  assign Feature_14_next = Next_Feature_14;
  assign Feature_15_next = Next_Feature_15;
  assign Feature_16_next = Next_Feature_16;
  assign Feature_17_next = Next_Feature_17;
  
  // Defines din for REGs Next_Feature_i
  assign Next_Feature_0_next = a_input;
  assign Next_Feature_1_next = a_input;
  assign Next_Feature_2_next = a_input;
  assign Next_Feature_3_next = a_input;
  assign Next_Feature_4_next = a_input;
  assign Next_Feature_5_next = a_input;
  assign Next_Feature_6_next = a_input;
  assign Next_Feature_7_next = a_input;
  assign Next_Feature_8_next = a_input;

  assign Next_Feature_9_next = b_input;
  assign Next_Feature_10_next = b_input;
  assign Next_Feature_11_next = b_input;
  assign Next_Feature_12_next = b_input;
  assign Next_Feature_13_next = b_input;
  assign Next_Feature_14_next = b_input;
  assign Next_Feature_15_next = b_input;
  assign Next_Feature_16_next = b_input;
  assign Next_Feature_17_next = b_input;
  
  // Defines din for REGs Output_i
  assign Output_0_next = mac_out0;
  assign Output_1_next = mac_out1;
  assign Output_2_next = mac_out2;
  assign Output_3_next = mac_out3;
  assign Output_4_next = mac_out4;
  assign Output_5_next = mac_out5;
  assign Output_6_next = mac_out6;
  assign Output_7_next = mac_out7;
  assign Output_8_next = mac_out8;
  assign Output_9_next = mac_out9;
  assign Output_10_next = mac_out10;
  assign Output_11_next = mac_out11;
  assign Output_12_next = mac_out12;
  assign Output_13_next = mac_out13;
  assign Output_14_next = mac_out14;
  assign Output_15_next = mac_out15;
  
  // Define we for REGs Feature_i ;; is the same for all regs
  assign Feature_0_we = Feature_we;
  assign Feature_1_we = Feature_we;
  assign Feature_2_we = Feature_we;
  assign Feature_3_we = Feature_we;
  assign Feature_4_we = Feature_we;
  assign Feature_5_we = Feature_we;
  assign Feature_6_we = Feature_we;
  assign Feature_7_we = Feature_we;
  assign Feature_8_we = Feature_we;
  assign Feature_9_we = Feature_we;
  assign Feature_10_we = Feature_we;
  assign Feature_11_we = Feature_we;
  assign Feature_12_we = Feature_we;
  assign Feature_13_we = Feature_we;
  assign Feature_14_we = Feature_we;
  assign Feature_15_we = Feature_we;
  assign Feature_16_we = Feature_we;
  assign Feature_17_we = Feature_we;
  
  // Define we for REGS Output_i ;; is the same for all regs
  assign Output_0_we = Output_we;
  assign Output_1_we = Output_we;
  assign Output_2_we = Output_we;
  assign Output_3_we = Output_we;
  assign Output_4_we = Output_we;
  assign Output_5_we = Output_we;
  assign Output_6_we = Output_we;
  assign Output_7_we = Output_we;
  assign Output_8_we = Output_we;
  assign Output_9_we = Output_we;
  assign Output_10_we = Output_we;
  assign Output_11_we = Output_we;
  assign Output_12_we = Output_we;
  assign Output_13_we = Output_we;
  assign Output_14_we = Output_we;
  assign Output_15_we = Output_we;
  
  // Define 18 to 1 mux for feature input to macs
  logic [IO_DATA_WIDTH-1:0] super_mac_a;
  logic [4:0] mux18_select;
  always @(*) begin
    case (mux18_select)
        5'd0: super_mac_a = Feature_0;
        5'd1: super_mac_a = Feature_1;
        5'd2: super_mac_a = Feature_2;
        5'd3: super_mac_a = Feature_3;
        5'd4: super_mac_a = Feature_4;
        5'd5: super_mac_a = Feature_5;
        5'd6: super_mac_a = Feature_6;
        5'd7: super_mac_a = Feature_7;
        5'd8: super_mac_a = Feature_8;
        5'd9: super_mac_a = Feature_9;
        5'd10: super_mac_a = Feature_10;
        5'd11: super_mac_a = Feature_11;
        5'd12: super_mac_a = Feature_12;
        5'd13: super_mac_a = Feature_13;
        5'd14: super_mac_a = Feature_14;
        5'd15: super_mac_a = Feature_15;
        5'd16: super_mac_a = Feature_16;
        5'd17: super_mac_a = Feature_17;
      default: super_mac_a = 0; // Default case for invalid select values
    endcase
  end
  
  // Define 16 to 1 mux for selection of output to interface
  logic signed [IO_DATA_WIDTH-1:0] output_data;
  assign out = output_data;
  always @(*) begin
    case (output_ch)
        5'd0: output_data = Output_0;
        5'd1: output_data = Output_1;
        5'd2: output_data = Output_2;
        5'd3: output_data = Output_3;
        5'd4: output_data = Output_4;
        5'd5: output_data = Output_5;
        5'd6: output_data = Output_6;
        5'd7: output_data = Output_7;
        5'd8: output_data = Output_8;
        5'd9: output_data = Output_9;
        5'd10: output_data = Output_10;
        5'd11: output_data = Output_11;
        5'd12: output_data = Output_12;
        5'd13: output_data = Output_13;
        5'd14: output_data = Output_14;
        5'd15: output_data = Output_15;
      default: output_data = 0; // Default case for invalid select values
    endcase
  end
        
  
     logic mac_valid;
     logic product_valid;
     logic mac_accumulate_internal;
  
    // Define super_mac := 16 mac units
    super_mac #(
      .A_WIDTH(IO_DATA_WIDTH),
      .B_WIDTH(IO_DATA_WIDTH),
      .ACCUMULATOR_WIDTH(ACCUMULATION_WIDTH),
      .OUTPUT_WIDTH(IO_DATA_WIDTH),
      .OUTPUT_SCALE(0)
  ) super_mac_unit (
      // Global inputs 
      .clk(clk),
      .arst_n_in(arst_n_in),
      .input_valid(mac_valid),
      .p_valid(product_valid),
      .accumulate_internal(mac_accumulate_internal),
      
      // Feature input
      .a(super_mac_a),
      
      // Kernel inputs
      .b0(KERNEL_out0),
      .b1(KERNEL_out1),
      .b2(KERNEL_out2),
      .b3(KERNEL_out3),
      .b4(KERNEL_out4),
      .b5(KERNEL_out5),
      .b6(KERNEL_out6),
      .b7(KERNEL_out7),
      .b8(KERNEL_out8),
      .b9(KERNEL_out9),
      .b10(KERNEL_out10),
      .b11(KERNEL_out11),
      .b12(KERNEL_out12),
      .b13(KERNEL_out13),
      .b14(KERNEL_out14),
      .b15(KERNEL_out15),
     
      // outputs
      .out0(mac_out0),
      .out1(mac_out1),
      .out2(mac_out2),
      .out3(mac_out3),
      .out4(mac_out4),
      .out5(mac_out5),
      .out6(mac_out6),
      .out7(mac_out7),
      .out8(mac_out8),
      .out9(mac_out9),
      .out10(mac_out10),
      .out11(mac_out11),
      .out12(mac_out12),
      .out13(mac_out13),
      .out14(mac_out14),
      .out15(mac_out15)
  );

      
    logic unsigned[$clog2(128)-1:0] KERNEL_read_addr;
    logic unsigned[$clog2(128)-1:0] KERNEL_write_addr;
    logic KERNEL_re;
    
    // Define KERNEL_SRAM := 16 SRAM units
    KERNEL_SRAM2 # (
        .WIDTH(IO_DATA_WIDTH)
   )KERNEL_SRAM(
      .clk(clk),
      .KERNEL_read_addr(KERNEL_read_addr),
      .KERNEL_write_addr(KERNEL_write_addr),
      .KERNEL_re(KERNEL_re),
      
      .KERNEL_din_0(a_input),
      .KERNEL_din_1(b_input),
      .KERNEL_din_2(a_input),
      .KERNEL_din_3(b_input),
      .KERNEL_din_4(a_input),
      .KERNEL_din_5(b_input),
      .KERNEL_din_6(a_input),
      .KERNEL_din_7(b_input),
      .KERNEL_din_8(a_input),
      .KERNEL_din_9(b_input),
      .KERNEL_din_10(a_input),
      .KERNEL_din_11(b_input),
      .KERNEL_din_12(a_input),
      .KERNEL_din_13(b_input),
      .KERNEL_din_14(a_input),
      .KERNEL_din_15(b_input),
      
      .KERNEL_we_0(KERNEL_we_0),
      .KERNEL_we_1(KERNEL_we_1),
      .KERNEL_we_2(KERNEL_we_2),
      .KERNEL_we_3(KERNEL_we_3),
      .KERNEL_we_4(KERNEL_we_4),
      .KERNEL_we_5(KERNEL_we_5),
      .KERNEL_we_6(KERNEL_we_6),
      .KERNEL_we_7(KERNEL_we_7),
      .KERNEL_we_8(KERNEL_we_8),
      .KERNEL_we_9(KERNEL_we_9),
      .KERNEL_we_10(KERNEL_we_10),
      .KERNEL_we_11(KERNEL_we_11),
      .KERNEL_we_12(KERNEL_we_12),
      .KERNEL_we_13(KERNEL_we_13),
      .KERNEL_we_14(KERNEL_we_14),
      .KERNEL_we_15(KERNEL_we_15),
      
      .KERNEL_qout_0(KERNEL_out0),
      .KERNEL_qout_1(KERNEL_out1),
      .KERNEL_qout_2(KERNEL_out2),
      .KERNEL_qout_3(KERNEL_out3),
      .KERNEL_qout_4(KERNEL_out4),
      .KERNEL_qout_5(KERNEL_out5),
      .KERNEL_qout_6(KERNEL_out6),
      .KERNEL_qout_7(KERNEL_out7),
      .KERNEL_qout_8(KERNEL_out8),
      .KERNEL_qout_9(KERNEL_out9),
      .KERNEL_qout_10(KERNEL_out10),
      .KERNEL_qout_11(KERNEL_out11),
      .KERNEL_qout_12(KERNEL_out12),
      .KERNEL_qout_13(KERNEL_out13),
      .KERNEL_qout_14(KERNEL_out14),
      .KERNEL_qout_15(KERNEL_out15)
     );


 controller_fsm #(
      .FEATURE_MAP_WIDTH (FEATURE_MAP_WIDTH),
      .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
      .INPUT_NB_CHANNELS (INPUT_NB_CHANNELS),
      .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS)
  ) controller (
      .clk(clk),
      .arst_n_in(arst_n_in),
      
      .start(start),
      .running(running),
      
      .conv_stride_mode(conv_stride_mode),
      
      .a_valid(a_valid),
      .a_ready(a_ready),
      
      .output_valid(output_valid),
      .output_x(output_x),
      .output_y(output_y),
      .output_ch(output_ch),
      
      .Feature_we(Feature_we),
      .Output_we(Output_we),
    
      .Next_Feature_0_we(Next_Feature_0_we),
      .Next_Feature_1_we(Next_Feature_1_we),
      .Next_Feature_2_we(Next_Feature_2_we),
      .Next_Feature_3_we(Next_Feature_3_we),
      .Next_Feature_4_we(Next_Feature_4_we),
      .Next_Feature_5_we(Next_Feature_5_we),
      .Next_Feature_6_we(Next_Feature_6_we),
      .Next_Feature_7_we(Next_Feature_7_we),
      .Next_Feature_8_we(Next_Feature_8_we),
      .Next_Feature_9_we(Next_Feature_9_we),
      .Next_Feature_10_we(Next_Feature_10_we),
      .Next_Feature_11_we(Next_Feature_11_we),
      .Next_Feature_12_we(Next_Feature_12_we),
      .Next_Feature_13_we(Next_Feature_13_we),
      .Next_Feature_14_we(Next_Feature_14_we),
      .Next_Feature_15_we(Next_Feature_15_we),
      .Next_Feature_16_we(Next_Feature_16_we),
      .Next_Feature_17_we(Next_Feature_17_we),
      
      .mux18_select(mux18_select),
      .mac_valid(mac_valid),
      .product_valid(product_valid),
      .mac_accumulate_internal(mac_accumulate_internal),

      .KERNEL_read_addr(KERNEL_read_addr),
      .KERNEL_write_addr(KERNEL_write_addr),
      .KERNEL_re(KERNEL_re),
    
    
      .KERNEL_we_0(KERNEL_we_0),
      .KERNEL_we_1(KERNEL_we_1),
      .KERNEL_we_2(KERNEL_we_2),
      .KERNEL_we_3(KERNEL_we_3),
      .KERNEL_we_4(KERNEL_we_4),
      .KERNEL_we_5(KERNEL_we_5),
      .KERNEL_we_6(KERNEL_we_6),
      .KERNEL_we_7(KERNEL_we_7),
      .KERNEL_we_8(KERNEL_we_8),
      .KERNEL_we_9(KERNEL_we_9),
      .KERNEL_we_10(KERNEL_we_10),
      .KERNEL_we_11(KERNEL_we_11),
      .KERNEL_we_12(KERNEL_we_12),
      .KERNEL_we_13(KERNEL_we_13),
      .KERNEL_we_14(KERNEL_we_14),
      .KERNEL_we_15(KERNEL_we_15)
      
  );

  


endmodule
