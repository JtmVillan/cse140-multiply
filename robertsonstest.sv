// CSE140L     Lab 1
// top level test bench -- simulation only
// multiplicand inputs are valid from -64 to +127 only
//   We shall therefore restrict testing to 7-bit inputs (-64 to +63)
module robertsonstest;

// DUT Inputs = active drives from test bench into DUT
  bit               clk;                 // 1-bit, 0 or 1 only (no x or z)
  bit               reset;               // self-initializes to 0
  byte              multiplier;          // 8-bit two's comp, no x or z bits
  byte              multiplicand;

// DUT Outputs = passive inputs to test bench from DUT
  wire signed[15:0] product;		     // 16-bit two's comp
  wire              done;                // tells test bench to read product

// count number of clock cycles
  int               cycle,
// count number of individual trials
                    cycle1,
// count number of massed trials
                    cycle2;

// expected_product = multiplier * multiplicand
  logic signed[15:0] expected_product;	 // compare to DUT output

// Instantiate the Device Under Test (DUT): "dut" = instance name
// toprobertsons = instance type (defined in toprobertsons.sv as a module)
  robsmult dut (
  	.clk          (clk     ),
  	.reset        (reset   ), 		     // pulse 0-1-0 starts each new operation
  	.multiplier   (multiplier  ), 		 // incoming operands
  	.multiplicand (multiplicand),
  	.product      (product ),			 // result from DUT
  	.done         (done    )			 // DUT reports "operation complete"
	);

// emergency brake thread -- halts program if no done flags received from DUT
//  initial #100000ns $stop;

// launch second of two parallel threads, to do the actual testing
  initial begin
// starts automatically with 0*0
    rslt_disp;
// rslt_disp (see below) is a task (subroutine) call w/ automatic return to main
// Stimulus sequence starts with discrete tests
//   for debug, try various powers of two and other simple operands
/*
    multiplier   = -2;
    multiplicand = 2;
    rslt_disp;

    multiplier   = 2;
    multiplicand = 4;
    rslt_disp;*/

// Positive Multiplicand * Positive Multiplier
    multiplier   = 5;
    multiplicand = 6;
    rslt_disp;

// Negative Multiplicand *Positive Multiplier
    multiplier   =  7;
    multiplicand = -5;
    rslt_disp;
// Positive Multiplicand * Negative Multiplier
    multiplier   = -5;
    multiplicand =  6;
    rslt_disp;
// Positive Multiplicand * Negative Multiplier
    multiplier   = -7;
    multiplicand =  8;
    rslt_disp;
// Negative Multiplicand * Negative Multiplier
    multiplier   = -5;
    multiplicand = -6;
    rslt_disp;
// Negative Multiplicand * Negative Multiplier
    multiplier   = -9;
    multiplicand = -4;
    rslt_disp;
    //#40ns $display("clock cycles = %d, test cycles = %d, sequence_cycles = %d",cycle,cycle1,cycle2);
    //$stop;
// if errors encountered, insert #40ns $stop; here
//   debug discrete tests before running the whole -64 to +63 sequence
// now try a comprehensive (exhaustive) test -- nested FOR loops
    for(multiplier = -64; multiplier<64; multiplier++) begin
	  for(multiplicand = -64; multiplicand<64; multiplicand++)
        rslt_disp2;					   // second task call
    end
    #40ns $display("clock cycles = %d, test cycles = %d, sequence_cycles = %d",cycle,cycle1,cycle2);
    $stop;
  end

// generate digital clock to drive sequential logic in DUT
  always begin
	#5ns  clk = 1'b1;       // tic
	#5ns  clk = 1'b0;       // toc
    cycle++;
  end

// generate display list for transcript, individual tests
// this is the subroutine (Verilog uses "task" and "function")
//   run for each combination of multiplicand * multiplier
  task rslt_disp;
    reset = 1;                  // requeset next multiplication from DUT
    #10ns reset = 0;			// release reset command
	cycle1++;
    expected_product = multiplier * multiplicand;
 	#10ns wait(done);           // wait for acknowledge from DUT
    if (product == expected_product) begin
// in hex (0x) format
      $display("Simulation succeeded %h = %h = %h * %h", expected_product,product,multiplier,multiplicand);
// also in decimal
      $display("Simulation succeeded %d = %d = %d * %d", expected_product,product,multiplier,multiplicand);
    end
    else
      $display("Simulation failed %h != %h = %h * %h", product,expected_product,multiplier,multiplicand);
	#40ns;						// wait before return to main
  endtask		                // causes automatic return to main

// for comprehensive test, print only the failures
  task rslt_disp2;
    reset = 1;
    #10ns reset = 0;
    expected_product = multiplier * multiplicand;
	cycle2++;
 	#10ns wait(done);
    if (product != expected_product)
      $display("Simulation failed %h != %h = %h * %h", product,expected_product,multiplier,multiplicand);
	#40ns;
  endtask

endmodule
