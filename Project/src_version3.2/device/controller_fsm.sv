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
    FETCH_INITIAL_FEATURE,  // 6 cycles: read in first 18 feature data
    WRITE_THROUGH,          // 1 cycle: write Next_Features to Features
    COMPUTE,
    WRITEBACK               // 6 cycles: Final 16 outputs send back to testbench
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
  
  `REG(4, COMPUTE_COUNTER); // to count 0-11 to keep track of which calculations are happening (9 cycles multiplication + 2 cycles for pipeline adders to finish)
  `REG(3, READ_COUNTER); // to count 0-5 to keep track of when outputs are written back and when inputs are loaded in (takes at least 12 cycles)
  `REG(3, WRITE_COUNTER);
  
  `REG(1, NOW_IS_WRITE); // says when it is duts turn to write outputs
  
  logic last_x, last_y, last_KERNEL_COUNTER, last_ADDRESS_COUNTER, last_COMPUTE_COUNTER, last_READ_COUNTER, last_WRITE_COUNTER;
  logic interface_final_readwrite_cycle;
  logic first_calc;
  logic successful_read;
  logic last_overall;
  
  assign x_next = last_x ? 0 : x + {4'b0, conv_stride};
  assign y_next = last_y ? 0 : y + {4'b0, conv_stride};
  assign KERNEL_COUNTER_next = last_KERNEL_COUNTER ? 0 : KERNEL_COUNTER + 1;
  assign ADDRESS_COUNTER_next = last_ADDRESS_COUNTER ? 0 : ADDRESS_COUNTER + 1;
  assign COMPUTE_COUNTER_next = last_COMPUTE_COUNTER? 0 : COMPUTE_COUNTER + 1;
  assign READ_COUNTER_next = last_READ_COUNTER ? 0 : READ_COUNTER + 1;
  assign WRITE_COUNTER_next = last_WRITE_COUNTER ? 0 : WRITE_COUNTER + 1;
  
  assign last_x = x >= FEATURE_MAP_WIDTH - conv_stride; //if next step falls outside of feature map width --> reset
  assign last_y = y >= FEATURE_MAP_HEIGHT - conv_stride;
  assign last_KERNEL_COUNTER = (KERNEL_COUNTER == 15); 
  assign last_ADDRESS_COUNTER = (ADDRESS_COUNTER == 8);
  assign last_COMPUTE_COUNTER = (COMPUTE_COUNTER == 11);
  assign last_READ_COUNTER = (READ_COUNTER == 5);
  assign last_WRITE_COUNTER = (WRITE_COUNTER == 5);
  
  assign successful_read = bus_ready && bus_valid;
  assign interface_final_readwrite_cycle = last_WRITE_COUNTER;
  
  // when to update loop counters
  assign y_we      = interface_final_readwrite_cycle && (current_state != WRITEBACK); 
  assign x_we      = y_we && last_y;
  assign KERNEL_COUNTER_we = ADDRESS_COUNTER_we && last_ADDRESS_COUNTER;
  assign ADDRESS_COUNTER_we = (current_state==FETCH_KERNEL) && successful_read;
  assign COMPUTE_COUNTER_we = (current_state == COMPUTE) && (COMPUTE_COUNTER < 11 || interface_final_readwrite_cycle); // count to 11 and then wait until all outputs are written back
  assign READ_COUNTER_we = last_overall|| (successful_read && ((current_state == FETCH_INITIAL_FEATURE) || (current_state == COMPUTE)));
  assign WRITE_COUNTER_we = (current_state == WRITEBACK) || NOW_IS_WRITE ;
  
  
  assign NOW_IS_WRITE_we = (current_state == COMPUTE && ((READ_COUNTER == 5) && (successful_read || last_overall))) || (WRITE_COUNTER == 5);
  assign NOW_IS_WRITE_next = ((READ_COUNTER == 5) && (successful_read || last_overall));
  
  assign last_overall = last_y && last_x; //when total calculation is finished
  
  
  assign first_calc = (x==0)&&(y==0); // no writing back data during the first calculation
  
  

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
  
  assign mux_next_feature_we_select = (successful_read && (current_state != FETCH_KERNEL)) ? READ_COUNTER : 7;
  
  
  
  

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
          next_state = (last_ADDRESS_COUNTER && last_KERNEL_COUNTER && successful_read) ?  FETCH_INITIAL_FEATURE : FETCH_KERNEL;
      end
      
      FETCH_INITIAL_FEATURE: next_state = (last_READ_COUNTER && successful_read) ? WRITE_THROUGH :FETCH_INITIAL_FEATURE;
      
      WRITE_THROUGH: begin
        next_state = COMPUTE;
      end
      
      COMPUTE: begin
        next_state = (last_overall&&interface_final_readwrite_cycle) ? WRITEBACK : COMPUTE;
      end
      
      WRITEBACK: next_state =  last_WRITE_COUNTER ? IDLE : WRITEBACK;
      
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
    Feature_we = 0;
    Output_we = 0;
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
        
        FETCH_INITIAL_FEATURE: begin
            bus_ready = 1;
        end
        
        WRITE_THROUGH: begin
            Feature_we = 1;
        end
        
        COMPUTE: begin
            bus_ready = !NOW_IS_WRITE && !last_overall;
            mux9_select = COMPUTE_COUNTER;
            product_valid = (COMPUTE_COUNTER < 9);
            KERNEL_read_addr = COMPUTE_COUNTER;
            KERNEL_re = product_valid;
            mac_valid = (COMPUTE_COUNTER > 0) && (COMPUTE_COUNTER < 10);
            mac_accumulate_internal = (COMPUTE_COUNTER != 1);
            
            driving_busses = NOW_IS_WRITE;
            mux_output_select = WRITE_COUNTER;
            output_valid = !first_calc && NOW_IS_WRITE;
            Feature_we = interface_final_readwrite_cycle;
            Output_we = (COMPUTE_COUNTER == 11) && interface_final_readwrite_cycle;

        end
        
        WRITEBACK: begin
            driving_busses = 1;
            mux_output_select = WRITE_COUNTER;
            output_valid = 1;
        end
        
        
    endcase
  end
    
  
  
  
  
endmodule

