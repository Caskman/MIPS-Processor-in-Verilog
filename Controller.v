module Controller(Clk);
	
	
	
	input Clk;
	wire [31:0]  WriteDataToMem,Instruction,WriteDataToReg,ReadData1,MemToRegData,NextInstruct;
	wire [31:0] ReadData2,ALUResult,ReadDataFromMem,Extended15to0Inst,ALUSrcInB,ALUSrcInA;
	reg Reset,RegWrite;
	wire [4:0] ReadRegister1, ReadRegister2,WriteRegister;
	reg [3:0] ALUControl,ALUBSrc;
	reg [1:0] RegDst,RegDataSel,ALUASrc,BHW;
	reg MemtoReg,MemWrite,MemRead,BranchEqual,Jump,BranchNotEqual,NOOP,ExtendSign;
	reg BranchBLTZ_BGTZ,BranchBGEZ,JumpSel,RegWriteSel,DataMemExtendSign;
	wire Zero,BranchOut1,BranchOut2,BranchOutTotal,RegWriteOut;
	
	initial begin
		Reset <= 0;
	end
	
	InstructionFetchUnit IF(Instruction,Reset,Clk,Extended15to0Inst,BranchOutTotal,Instruction[25:0],Jump,NextInstruct,ReadData1,JumpSel);
	RegisterFile RF(ReadRegister1,ReadRegister2,WriteRegister,WriteDataToReg,RegWriteOut,Clk,ReadData1,ReadData2);
	ALU32Bit ALU(ALUControl, ALUSrcInA, ALUSrcInB, ALUResult, Zero);
	DataMemory DMem(ALUResult, WriteDataToMem, Clk, MemWrite, MemRead, ReadDataFromMem,BHW,DataMemExtendSign);
	sign_extension InstExtend(Extended15to0Inst,Instruction[15:0],ExtendSign);
	mux_2to1_32bit WriteDataRegInputMux(MemToRegData, ALUResult, ReadDataFromMem, MemtoReg);
	mux_4to1_5bit WriteRegInputMux(WriteRegister,ReadRegister2,Instruction[15:11],5'd31,5'h0,RegDst);
	mux_4to1_32bit ALUAInputMux(ALUSrcInA,ReadData1,ReadData2,Extended15to0Inst,32'b0,ALUASrc);
	mux_16to1_32bit ALUBInputMux(ALUSrcInB,ReadData2,Extended15to0Inst,32'd0,32'd1,{27'd0,Instruction[10:6]},ReadData1,32'd16,{26'd0,Instruction[21],Instruction[10:6]},{26'd0,Instruction[6],ReadData1[4:0]},32'd0,32'd0,32'd0,32'd0,32'd0,32'd0,32'd0,ALUBSrc);
	mux_4to1_32bit RegDataMux(WriteDataToReg,MemToRegData,NextInstruct,ReadData1,32'd0,RegDataSel);
	mux_2to1_1bit RegWriteMux(RegWriteOut,RegWrite,Zero,RegWriteSel);

	assign ReadRegister1 = Instruction[25:21];// rs
	assign ReadRegister2 = Instruction[20:16];// rt
	assign WriteDataToMem = ReadData2;
	assign BranchOut1 = BranchEqual & Zero; // Represents AND gate
	assign BranchOut2 = BranchNotEqual & (~Zero);
	assign BranchOut3 = BranchBLTZ_BGTZ & ALUResult[0];
	assign BranchOut4 = BranchBGEZ & ~(ALUResult[0]);
	assign BranchOutTotal = BranchOut1 | BranchOut2 | BranchOut3 | BranchOut4;
	 
 
	always @(Instruction) begin
	
		
//			Jump <= 0;
//			JumpSel <= 0;
//			MemRead <= 0;
//			MemtoReg <= 0;
//			MemWrite <= 0;
//			ALUControl <= 0;
//			ALUASrc <= 0;
//			ALUBSrc <= 0;
//			ExtendSign <= 0;
//			BranchEqual <= 0;
//			BranchNotEqual <= 0;
//			BranchBLTZ_BGTZ <= 0;
//			BranchBGEZ <= 0;
//			RegWrite <= 0;
//			RegWriteSel <= 0;
//			RegDataSel <= 0;
//			RegDst <= 0;
//			BHW <= 0;
//			DataMemExtendSign <= 0;


		if (Instruction != 0) begin
			case (Instruction[31:26]) 
				0: begin // R-type or SPECIAL
					case (Instruction[5:0]) 
						32: begin // ADD
							ALUControl <= 2;
							RegWrite <= 1;
							ALUBSrc <= 0;
							ALUASrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						33: begin // ADDU
							ALUControl <= 2;
							RegWrite <= 1;
							ALUBSrc <= 0;
							ALUASrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						36:begin // AND
							ALUControl <= 0;
							RegWrite <= 1;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						37: begin // OR
							ALUControl <= 1;
							RegWrite <= 1;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						34:begin // SUB
							ALUControl <= 6;
							RegWrite <= 1;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						42:begin // SLT
							ALUControl <= 7;
							RegWrite <= 1;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						39: begin // NOR
							ALUControl <= 3;
							RegWrite <= 1;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						0: begin // SLL
							ALUControl <= 10;
							RegWrite <= 1;
							ALUBSrc <= 4;
							ALUASrc <= 1;
							Jump <= 0;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						8: begin // JR
							Jump <= 1;
							JumpSel <= 1;
							RegWrite <= 0;
							RegWriteSel <= 0;
						end
						10: begin // MOVZ
							Jump <= 0;
							ALUBSrc <= 2;
							ALUControl <= 6;
							ALUASrc <= 1;
							RegDataSel <= 2;
							RegWriteSel <= 1;
						end
						2: begin // ROTR & SRL
							Jump <= 0;
							ALUControl <= 13;
							ALUASrc <= 1;
							ALUBSrc <= 7;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						6: begin // ROTRV & SRLV
							Jump <= 0;
							ALUControl <= 13;
							ALUASrc <= 1;
							ALUBSrc <= 8;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						38: begin // XOR
							Jump <= 0;
							ALUControl <= 4;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						4: begin // SLLV
							Jump <= 0;
							ALUControl <= 10;
							ALUASrc <= 1;
							ALUBSrc <= 4;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						35: begin // SUBU
							Jump <= 0;
							ALUControl <= 6;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
						end
						43: begin // SLTU
							Jump <= 0;
							MemRead <= 0;
							MemtoReg <= 0;
							MemWrite <= 0;
							ALUControl <= 14;
							ALUASrc <= 0;
							ALUBSrc <= 0;
							BranchEqual <= 0;
							BranchNotEqual <= 0;
							BranchBLTZ_BGTZ <= 0;
							BranchBGEZ <= 0;
							RegWrite <= 1;
							RegDataSel <= 0;
							RegDst <= 1;
							RegWriteSel <= 0;
						end
						3: begin // SRA
							Jump <= 0;
							ALUControl <= 15;
							ALUASrc <= 1;
							ALUBSrc <= 4;
							RegWrite <= 1;
							RegWriteSel <= 0;
						end
						7: begin // SRAV
							Jump <= 0;
							ALUControl <= 15;
							ALUASrc <= 1;
							ALUBSrc <= 5;
							RegWrite <= 1;
							RegWriteSel <= 0;
						end
						default:
						RegWrite <= 0;
						
					endcase
					RegDst <= 1;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
				end
				28: begin // SPECIAL2
					case (Instruction[5:0])
						33: begin // CLO
							Jump <= 0;
							RegDst <= 1;
							BranchEqual <= 0;
							MemRead <= 0;
							MemtoReg <= 0;
							MemWrite <= 0;
							ALUControl <= 12;
							RegWrite <= 1;
							BranchNotEqual <= 0;
							ALUASrc <= 0;
							ALUBSrc <= 3;
							BranchBLTZ_BGTZ <= 0;
							BranchBGEZ <= 0;
							RegDataSel <= 0;
						end
						32: begin // CLZ
							Jump <= 0;
							RegDst <= 1;
							BranchEqual <= 0;
							MemRead <= 0;
							MemtoReg <= 0;
							MemWrite <= 0;
							ALUControl <= 12;
							RegWrite <= 1;
							BranchNotEqual <= 0;
							ALUASrc <= 0;
							ALUBSrc <= 2;
							BranchBLTZ_BGTZ <= 0;
							BranchBGEZ <= 0;
							RegDataSel <= 0;
						end
					endcase
					RegWriteSel <= 0;
				end
				8: begin // ADDI
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ALUASrc <= 0;
					ExtendSign <= 1;
					RegWriteSel <= 0;
				end
				9: begin //ADDIU
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				12: begin // ANDI
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				13: begin // ORI
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 1;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				4: begin // BEQ
					BranchEqual <= 1;
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 0;
					ALUControl <= 6;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				2: begin // Jump
					Jump <= 1;
					JumpSel <= 0;
					MemWrite <= 0;
					RegWrite <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWriteSel <= 0;
				end
				35: begin // LW
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
					BHW <= 2;
					DataMemExtendSign <= 1;
				end
				43: begin // SW
					Jump <= 0;
					RegDst <= 0;
					BranchEqual <= 0;
					MemWrite <= 1;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					RegWrite <= 0;
					ALUControl <= 2;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
					BHW <= 2;
					DataMemExtendSign <= 1;
				end
				5: begin // BNE
					Jump <= 0;
					BranchEqual <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 0;
					ALUControl <= 6;
					BranchNotEqual <= 1;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				28: begin // MUL 
					RegDst <= 1;
					Jump <= 0;
					BranchEqual <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUASrc <= 0;
					ALUBSrc <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					ALUControl <= 9;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWriteSel <= 0;
				end
				1: begin // BGEZ & BLTZ 
					case (Instruction[20:16])
						0: begin // BLTZ
							BranchBLTZ_BGTZ <= 1;
							BranchBGEZ <= 0;
						end
						1: begin // BGEZ
							BranchBGEZ <= 1;
							BranchBLTZ_BGTZ <= 0;
						end
					endcase
					Jump <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemWrite <= 0;
					ALUBSrc <= 2;
					ALUControl <= 7;
					RegWrite <= 0;
					BranchNotEqual <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
					RegWriteSel <= 0;
				end
				7: begin // BGTZ
					Jump <= 0;
					BranchEqual <= 0;
					MemRead <= 0;
					MemWrite <= 0;
					ALUBSrc <= 2;
					ALUControl <= 11;
					RegWrite <= 0;
					BranchNotEqual <= 0;
					ALUASrc <= 0;
					ExtendSign <= 0;
					BranchBGEZ <= 0;
					BranchBLTZ_BGTZ <= 1;
					RegWriteSel <= 0;
				end
				3: begin // JAL
					Jump <= 1;
					JumpSel <= 0;
					RegDst <= 2;
					BranchEqual <= 0;
					MemRead <= 0;
					MemWrite <= 0;
					RegWrite <= 1;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegDataSel <= 1;
					RegWriteSel <= 0;
				end
				14: begin // XORI
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUControl <= 4;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 0;
				end
				10: begin // SLTI
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUControl <= 7;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 1;
				end
				11: begin // SLTIU
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUControl <= 14;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 0;
				end
				15: begin // LUI
					Jump <= 0;
					MemRead <= 0;
					MemtoReg <= 0;
					MemWrite <= 0;
					ALUControl <= 10;
					ALUASrc <= 2;
					ALUBSrc <= 6;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 0;
				end
				32: begin // LB
					Jump <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 1;
					BHW <= 0;
					DataMemExtendSign <= 1;
				end
				36: begin // LBU
					Jump <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegDataSel <= 0;
					RegDst <= 0;
					RegWriteSel <= 0;
					ExtendSign <= 1;
					BHW <= 0;
					DataMemExtendSign <= 0;
				end
				33: begin // LH
					Jump <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					ExtendSign <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegWriteSel <= 0;
					RegDataSel <= 0;
					RegDst <= 0;
					BHW <= 1;
					DataMemExtendSign <= 1;
				end
				37: begin // LHU
					Jump <= 0;
					MemRead <= 1;
					MemtoReg <= 1;
					MemWrite <= 0;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					ExtendSign <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 1;
					RegWriteSel <= 0;
					RegDataSel <= 0;
					RegDst <= 0;
					BHW <= 1;
					DataMemExtendSign <= 0;
				end
				40: begin // SB
					Jump <= 0;
					MemRead <= 0;
					MemWrite <= 1;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					ExtendSign <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 0;
					RegWriteSel <= 0;
					BHW <= 0;
					DataMemExtendSign <= 1;
				end
				41: begin // SH
					Jump <= 0;
					MemRead <= 0;
					MemWrite <= 1;
					ALUControl <= 2;
					ALUASrc <= 0;
					ALUBSrc <= 1;
					ExtendSign <= 1;
					BranchEqual <= 0;
					BranchNotEqual <= 0;
					BranchBLTZ_BGTZ <= 0;
					BranchBGEZ <= 0;
					RegWrite <= 0;
					RegWriteSel <= 0;
					BHW <= 1;
					DataMemExtendSign <= 1;
				end
				31: begin // SPECIAL3
					case (Instruction[10:6])
						16: begin // SEB
							Jump <= 0;
							MemRead <= 0;
							MemtoReg <= 0;
							MemWrite <= 0;
							ALUControl <= 5;
							ALUASrc <= 1;
							ALUBSrc <= 2;
							BranchEqual <= 0;
							BranchNotEqual <= 0;
							BranchBLTZ_BGTZ <= 0;
							BranchBGEZ <= 0;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
							RegDst <= 1;
						end
						24: begin // SEH
							Jump <= 0;
							MemRead <= 0;
							MemtoReg <= 0;
							MemWrite <= 0;
							ALUControl <= 5;
							ALUASrc <= 1;
							ALUBSrc <= 3;
							BranchEqual <= 0;
							BranchNotEqual <= 0;
							BranchBLTZ_BGTZ <= 0;
							BranchBGEZ <= 0;
							RegWrite <= 1;
							RegWriteSel <= 0;
							RegDataSel <= 0;
							RegDst <= 1;
						end
					endcase
				end
			endcase
			NOOP <= 0;
		end else begin
			NOOP <= 1;
			Jump <= 0;
			JumpSel <= 0;
			MemRead <= 0;
			MemtoReg <= 0;
			MemWrite <= 0;
			ALUControl <= 0;
			ALUASrc <= 0;
			ALUBSrc <= 0;
			ExtendSign <= 0;
			BranchEqual <= 0;
			BranchNotEqual <= 0;
			BranchBLTZ_BGTZ <= 0;
			BranchBGEZ <= 0;
			RegWrite <= 0;
			RegWriteSel <= 0;
			RegDataSel <= 0;
			RegDst <= 0;
			BHW <= 0;
			DataMemExtendSign <= 0;
		end
	end


	
	


endmodule