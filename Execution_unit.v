module Execution_unit(
  input [7:0] PC,
  input [7:0] control_signals_in,
  input [63:0] op1,op2,
  input [7:0] address_in,
  input [3:0] reg_to_be_written_in,
  input flag,

  output reg [7:0] control_signals_out,
  output reg [63:0] value_to_be_written,
  output reg [7:0] address_out,
  output reg [3:0] reg_to_be_written_out,
  output reg [7:0] BranchPC,
  output reg isBranchTaken,
  clk
  );
  reg [63:0] inc,add,mul,XOR,cmp;
  reg[2:0] opcode;
  always @(posedge clk) begin
    opcode <= control_signals_in[2:0];
    isBranchTaken <= ((control_signals_in[3] && flag) || control_signals_in[7]) ;
    control_signals_out [7:0] <= control_signals_in[7:0];
    address_out [7:0] <= address_in [7:0];
    reg_to_be_written_out [3:0] <= reg_to_be_written_in [3:0];
    BranchPC [7:0] <= (PC [7:0] + address_in [7:0]);
    inc <= (op1 [63:0] + 64'b0000000000000000000000000000000000000000000000000000000000000001);
    add <= (op1 [63:0] + op2 [63:0]);
    mul <= (op1 [63:0] * op2 [63:0]);
    XOR <= (op1 [63:0] ^ op2 [63:0]);
    if (XOR == 64'b0000000000000000000000000000000000000000000000000000000000000000) begin
      cmp = 64'b0000000000000000000000000000000000000000000000000000000000000001;
    end
    else cmp = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    
    case (opcode)
      3'b001: value_to_be_written = add;
      3'b010: value_to_be_written = mul;
      3'b100: value_to_be_written = XOR;
      3'b011: value_to_be_written = inc;
      3'b110: value_to_be_written = cmp;
      default: value_to_be_written = 0;
    endcase
  end
endmodule

// module tb();
//   input [7:0] tb_PC,
//   input [2:0] control_signals_in,
//   input [63:0] op1,op2,
//   input [7:0] address_in,
//   input [3:0] reg_to_be_written_in,
//   input flag,

//   output reg [1:0] control_signals_out,
//   output reg [63:0] value_to_be_written,
//   output reg [7:0] address_out,
//   output reg [3:0] reg_to_be_written_out,
//   output reg [7:0] BranchPC,
  
    
    
//     control_unit cu(
//       .PC(tb_PC),
//       .control_rod(tb_control_rod,
//       .clk(clk)
//     );
//       initial begin
//         tb_opcode=4'b0111; #10;
        
//       end
// endmodule
