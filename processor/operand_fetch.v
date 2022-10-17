`include "control_unit.v"
`include "register_file.v"

module operand_fetch(
    input wire [23:0] IF_output,       
    input wire clk,
    output wire [1:0] stalling_control_signal,
    output wire [156:0] OF_output      // control_rod (8 bit), PC(8 bit), reg1_data(64 bit), reg2_data(64 bit), flag(1 bit), address(8 bit), reg_write_address(4 bit)
);

//  OUTPUT DATA
wire [9:0] Control_rod;
wire [63:0] reg1_data;
wire [63:0] reg2_data;
wire [0:0] Flag;
reg [3:0] register_to_be_written;

//   GIVING REDUNDENT DATA AS INPUT IN CASE OF REGISTER WRITE
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
//  END OF ASSIGNING REDUNDANT DATA 

// Generating Control Signals
control_unit cu (IF_output[11:8], Control_rod);
// Invoking register file
register_file reg_file (IF_output[15:12], IF_output[19:16], write_port_address_wire, write_data_wire, is_write_wire, clk, reg1_data, reg2_data, Flag);

// MUX for the selection of write-back address
always @(posedge clk) begin
    register_to_be_written = IF_output[15:12];
    if ((Control_rod[0]|Control_rod[1]|Control_rod[2])&&!(Control_rod == 10'b1001000011)) begin
        register_to_be_written = IF_output[23:20];
    end
end

// ASSIGNING OUTPUTS
assign OF_output[7:0] = Control_rod[7:0];                   // Control Rod
assign OF_output[15:8] = IF_output[7:0];                    // Program Counter
assign OF_output[79:16] = reg1_data;                        // Register-1 read data
assign OF_output[143:80] = reg2_data;                       // Register-2 read data
assign OF_output[144] = Flag;                               // Flag
assign OF_output[152:145] = IF_output[23:16];               // Address in case of LW/SW instruction
assign OF_output[156:153] = register_to_be_written;         // Address of register to be written in write-back
assign stalling_control_signal[1:0] = Control_rod[9:8];     // Control signal needed for Stalling

endmodule