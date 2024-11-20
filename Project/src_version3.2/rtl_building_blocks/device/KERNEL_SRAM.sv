// Instantiates 32 SRAM memory blocks, 1 for each (input_channel, output_channel)
// each block storing 9 kernel coefficients
// each block has height of 128 because it takes less area
module KERNEL_SRAM #(
  // initial value overwritten by tbench_top
  parameter int WIDTH = 16,
  parameter int HEIGHT = 128,
  parameter bit USED_AS_EXTERNAL_MEM = 0
  )
  (
  input logic clk,  
  
  input logic unsigned[$clog2(HEIGHT)-1:0] KERNEL_read_addr,
  input logic unsigned[$clog2(HEIGHT)-1:0] KERNEL_write_addr,
  input logic KERNEL_re,
  
  // KERNEL inputs  
  input logic [WIDTH-1:0] KERNEL_din_0a,
  input logic [WIDTH-1:0] KERNEL_din_1a,
  input logic [WIDTH-1:0] KERNEL_din_2a,
  input logic [WIDTH-1:0] KERNEL_din_3a,
  input logic [WIDTH-1:0] KERNEL_din_4a,
  input logic [WIDTH-1:0] KERNEL_din_5a,
  input logic [WIDTH-1:0] KERNEL_din_6a,
  input logic [WIDTH-1:0] KERNEL_din_7a,
  input logic [WIDTH-1:0] KERNEL_din_8a,
  input logic [WIDTH-1:0] KERNEL_din_9a,
  input logic [WIDTH-1:0] KERNEL_din_10a,
  input logic [WIDTH-1:0] KERNEL_din_11a,
  input logic [WIDTH-1:0] KERNEL_din_12a,
  input logic [WIDTH-1:0] KERNEL_din_13a,
  input logic [WIDTH-1:0] KERNEL_din_14a,
  input logic [WIDTH-1:0] KERNEL_din_15a,
  
  input logic [WIDTH-1:0] KERNEL_din_0b,
  input logic [WIDTH-1:0] KERNEL_din_1b,
  input logic [WIDTH-1:0] KERNEL_din_2b,
  input logic [WIDTH-1:0] KERNEL_din_3b,
  input logic [WIDTH-1:0] KERNEL_din_4b,
  input logic [WIDTH-1:0] KERNEL_din_5b,
  input logic [WIDTH-1:0] KERNEL_din_6b,
  input logic [WIDTH-1:0] KERNEL_din_7b,
  input logic [WIDTH-1:0] KERNEL_din_8b,
  input logic [WIDTH-1:0] KERNEL_din_9b,
  input logic [WIDTH-1:0] KERNEL_din_10b,
  input logic [WIDTH-1:0] KERNEL_din_11b,
  input logic [WIDTH-1:0] KERNEL_din_12b,
  input logic [WIDTH-1:0] KERNEL_din_13b,
  input logic [WIDTH-1:0] KERNEL_din_14b,
  input logic [WIDTH-1:0] KERNEL_din_15b,
  
  // KERNEL write enables
  input logic KERNEL_we_0a,
  input logic KERNEL_we_1a,
  input logic KERNEL_we_2a,
  input logic KERNEL_we_3a,
  input logic KERNEL_we_4a,
  input logic KERNEL_we_5a,
  input logic KERNEL_we_6a,
  input logic KERNEL_we_7a,
  input logic KERNEL_we_8a,
  input logic KERNEL_we_9a,
  input logic KERNEL_we_10a,
  input logic KERNEL_we_11a,
  input logic KERNEL_we_12a,
  input logic KERNEL_we_13a,
  input logic KERNEL_we_14a,
  input logic KERNEL_we_15a,
  
  input logic KERNEL_we_0b,
  input logic KERNEL_we_1b,
  input logic KERNEL_we_2b,
  input logic KERNEL_we_3b,
  input logic KERNEL_we_4b,
  input logic KERNEL_we_5b,
  input logic KERNEL_we_6b,
  input logic KERNEL_we_7b,
  input logic KERNEL_we_8b,
  input logic KERNEL_we_9b,
  input logic KERNEL_we_10b,
  input logic KERNEL_we_11b,
  input logic KERNEL_we_12b,
  input logic KERNEL_we_13b,
  input logic KERNEL_we_14b,
  input logic KERNEL_we_15b,
  
  // KERNEL outputs qout
  output logic[WIDTH-1:0] KERNEL_qout_0a,
  output logic[WIDTH-1:0] KERNEL_qout_1a,
  output logic[WIDTH-1:0] KERNEL_qout_2a,
  output logic[WIDTH-1:0] KERNEL_qout_3a,
  output logic[WIDTH-1:0] KERNEL_qout_4a,
  output logic[WIDTH-1:0] KERNEL_qout_5a,
  output logic[WIDTH-1:0] KERNEL_qout_6a,
  output logic[WIDTH-1:0] KERNEL_qout_7a,
  output logic[WIDTH-1:0] KERNEL_qout_8a,
  output logic[WIDTH-1:0] KERNEL_qout_9a,
  output logic[WIDTH-1:0] KERNEL_qout_10a,
  output logic[WIDTH-1:0] KERNEL_qout_11a,
  output logic[WIDTH-1:0] KERNEL_qout_12a,
  output logic[WIDTH-1:0] KERNEL_qout_13a,
  output logic[WIDTH-1:0] KERNEL_qout_14a,
  output logic[WIDTH-1:0] KERNEL_qout_15a,
  
  output logic[WIDTH-1:0] KERNEL_qout_0b,
  output logic[WIDTH-1:0] KERNEL_qout_1b,
  output logic[WIDTH-1:0] KERNEL_qout_2b,
  output logic[WIDTH-1:0] KERNEL_qout_3b,
  output logic[WIDTH-1:0] KERNEL_qout_4b,
  output logic[WIDTH-1:0] KERNEL_qout_5b,
  output logic[WIDTH-1:0] KERNEL_qout_6b,
  output logic[WIDTH-1:0] KERNEL_qout_7b,
  output logic[WIDTH-1:0] KERNEL_qout_8b,
  output logic[WIDTH-1:0] KERNEL_qout_9b,
  output logic[WIDTH-1:0] KERNEL_qout_10b,
  output logic[WIDTH-1:0] KERNEL_qout_11b,
  output logic[WIDTH-1:0] KERNEL_qout_12b,
  output logic[WIDTH-1:0] KERNEL_qout_13b,
  output logic[WIDTH-1:0] KERNEL_qout_14b,
  output logic[WIDTH-1:0] KERNEL_qout_15b
  );
  
  //unit0a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit0a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_0a),
      .write_en(KERNEL_we_0a),
      .din(KERNEL_din_0a)
  );
  
  //unit1a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit1a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_1a),
      .write_en(KERNEL_we_1a),
      .din(KERNEL_din_1a)
  );
  
  //unit2a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit2a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_2a),
      .write_en(KERNEL_we_2a),
      .din(KERNEL_din_2a)
  );
  
  //unit3a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit3a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_3a),
      .write_en(KERNEL_we_3a),
      .din(KERNEL_din_3a)
  );
  
  //unit4a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit4a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_4a),
      .write_en(KERNEL_we_4a),
      .din(KERNEL_din_4a)
  );
  
  //unit5a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit5a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_5a),
      .write_en(KERNEL_we_5a),
      .din(KERNEL_din_5a)
  );
  
  //unit6a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit6a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_6a),
      .write_en(KERNEL_we_6a),
      .din(KERNEL_din_6a)
  );
  
  //unit7a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit7a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_7a),
      .write_en(KERNEL_we_7a),
      .din(KERNEL_din_7a)
  );
  
  //unit8a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit8a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_8a),
      .write_en(KERNEL_we_8a),
      .din(KERNEL_din_8a)
  );
  
  //unit9a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit9a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_9a),
      .write_en(KERNEL_we_9a),
      .din(KERNEL_din_9a)
  );
  
  
  //unit10a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit10a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_10a),
      .write_en(KERNEL_we_10a),
      .din(KERNEL_din_10a)
  );
  
  
  //unit11a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit11a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_11a),
      .write_en(KERNEL_we_11a),
      .din(KERNEL_din_11a)
  );
  
  //unit12a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit12a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_12a),
      .write_en(KERNEL_we_12a),
      .din(KERNEL_din_12a)
  );
  
  //unit13a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit13a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_13a),
      .write_en(KERNEL_we_13a),
      .din(KERNEL_din_13a)
  );
  
  //unit14a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit14a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_14a),
      .write_en(KERNEL_we_14a),
      .din(KERNEL_din_14a)
  );
  
  
  //unit15a
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit15a (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_15a),
      .write_en(KERNEL_we_15a),
      .din(KERNEL_din_15a)
  );
  
  //unit0b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit0b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_0b),
      .write_en(KERNEL_we_0b),
      .din(KERNEL_din_0b)
  );
  
  //unit1b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit1b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_1b),
      .write_en(KERNEL_we_1b),
      .din(KERNEL_din_1b)
  );
  
  //unit2b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit2b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_2b),
      .write_en(KERNEL_we_2b),
      .din(KERNEL_din_2b)
  );
  
  //unit3b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit3b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_3b),
      .write_en(KERNEL_we_3b),
      .din(KERNEL_din_3b)
  );
  
  //unit4b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit4b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_4b),
      .write_en(KERNEL_we_4b),
      .din(KERNEL_din_4b)
  );
  
  //unit5b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit5b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_5b),
      .write_en(KERNEL_we_5b),
      .din(KERNEL_din_5b)
  );
  
  //unit6b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit6b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_6b),
      .write_en(KERNEL_we_6b),
      .din(KERNEL_din_6b)
  );
  
  //unit7b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit7b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_7b),
      .write_en(KERNEL_we_7b),
      .din(KERNEL_din_7b)
  );
  
  //unit8b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit8b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_8b),
      .write_en(KERNEL_we_8b),
      .din(KERNEL_din_8b)
  );
  
  //unit9b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit9b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_9b),
      .write_en(KERNEL_we_9b),
      .din(KERNEL_din_9b)
  );
  
  
  //unit10b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit10b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_10b),
      .write_en(KERNEL_we_10b),
      .din(KERNEL_din_10b)
  );
  
  
  //unit11b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit11b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_11b),
      .write_en(KERNEL_we_11b),
      .din(KERNEL_din_11b)
  );
  
  //unit12b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit12b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_12b),
      .write_en(KERNEL_we_12b),
      .din(KERNEL_din_12b)
  );
  
  //unit13b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit13b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_13b),
      .write_en(KERNEL_we_13b),
      .din(KERNEL_din_13b)
  );
  
  //unit14b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit14b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_14b),
      .write_en(KERNEL_we_14b),
      .din(KERNEL_din_14b)
  );
  
  
  //unit15b
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit15b (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_15b),
      .write_en(KERNEL_we_15b),
      .din(KERNEL_din_15b)
  );
  endmodule