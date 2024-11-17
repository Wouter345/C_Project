// Instantiates 16 SRAM memory blocks, 1 for each output channel
// each block storing 18 kernel coefficients
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
  input logic [WIDTH-1:0] KERNEL_din_0,
  input logic [WIDTH-1:0] KERNEL_din_1,
  input logic [WIDTH-1:0] KERNEL_din_2,
  input logic [WIDTH-1:0] KERNEL_din_3,
  input logic [WIDTH-1:0] KERNEL_din_4,
  input logic [WIDTH-1:0] KERNEL_din_5,
  input logic [WIDTH-1:0] KERNEL_din_6,
  input logic [WIDTH-1:0] KERNEL_din_7,
  input logic [WIDTH-1:0] KERNEL_din_8,
  input logic [WIDTH-1:0] KERNEL_din_9,
  input logic [WIDTH-1:0] KERNEL_din_10,
  input logic [WIDTH-1:0] KERNEL_din_11,
  input logic [WIDTH-1:0] KERNEL_din_12,
  input logic [WIDTH-1:0] KERNEL_din_13,
  input logic [WIDTH-1:0] KERNEL_din_14,
  input logic [WIDTH-1:0] KERNEL_din_15,
  
  // KERNEL write enables
  input logic KERNEL_we_0,
  input logic KERNEL_we_1,
  input logic KERNEL_we_2,
  input logic KERNEL_we_3,
  input logic KERNEL_we_4,
  input logic KERNEL_we_5,
  input logic KERNEL_we_6,
  input logic KERNEL_we_7,
  input logic KERNEL_we_8,
  input logic KERNEL_we_9,
  input logic KERNEL_we_10,
  input logic KERNEL_we_11,
  input logic KERNEL_we_12,
  input logic KERNEL_we_13,
  input logic KERNEL_we_14,
  input logic KERNEL_we_15,
  
  // KERNEL outputs qout
  output logic[WIDTH-1:0] KERNEL_qout_0,
  output logic[WIDTH-1:0] KERNEL_qout_1,
  output logic[WIDTH-1:0] KERNEL_qout_2,
  output logic[WIDTH-1:0] KERNEL_qout_3,
  output logic[WIDTH-1:0] KERNEL_qout_4,
  output logic[WIDTH-1:0] KERNEL_qout_5,
  output logic[WIDTH-1:0] KERNEL_qout_6,
  output logic[WIDTH-1:0] KERNEL_qout_7,
  output logic[WIDTH-1:0] KERNEL_qout_8,
  output logic[WIDTH-1:0] KERNEL_qout_9,
  output logic[WIDTH-1:0] KERNEL_qout_10,
  output logic[WIDTH-1:0] KERNEL_qout_11,
  output logic[WIDTH-1:0] KERNEL_qout_12,
  output logic[WIDTH-1:0] KERNEL_qout_13,
  output logic[WIDTH-1:0] KERNEL_qout_14,
  output logic[WIDTH-1:0] KERNEL_qout_15
  );
  
  //unit0
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit0 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_0),
      .write_en(KERNEL_we_0),
      .din(KERNEL_din_0)
  );
  
  //unit1
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit1 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_1),
      .write_en(KERNEL_we_1),
      .din(KERNEL_din_1)
  );
  
  //unit2
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit2 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_2),
      .write_en(KERNEL_we_2),
      .din(KERNEL_din_2)
  );
  
  //unit3
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit3 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_3),
      .write_en(KERNEL_we_3),
      .din(KERNEL_din_3)
  );
  
  //unit4
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit4 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_4),
      .write_en(KERNEL_we_4),
      .din(KERNEL_din_4)
  );
  
  //unit5
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit5 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_5),
      .write_en(KERNEL_we_5),
      .din(KERNEL_din_5)
  );
  
  //unit6
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit6 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_6),
      .write_en(KERNEL_we_6),
      .din(KERNEL_din_6)
  );
  
  //unit7
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit7 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_7),
      .write_en(KERNEL_we_7),
      .din(KERNEL_din_7)
  );
  
  //unit8
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit8 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_8),
      .write_en(KERNEL_we_8),
      .din(KERNEL_din_8)
  );
  
  //unit9
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit9 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_9),
      .write_en(KERNEL_we_9),
      .din(KERNEL_din_9)
  );
  
  
  //unit10
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit10 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_10),
      .write_en(KERNEL_we_10),
      .din(KERNEL_din_10)
  );
  
  
  //unit11
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit11 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_11),
      .write_en(KERNEL_we_11),
      .din(KERNEL_din_11)
  );
  
  //unit12
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit12 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_12),
      .write_en(KERNEL_we_12),
      .din(KERNEL_din_12)
  );
  
  //unit13
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit13 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_13),
      .write_en(KERNEL_we_13),
      .din(KERNEL_din_13)
  );
  
  //unit14
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit14 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_14),
      .write_en(KERNEL_we_14),
      .din(KERNEL_din_14)
  );
  
  
  //unit15
  memory #(
      .WIDTH(WIDTH),
      .HEIGHT(HEIGHT),
      .USED_AS_EXTERNAL_MEM(0)
  ) memory_unit15 (
      .clk(clk),
      .read_addr(KERNEL_read_addr),
      .write_addr(KERNEL_write_addr),
      .read_en(KERNEL_re),
      
      .qout(KERNEL_qout_15),
      .write_en(KERNEL_we_15),
      .din(KERNEL_din_15)
  );
  endmodule