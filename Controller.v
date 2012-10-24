module Controller(Clk);
	
	
	
	input Clk;
   wire  [31:0]  WriteDataToMem,Instruction,WriteDataToReg,ReadData1;
	wire [31:0] ReadData2,ALUResult,ReadDataFromMem,Extended15to0Inst,ALUSrcInB,ALUSrcInA;
	reg Reset,RegWrite;
	wire [4:0] ReadRegister1, ReadRegister2,WriteRegister;
	reg [3:0] ALUControl;
	reg MemtoReg,MemWrite,MemRead,RegDst,ALUBSrc,ALUASrc,Branch,Jump,BranchNotEqual,NOOP,ExtendSign;
	wire Zero,BranchOut1,BranchOut2,BranchOutTotal;
	
	initial begin
		Reset <= 0;
	end

   InstructionFetchUnit IF(Instruction,Reset,Clk,Extended15to0Inst,BranchOutTotal,Instruction[25:0],Jump);
	RegisterFile RF(ReadRegister1,ReadRegister2,WriteRegister,WriteDataToReg,RegWrite,Clk,ReadData1,ReadData2);
	ALU32Bit ALU(ALUControl, ALUSrcInA, ALUSrcInB, ALUResult, Zero);
	DataMemory DMem(ALUResult, WriteDataToMem, Clk, MemWrite, MemRead, ReadDataFromMem);
	mux_2to1_32bit WriteDataRegInputMux(WriteDataToReg, ALUResult, ReadDataFromMem, MemtoReg);
	mux_2to1_5bit WriteRegInputMux(WriteRegister,ReadRegister2,Instruction[15:11],RegDst);
	mux_2to1_32bit ALUAInputMux(ALUSrcInA,ReadData1,ReadData2,ALUASrc);
	mux_2to1_32bit ALUBInputMux(ALUSrcInB,ReadData2,Extended15to0Inst,ALUBSrc);
	sign_extension InstExtend(Extended15to0Inst,Instruction[15:0],ExtendSign);

	assign ReadRegister1 = Instruction[25:21];// rs
	assign ReadRegister2 = Instruction[20:16];// rt
	assign WriteDataToMem = ReadData2;
	assign BranchOut1 = Branch & Zero; // Represents AND gate
	assign BranchOut2 = BranchNotEqual & (~Zero);
	assign BranchOutTotal = BranchOut1 | BranchOut2;
	 
 
	always @(Instruction) begin
	
		$display("Instruction = %h",Instruction);
		
//			Jump <= 0;
//			RegDst <= 1;
//			Branch <= 0;
//			MemRead <= 0;
//			MemtoReg <= 0;
//			MemWrite <= 0;
//			ALUBSrc <= 0;
//			ALUControl <= 0;
//			RegWrite <= 0;
//			BranchNotEqual <= 0;
//			ALUASrc <= 0;

//			ExtendSign <= 0;
			

		if (Instruction != 0) begin
			case (Instruction[31:26]) 
				0: begin // R-type
					case (Instruction[5:0]) 
					 32: begin
						 ALUControl <= 2;
						 RegWrite <= 1;
						ALUBSrc <= 0;
						ALUASrc <= 0;
						$display("ADD");
						end
					 33: begin // ADDU
						 ALUControl <= 2;
						 RegWrite <= 1;
						ALUBSrc <= 0;
						ALUASrc <= 0;
					 end
					 36:begin
						 ALUControl <= 0;
						 RegWrite <= 1;
						ALUASrc <= 0;
					ALUBSrc <= 0;
					$display("AND");
						end
					 37: begin
						 ALUControl <= 1;
						 RegWrite <= 1;
						ALUASrc <= 0;
					ALUBSrc <= 0;
					$display("OR");
						end
					 34:begin
						 ALUControl <= 6;
						 RegWrite <= 1;
						ALUASrc <= 0;
					ALUBSrc <= 0;
					$display("SUB");
						end
					 42:begin
						 ALUControl <= 7;
						 RegWrite <= 1;
						ALUASrc <= 0;
					ALUBSrc <= 0;
					$display("SLT");
						end
					 39: begin
						 ALUControl <= 3;
						 RegWrite <= 1;
						ALUASrc <= 0;
					ALUBSrc <= 0;
					$display("NOR");
						end
					 0: begin // SLL
						ALUControl <= 10;
						RegWrite <= 1;
						ALUBSrc <= 1;
						ALUASrc <= 1;
					 end
						
						
					default:
						 RegWrite <= 0;
						
					endcase
					Jump <= 0;
					RegDst <= 1;
					Branch <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					BranchNotEqual <= 0;
					
					
				end
				8: begin // ADDI
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					ALUASrc <= 0;
					ExtendSign <= 1;
					$display("ADDI");
				end
				9: begin //ADDIU
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
				end
				12: begin // ANDI
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					ALUControl <= 0;
					BranchNotEqual <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
					$display("ANDI");
				end
				13: begin // ORI
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					ALUControl <= 1;
					BranchNotEqual <= 0;
					ExtendSign <= 0;
					$display("ORI");
				end
				4: begin // BEQ
					Branch <= 1;
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 0;
					ALUControl <= 6;
					BranchNotEqual <= 0;
					ExtendSign <= 0;
					$display("BEQ");
				end
				2: begin // Jump
					Jump <= 1;
					MemWrite <= 0;
					RegWrite <= 0;
					BranchNotEqual <= 0;
					$display("Jump");
				end
				35: begin // LW
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					ExtendSign <= 0;
					$display("LW");
				end
				43: begin // SW
					Jump <= 0;
					RegDst <= 0;
					Branch <= 0;
					MemWrite <= 1;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 0;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					ExtendSign <= 0;
					$display("SW");
				end
				5: begin // BNE
					Jump <= 0;
					Branch <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 0;
					ALUControl <= 6;
					BranchNotEqual <= 1;
					ExtendSign <= 0;
					$display("SW");
				end
				28: begin // MUL 
					RegDst <= 1;
					Jump <= 0;
					Branch <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 1;
					ALUControl <= 9;
					BranchNotEqual <= 0;
				end
			endcase
			NOOP <= 0;
		end else begin
			NOOP <= 1;
			Jump <= 0;
			RegDst <= 0;
			Branch <= 0;
			MemRead <= 0;
			MemtoReg <= 0;
			MemWrite <= 0;
			ALUBSrc <= 0;
			ALUControl <= 0;
			RegWrite <= 0;
			BranchNotEqual <= 0;
			ALUASrc <= 0;

		end
	end


	
	


endmodule