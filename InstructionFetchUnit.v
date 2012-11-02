`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory 3 (PostLab)
// Module - InstructionFetchUnit.v
// Description - Fetches the instruction from the instruction memory based on 
//               the program counter (PC) value.
// INPUTS:-
// Reset: 1-Bit input signal. 
// Clk: Input clock signal.
//
// OUTPUTS:-
// Instruction: 32-Bit output instruction from the instruction memory.
//
// FUNCTIONALITY:-
// Please connect up the following implemented modules to create this
// 'InstructionFetchUnit':-
//   (a) ProgramCounter.v
//   (b) PCAdder.v
//   (c) InstructionMemory.v
// Connect the modules together in a testbench so that the instruction memory
// outputs the contents of the next instruction indicated by the memory location
// in the PC at every clock cycle. Please initialize the instruction memory with
// some preliminary values for debugging purposes.
//
// @@ The 'Reset' input control signal is connected to the program counter (PC) 
// register which initializes the unit to output the first instruction in 
// instruction memory.
// @@ The 'Instruction' output port holds the output value from the instruction
// memory module.
// @@ The 'Clk' input signal is connected to the program counter (PC) register 
// which generates a continuous clock pulse into the module.
////////////////////////////////////////////////////////////////////////////////

module InstructionFetchUnit(Instruction, Reset, Clk,InstructOffset,Branch,JumpInstruction,Jump,NextInstruct,JumpRegister,JumpSel);

    /* Please fill in the implementation here... */
	 wire [31:0] PCAdderOut,PCNext,Instruction,ALUResult,PCOut,PCNextBJ;
	 wire Zero;
	 input Reset,Clk,Branch,Jump,JumpSel;
	 input [31:0] InstructOffset,JumpRegister;
	 input [25:0] JumpInstruction;
	 wire [31:0] JumpIn;
	 reg [3:0] ALUControl;
	 
	 output [31:0] Instruction,NextInstruct;
	 
	 initial begin
		ALUControl <= 2;
	 end
	 
	 PCAdder adder(PCOut,PCAdderOut);
	 
	 ProgramCounter PC(PCNext,PCOut,Reset,Clk);
	 
	 InstructionMemory mem(PCOut,Instruction);
	 mux_2to1_32bit PCNextOrBranchMux(PCNextBJ,PCAdderOut,ALUResult,Branch);
	 mux_2to1_32bit jumpsel(JumpIn, {PCOut[31:26],(JumpInstruction<<2)}, JumpRegister, JumpSel); 
	 mux_2to1_32bit jump(PCNext,PCNextBJ,JumpIn,Jump); 
	 ALU32Bit OffsetCalc(ALUControl,PCOut,(InstructOffset<<2),ALUResult,Zero);
	 
	 assign NextInstruct = PCAdderOut;

endmodule

