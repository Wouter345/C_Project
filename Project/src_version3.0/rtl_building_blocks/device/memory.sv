//a simple pseudo-2 port memory (can read and write simultaneously)
module memory #(
  //initial value overwritten by tbench_top
  parameter int WIDTH = 16,
  parameter int HEIGHT = 1,
  parameter bit USED_AS_EXTERNAL_MEM = 0// for area, bandwidth and energy estimation
  )
  (
  input logic clk,

  //read port (0 cycle: there is no clock edge between changing the read_addr and the output)
  input logic unsigned[$clog2(HEIGHT)-1:0] read_addr,
  input logic unsigned[$clog2(HEIGHT)-1:0] write_addr,
  input logic read_en,
  
  input logic [WIDTH-1:0] din,
  input logic write_en,
  output logic[WIDTH-1:0] qout
  );


  //storage
  logic [WIDTH-1:0] data [HEIGHT];

  always @ (posedge clk) begin
    if (write_en) begin
        data[write_addr] <= din;
    end
  end

  assign qout = read_en ? data[read_addr] :'x ; //assings read_data or unknown

  `ifndef TARGET_SYNTHESIS //ensure below code is only used for simulation, not actual synthesis
  //area logging
  initial begin
    #0;
    if(!USED_AS_EXTERNAL_MEM) begin // external memory --> area=0
      if (HEIGHT<128) begin //register (<128) --> 17 area per bit
        tbench_top.area += 17*WIDTH*HEIGHT;
        $display("%m added %d to area", 17*WIDTH*HEIGHT);
      end else begin //on_chip SRAM (>=128) --> 1 area per bit
        tbench_top.area += 1*WIDTH*HEIGHT;
        $display("%m added %d to area", 1*WIDTH*HEIGHT);
      end
    end
  end

  //energy logging:
  always @(posedge clk) begin
    if(read_en)
      tbench_top.energy += WIDTH*(USED_AS_EXTERNAL_MEM?1:0.1); // if used as internal(on_chip) memory --> 0.1 energy per read
                                                               // if external --> 1 energy per bit
  end
  always @(posedge clk) begin
    if(write_en)
      tbench_top.energy += WIDTH*(USED_AS_EXTERNAL_MEM?1:0.1);
  end
  `endif
endmodule
