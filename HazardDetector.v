`timescale 1ns / 1ps
module HazardDetector(MemRead_MEM,Rs_ID,Rt_ID,Rt_EX,InstructionSel,PCWrite,IF_ID_Write,Reset);
	input MemRead_MEM,Reset;
	input [4:0] Rs_ID,Rt_ID,Rt_EX;
	output InstructionSel,PCWrite,IF_ID_Write;
	reg InstructionSel,PCWrite,IF_ID_Write;
	
	always @(MemRead_MEM,Rs_ID,Rt_ID,Rt_EX,Reset) begin
		if (Reset == 0) begin
			if (MemRead_MEM == 1 && (Rs_ID == Rt_EX || Rt_ID == Rt_EX)) begin // hazard detected
				InstructionSel <= 0;
				PCWrite <= 0;
				IF_ID_Write <= 0;
			end else begin // hazard not detected
				InstructionSel <= 1;
				PCWrite <= 1;
				IF_ID_Write <= 1;
			end
		end else begin
			PCWrite <= 0;
			InstructionSel <= 0;
			IF_ID_Write <= 0;
		end
	end
	
	
endmodule