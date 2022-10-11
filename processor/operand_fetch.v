`include "control_unit.v"
`include "register_file.v"

module operand_fetch(
    // input wire [3:0] pc,            // Program Counter
    // input wire [15:0] instruction,  // Instruction from instruction memory
    // input wire [3:0] write_port_address,
    input wire [23:0] IF_output,       
    // input wire [63:0] write_data,
    input wire clk,

    // output wire [7:0] control_rod,
    // output wire [7:0] PC,
    // output wire [63:0] register_read1,
    // output wire [63:0] register_read2,
    // output wire        flag,
    // output wire [7:0] address,
    // output wire [3:0] reg_to_be_written
    output wire [156:0] OF_output      // control_rod (8 bit), PC(8 bit), reg1_data(64 bit), reg2_data(64 bit), flag(1 bit), address(8 bit), reg_write_address(4 bit)
);

wire [7:0] Control_rod;
wire [63:0] reg1_data;
wire [63:0] reg2_data;
wire [0:0] Flag;
reg [3:0] register_to_be_written;

reg [63:0] write_data;
reg [3:0] write_port_address;
reg is_write;

initial write_data = 64'd0;
initial write_port_address = 4'd0;
initial is_write = 1'b0;

wire [63:0] write_data_wire;
wire [3:0] write_port_address_wire;
wire is_write_wire;

assign write_data_wire = write_data;
assign write_port_address_wire = write_port_address;
assign is_write_wire = is_write;

control_unit cu (IF_output[11:8], Control_rod);
register_file reg_file (IF_output[15:12], IF_output[19:16], write_port_address_wire, write_data_wire, is_write_wire, clk, reg1_data, reg2_data, Flag);

always @(posedge clk) begin
    register_to_be_written = IF_output[15:12];
    if (Control_rod[0]|Control_rod[1]|Control_rod[2]) begin
        register_to_be_written = IF_output[23:20];
    end
end

// assign control_rod = Control_rod;
// assign PC = pc;
// assign register_read1 = reg1_data;
// assign register_read2 = reg2_data;
// assign Flag = flag;
// assign address = instruction[23:16];
// assign reg_to_be_written = register_to_be_written;

assign OF_output[7:0] = Control_rod;
assign OF_output[15:8] = IF_output[7:0];
assign OF_output[79:16] = reg1_data;
assign OF_output[143:80] = reg2_data;
assign OF_output[144] = Flag;
assign OF_output[152:145] = IF_output[23:16];
assign OF_output[156:153] = register_to_be_written;

endmodule