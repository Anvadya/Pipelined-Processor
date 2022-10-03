module pipeline(
  input  [3:0]    opcode,    			  // First four bits of the instruction
  input            clk,             // Clock
  
  output [7:0]  control_rod         // Set of all control signals 
);
  
  reg [7:0] cu_reg=8'b000000000;    // Register to store the values of the control signals
  
  always @ (posedge clk) begin
    cu_reg[7:0]	<= 8'b000000000;	  //Set all the bits of the control unit register to 0
    if(!opcode[3])
      cu_reg[2:0] <= opcode[2:0];	  //Conrol_signals for ALU operations and NOP
    else if(opcode[0]&opcode[1]) begin		//Control Signals for BEQ and JMP
      if(opcode[2]) 
        cu_reg[7]<=1'b1;
      else
        cu_reg[3]<=1'b1;
    end else								//Control Signals for LD, ST and RES
      cu_reg[6:4] <= opcode[2:0];
  end
  
  assign control_rod = cu_reg;      //Attaching the output wire to the control unit register

endmodule


OPCODES:
NOP : 0000
ADD : 0001
MUL : 0010
XOR : 0100
INC : 0011
CMP : 0110
BEQ : 1011
JMP : 1111
LD  : 1101
ST  : 1010
RES : 1100

Control Rod (Bits):
0-2 for ALU
3 for BEQ
4 for ReadMem
5 for MemWrite
6 for RegWrite
7 for JMP
