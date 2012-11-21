`timescale 1ns / 1ps

module ForwardingControl(Rs,Rt,RegWrite_MEM,WriteRegAddress_MEM,RegWrite_WB,WriteRegAddress_WB,ReadData1Sel,ReadData2Sel);
	input [4:0] Rs,Rt,WriteRegAddress_MEM,WriteRegAddress_WB;
	input RegWrite_MEM,RegWrite_WB;
	output [1:0] ReadData1Sel,ReadData2Sel;
	reg [1:0] ReadData1Sel,ReadData2Sel;
	
	
	always @(Rs,Rt,WriteRegAddress_MEM,WriteRegAddress_WB,RegWrite_MEM,RegWrite_WB) begin
		
		if (Rs == WriteRegAddress_MEM && RegWrite_MEM == 1) begin
			ReadData1Sel <= 1;
		end else if (Rs == WriteRegAddress_WB && RegWrite_WB == 1) begin
			ReadData1Sel <= 2;
		end else begin
			ReadData1Sel <= 0;
		end
		
		if (Rt == WriteRegAddress_MEM && RegWrite_MEM == 1) begin
			ReadData2Sel <= 1;
		end else if (Rt == WriteRegAddress_WB && RegWrite_WB == 1) begin
			ReadData2Sel <= 2;
		end else begin
			ReadData2Sel <= 0;
		end
		
		// if (RegWrite_MEM == 1) begin // mem stage is modifying
			// if (Rs == WriteRegAddress_MEM) begin // ReadData1 is dependent
				// ReadData1Sel <= 1;
			// end else begin
				// ReadData1Sel <= 0;
			// end
			// if (Rt == WriteRegAddress_MEM) begin // ReadData2 is dependent
				// ReadData2Sel <= 1;
			// end else begin
				// ReadData2Sel <= 0;
			// end
		// end else if (RegData_WB == 1) begin // WB stage is modifying
			// if (Rs == WriteRegAddress_WB) begin // ReadData1 is dependent
				// ReadData1 <= 0;
				// ReadData2 <= 1;
			// end
			// if (Rt == WriteRegAddress_WB) begin // ReadData2 is dependent
				// ReadData1 <= 0;
				// ReadData2 <= 1;
			// end
		// end
		
		
		
	end
	
	
	
endmodule