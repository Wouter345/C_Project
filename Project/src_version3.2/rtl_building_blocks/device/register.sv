// set this file to global include to get rid of syntax warnings for macro REG in other modules
module register #(
  parameter integer WIDTH     = 20,
  parameter integer RESET_VAL = 'b0
   )(
  input  logic              clk,
  input  logic              arst_n_in, //asynchronous reset, active low
  input  logic [WIDTH-1:0]  din,
  output logic [WIDTH-1:0]  qout,
  input  logic              we //write enable (register does write only when write enable is high)
);

logic [WIDTH-1:0] r;

always_ff @(posedge clk, negedge arst_n_in) begin
   if(arst_n_in==0)begin
      r <= RESET_VAL;
   end else begin
      if(we)
        r <= din;
   end
end
assign qout = r;

`ifndef TARGET_SYNTHESIS     /////// ?? Does these registers not count towards energy ??
//area logging
initial begin 
  #0;
  tbench_top.area += 17*WIDTH;
  $display("%m added %d to area", 17*WIDTH);
end
// energy logging, added myself
always @(posedge clk) begin
    if (we) begin
        tbench_top.energy += WIDTH*(0.1);
     end
  end
`endif


endmodule



//Instantiation macro:
//you can use this macro to do the following things in one line
//1) define <r_name> and <r_name>_next as logic [r_width-1:0]
//2) define <r_name>_we as logic;
//3) instantiate register instance of width <r_width> named <r_name>_r with
//     <r_name> as qout
//     <r_name>_next as din
//     <r_name>_we as we
//     clk as clk
//     arst_n_in as arst_n_in
//E.g.: `REG(32, my_register);

`define REG(r_width, r_name) \
logic [r_width-1:0] ``r_name``_next, r_name;\
logic ``r_name``_we;\
register #(.WIDTH(r_width)) ``r_name``_r(.clk(clk), .arst_n_in(arst_n_in), .din(``r_name``_next), .qout(r_name), .we(``r_name``_we))
