

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:30 11/05/2012 
// Design Name: 
// Module Name:    if_id_reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module if_id_reg(clk,rst,pc_in,instruction_in,instruction_out,pc_out);
    input clk, rst;
	 input [31:0] instruction_in,pc_in;
	 output [31:0] instruction_out, pc_out;
	 reg [31:0] instruction_out, pc_out;

	 
	always@(rst)
	begin
		instruction_out <= 32'b0;
		pc_out <= 32'b0;
	end

	always@(posedge clk)
	begin
		instruction_out <= instruction_in;
		pc_out <= pc_in;
	end
	 


endmodule
