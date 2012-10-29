`timescale 1ns / 1ps


module DataMemModifier(out, in,BHW,Lower2,ExtendSign);
	
	output [31:0] out;
	input [31:0] in;
	reg [31:0] out,temp;
	input [1:0] BHW,Lower2;
	input ExtendSign;
	
	always @(in,BHW,Lower2) begin
		case (BHW)
			0: begin // BYTE
				case (Lower2) // 31:24,23:16,15:8,7:0
					0: begin
						if (ExtendSign)
							out <= {in[7],24'b0,in[6:0]};
						else 
							out <= {24'b0,in[7:0]};
					end
					1: begin
						if (ExtendSign)
							out <= {in[15],24'b0,in[14:8]};
						else 
							out <= {24'b0,in[15:8]};
					end
					2: begin
						if (ExtendSign)
							out <= {in[23],24'b0,in[22:16]};
						else 
							out <= {24'b0,in[23:16]};
					end
					3: begin
						if (ExtendSign)
							out <= {in[31],24'b0,in[30:24]};
						else 
							out <= {24'b0,in[31:24]};
					end
				endcase
			end
			1: begin // HALFWORD
				case (Lower2)
					0: begin
						if (ExtendSign)
							out <= {in[15],16'b0,in[14:0]};
						else 
							out <= {16'b0,in[15:0]};
					end	
					1: begin
						if (ExtendSign)
							out <= {in[31],16'b0,in[30:16]};
						else 
							out <= {16'b0,in[31:16]};
					end
				endcase
			end
			2: begin // WORD
				out <= in;
			end
		endcase
		
	end

endmodule
