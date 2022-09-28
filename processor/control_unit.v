module control_unit(
  input wire [3:0]   opcode   			  // First four bits of the instruction
  input              clk,                 // Clock
  
  output wire [8:0]  control_rod          // Set of all control signals 
);
  
  always @(*) begin
    control_rod[8:0]	<= 9'b000000000;	//Set all the bits of the control_rod to 0
    if(!opcode[3])
      assign control_rod[2:0] = opcode[2:0];		//Conrol_signals for ALU operations
    else if(opcode[0]&opcode[1]) begin		//Control Signals for BEQ and JMP
      if(opcode[2]) 
        assign control_rod[8] = 1'b1;
      else
        assign control_rod[4] = 1'b1;
    end else								//Control Signals for LD, ST and RES
      assign control_rod[7:5] = opcode[2:0];
  end
end module 									//control_unit
  
