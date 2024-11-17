// Instantiates 16 KERNEL_REG blocks, 1 for each output channel
// each block storing 18 kernel coefficients
module KERNEL_SRAM2 #(
  // initial value overwritten by tbench_top
  parameter int WIDTH = 16
  )
  (
  input logic clk,  
  
  input logic unsigned [4:0] KERNEL_read_addr,
  input logic unsigned [4:0] KERNEL_write_addr,
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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
  KERNEL_REG #(
      .WIDTH(WIDTH)
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