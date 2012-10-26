`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory 1
// Module - sign_extension.v
// Description - Extends a 16-Bit input number to produce a 32-Bit output 
// number.
////////////////////////////////////////////////////////////////////////////////

module sign_extension(out, in,ExtendSign);

    /* A 32-Bit output word */
    output  [31:0] out;
    
    /* A 16-Bit input word */
    input   [15:0] in;
	 input ExtendSign;
	 reg [31:0] out;
	 reg [15:0] A;
	 reg [31:0] B;

    /* Fill in the implementation here... */ 
    always@(in)
	 begin
		if (ExtendSign == 0) begin
			out <= in;
		end else begin
			if ((in & 16'h8000) == 16'h8000)
			begin
			  out <= 32'hffff0000 + in;
			end
			else 
			begin
			  out <= in;
			end
		end
		//out <= B;
	 end
endmodule
