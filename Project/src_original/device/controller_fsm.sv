module controller_fsm #(
    parameter int LOG2_OF_MEM_HEIGHT = 20,
    parameter int FEATURE_MAP_WIDTH  = 1024,
    parameter int FEATURE_MAP_HEIGHT = 1024,
    parameter int INPUT_NB_CHANNELS  = 64,
    parameter int OUTPUT_NB_CHANNELS = 64
) (
    input logic clk,
    input logic arst_n_in, //asynchronous reset, active low

    input  logic start,
    output logic running,

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

    //memory control interface
    output logic mem_we,
    output logic [LOG2_OF_MEM_HEIGHT-1:0] mem_write_addr,
    output logic mem_re,
    output logic [LOG2_OF_MEM_HEIGHT-1:0] mem_read_addr,

    //datapad control interface & external handshaking communication of a and b
    input  logic a_valid,
    input  logic b_valid,
    output logic b_ready,
    output logic a_ready,
    output logic write_a,
    output logic write_b,
    output logic mac_valid,
    output logic mac_accumulate_internal,
    output logic mac_accumulate_with_0,

    output logic output_valid,
    output logic [$clog2(FEATURE_MAP_WIDTH)-1:0] output_x,
    output logic [$clog2(FEATURE_MAP_HEIGHT)-1:0] output_y,
    output logic [$clog2(OUTPUT_NB_CHANNELS)-1:0] output_ch

);

  logic [2:0] conv_stride;
  assign conv_stride = 1 << conv_stride_mode; //1;2;4
  logic [2:0] conv_kernel;
  assign conv_kernel = (conv_kernel_mode << 1) + 1; //1*1;3*3;5*5

  //loop counters (see register.sv for macro)
  `REG(32, k_v);    // THESE DO NOT NEED TO BE 32 BITS WIDE = very expensive area (17 per bit) total of 3264 area
  `REG(32, k_h);
  `REG(32, x);
  `REG(32, y);
  `REG(32, ch_in);
  `REG(32, ch_out);

  logic reset_k_v, reset_k_h, reset_x, reset_y, reset_ch_in, reset_ch_out;
  assign k_v_next = reset_k_v ? 0 : k_v + 1;
  assign k_h_next = reset_k_h ? 0 : k_h + 1;
  assign x_next = reset_x ? 0 : x + {29'b0, conv_stride};
  assign y_next = reset_y ? 0 : y + {29'b0, conv_stride};
  assign ch_in_next = reset_ch_in ? 0 : ch_in + 1;
  assign ch_out_next = reset_ch_out ? 0 : ch_out + 1;

  logic last_k_v, last_k_h, last_x, last_y, last_ch_in, last_ch_out;
  assign last_k_v = k_v == {29'b0, conv_kernel} - 1;
  assign last_k_h = k_h == {29'b0, conv_kernel} - 1;
  assign last_x = x >= FEATURE_MAP_WIDTH - conv_stride; //if next step falls outside of feature map width --> reset
  assign last_y = y >= FEATURE_MAP_HEIGHT - conv_stride;
  assign last_ch_in = ch_in == INPUT_NB_CHANNELS - 1;
  assign last_ch_out = ch_out == OUTPUT_NB_CHANNELS - 1;

  assign reset_k_v = last_k_v;
  assign reset_k_h = last_k_h;
  assign reset_x = last_x;
  assign reset_y = last_y;
  assign reset_ch_in = last_ch_in;
  assign reset_ch_out = last_ch_out;

  /*
  chosen loop order:
  for x
    for y
      for ch_in
        for ch_out     (with this order, accumulations need to be kept because ch_out is inside ch_in)
          for k_v
            for k_h
              body
  */
  // ==>
  
  // when to update loop counters
  assign k_h_we    = mac_valid;  //each time a mac is done, k_h_we increments (or resets to 0 if last)
  assign k_v_we    = mac_valid && last_k_h;  //only if last of k_h loop
  assign ch_out_we = mac_valid && last_k_h && last_k_v;  //only if last of all enclosed loops
  assign ch_in_we  = mac_valid && last_k_h && last_k_v && last_ch_out; //only if last of all enclosed loops
  assign y_we      = mac_valid && last_k_h && last_k_v && last_ch_out && last_ch_in; //only if last of all enclosed loops
  assign x_we      = mac_valid && last_k_h && last_k_v && last_ch_out && last_ch_in && last_y; //only if last of all enclosed loops

  logic last_overall;
  assign last_overall = last_k_h && last_k_v && last_ch_out && last_ch_in && last_y && last_x; //when total calculation is finished


  `REG(32, prev_ch_out); // ?? why an extra register when prev_ch_out is always = ch_out-1 ?? --> is only extra hardware + ?? DOES NOT NEED TO BE 32 BITS ??
  assign prev_ch_out_next        = ch_out;
  assign prev_ch_out_we          = ch_out_we;
  //given loop order, partial sums need be saved over input channels
  assign mem_we                  = k_v == 0 && k_h == 0;
  assign mem_write_addr          = prev_ch_out;

  //and loaded back
  assign mem_re                  = k_v == 0 && k_h == 0;
  assign mem_read_addr           = ch_out;

  assign mac_accumulate_internal = !(k_v == 0 && k_h == 0); // if switching to next output channel, DO NOT accumulate internal
  assign mac_accumulate_with_0   = ch_in == 0 && k_v == 0 && k_h == 0; //accumulate with 0 or ext_mem_qout?

  //mark outputs
  `REG(1, output_valid_reg);
  assign output_valid_reg_next = mac_valid && last_ch_in && last_k_v && last_k_h; //after calculations for specific (x,y) over all input channels and kernal size --> return output for every output channel 
  assign output_valid_reg_we = 1;
  assign output_valid = output_valid_reg;

  // The output address (x, y, ch) is retended by these registers
  // DO NOT NEED TO BE 32 BITS !!!!!!!!!
  register #(
      .WIDTH(32)
  ) output_x_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(x),
      .qout(output_x),
      .we(mac_valid && last_ch_in && last_k_v && last_k_h)
  );
  register #(
      .WIDTH(32)
  ) output_y_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(y),
      .qout(output_y),
      .we(mac_valid && last_ch_in && last_k_v && last_k_h)
  );
  register #(
      .WIDTH(32)
  ) output_ch_r (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(ch_out),
      .qout(output_ch),
      .we(mac_valid && last_ch_in && last_k_v && last_k_h)
  );
  //mini fsm to loop over <fetch_a, fetch_b, acc>

  typedef enum {
    IDLE,
    FETCH_A,
    FETCH_B,
    MAC
  } fsm_state_e;

  fsm_state_e current_state;
  fsm_state_e next_state;
  always @(posedge clk or negedge arst_n_in) begin
    if (arst_n_in == 0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end


  always_comb begin
    //defaults: applicable if not overwritten below
    write_a   = 0;
    write_b   = 0;
    mac_valid = 0;
    running   = 1;
    a_ready   = 0;
    b_ready   = 0;

    case (current_state)
      IDLE: begin
        running = 0;
        next_state = start ? FETCH_A : IDLE;
      end
      FETCH_A: begin
        a_ready = 1;
        write_a = a_valid;
        next_state = a_valid ? FETCH_B : FETCH_A;
      end
      FETCH_B: begin
        b_ready = 1;
        write_b = b_valid;
        next_state = b_valid ? MAC : FETCH_B;
      end
      MAC: begin
        mac_valid  = 1;
        next_state = last_overall ? IDLE : FETCH_A;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end
endmodule

/*
      FETCH: begin
        a_ready = 1;
        b_ready = 1;
        write_a = a_valid;
        write_b = b_valid;
        next_state = b_valid ? MAC : FETCH;
       end
      MAC: begin
        mac_valid = 1;
        next_state = last_overall ? IDLE : FETCH;
*/
