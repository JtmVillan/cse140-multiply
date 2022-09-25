// Counter that decrements from WIDTH to 0 at every positive clock edge.
// CSE140L      lab 1
module counter_down	#(parameter dw=8, WIDTH=7)
(
  input                 clk,
  input                 reset,
  input                 ena,
  output logic [dw-1:0] result);

  always @(posedge clk)	 begin
      if (reset == 1 && ena == 1) begin
          result <= WIDTH;
      end
      else if (reset == 1 && ena == 0) begin
          result <= WIDTH;
      end
      else if (reset == 0 && ena == 1) begin
          result <= result - 1;
      end
// fill in guts -- clocked (sequential) logic
//  if(...) result <= ...;	      // note nonblocking (<=) assignment!!
//  else if(...) result <= ...;
//reset   ena      result
//  1      1       WIDTH
//  1      0       WIDTH
//  0      1       decrease by 1
//  0      0       hold
  end
endmodule

/*
int i = 10
while (i < 0) {     a condition is met
    do something      it decrements
    i--;
}
*/
