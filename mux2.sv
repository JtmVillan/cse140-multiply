// 2:1 mux (selector) of N-wide buses
// CSE140L
module mux2 #(parameter WIDTH = 8)
 (input        [WIDTH-1:0] d0, d1,
  input                    s,
  output logic [WIDTH-1:0] y);

  always_comb begin
      if (s == 0) begin
          y = d0;
      end
      else begin
          y = d1;
      end
  end
// fill in guts
// combinational (unclocked) logic -- use =, not <=
// always_comb if(...) y = ...;
// s   y
// 0   d0	y[7:0] = d0[7:0]
// 1   d1	y[7:0] = d1[7:0]

endmodule
