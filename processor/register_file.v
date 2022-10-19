module register_file (
    input wire [3:0]   reg1_read_address,   // Input address of the 1st register    
    input wire [3:0]   reg2_read_address,   // Input address of the 2nd register
    input wire [3:0]   write_port_address,  // Input address of the write register            
    input wire[63:0]   write_data,          // Input of Data what to write     
    input wire [0:0]   is_write,            // Control unit signal ; write or not    
    input              clk,                      // Clock                    

    output wire [63:0] reg1_data,         // Output of the 1st read register
    output wire [63:0] reg2_data,         // Output of the 2nd read register
    output wire [0:0]  flag                // Output of the flag 
);


reg [63:0] reg1_data_temp;
reg [63:0] reg2_data_temp;
// writing back to the register if is_write = 1

always @(posedge clk) begin
    reg1_data_temp = ifofexmawb.registers[reg1_read_address];
    reg2_data_temp = ifofexmawb.registers[reg2_read_address];
    if (is_write) begin
        ifofexmawb.registers[write_port_address] = write_data;
    end
end

// Loading the outputs in the wires
assign flag = ifofexmawb.registers[15][0:0];
assign reg1_data = reg1_data_temp;
assign reg2_data = reg2_data_temp;

endmodule //register_file