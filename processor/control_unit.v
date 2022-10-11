module control_unit(
  input  [3:0]    opcode,    			  // First four bits of the instruction
//   input            clk,             // Clock

  output [7:0]  control_rod         // Set of all control signals
);

  reg [7:0] cu_reg=8'b00000000;    // Register to store the values of the control signals

  always @ (*) begin
    cu_reg[7:0]	<= 8'b00000000;	  //Set all the bits of the control unit register to 0
    if(!opcode[3]) begin                   //bit no. 3 of the opcode is 0 for the operations which need to be performed by the ALU else it is 1
      cu_reg[2:0] <= opcode[2:0];	  //Conrol_signals for ALU operations(other than the bit no. 3, rest others are the same as the corresponding bits of the opcode)
      cu_reg[6]<=1'b1;
    end else if(opcode[0]&opcode[1]) begin		//Control Signals for BEQ and JMP (both the bits 0 and 1 in the opcode are 1 in case of jump and beq)
      if(opcode[2])                         // bit no. 2 of the opcode is 1 for jump instruction
        cu_reg[7]<=1'b1;
      else                                  // bit no. 2 of the opcode is 0 for beq instruction
        cu_reg[3]<=1'b1;
    end else								//Control Signals for LD, ST and RES (bit no. 0 of the opcode is 1 and the bit no. 1 is 0 for these operations)
      cu_reg[6:4] <= opcode[2:0];           //The bits from 5 to 8 of the control rod are the same as the bits from 0 to 2 of the opcodes
  end


    // Refer to the opcode table:
    // NOP : 1000
    // ADD : 0001
    // MUL : 0010
    // XOR : 0100
    // INC : 0011
    // CMP : 0110
    // BEQ : 1011
    // JMP : 1111
    // LD  : 1101
    // ST  : 1010
    // RES : 1100

  assign control_rod = cu_reg;      //Attaching the output wire to the control unit register

endmodule


// module tb();
//     reg [3:0] op;
//     output [7:0] cr;

//     aryan_test dut(.opcode(op),.control_rod(cr));

//     initial begin
//         $dumpfile("aryan.vcd");
//         $dumpvars(0,tb);
//         op <= 4'b0001;    #10;
//         op <= 4'b1111;    #10;
//         op <= 4'b0110;    #10;
//         op <= 4'b1101;    #10;
//         $finish;
//     end

// endmodule

// OPCODES:
// NOP : 1000
// ADD : 0001
// MUL : 0010
// XOR : 0100
// INC : 0011
// CMP : 0110
// BEQ : 1011
// JMP : 1111
// LD  : 1101
// ST  : 1010
// RES : 1100

// Control Rod (Bits):
// 0-2 for ALU
// 3 for BEQ
// 4 for ReadMem
// 5 for MemWrite
// 6 for RegWrite
// 7 for JMP
