module alu(
  input wire [156:0] OF_output,

  // input wire [7:0] control_signals_in,
  // input wire [3:0] PC,
  // input wire [63:0] op1,
  // input wire [63:0] op2,
  // input wire        flag,
  // input wire [7:0] address_in,
  // input wire [3:0] reg_to_be_written_in,

  input wire clk,
  // input [7:0] PC,
  // input [7:0] control_signals_in,
  // input [63:0] op1,op2,
  // input [7:0] address_in,
  // input [3:0] reg_to_be_written_in,
  // input flag,
  output wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite,
  output wire [8:0] BranchPC_with_isBranch
  // output wire [7:0] BranchPC,
  // output wire [0:0] isBranchTaken

  // output reg [7:0] control_signals_out,
  // output reg [63:0] value_to_be_written,
  // output reg [7:0] address_out,
  // output reg [3:0] reg_to_be_written_out,
  // output reg [7:0] BranchPC,
  // output reg isBranchTaken,
  );
  reg [7:0] control_signals_in;
  wire [7:0] PC;
  wire [63:0] op1;
  wire [63:0] op2;
  wire        flag;
  wire [7:0] address_in;
  wire [3:0] reg_to_be_written_in;

// 00111111  00000011 0000000000000000000000000000000000000000000000000000000000000011 0000000000000000000000000000000000000000000000000000000000000001 0 11111100 1101
// 1101 11111100 0 0000000000000000000000000000000000000000000000000000000000000001 0000000000000000000000000000000000000000000000000000000000000011 00000011 11111001
// 0011111100000011000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000010111111101101
  // assign BranchPC[7:0] = BranchPC_with_isBranch [7:0];
  // assign isBranchTaken [0:0]  = BranchPC_with_isBranch [8:8];
  assign PC [7:0] = OF_output[15:8];
  assign op1 [63:0] = OF_output[79:16];
  assign op2 [63:0] = OF_output[143:80];
  assign flag = OF_output[144:144];
  assign address_in [7:0] = OF_output[152:145];
  assign reg_to_be_written_in [3:0] = OF_output[156:153];

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
  always @(posedge clk) begin
    control_signals_in [7:0] = OF_output[7:0];
    ismemwrite = control_signals_in[5];
    opcode [2:0] = control_signals_in[2:0];
    is_branch_taken = ((control_signals_in[3] & flag) | control_signals_in[7]) ;    control_signals_out [7:0] = control_signals_in[7:0];
    if(is_branch_taken) begin
      // $display("EX says branch lo");
    end
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
    // case (opcode)
    //   3'b001: value_to_be_written = add;
    //   3'b010: value_to_be_written = mul;
    //   3'b100: value_to_be_written = XOR;
    //   3'b011: value_to_be_written = inc;
    //   3'b110: value_to_be_written = cmp;      
    // endcase
  end
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [7:0] = address_out [7:0];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [71:8] = value_to_be_written [63:0];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [74:72] = control_signals_in[6:4];
  assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite [78:75] = reg_to_be_written_out [3:0];
  assign BranchPC_with_isBranch [7:0] = branch_pc [7:0];
  assign BranchPC_with_isBranch [8:8] = is_branch_taken;
endmodule