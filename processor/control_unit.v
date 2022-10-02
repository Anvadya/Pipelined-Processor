module pipeline(
  input  [3:0]    opcode,    			  // First four bits of the instruction
  input            clk,             // Clock
  
  output [8:0]  control_rod         // Set of all control signals 
);
  
  reg [8:0] cu_reg=9'b000000000;    // Register to store the values of the control signals
  
  always @ (posedge clk) begin
    cu_reg[8:0]	<= 9'b000000000;	  //Set all the bits of the control unit register to 0
    if(!opcode[3])
      cu_reg[2:0] <= opcode[2:0];	  //Conrol_signals for ALU operations and NOP
    else if(opcode[0]&opcode[1]) begin		//Control Signals for BEQ and JMP
      if(opcode[2]) 
        cu_reg[8]<=1'b1;
      else
        cu_reg[4]<=1'b1;
    end else								//Control Signals for LD, ST and RES
      cu_reg[7:5] <= opcode[2:0];
  end
  
  assign control_rod = cu_reg;      //Attaching the output wire to the control unit register

endmodule
