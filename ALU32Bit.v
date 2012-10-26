`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory 3 (PreLab)
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: 4-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU behaviorally, so that it supports addition,  subtraction,
// AND, OR, and set on less than (SLT). The 'ALUResult' will output the 
// corresponding result of the operation based on the 32-Bit inputs, 'A', and 
// 'B'. The 'Zero' flag is high when 'ALUResult' is '0'. The 'ALUControl' signal 
// should determine the function of the ALU based on the table below:-
// Op   | 'ALUControl' value
// ==========================
// ADD  | 0010
// SUB  | 0110
// AND  | 0000
// OR   | 0001
// SLT  | 0111
//
// NOTE:-
// SLT (i.e., set on less than): ALUResult is '32'h000000001' if A < B.
// 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, Zero);

	input   [3:0]   ALUControl; // control bits for ALU operation
	input   [31:0]  A, B;	    // inputs

	integer temp,i,x;
	output  reg [31:0]  ALUResult;	// answer
	output  reg     Zero;	    // Zero=1 if ALUResult == 0

    /* Please fill in the implementation here... */


    always @(ALUControl,A,B)
    begin
    	if (ALUControl == 0) // AND
    	begin
    		ALUResult <= A & B;
    	end
    	else if (ALUControl == 1) // OR
    	begin
    		ALUResult <= A | B;
    	end
    	else if (ALUControl == 2) // ADD
    	begin
    		ALUResult <= A + B;
    	end
    	else if (ALUControl == 6) // SUB
    	begin
    		ALUResult <= A + (~B + 1);
    	end
    	else if (ALUControl == 7) // SLT
    	begin
			if (A[31] != B[31]) begin
				if (A[31] > B[31]) begin
					ALUResult <= 1;
				end else begin
					ALUResult <= 0;
				end
			end else begin
				if (A < B)
				begin
					ALUResult <= 1;
				end
				else
				begin
					ALUResult <= 0;
				end
			end
    	end
		else if (ALUControl == 3) // NOR
		begin
			ALUResult <= ~(A | B);
		end
		else if (ALUControl == 8) // Jump
		begin
			ALUResult <= 0;
		end
		else if (ALUControl == 9) // MUL
		begin
			ALUResult <= A * B;
		end
		else if (ALUControl == 10) // SLL
		begin
			ALUResult <= A << (B[10:6]);
		end
		else if (ALUControl == 11) // SGT - Set Greater Than
		begin
			if (A[31] != B[31]) begin
				if (A[31] > B[31]) begin
					ALUResult <= 0;
				end else begin
					ALUResult <= 1;
				end
			end else begin
				if (A < B)
				begin
					ALUResult <= 0;
				end
				else
				begin
					ALUResult <= 1;
				end
			end
		end
		else if (ALUControl == 12) // CLO/CLZ
		begin
			x = B;
			temp = 32;
			for (i = 31; i >= 0; i = i - 1) begin
					if (A[i] == x) begin
						temp = 31 - i;
						i = -2;
					end
			end
			ALUResult <= temp;
		end


    end


	always @(ALUResult) begin
		if (ALUResult == 0) begin
			Zero <= 1;
		end else begin
			Zero <= 0;
		end
	
	end

endmodule

