module alu(
  input wire [156:0] OF_output, // input taken from OF-EX register
  input wire clk,
  
  output wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite, // output for EX-MA register
  output wire [8:0] BranchPC_with_isBranch // output for IF (whether to go for branching)
  );

  // registers for breakdown of input into required parts
  
  reg [7:0] control_signals_in;
  wire [7:0] PC;
  wire [63:0] op1;
  wire [63:0] op2;
  wire        flag;
  wire [7:0] address_in;
  wire [3:0] reg_to_be_written_in;

  // assigning values

  assign PC [7:0] = OF_output[15:8];
  assign op1 [63:0] = OF_output[79:16];
  assign op2 [63:0] = OF_output[143:80];
  assign flag = OF_output[144:144];
  assign address_in [7:0] = OF_output[152:145];
  assign reg_to_be_written_in [3:0] = OF_output[156:153];

  // output registers

  reg ismemwrite;
  reg [7:0] control_signals_out;
  reg [63:0] value_to_be_written;
  reg [7:0] address_out;
  reg [3:0] reg_to_be_written_out;
  reg [7:0] branch_pc;
  reg is_branch_taken;
  reg [63:0] inc,add,mul,XOR,cmp;
  reg [2:0] opcode;
  reg [8:0] temp;
  
  // main driver code
  always @(posedge clk) begin
    control_signals_in [7:0] = OF_output[7:0];
    ismemwrite = control_signals_in[5];
    opcode [2:0] = control_signals_in[2:0];
    is_branch_taken = ((control_signals_in[3] & flag) | control_signals_in[7]);    
    control_signals_out [7:0] = control_signals_in[7:0];
    address_out [7:0] = address_in [7:0];
    reg_to_be_written_out [3:0] = reg_to_be_written_in [3:0];
    temp [8:0] = (PC [7:0] + address_in [7:0]);
    branch_pc [7:0] = (temp[7:0]);
    inc = (op1 [63:0] + 64'b0000000000000000000000000000000000000000000000000000000000000001);
    add = (op1 [63:0] + op2 [63:0]);
    mul = (op1 [63:0] * op2 [63:0]);
    XOR = (op1 [63:0] ^ op2 [63:0]);
    if (XOR == 64'b0000000000000000000000000000000000000000000000000000000000000000) begin
      cmp = 64'b0000000000000000000000000000000000000000000000000000000000000001;
    end
    else cmp = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    if (opcode == 3'b001) value_to_be_written = add;
    else if (opcode == 3'b010) value_to_be_written = mul;
    else if (opcode == 3'b100) value_to_be_written = XOR;
    else if (opcode == 3'b011) value_to_be_written = inc;
    else if (opcode == 3'b110) value_to_be_written = cmp;
    else value_to_be_written = 0;
    if (ismemwrite) value_to_be_written = op1;
    
  end

  // converging output registers value to single output wire
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [7:0] = address_out [7:0];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [71:8] = value_to_be_written [63:0];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [74:72] = control_signals_in[6:4];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [78:75] = reg_to_be_written_out [3:0];
  assign BranchPC_with_isBranch [7:0] = branch_pc [7:0];
  assign BranchPC_with_isBranch [8:8] = is_branch_taken;
endmodule