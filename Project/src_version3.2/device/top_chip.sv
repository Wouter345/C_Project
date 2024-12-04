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

    // bidirectional busses
    inout wire [IO_DATA_WIDTH-1:0] bus_1,
    inout wire [IO_DATA_WIDTH-1:0] bus_2,
    inout wire [IO_DATA_WIDTH-1:0] bus_3,
    
    input logic bus_valid,
    output logic bus_ready,
    
    // is dut driving the connections
    output logic driving_busses,
    
    // Interface data outputs
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch,


    input  logic start,
    output logic running
);
  
  // Bidir busses connections
  logic [IO_DATA_WIDTH-1:0] to_bus_1;   //to_bidir_bus;
  logic [IO_DATA_WIDTH-1:0] to_bus_2;
  logic [IO_DATA_WIDTH-1:0] to_bus_3;
  
  logic [IO_DATA_WIDTH-1:0] from_bus_1; //from_bidir_bus;
  logic [IO_DATA_WIDTH-1:0] from_bus_2;
  logic [IO_DATA_WIDTH-1:0] from_bus_3;
  
  assign bus_1 = (driving_busses) ? to_bus_1 : 'Z;
  assign from_bus_1 = bus_1;
  assign bus_2 = (driving_busses) ? to_bus_2 : 'Z;
  assign from_bus_2 = bus_2;
  assign bus_3 = (driving_busses) ? to_bus_3 : 'Z;
  assign from_bus_3 = bus_3;
  
  
  
  // Define MAC outputs
  logic signed [IO_DATA_WIDTH-1:0] mac_out0a, mac_out0b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out1a, mac_out1b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out2a, mac_out2b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out3a, mac_out3b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out4a, mac_out4b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out5a, mac_out5b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out6a, mac_out6b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out7a, mac_out7b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out8a, mac_out8b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out9a, mac_out9b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out10a, mac_out10b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out11a, mac_out11b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out12a, mac_out12b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out13a, mac_out13b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out14a, mac_out14b;
  logic signed [IO_DATA_WIDTH-1:0] mac_out15a, mac_out15b;

  // Define KERNEL SRAM outputs
  logic [IO_DATA_WIDTH-1:0] KERNEL_out0a, KERNEL_out0b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out1a, KERNEL_out1b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out2a, KERNEL_out2b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out3a, KERNEL_out3b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out4a, KERNEL_out4b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out5a, KERNEL_out5b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out6a, KERNEL_out6b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out7a, KERNEL_out7b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out8a, KERNEL_out8b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out9a, KERNEL_out9b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out10a, KERNEL_out10b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out11a, KERNEL_out11b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out12a, KERNEL_out12b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out13a, KERNEL_out13b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out14a, KERNEL_out14b;
  logic [IO_DATA_WIDTH-1:0] KERNEL_out15a, KERNEL_out15b;
  
  // Define KERNEL Write Enables
  logic KERNEL_we_0a, KERNEL_we_0b;
  logic KERNEL_we_1a, KERNEL_we_1b;
  logic KERNEL_we_2a, KERNEL_we_2b;
  logic KERNEL_we_3a, KERNEL_we_3b;
  logic KERNEL_we_4a, KERNEL_we_4b;
  logic KERNEL_we_5a, KERNEL_we_5b;
  logic KERNEL_we_6a, KERNEL_we_6b;
  logic KERNEL_we_7a, KERNEL_we_7b;
  logic KERNEL_we_8a, KERNEL_we_8b;
  logic KERNEL_we_9a, KERNEL_we_9b;
  logic KERNEL_we_10a, KERNEL_we_10b;
  logic KERNEL_we_11a, KERNEL_we_11b;
  logic KERNEL_we_12a, KERNEL_we_12b;
  logic KERNEL_we_13a, KERNEL_we_13b;
  logic KERNEL_we_14a, KERNEL_we_14b;
  logic KERNEL_we_15a, KERNEL_we_15b;
  
  // Define KERNEL_we multiplexer
  logic [4:0] mux_KERNEL_we_select;
  always_comb
  begin
    KERNEL_we_0a = 0; KERNEL_we_0b = 0;
    KERNEL_we_1a = 0; KERNEL_we_1b = 0;
    KERNEL_we_2a = 0; KERNEL_we_2b = 0;
    KERNEL_we_3a = 0; KERNEL_we_3b = 0;
    KERNEL_we_4a = 0; KERNEL_we_4b = 0;
    KERNEL_we_5a = 0; KERNEL_we_5b = 0;
    KERNEL_we_6a = 0; KERNEL_we_6b = 0;
    KERNEL_we_7a = 0; KERNEL_we_7b = 0;
    KERNEL_we_8a = 0; KERNEL_we_8b = 0;
    KERNEL_we_9a = 0; KERNEL_we_9b = 0;
    KERNEL_we_10a = 0; KERNEL_we_10b = 0;
    KERNEL_we_11a = 0; KERNEL_we_11b = 0;
    KERNEL_we_12a = 0; KERNEL_we_12b = 0;
    KERNEL_we_13a = 0; KERNEL_we_13b = 0;
    KERNEL_we_14a = 0; KERNEL_we_14b = 0;
    KERNEL_we_15a = 0; KERNEL_we_15b = 0;
    case(mux_KERNEL_we_select)
        0: begin
            KERNEL_we_0a = 1;
            KERNEL_we_1a = 1; end
        1: begin
            KERNEL_we_2a = 1;
            KERNEL_we_3a = 1; end
        2: begin
            KERNEL_we_4a = 1;
            KERNEL_we_5a = 1; end
        3: begin
            KERNEL_we_6a = 1;
            KERNEL_we_7a = 1; end
        4: begin
            KERNEL_we_8a = 1;
            KERNEL_we_9a = 1; end
        5: begin
            KERNEL_we_10a = 1;
            KERNEL_we_11a = 1; end
        6: begin
            KERNEL_we_12a = 1;
            KERNEL_we_13a = 1; end
        7: begin
            KERNEL_we_14a = 1;
            KERNEL_we_15a = 1; end
        8: begin
            KERNEL_we_0b = 1;
            KERNEL_we_1b = 1; end
        9: begin
            KERNEL_we_2b = 1;
            KERNEL_we_3b = 1; end
        10: begin
            KERNEL_we_4b = 1;
            KERNEL_we_5b = 1; end
        11: begin
            KERNEL_we_6b = 1;
            KERNEL_we_7b = 1; end
        12: begin
            KERNEL_we_8b = 1;
            KERNEL_we_9b = 1; end
        13: begin
            KERNEL_we_10b = 1;
            KERNEL_we_11b = 1; end
        14: begin
            KERNEL_we_12b = 1;
            KERNEL_we_13b = 1; end
        15: begin
            KERNEL_we_14b = 1;
            KERNEL_we_15b = 1; end
     endcase
  end
  

  // Define REGs Feature_i (18 regs)
  logic Feature_we; //write enable for all REG Features at the same time
  `REG(IO_DATA_WIDTH, Feature_0a); `REG(IO_DATA_WIDTH, Feature_0b); // qout used in super_mac
  `REG(IO_DATA_WIDTH, Feature_1a); `REG(IO_DATA_WIDTH, Feature_1b); // din comes from regs Next_Feature_i
  `REG(IO_DATA_WIDTH, Feature_2a); `REG(IO_DATA_WIDTH, Feature_2b); // we set by Feature_we which is set by controller
  `REG(IO_DATA_WIDTH, Feature_3a); `REG(IO_DATA_WIDTH, Feature_3b); 
  `REG(IO_DATA_WIDTH, Feature_4a); `REG(IO_DATA_WIDTH, Feature_4b); 
  `REG(IO_DATA_WIDTH, Feature_5a); `REG(IO_DATA_WIDTH, Feature_5b);
  `REG(IO_DATA_WIDTH, Feature_6a); `REG(IO_DATA_WIDTH, Feature_6b);
  `REG(IO_DATA_WIDTH, Feature_7a); `REG(IO_DATA_WIDTH, Feature_7b); 
  `REG(IO_DATA_WIDTH, Feature_8a); `REG(IO_DATA_WIDTH, Feature_8b); 
  
  // Defines REGs Next_Feature_i (18 regs)
  `REG(IO_DATA_WIDTH, Next_Feature_0a); `REG(IO_DATA_WIDTH, Next_Feature_0b); // qout used as input for regs Feature_i
  `REG(IO_DATA_WIDTH, Next_Feature_1a); `REG(IO_DATA_WIDTH, Next_Feature_1b); // din comes from a_input and b_input, from interface
  `REG(IO_DATA_WIDTH, Next_Feature_2a); `REG(IO_DATA_WIDTH, Next_Feature_2b); // we set by controller for all 18
  `REG(IO_DATA_WIDTH, Next_Feature_3a); `REG(IO_DATA_WIDTH, Next_Feature_3b); 
  `REG(IO_DATA_WIDTH, Next_Feature_4a); `REG(IO_DATA_WIDTH, Next_Feature_4b); 
  `REG(IO_DATA_WIDTH, Next_Feature_5a); `REG(IO_DATA_WIDTH, Next_Feature_5b); 
  `REG(IO_DATA_WIDTH, Next_Feature_6a); `REG(IO_DATA_WIDTH, Next_Feature_6b);
  `REG(IO_DATA_WIDTH, Next_Feature_7a); `REG(IO_DATA_WIDTH, Next_Feature_7b);
  `REG(IO_DATA_WIDTH, Next_Feature_8a); `REG(IO_DATA_WIDTH, Next_Feature_8b); 

  // Defines REGs Output_i (16 regs)
  logic Output_we;
  `REG(IO_DATA_WIDTH, Output_0); // qout used for output interface
  `REG(IO_DATA_WIDTH, Output_1); // din comes from super_adders
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
  assign Feature_0a_next = Next_Feature_0a; assign Feature_0b_next = Next_Feature_0b;
  assign Feature_1a_next = Next_Feature_1a; assign Feature_1b_next = Next_Feature_1b;
  assign Feature_2a_next = Next_Feature_2a; assign Feature_2b_next = Next_Feature_2b;
  assign Feature_3a_next = Next_Feature_3a; assign Feature_3b_next = Next_Feature_3b;
  assign Feature_4a_next = Next_Feature_4a; assign Feature_4b_next = Next_Feature_4b;
  assign Feature_5a_next = Next_Feature_5a; assign Feature_5b_next = Next_Feature_5b;
  assign Feature_6a_next = Next_Feature_6a; assign Feature_6b_next = Next_Feature_6b;
  assign Feature_7a_next = Next_Feature_7a; assign Feature_7b_next = Next_Feature_7b;
  assign Feature_8a_next = Next_Feature_8a; assign Feature_8b_next = Next_Feature_8b;
  
  // Defines din for REGs Next_Feature_i
  assign Next_Feature_0a_next = from_bus_1; assign Next_Feature_0b_next = from_bus_1;
  assign Next_Feature_1a_next = from_bus_2; assign Next_Feature_1b_next = from_bus_2;
  assign Next_Feature_2a_next = from_bus_3; assign Next_Feature_2b_next = from_bus_3;
  assign Next_Feature_3a_next = from_bus_1; assign Next_Feature_3b_next = from_bus_1;
  assign Next_Feature_4a_next = from_bus_2; assign Next_Feature_4b_next = from_bus_2;
  assign Next_Feature_5a_next = from_bus_3; assign Next_Feature_5b_next = from_bus_3;
  assign Next_Feature_6a_next = from_bus_1; assign Next_Feature_6b_next = from_bus_1;
  assign Next_Feature_7a_next = from_bus_2; assign Next_Feature_7b_next = from_bus_2;
  assign Next_Feature_8a_next = from_bus_3; assign Next_Feature_8b_next = from_bus_3;

  // Defines din for REGs Output_i
  // = output of super adders
  
  // Define we for REGs Feature_i ;; is the same for all regs
  assign Feature_0a_we = Feature_we; assign Feature_0b_we = Feature_we;
  assign Feature_1a_we = Feature_we; assign Feature_1b_we = Feature_we;
  assign Feature_2a_we = Feature_we; assign Feature_2b_we = Feature_we;
  assign Feature_3a_we = Feature_we; assign Feature_3b_we = Feature_we;
  assign Feature_4a_we = Feature_we; assign Feature_4b_we = Feature_we;
  assign Feature_5a_we = Feature_we; assign Feature_5b_we = Feature_we;
  assign Feature_6a_we = Feature_we; assign Feature_6b_we = Feature_we;
  assign Feature_7a_we = Feature_we; assign Feature_7b_we = Feature_we;
  assign Feature_8a_we = Feature_we; assign Feature_8b_we = Feature_we;

  // Define we multiplexer for REGs Next_feature_i
  logic [2:0] mux_next_feature_we_select;
  always_comb
  begin
    Next_Feature_0a_we = 0; Next_Feature_0b_we = 0;
    Next_Feature_1a_we = 0; Next_Feature_1b_we = 0;
    Next_Feature_2a_we = 0; Next_Feature_2b_we = 0;
    Next_Feature_3a_we = 0; Next_Feature_3b_we = 0;
    Next_Feature_4a_we = 0; Next_Feature_4b_we = 0;
    Next_Feature_5a_we = 0; Next_Feature_5b_we = 0;
    Next_Feature_6a_we = 0; Next_Feature_6b_we = 0;
    Next_Feature_7a_we = 0; Next_Feature_7b_we = 0;
    Next_Feature_8a_we = 0; Next_Feature_8b_we = 0;
    case(mux_next_feature_we_select)
        0: begin
            Next_Feature_0a_we = 1;
            Next_Feature_1a_we = 1;
            Next_Feature_2a_we = 1; end
        1: begin
            Next_Feature_3a_we = 1;
            Next_Feature_4a_we = 1;
            Next_Feature_5a_we = 1; end
        2: begin
            Next_Feature_6a_we = 1;
            Next_Feature_7a_we = 1;
            Next_Feature_8a_we = 1; end
        3: begin
            Next_Feature_0b_we = 1;
            Next_Feature_1b_we = 1;
            Next_Feature_2b_we = 1; end
        4: begin
            Next_Feature_3b_we = 1;
            Next_Feature_4b_we = 1;
            Next_Feature_5b_we = 1; end
        5: begin
            Next_Feature_6b_we = 1;
            Next_Feature_7b_we = 1;
            Next_Feature_8b_we = 1; end
     endcase
  end
  
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
  
  // Define 18 to 2 mux for feature input super_mac_aa and super_mac_ab to macs
  logic [IO_DATA_WIDTH-1:0] super_mac_aa;
  logic [IO_DATA_WIDTH-1:0] super_mac_ab;
  logic [4:0] mux9_select;
  always @(*) begin
    case (mux9_select)
        0: begin
            super_mac_aa = Feature_0a;
            super_mac_ab = Feature_0b; end
        1: begin
            super_mac_aa = Feature_1a;
            super_mac_ab = Feature_1b; end
        2: begin
            super_mac_aa = Feature_2a;
            super_mac_ab = Feature_2b; end
        3: begin
            super_mac_aa = Feature_3a;
            super_mac_ab = Feature_3b; end
        4: begin
            super_mac_aa = Feature_4a;
            super_mac_ab = Feature_4b; end
        5: begin
            super_mac_aa = Feature_5a;
            super_mac_ab = Feature_5b; end    
        6: begin
            super_mac_aa = Feature_6a;
            super_mac_ab = Feature_6b; end
        7: begin
            super_mac_aa = Feature_7a;
            super_mac_ab = Feature_7b; end
        8: begin
            super_mac_aa = Feature_8a;
            super_mac_ab = Feature_8b; end       
        default: begin
            super_mac_aa = 0;
            super_mac_ab = 0; end
    endcase
  end
  
  // Define 16 to 3 mux for selection of output to interface
  logic signed [IO_DATA_WIDTH-1:0] output_data1, output_data2, output_data3;
  logic [2:0] mux_output_select;
  assign to_bus_1 = output_data1;
  assign to_bus_2 = output_data2;
  assign to_bus_3 = output_data3;
  always @(*) begin
    case (mux_output_select)
         0: begin
            output_data1 = Output_0;
            output_data2 = Output_1;
            output_data3 = Output_2; 
            output_ch = 0; end
         1: begin
            output_data1 = Output_3;
            output_data2 = Output_4;
            output_data3 = Output_5; 
            output_ch = 3; end
         2: begin
            output_data1 = Output_6;
            output_data2 = Output_7;
            output_data3 = Output_8; 
            output_ch = 6; end
         3: begin
            output_data1 = Output_9;
            output_data2 = Output_10;
            output_data3 = Output_11; 
            output_ch = 9; end
         4: begin
            output_data1 = Output_12;
            output_data2 = Output_13;
            output_data3 = Output_14; 
            output_ch = 12; end
         5: begin
            output_data1 = Output_15;
            output_data2 = 0;
            output_data3 = 0; 
            output_ch = 15; end
      default: begin
            output_data1 = 0;
            output_data2 = 0;
            output_data3 = 0; 
            output_ch = 0; end
    endcase
  end
        
  
     logic mac_valid;
     logic product_valid;
     logic mac_accumulate_internal;
  
    // Define super_mac := 32 mac units
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
      .aa(super_mac_aa),
      .ab(super_mac_ab),
      
      // Kernel inputs
      .b0a(KERNEL_out0a),
      .b1a(KERNEL_out1a),
      .b2a(KERNEL_out2a),
      .b3a(KERNEL_out3a),
      .b4a(KERNEL_out4a),
      .b5a(KERNEL_out5a),
      .b6a(KERNEL_out6a),
      .b7a(KERNEL_out7a),
      .b8a(KERNEL_out8a),
      .b9a(KERNEL_out9a),
      .b10a(KERNEL_out10a),
      .b11a(KERNEL_out11a),
      .b12a(KERNEL_out12a),
      .b13a(KERNEL_out13a),
      .b14a(KERNEL_out14a),
      .b15a(KERNEL_out15a),
      
      .b0b(KERNEL_out0b),
      .b1b(KERNEL_out1b),
      .b2b(KERNEL_out2b),
      .b3b(KERNEL_out3b),
      .b4b(KERNEL_out4b),
      .b5b(KERNEL_out5b),
      .b6b(KERNEL_out6b),
      .b7b(KERNEL_out7b),
      .b8b(KERNEL_out8b),
      .b9b(KERNEL_out9b),
      .b10b(KERNEL_out10b),
      .b11b(KERNEL_out11b),
      .b12b(KERNEL_out12b),
      .b13b(KERNEL_out13b),
      .b14b(KERNEL_out14b),
      .b15b(KERNEL_out15b),
     
      // outputs
      .out0a(mac_out0a),
      .out1a(mac_out1a),
      .out2a(mac_out2a),
      .out3a(mac_out3a),
      .out4a(mac_out4a),
      .out5a(mac_out5a),
      .out6a(mac_out6a),
      .out7a(mac_out7a),
      .out8a(mac_out8a),
      .out9a(mac_out9a),
      .out10a(mac_out10a),
      .out11a(mac_out11a),
      .out12a(mac_out12a),
      .out13a(mac_out13a),
      .out14a(mac_out14a),
      .out15a(mac_out15a),
      
      .out0b(mac_out0b),
      .out1b(mac_out1b),
      .out2b(mac_out2b),
      .out3b(mac_out3b),
      .out4b(mac_out4b),
      .out5b(mac_out5b),
      .out6b(mac_out6b),
      .out7b(mac_out7b),
      .out8b(mac_out8b),
      .out9b(mac_out9b),
      .out10b(mac_out10b),
      .out11b(mac_out11b),
      .out12b(mac_out12b),
      .out13b(mac_out13b),
      .out14b(mac_out14b),
      .out15b(mac_out15b)
  );
  
  //Define super_adders := 16 adders for combining of outputs from input channel 1 and 2.
  super_adders #(
  .A_WIDTH(IO_DATA_WIDTH),
  .OUT_WIDTH(IO_DATA_WIDTH)
  )
  super_adders_unit  (
      .input_0a(mac_out0a),
      .input_1a(mac_out1a),
      .input_2a(mac_out2a),
      .input_3a(mac_out3a),
      .input_4a(mac_out4a),
      .input_5a(mac_out5a),
      .input_6a(mac_out6a),
      .input_7a(mac_out7a),
      .input_8a(mac_out8a),
      .input_9a(mac_out9a),
      .input_10a(mac_out10a),
      .input_11a(mac_out11a),
      .input_12a(mac_out12a),
      .input_13a(mac_out13a),
      .input_14a(mac_out14a),
      .input_15a(mac_out15a),
      
      .input_0b(mac_out0b),
      .input_1b(mac_out1b),
      .input_2b(mac_out2b),
      .input_3b(mac_out3b),
      .input_4b(mac_out4b),
      .input_5b(mac_out5b),
      .input_6b(mac_out6b),
      .input_7b(mac_out7b),
      .input_8b(mac_out8b),
      .input_9b(mac_out9b),
      .input_10b(mac_out10b),
      .input_11b(mac_out11b),
      .input_12b(mac_out12b),
      .input_13b(mac_out13b),
      .input_14b(mac_out14b),
      .input_15b(mac_out15b),
      
      .output_0(Output_0_next),
      .output_1(Output_1_next),
      .output_2(Output_2_next),
      .output_3(Output_3_next),
      .output_4(Output_4_next),
      .output_5(Output_5_next),
      .output_6(Output_6_next),
      .output_7(Output_7_next),
      .output_8(Output_8_next),
      .output_9(Output_9_next),
      .output_10(Output_10_next),
      .output_11(Output_11_next),
      .output_12(Output_12_next),
      .output_13(Output_13_next),
      .output_14(Output_14_next),
      .output_15(Output_15_next)
  );
      
    logic unsigned[$clog2(128)-1:0] KERNEL_read_addr;
    logic unsigned[$clog2(128)-1:0] KERNEL_write_addr;
    logic KERNEL_re;
    
    // Define KERNEL_SRAM := 32 SRAM units
    KERNEL_SRAM # (
        .WIDTH(IO_DATA_WIDTH),
        .HEIGHT(128),
        .USED_AS_EXTERNAL_MEM(0)
   )KERNEL_SRAM(
      .clk(clk),
      .KERNEL_read_addr(KERNEL_read_addr),
      .KERNEL_write_addr(KERNEL_write_addr),
      .KERNEL_re(KERNEL_re),
      
      .KERNEL_din_0a(from_bus_1),
      .KERNEL_din_1a(from_bus_2),
      .KERNEL_din_2a(from_bus_1),
      .KERNEL_din_3a(from_bus_2),
      .KERNEL_din_4a(from_bus_1),
      .KERNEL_din_5a(from_bus_2),
      .KERNEL_din_6a(from_bus_1),
      .KERNEL_din_7a(from_bus_2),
      .KERNEL_din_8a(from_bus_1),
      .KERNEL_din_9a(from_bus_2),
      .KERNEL_din_10a(from_bus_1),
      .KERNEL_din_11a(from_bus_2),
      .KERNEL_din_12a(from_bus_1),
      .KERNEL_din_13a(from_bus_2),
      .KERNEL_din_14a(from_bus_1),
      .KERNEL_din_15a(from_bus_2),
      
      .KERNEL_din_0b(from_bus_1),
      .KERNEL_din_1b(from_bus_2),
      .KERNEL_din_2b(from_bus_1),
      .KERNEL_din_3b(from_bus_2),
      .KERNEL_din_4b(from_bus_1),
      .KERNEL_din_5b(from_bus_2),
      .KERNEL_din_6b(from_bus_1),
      .KERNEL_din_7b(from_bus_2),
      .KERNEL_din_8b(from_bus_1),
      .KERNEL_din_9b(from_bus_2),
      .KERNEL_din_10b(from_bus_1),
      .KERNEL_din_11b(from_bus_2),
      .KERNEL_din_12b(from_bus_1),
      .KERNEL_din_13b(from_bus_2),
      .KERNEL_din_14b(from_bus_1),
      .KERNEL_din_15b(from_bus_2),
      
      .KERNEL_we_0a(KERNEL_we_0a),
      .KERNEL_we_1a(KERNEL_we_1a),
      .KERNEL_we_2a(KERNEL_we_2a),
      .KERNEL_we_3a(KERNEL_we_3a),
      .KERNEL_we_4a(KERNEL_we_4a),
      .KERNEL_we_5a(KERNEL_we_5a),
      .KERNEL_we_6a(KERNEL_we_6a),
      .KERNEL_we_7a(KERNEL_we_7a),
      .KERNEL_we_8a(KERNEL_we_8a),
      .KERNEL_we_9a(KERNEL_we_9a),
      .KERNEL_we_10a(KERNEL_we_10a),
      .KERNEL_we_11a(KERNEL_we_11a),
      .KERNEL_we_12a(KERNEL_we_12a),
      .KERNEL_we_13a(KERNEL_we_13a),
      .KERNEL_we_14a(KERNEL_we_14a),
      .KERNEL_we_15a(KERNEL_we_15a),
      
      .KERNEL_we_0b(KERNEL_we_0b),
      .KERNEL_we_1b(KERNEL_we_1b),
      .KERNEL_we_2b(KERNEL_we_2b),
      .KERNEL_we_3b(KERNEL_we_3b),
      .KERNEL_we_4b(KERNEL_we_4b),
      .KERNEL_we_5b(KERNEL_we_5b),
      .KERNEL_we_6b(KERNEL_we_6b),
      .KERNEL_we_7b(KERNEL_we_7b),
      .KERNEL_we_8b(KERNEL_we_8b),
      .KERNEL_we_9b(KERNEL_we_9b),
      .KERNEL_we_10b(KERNEL_we_10b),
      .KERNEL_we_11b(KERNEL_we_11b),
      .KERNEL_we_12b(KERNEL_we_12b),
      .KERNEL_we_13b(KERNEL_we_13b),
      .KERNEL_we_14b(KERNEL_we_14b),
      .KERNEL_we_15b(KERNEL_we_15b),
      
      .KERNEL_qout_0a(KERNEL_out0a),
      .KERNEL_qout_1a(KERNEL_out1a),
      .KERNEL_qout_2a(KERNEL_out2a),
      .KERNEL_qout_3a(KERNEL_out3a),
      .KERNEL_qout_4a(KERNEL_out4a),
      .KERNEL_qout_5a(KERNEL_out5a),
      .KERNEL_qout_6a(KERNEL_out6a),
      .KERNEL_qout_7a(KERNEL_out7a),
      .KERNEL_qout_8a(KERNEL_out8a),
      .KERNEL_qout_9a(KERNEL_out9a),
      .KERNEL_qout_10a(KERNEL_out10a),
      .KERNEL_qout_11a(KERNEL_out11a),
      .KERNEL_qout_12a(KERNEL_out12a),
      .KERNEL_qout_13a(KERNEL_out13a),
      .KERNEL_qout_14a(KERNEL_out14a),
      .KERNEL_qout_15a(KERNEL_out15a),
      
      .KERNEL_qout_0b(KERNEL_out0b),
      .KERNEL_qout_1b(KERNEL_out1b),
      .KERNEL_qout_2b(KERNEL_out2b),
      .KERNEL_qout_3b(KERNEL_out3b),
      .KERNEL_qout_4b(KERNEL_out4b),
      .KERNEL_qout_5b(KERNEL_out5b),
      .KERNEL_qout_6b(KERNEL_out6b),
      .KERNEL_qout_7b(KERNEL_out7b),
      .KERNEL_qout_8b(KERNEL_out8b),
      .KERNEL_qout_9b(KERNEL_out9b),
      .KERNEL_qout_10b(KERNEL_out10b),
      .KERNEL_qout_11b(KERNEL_out11b),
      .KERNEL_qout_12b(KERNEL_out12b),
      .KERNEL_qout_13b(KERNEL_out13b),
      .KERNEL_qout_14b(KERNEL_out14b),
      .KERNEL_qout_15b(KERNEL_out15b)
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
      
      .bus_valid(bus_valid),
      .bus_ready(bus_ready),
      
      .driving_busses(driving_busses),
      
      .mux_output_select(mux_output_select),
      .output_valid(output_valid),
      .output_x(output_x),
      .output_y(output_y),
      
      .Feature_we(Feature_we),
      .Output_we(Output_we),
      .mux_next_feature_we_select(mux_next_feature_we_select),
      
      
      .mux9_select(mux9_select),
      .mac_valid(mac_valid),
      .product_valid(product_valid),
      .mac_accumulate_internal(mac_accumulate_internal),

      .KERNEL_read_addr(KERNEL_read_addr),
      .KERNEL_write_addr(KERNEL_write_addr),
      .KERNEL_re(KERNEL_re),
      .mux_KERNEL_we_select(mux_KERNEL_we_select)
  );

endmodule
