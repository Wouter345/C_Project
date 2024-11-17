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
    // 0: step = 1, 1: step = 2, 2: step = 4

    // interface input control signals
    input  logic bus_valid,
    output logic bus_ready,
    
    output logic driving_busses,
    
    // interface output control signals
    output logic [2:0] mux_output_select,
    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch, // 3 outputs are send back at once, but always [ch0, ch1, ch2] -> so 1 output_ch is enough information for checker
    
    // WRITE ENABLES REGs
    output logic Feature_we,
    output logic Output_we,
    output logic [2:0] mux_next_feature_we_select,
    
    // super_mac control signals
    output logic [4:0] mux9_select,
    output logic mac_valid,
    output logic product_valid,
    output logic mac_accumulate_internal,
    
    // KERNAL_SRAM control signals
    output logic unsigned[$clog2(128)-1:0] KERNEL_read_addr,
    output logic unsigned[$clog2(128)-1:0] KERNEL_write_addr,
    output logic KERNEL_re,
    output logic [4:0] mux_KERNEL_we_select
);

  // FINITE STATE MACHINE 
  typedef enum {
    IDLE,                   // idle state, wait for start signal
    FETCH_KERNEL,           // 144 cycles: read in kernel data
    FETCH_INITIAL_FEATURE0,  // 6 cycles: read in first 18 feature data
    FETCH_INITIAL_FEATURE1,
    FETCH_INITIAL_FEATURE2,
    FETCH_INITIAL_FEATURE3,
    FETCH_INITIAL_FEATURE4,
    FETCH_INITIAL_FEATURE5,
    WRITE_THROUGH,          // 1 cycle: write Next_Features to Features
    COMPUTE0,               // 12 cycles for compute state: 9 cycles multiplication, but need more cycles to send and read data
    COMPUTE1,               //                                                       --> multiplication only in C0->C8
    COMPUTE2,               // in compute state: read 18 next inputs from testbench    (C6->C11) (6 cycles)
    COMPUTE3,               //                   send 16 previous outputs to testbench (C0->C5) (6 cycles)
    COMPUTE4,               //                   do 32 parallel mac operations in each compute state
    COMPUTE5,               
    COMPUTE6,               
    COMPUTE7,               
    COMPUTE8,
    COMPUTE9,
    COMPUTE10,
    COMPUTE11,
    WRITEBACK0,             // 6 cycles: Final 16 outputs send back to testbench
    WRITEBACK1,
    WRITEBACK2,
    WRITEBACK3,
    WRITEBACK4,
    WRITEBACK5
  } fsm_state_e;

  fsm_state_e current_state;
  fsm_state_e next_state;

  // Define stride and kernel size
  logic [2:0] conv_stride;
  assign conv_stride = 1 << conv_stride_mode; //1;2;4
  logic [2:0] conv_kernel;
  assign conv_kernel = 3; //hardcoded for 3x3
    
    
   
  // -------DEFINE COUNTERS------------------------------
  //Define loop counters x,y 
  `REG(7, x); //7 bits (0,127)
  `REG(7, y); //7 bits (0,127)
  
  `REG(4, KERNEL_COUNTER); // to count 0-15 for reading in kernel 
  `REG(4, ADDRESS_COUNTER);// to count 0-8 for addresses of KERNEL_SRAM
  
  logic last_x, last_y, last_KERNEL_COUNTER, last_ADDRESS_COUNTER;
  assign x_next = last_x ? 0 : x + {4'b0, conv_stride};
  assign y_next = last_y ? 0 : y + {4'b0, conv_stride};
  assign KERNEL_COUNTER_next = last_KERNEL_COUNTER ? 0 : KERNEL_COUNTER + 1;
  assign ADDRESS_COUNTER_next = last_ADDRESS_COUNTER ? 0 : ADDRESS_COUNTER + 1;
  
  assign last_x = x >= FEATURE_MAP_WIDTH - conv_stride; //if next step falls outside of feature map width --> reset
  assign last_y = y >= FEATURE_MAP_HEIGHT - conv_stride;
  assign last_KERNEL_COUNTER = (KERNEL_COUNTER == 15); 
  assign last_ADDRESS_COUNTER = (ADDRESS_COUNTER == 8);
	
  // when to update loop counters
  assign y_we      = (current_state==COMPUTE11); 
  assign x_we      = y_we && last_y;
  assign KERNEL_COUNTER_we = (current_state==FETCH_KERNEL) && last_ADDRESS_COUNTER;
  assign ADDRESS_COUNTER_we = (current_state==FETCH_KERNEL);
  
  
  logic last_overall;
  assign last_overall = last_y && last_x; //when total calculation is finished
  
  logic first_calc, output_valid_int;
  assign first_calc = (x==0)&&(y==0); // no writing back data during the first calculation
  assign output_valid_int = first_calc? 0 : 1;
  
  

  assign KERNEL_write_addr = ADDRESS_COUNTER;
  
  
  
  
  // The output address (x, y) is retended by these registers, output_ch determined by OUTPUT_COUNTER
  register #(
      .WIDTH(7)
  ) output_x_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(x),
      .qout(output_x),
      .we(y_we)
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
  
  

  always @(posedge clk or negedge arst_n_in) begin
    if (arst_n_in == 0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end


  // -------------NEXT STATE LOGIC-------------------------------------
  always_comb begin
    case (current_state)
    
      IDLE: begin
          next_state = start ? FETCH_KERNEL : IDLE;
      end
      
      FETCH_KERNEL: begin
          next_state = (last_ADDRESS_COUNTER && last_KERNEL_COUNTER) ?  FETCH_INITIAL_FEATURE0 : FETCH_KERNEL;
      end
      
      FETCH_INITIAL_FEATURE0: next_state = FETCH_INITIAL_FEATURE1;
      FETCH_INITIAL_FEATURE1: next_state = FETCH_INITIAL_FEATURE2;
      FETCH_INITIAL_FEATURE2: next_state = FETCH_INITIAL_FEATURE3;
      FETCH_INITIAL_FEATURE3: next_state = FETCH_INITIAL_FEATURE4;
      FETCH_INITIAL_FEATURE4: next_state = FETCH_INITIAL_FEATURE5;
      FETCH_INITIAL_FEATURE5: next_state = WRITE_THROUGH;
      
      WRITE_THROUGH: begin
        next_state = COMPUTE0;
      end
      
      COMPUTE0: next_state = COMPUTE1;
      COMPUTE1: next_state = COMPUTE2;
      COMPUTE2: next_state = COMPUTE3;
      COMPUTE3: next_state = COMPUTE4;
      COMPUTE4: next_state = COMPUTE5;
      COMPUTE5: next_state = COMPUTE6;
      COMPUTE6: next_state = COMPUTE7;
      COMPUTE7: next_state = COMPUTE8;
      COMPUTE8: next_state = COMPUTE9;
      COMPUTE9: next_state = COMPUTE10;
      COMPUTE10: next_state = COMPUTE11;
      COMPUTE11: begin
        next_state = last_overall ? WRITEBACK0 : COMPUTE0;
      end
      
      WRITEBACK0: next_state = WRITEBACK1;
      WRITEBACK1: next_state = WRITEBACK2;
      WRITEBACK2: next_state = WRITEBACK3;
      WRITEBACK3: next_state = WRITEBACK4;
      WRITEBACK4: next_state = WRITEBACK5;
      WRITEBACK5: next_state = IDLE;
      
      default: begin
        next_state = IDLE;
      end
      
    endcase
  end
  
  // CONTROL SIGNALS THAT ARE ONLY DEPENDANT ON THE STATE
  always_comb
  begin
    // default values
	running = 1;
	bus_ready = 0;
	driving_busses = 0;
    mux_output_select = 0;
    output_valid = 0;
    output_ch = 0;
    Feature_we = 0;
    Output_we = 0;
    mux_next_feature_we_select = 7; // select no write enables to 1
    mux9_select = 0;
    mac_valid = 0;
    product_valid = 0;
    mac_accumulate_internal = 1;
    KERNEL_read_addr = 0;
    KERNEL_re = 0;
    mux_KERNEL_we_select = 31; // select no write enables to 1
    
    // CONTROL SIGNAL VALUES FOR EACH STATE HERE  
    case(current_state)
        
        
        IDLE: begin
            running = 0;
        end
        
        FETCH_KERNEL: begin
            bus_ready = 1;
            mux_KERNEL_we_select = KERNEL_COUNTER;
        end
        
        FETCH_INITIAL_FEATURE0: begin
            bus_ready = 1;
            mux_next_feature_we_select = 0;
        end
        
        FETCH_INITIAL_FEATURE1: begin
            bus_ready = 1;
            mux_next_feature_we_select = 1;
        end
        
        FETCH_INITIAL_FEATURE2: begin
            bus_ready = 1;
            mux_next_feature_we_select = 2;
        end
        
        FETCH_INITIAL_FEATURE3: begin
            bus_ready = 1;
            mux_next_feature_we_select = 3;
        end
        
        FETCH_INITIAL_FEATURE4: begin
            bus_ready = 1;
            mux_next_feature_we_select = 4;
        end
        
        FETCH_INITIAL_FEATURE5: begin
            bus_ready = 1;
            mux_next_feature_we_select = 5;
        end
        
        WRITE_THROUGH: begin
            Feature_we = 1;
        end
        
        COMPUTE0: begin
            bus_ready = 1;
            mux_next_feature_we_select = 0;
            mux9_select = 0;
            product_valid = 1;
            KERNEL_read_addr = 0;
            KERNEL_re = 1;
        end
        
        COMPUTE1: begin
            bus_ready = 1;
            mux_next_feature_we_select = 1;
            mux9_select = 1;
            mac_valid = 1;
            product_valid = 1;
            mac_accumulate_internal = 0;
            KERNEL_read_addr = 1;
            KERNEL_re = 1;
        end
        
        COMPUTE2: begin
            bus_ready = 1;
            mux_next_feature_we_select = 2;
            mux9_select = 2;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 2;
            KERNEL_re = 1;
        end
        
        COMPUTE3: begin
            bus_ready = 1;
            mux_next_feature_we_select = 3;
            mux9_select = 3;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 3;
            KERNEL_re = 1;
        end
        
        COMPUTE4: begin
            bus_ready = 1;
            mux_next_feature_we_select = 4;
            mux9_select = 4;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 4;
            KERNEL_re = 1;
        end
        
        COMPUTE5: begin
            bus_ready = 1;
            mux_next_feature_we_select = 5;
            mux9_select = 5;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 5;
            KERNEL_re = 1;
        end
        
        COMPUTE6: begin
            driving_busses = 1;
            mux_output_select = 0;
            output_valid = !first_calc;
            output_ch = 0;
            mux9_select = 6;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 6;
            KERNEL_re = 1;
        end
        
        COMPUTE7: begin
            driving_busses = 1;
            mux_output_select = 1;
            output_valid = !first_calc;
            output_ch = 3;
            mux9_select = 7;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 7;
            KERNEL_re = 1;
        end
        
        COMPUTE8: begin
            driving_busses = 1;
            mux_output_select = 2;
            output_valid = !first_calc;
            output_ch = 6;
            mux9_select = 8;
            mac_valid = 1;
            product_valid = 1;
            KERNEL_read_addr = 8;
            KERNEL_re = 1;
        end
        
        COMPUTE9: begin
            driving_busses = 1;
            mux_output_select = 3;
            output_valid = !first_calc;
            output_ch = 9;
            mac_valid = 1;
        end
        
        COMPUTE10: begin
            driving_busses = 1;
            mux_output_select = 4;
            output_valid = !first_calc;
            output_ch = 12;
        end
        
        COMPUTE11: begin
            driving_busses = 1;
            mux_output_select = 5;
            output_valid = !first_calc;
            output_ch = 15;
            Feature_we = 1;
            Output_we = 1;
        end
        
        WRITEBACK0: begin
            driving_busses = 1;
            mux_output_select = 0;
            output_valid = 1;
            output_ch = 0;
        end
        
        WRITEBACK1: begin
            driving_busses = 1;
            mux_output_select = 1;
            output_valid = 1;
            output_ch = 3;
        end
        
        WRITEBACK2: begin
            driving_busses = 1;
            mux_output_select = 2;
            output_valid = 1;
            output_ch = 6;
        end
        
        WRITEBACK3: begin
            driving_busses = 1;
            mux_output_select = 3;
            output_valid = 1;
            output_ch = 9;
        end
        
        WRITEBACK4: begin
            driving_busses = 1;
            mux_output_select = 4;
            output_valid = 1;
            output_ch = 12;
        end
        
        WRITEBACK5: begin
            driving_busses = 1;
            mux_output_select = 5;
            output_valid = 1;
            output_ch = 15;
        end
        
    endcase
  end
    
  
  
  
  
endmodule

