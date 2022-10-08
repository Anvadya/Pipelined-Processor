`include "control_unit.v"
`include "register_file.v"

module operand_fetch(
    input wire [3:0] pc,            // Program Counter
    input wire [15:0] instruction,  // Instruction from instruction memory
    input wire [3:0] write_port_address,
    input wire [63:0] write_data,
    input wire [0:0] is_write,
    input wire [0:0] is_math,
    input wire clk,

    output wire [7:0] control_rod,
    output wire [3:0] PC,
    output wire [63:0] register_read1,
    output wire [63:0] register_read2,
    output wire        flag,
    output wire [7:0] address,
    output wire [3:0] reg_to_be_written
);

wire [7:0] Control_rod;
wire [63:0] reg1_data;
wire [63:0] reg2_data;
wire [0:0] Flag;
reg [3:0] register_to_be_written;

control_unit cu (instruction[3:0], clk, Control_rod);
register_file reg_file (instruction[7:4], instruction[11:8], write_port_address, write_data, is_write, clk, reg1_data, reg2_data, Flag);

always @(posedge clk) begin
    register_to_be_written = instruction[7:4];
    if (is_math) begin
        register_to_be_written = instruction[15:12];
    end
end

assign control_rod = Control_rod;
assign PC = pc;
assign register_read1 = reg1_data;
assign register_read2 = reg2_data;
assign Flag = flag;
assign address = instruction[15:8];
assign reg_to_be_written = register_to_be_written;


endmodule