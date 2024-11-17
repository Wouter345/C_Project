// Defines 18 registers with 1 read port and 1 write port
module KERNEL_REG#(
  //initial value overwritten by tbench_top
  parameter int WIDTH = 16
  )
  (
  input logic clk,

  //read port (0 cycle: there is no clock edge between changing the read_addr and the output)
  input logic unsigned [4:0] read_addr,
  input logic unsigned [4:0] write_addr,
  input logic read_en, //isnt used here
  
  input logic [WIDTH-1:0] din,
  input logic write_en,
  output logic[WIDTH-1:0] qout
  );


  `REG(WIDTH, reg0);
  `REG(WIDTH, reg1);
  `REG(WIDTH, reg2);
  `REG(WIDTH, reg3);
  `REG(WIDTH, reg4);
  `REG(WIDTH, reg5);
  `REG(WIDTH, reg6);
  `REG(WIDTH, reg7);
  `REG(WIDTH, reg8);
  `REG(WIDTH, reg9);
  `REG(WIDTH, reg10);
  `REG(WIDTH, reg11);
  `REG(WIDTH, reg12);
  `REG(WIDTH, reg13);
  `REG(WIDTH, reg14);
  `REG(WIDTH, reg15);
  `REG(WIDTH, reg16);
  `REG(WIDTH, reg17);
  
  assign reg0_next = din;
  assign reg1_next = din;
  assign reg2_next = din;
  assign reg3_next = din;
  assign reg4_next = din;
  assign reg5_next = din;
  assign reg6_next = din;
  assign reg7_next = din;
  assign reg8_next = din;
  assign reg9_next = din;
  assign reg10_next = din;
  assign reg11_next = din;
  assign reg12_next = din;
  assign reg13_next = din;
  assign reg14_next = din;
  assign reg15_next = din;
  assign reg16_next = din;
  assign reg17_next = din;
  
  
  always_comb
  begin
    reg0_we = 0;
    reg1_we = 0;
    reg2_we = 0;
    reg3_we = 0;
    reg4_we = 0;
    reg5_we = 0;
    reg6_we = 0;
    reg7_we = 0;
    reg8_we = 0;
    reg9_we = 0;
    reg10_we = 0;
    reg11_we = 0;
    reg12_we = 0;
    reg13_we = 0;
    reg14_we = 0;
    reg15_we = 0;
    reg16_we = 0;
    reg17_we = 0;
    case(write_addr)
        0: reg0_we = write_en;
        1: reg1_we = write_en;
        2: reg2_we = write_en;
        3: reg3_we = write_en;
        4: reg4_we = write_en;
        5: reg5_we = write_en;
        6: reg6_we = write_en;
        7: reg7_we = write_en;
        8: reg8_we = write_en;
        9: reg9_we = write_en;
        10: reg10_we = write_en;
        11: reg11_we = write_en;
        12: reg12_we = write_en;
        13: reg13_we = write_en;
        14: reg14_we = write_en;
        15: reg15_we = write_en;
        16: reg16_we = write_en;
        17: reg17_we = write_en;
    endcase
  end
  
  logic [WIDTH-1:0] output_data;
  assign qout = output_data;
  
  always_comb
  begin
    case(read_addr)
        0: output_data = reg0;
        1: output_data = reg1;
        2: output_data = reg2;
        3: output_data = reg3;
        4: output_data = reg4;
        5: output_data = reg5;
        6: output_data = reg6;
        7: output_data = reg7;
        8: output_data = reg8;
        9: output_data = reg9;
        10: output_data = reg10;
        11: output_data = reg11;
        12: output_data = reg12;
        13: output_data = reg13;
        14: output_data = reg14;
        15: output_data = reg15;
        16: output_data = reg16;
        17: output_data = reg17;
        default: output_data = 0;
    endcase
  end


endmodule
