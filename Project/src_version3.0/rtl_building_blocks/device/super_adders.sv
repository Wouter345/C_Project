// Instantiates 16 adder units working in parallel
module super_adders #(
  parameter int A_WIDTH = 16,
  parameter int OUT_WIDTH = 16
  )
  (
  input logic signed [A_WIDTH-1:0] input_0a,
  input logic signed [A_WIDTH-1:0] input_1a,
  input logic signed [A_WIDTH-1:0] input_2a,
  input logic signed [A_WIDTH-1:0] input_3a,
  input logic signed [A_WIDTH-1:0] input_4a,
  input logic signed [A_WIDTH-1:0] input_5a,
  input logic signed [A_WIDTH-1:0] input_6a,
  input logic signed [A_WIDTH-1:0] input_7a,
  input logic signed [A_WIDTH-1:0] input_8a,
  input logic signed [A_WIDTH-1:0] input_9a,
  input logic signed [A_WIDTH-1:0] input_10a,
  input logic signed [A_WIDTH-1:0] input_11a,
  input logic signed [A_WIDTH-1:0] input_12a,
  input logic signed [A_WIDTH-1:0] input_13a,
  input logic signed [A_WIDTH-1:0] input_14a,
  input logic signed [A_WIDTH-1:0] input_15a,
  
  input logic signed [A_WIDTH-1:0] input_0b,
  input logic signed [A_WIDTH-1:0] input_1b,
  input logic signed [A_WIDTH-1:0] input_2b,
  input logic signed [A_WIDTH-1:0] input_3b,
  input logic signed [A_WIDTH-1:0] input_4b,
  input logic signed [A_WIDTH-1:0] input_5b,
  input logic signed [A_WIDTH-1:0] input_6b,
  input logic signed [A_WIDTH-1:0] input_7b,
  input logic signed [A_WIDTH-1:0] input_8b,
  input logic signed [A_WIDTH-1:0] input_9b,
  input logic signed [A_WIDTH-1:0] input_10b,
  input logic signed [A_WIDTH-1:0] input_11b,
  input logic signed [A_WIDTH-1:0] input_12b,
  input logic signed [A_WIDTH-1:0] input_13b,
  input logic signed [A_WIDTH-1:0] input_14b,
  input logic signed [A_WIDTH-1:0] input_15b,
  
  output logic signed [OUT_WIDTH-1:0] output_0,
  output logic signed [OUT_WIDTH-1:0] output_1,
  output logic signed [OUT_WIDTH-1:0] output_2,
  output logic signed [OUT_WIDTH-1:0] output_3,
  output logic signed [OUT_WIDTH-1:0] output_4,
  output logic signed [OUT_WIDTH-1:0] output_5,
  output logic signed [OUT_WIDTH-1:0] output_6,
  output logic signed [OUT_WIDTH-1:0] output_7,
  output logic signed [OUT_WIDTH-1:0] output_8,
  output logic signed [OUT_WIDTH-1:0] output_9,
  output logic signed [OUT_WIDTH-1:0] output_10,
  output logic signed [OUT_WIDTH-1:0] output_11,
  output logic signed [OUT_WIDTH-1:0] output_12,
  output logic signed [OUT_WIDTH-1:0] output_13,
  output logic signed [OUT_WIDTH-1:0] output_14,
  output logic signed [OUT_WIDTH-1:0] output_15

  );
    
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add0 (
     .a(input_0a),
     .b(input_0b),
     .out(output_0)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add1 (
     .a(input_1a),
     .b(input_1b),
     .out(output_1)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add2 (
     .a(input_2a),
     .b(input_2b),
     .out(output_2)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add3 (
     .a(input_3a),
     .b(input_3b),
     .out(output_3)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add4 (
     .a(input_4a),
     .b(input_4b),
     .out(output_4)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add5 (
     .a(input_5a),
     .b(input_5b),
     .out(output_5)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add6 (
     .a(input_6a),
     .b(input_6b),
     .out(output_6)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add7 (
     .a(input_7a),
     .b(input_7b),
     .out(output_7)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add8 (
     .a(input_8a),
     .b(input_8b),
     .out(output_8)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add9 (
     .a(input_9a),
     .b(input_9b),
     .out(output_9)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add10 (
     .a(input_10a),
     .b(input_10b),
     .out(output_10)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add11 (
     .a(input_11a),
     .b(input_11b),
     .out(output_11)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add12 (
     .a(input_12a),
     .b(input_12b),
     .out(output_12)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add13 (
     .a(input_13a),
     .b(input_13b),
     .out(output_13)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add14 (
     .a(input_14a),
     .b(input_14b),
     .out(output_14)
  );
  
  adder #( .A_WIDTH(A_WIDTH),
           .B_WIDTH(A_WIDTH),
           .OUT_WIDTH(OUT_WIDTH),
           .OUT_SCALE(0)
  ) add15 (
     .a(input_15a),
     .b(input_15b),
     .out(output_15)
  );
    


endmodule
