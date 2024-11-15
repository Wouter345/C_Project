module controller_fsm #(
    parameter int FEATURE_MAP_WIDTH  = 128,
    parameter int FEATURE_MAP_HEIGHT = 128,
    parameter int INPUT_NB_CHANNELS  = 2,
    parameter int OUTPUT_NB_CHANNELS = 32
) (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    input  logic start,
    output logic running,

    input logic [1:0] conv_stride_mode,
    // Currently support 3 modes:
    // 0: step = 1
    // 1: step = 2
    // 2: step = 4

    // interface input control signals
    input  logic a_valid,
    output logic a_ready,
    
    // interface output control signals
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch, 
    
    // WRITE ENABLES REGs
    output logic Feature_we,
    output logic Output_we,
    
    output logic Next_Feature_0_we,
    output logic Next_Feature_1_we,
    output logic Next_Feature_2_we,
    output logic Next_Feature_3_we,
    output logic Next_Feature_4_we,
    output logic Next_Feature_5_we,
    output logic Next_Feature_6_we,
    output logic Next_Feature_7_we,
    output logic Next_Feature_8_we,
    output logic Next_Feature_9_we,
    output logic Next_Feature_10_we,
    output logic Next_Feature_11_we,
    output logic Next_Feature_12_we,
    output logic Next_Feature_13_we,
    output logic Next_Feature_14_we,
    output logic Next_Feature_15_we,
    output logic Next_Feature_16_we,
    output logic Next_Feature_17_we,
    
    // super_mac control signals
    output logic [4:0] mux18_select,
    output logic mac_valid,
    output logic mac_accumulate_internal,
    
    // KERNAL_SRAM control signals
    output logic unsigned[$clog2(128)-1:0] KERNEL_read_addr,
    output logic unsigned[$clog2(128)-1:0] KERNEL_write_addr,
    output logic KERNEL_re,
    
    // WRITE ENABLES for KERNEL_SRAM
    output logic KERNEL_we_0,
    output logic KERNEL_we_1,
    output logic KERNEL_we_2,
    output logic KERNEL_we_3,
    output logic KERNEL_we_4,
    output logic KERNEL_we_5,
    output logic KERNEL_we_6,
    output logic KERNEL_we_7,
    output logic KERNEL_we_8,
    output logic KERNEL_we_9,
    output logic KERNEL_we_10,
    output logic KERNEL_we_11,
    output logic KERNEL_we_12,
    output logic KERNEL_we_13,
    output logic KERNEL_we_14,
    output logic KERNEL_we_15
    
    
);

  // FINITE STATE MACHINE 
  typedef enum {
    IDLE,                   // idle state, wait for start signal
    FETCH_KERNEL,           // 144 cycles: read in kernel data
    FETCH_INITIAL_FEATURE,  // 9 cycles: read in first 18 feature data
    WRITE_THROUGH,          // 1 cycle: write Next_Features to Features
    COMPUTE0,               // 18 cycles for compute state: decided to split it up into different states for better overview
    COMPUTE1,               
    COMPUTE2,
    COMPUTE3,               
    COMPUTE4,
    COMPUTE5,               // in compute state: send 16 previous outputs to testbench, read 18 next inputs from testbench, do 16 parallel mac operations
    COMPUTE6,
    COMPUTE7,
    COMPUTE8,
    COMPUTE9,
    COMPUTE10,
    COMPUTE11,
    COMPUTE12,
    COMPUTE13,
    COMPUTE14,
    COMPUTE15,
    COMPUTE16,
    COMPUTE17,
    WRITEBACK               // 16 cycles: Final 16 outputs send back to testbench
  } fsm_state_e;

  fsm_state_e current_state;
  fsm_state_e next_state;

  // Define stride and kernel size
  logic [2:0] conv_stride;
  assign conv_stride = 1 << conv_stride_mode; //1;2;4
  logic [2:0] conv_kernel;
  assign conv_kernel = 3; //hardcoded for 3x3

  //Define loop counters x,y to keep track of when computation is finished
  `REG(7, x); //7 bits (0,127)
  `REG(7, y); //7 bits (0,127)
  
  `REG(4, KERNEL_COUNTER); // to count 0-8 for reading in kernel --> determines all KERNEL_we
  `REG(5, OUTPUT_COUNTER); // to count 0-15 for each output value
  `REG(5, COMPUTE_COUNTER);// to count 0-17 for addresses of KERNEL_SRAM
  
  logic last_x, last_y, last_KERNEL_COUNTER, last_OUTPUT_COUNTER, last_COMPUTE_COUNTER;
  assign x_next = last_x ? 0 : x + {4'b0, conv_stride};
  assign y_next = last_y ? 0 : y + {4'b0, conv_stride};
  assign KERNEL_COUNTER_next = last_KERNEL_COUNTER ? 0 : KERNEL_COUNTER + 4'd1;
  assign OUTPUT_COUNTER_next = last_OUTPUT_COUNTER ? 0 : OUTPUT_COUNTER + 5'd1;
  assign COMPUTE_COUNTER_next = last_COMPUTE_COUNTER ? 0 : COMPUTE_COUNTER + 5'd1;
  
  assign last_x = (x >= FEATURE_MAP_WIDTH - conv_stride); //if next step falls outside of feature map width --> reset
  assign last_y = (y >= FEATURE_MAP_HEIGHT - conv_stride);
  assign last_KERNEL_COUNTER = (KERNEL_COUNTER == 4'd9);
  assign last_OUTPUT_COUNTER = (OUTPUT_COUNTER == 5'd15);
  assign last_COMPUTE_COUNTER = (COMPUTE_COUNTER == 18);

  // when to update loop counters
  assign y_we      = (current_state==COMPUTE17); 
  assign x_we      = (current_state==COMPUTE17) && last_y;
  assign KERNEL_COUNTER_we = (current_state==FETCH_KERNEL) && last_COMPUTE_COUNTER;
  // assign OUTPUT_COUNTER_we = ; --> happens in state control logic
  assign COMPUTE_COUNTER_we = (current_state==FETCH_INITIAL_FEATURE)||(current_state==FETCH_KERNEL);
  
  
  logic last_overall;
  assign last_overall = last_y && last_x; //when total calculation is finished
  
  logic first_calc, output_valid_int;
  assign first_calc = (x==0)&&(y==0);
  assign output_valid_int = first_calc? 0 : 1;
  
  
  /*
  chosen loop order:
  for x
    for y
        for ch_in 
          for COMPUTE (0-17)
              body: ch_out (all 16 computed in parallel)
                
  */
  // ==>
  
  

  assign KERNEL_write_addr = COMPUTE_COUNTER;
  
  always_comb
  begin
    KERNEL_we_0 = 0;
    KERNEL_we_1 = 0;
    KERNEL_we_2 = 0;
    KERNEL_we_3 = 0;
    KERNEL_we_4 = 0;
    KERNEL_we_5 = 0;
    KERNEL_we_6 = 0;
    KERNEL_we_7 = 0;
    KERNEL_we_8 = 0;
    KERNEL_we_9 = 0;
    KERNEL_we_10 = 0;
    KERNEL_we_11 = 0;
    KERNEL_we_12 = 0;
    KERNEL_we_13 = 0;
    KERNEL_we_14 = 0;
    KERNEL_we_15 = 0;
    case(KERNEL_COUNTER)
        
        0: begin
            KERNEL_we_0 = (current_state==FETCH_KERNEL);
            KERNEL_we_1 = (current_state==FETCH_KERNEL);
        end
        
        1: begin
            KERNEL_we_2 = (current_state==FETCH_KERNEL);
            KERNEL_we_3 = (current_state==FETCH_KERNEL);
        end
        
        2: begin
            KERNEL_we_4 = (current_state==FETCH_KERNEL);
            KERNEL_we_5 = (current_state==FETCH_KERNEL);
        end
        
        3: begin
            KERNEL_we_6 = (current_state==FETCH_KERNEL);
            KERNEL_we_7 = (current_state==FETCH_KERNEL);
        end
        
        4: begin
            KERNEL_we_8 = (current_state==FETCH_KERNEL);
            KERNEL_we_9 = (current_state==FETCH_KERNEL);
        end
        
        5: begin
            KERNEL_we_10 = (current_state==FETCH_KERNEL);
            KERNEL_we_11 = (current_state==FETCH_KERNEL);
        end
        
        6: begin
            KERNEL_we_12 = (current_state==FETCH_KERNEL);
            KERNEL_we_13 = (current_state==FETCH_KERNEL);
        end
        
        7: begin
            KERNEL_we_14 = (current_state==FETCH_KERNEL);
            KERNEL_we_15 = (current_state==FETCH_KERNEL);
        end
  
    endcase
  end
  // The output address (x, y) is retended by these registers
  register #(
      .WIDTH(7)
  ) output_x_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(x),
      .qout(output_x),
      .we(x_we)
  );
  register #(
      .WIDTH(7)
  ) output_y_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(y),
      .qout(output_y),
      .we(y_we)
  );
  assign output_ch = OUTPUT_COUNTER;
  

  always @(posedge clk or negedge arst_n_in) begin
    if (arst_n_in == 0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end


  // NEXT STATE LOGIC
  always_comb begin
    case (current_state)
    
      IDLE: begin
          next_state = start ? FETCH_KERNEL : IDLE;
      end
      
      FETCH_KERNEL: begin
          next_state = (last_COMPUTE_COUNTER && last_KERNEL_COUNTER) ?  FETCH_INITIAL_FEATURE : FETCH_KERNEL;
      end
      
      FETCH_INITIAL_FEATURE: begin
          next_state = last_COMPUTE_COUNTER ? WRITE_THROUGH : FETCH_INITIAL_FEATURE;
      end
      
      WRITE_THROUGH: begin
        next_state = COMPUTE0;
      end
      
      COMPUTE0: begin
        next_state = COMPUTE1;
      end
      
      COMPUTE1: begin
        next_state = COMPUTE2;
      end
      
      COMPUTE2: begin
        next_state = COMPUTE3;
      end
      
      COMPUTE3: begin
        next_state = COMPUTE4;
      end
      
      COMPUTE4: begin
        next_state = COMPUTE5;
      end
      
      COMPUTE5: begin
        next_state = COMPUTE6;
      end
      
      COMPUTE6: begin
        next_state = COMPUTE7;
      end
      
      COMPUTE7: begin
        next_state = COMPUTE8;
      end
      
      COMPUTE8: begin
        next_state = COMPUTE9;
      end
      
      COMPUTE9: begin
        next_state = COMPUTE10;
      end
      COMPUTE10: begin
        next_state = COMPUTE11;
      end
      
      COMPUTE11: begin
        next_state = COMPUTE12;
      end
      
      COMPUTE12: begin
        next_state = COMPUTE13;
      end
      
      COMPUTE13: begin
        next_state = COMPUTE14;
      end
      COMPUTE14: begin
        next_state = COMPUTE15;
      end
      
      COMPUTE15: begin
        next_state = COMPUTE16;
      end
      
      COMPUTE16: begin
        next_state = COMPUTE17;
      end
      
      COMPUTE17: begin
        next_state = last_overall ? WRITEBACK : COMPUTE0;
      end
      
      WRITEBACK: begin
        next_state = last_OUTPUT_COUNTER ? IDLE : WRITEBACK;
      end
      
      default: begin
        next_state = IDLE;
      end
      
    endcase
  end
  
  // CONTROL SIGNALS THAT ARE ONLY DEPENDANT ON THE STATE
  always_comb
  begin
  running = 1;
    a_ready = 0;
    Feature_we = 0;
    Output_we = 0;
    output_valid = 0;
    mux18_select = 0;
    mac_valid = 0;
    mac_accumulate_internal = 1;
    OUTPUT_COUNTER_we = 0;
    
    KERNEL_read_addr = 0;
    
    Next_Feature_0_we = 0;
    Next_Feature_1_we = 0;
    Next_Feature_2_we = 0;
    Next_Feature_3_we = 0;
    Next_Feature_4_we = 0;
    Next_Feature_5_we = 0;
    Next_Feature_6_we = 0;
    Next_Feature_7_we = 0;
    Next_Feature_8_we = 0;
    Next_Feature_9_we = 0;
    Next_Feature_10_we = 0;
    Next_Feature_11_we = 0;
    Next_Feature_12_we = 0;
    Next_Feature_13_we = 0;
    Next_Feature_14_we = 0;
    Next_Feature_15_we = 0;
    Next_Feature_16_we = 0;
    Next_Feature_17_we = 0;
    
    KERNEL_re = 0;
    // CONTROL SIGNAL VALUES FOR EACH STATE HERE  
    case(current_state)
        
        IDLE: begin
            running = 0;
        end
        
        FETCH_KERNEL: begin
            a_ready = 1;
        end
        
        FETCH_INITIAL_FEATURE: begin
            a_ready = 1;
            
            Next_Feature_0_we = (COMPUTE_COUNTER == 0);
            Next_Feature_9_we = (COMPUTE_COUNTER == 0);
            Next_Feature_1_we = (COMPUTE_COUNTER == 1);
            Next_Feature_10_we = (COMPUTE_COUNTER == 1);
            Next_Feature_2_we = (COMPUTE_COUNTER == 2);
            Next_Feature_11_we = (COMPUTE_COUNTER == 2);
            Next_Feature_3_we = (COMPUTE_COUNTER == 3);
            Next_Feature_12_we = (COMPUTE_COUNTER == 3);
            Next_Feature_4_we = (COMPUTE_COUNTER == 4);
            Next_Feature_13_we = (COMPUTE_COUNTER == 4);
            Next_Feature_5_we = (COMPUTE_COUNTER == 5);
            Next_Feature_14_we = (COMPUTE_COUNTER == 5);
            Next_Feature_6_we = (COMPUTE_COUNTER == 6);
            Next_Feature_15_we = (COMPUTE_COUNTER == 6);
            Next_Feature_7_we = (COMPUTE_COUNTER == 7);
            Next_Feature_16_we = (COMPUTE_COUNTER == 7);
            Next_Feature_8_we = (COMPUTE_COUNTER == 8);
            Next_Feature_17_we = (COMPUTE_COUNTER == 8);
            
        end
        
        WRITE_THROUGH: begin
            Feature_we = 1;
        end
        
        COMPUTE0: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mac_valid = 1;
            mac_accumulate_internal = 0;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_0_we = 1;
            Next_Feature_9_we = 1;
            KERNEL_re = 1;
        end
        
        COMPUTE1: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 1;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            
            Next_Feature_1_we = 1;
            Next_Feature_10_we = 1;
            
            KERNEL_read_addr = 1;
            KERNEL_re = 1;
        end
        
        COMPUTE2: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 2;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_2_we = 1;
            Next_Feature_11_we = 1;
            
            KERNEL_read_addr = 2;
            KERNEL_re = 1;
        end
        
        COMPUTE3: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 3;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_3_we = 1;
            Next_Feature_12_we = 1;
            
            KERNEL_read_addr = 3;
            KERNEL_re = 1;
        end
        
        COMPUTE4: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 4;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_4_we = 1;
            Next_Feature_13_we = 1;
            
            KERNEL_read_addr = 4;
            KERNEL_re = 1;
        end
        
        COMPUTE5: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 5;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_5_we = 1;
            Next_Feature_14_we = 1;
            
            KERNEL_read_addr = 5;
            KERNEL_re = 1;
        end
        
        COMPUTE6: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 6;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_6_we = 1;
            Next_Feature_15_we = 1;
            
            KERNEL_read_addr = 6;
            KERNEL_re = 1;
        end
        
        COMPUTE7: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 7;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_7_we = 1;
            Next_Feature_16_we = 1;
            
            KERNEL_read_addr = 7;
            KERNEL_re = 1;
        end
        
        COMPUTE8: begin
            a_ready = 1;
            output_valid = output_valid_int;
            mux18_select = 8;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_8_we = 1;
            Next_Feature_17_we = 1;
            
            KERNEL_read_addr = 8;
            KERNEL_re = 1;
        end
        
        COMPUTE9: begin
            output_valid = output_valid_int;
            mux18_select = 9;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 9;
            KERNEL_re = 1;
        end
        
        COMPUTE10: begin
            output_valid = output_valid_int;
            mux18_select = 10;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 10;
            KERNEL_re = 1;
        end
        
        COMPUTE11: begin
            output_valid = output_valid_int;
            mux18_select = 11;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 11;
            KERNEL_re = 1;
        end
        
        COMPUTE12: begin
            output_valid = output_valid_int;
            mux18_select = 12;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 12;
            KERNEL_re = 1;
        end
        
        COMPUTE13: begin
            output_valid = output_valid_int;
            mux18_select = 13;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 13;
            KERNEL_re = 1;
        end
        
        COMPUTE14: begin
            output_valid = output_valid_int;
            mux18_select = 14;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 14;
            KERNEL_re = 1;
        end
        
        COMPUTE15: begin
            output_valid = output_valid_int;
            mux18_select = 15;
            mac_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            KERNEL_read_addr = 15;
            KERNEL_re = 1;
        end
        
        COMPUTE16: begin
            mux18_select = 16;
            mac_valid = 1;
            
            KERNEL_read_addr = 16;
            KERNEL_re = 1;
        end
        
        COMPUTE17: begin
            Feature_we = 1;
            Output_we = 1;   
            mux18_select = 17;
            
            KERNEL_read_addr = 17;
            KERNEL_re = 1;
        end
        
        WRITEBACK: begin
            output_valid = 1;
            OUTPUT_COUNTER_we = 1;
            
            Next_Feature_0_we = 0;
        end
        
    
    endcase
  end
    
  
  
  
  
endmodule

