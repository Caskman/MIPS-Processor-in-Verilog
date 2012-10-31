`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory 3 + Lab 12
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a memory and initilize it by reading from a test data.  
// The 'WriteData' value is written into the address 
// in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location if 
// 'MemRead' is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data that needs to be written into the address 
    input Clk;
    input MemWrite; 		// Control signal for memory write 
    input MemRead; 			// Control signal for memory read 

    output reg[31:0] ReadData; // Contents of memory location at Address

    reg 	[31:0] 	Memory[0:1024];	// size needs to be adjusted based on the size of the test_data.txt
   
   //assign ReadData = (MemRead == 1) ? Memory[Address] : 32'h00000000;
   
   		always 	@(posedge Clk)		   //Memory write
   		begin
   		
   		if (MemWrite==1)
   				Memory[Address>>2] = WriteData;
   		end
   		
   		always @(Address or MemRead)
   		begin	
   			if	(MemRead == 1)
   				ReadData <= Memory[Address>>2];	//Memory read
   			else
   				ReadData <= 32'h00000000;
					
					//$display("%h",Memory[Address]);
   		end 
   		
			initial begin
				$readmemh("test_data.txt",Memory);
			
			end
            // initialize memory by reading hex values  
   	    // Input file must have the exact name "test_data.txt" with the following format:
            // first line is number of rows for frame data (i)
            // second line is number of columns for frame data (j)
            // third line is number of rows for window data (k)
            // fourth line is number of columns for window data (l)
            // followed by i*j number of pixel values for frame data
            // followed by k*l number of pixel values for window data
		//
            // Notes: 
            // 1-make sure to adjust the "Memory" size based on your test input
            //   for 16x16 and 8x8 test case your memory  will have 4 values for size 
            //   information, 256 for frame, 64 for window (total of 324). 
            //   Memory[0:323]
            // 2-watch out for wild characters at the end of the last entry in your test file

            // insert your code here for reading from test data ! Be careful, this step is done only once 
            // right before starting the vbsme code. 
            
                        
	    		

endmodule