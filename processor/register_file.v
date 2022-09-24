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


reg [63:0] registers [15:0];              // 16 registers of 64 bit , Index[0 to 14] => General purpose registers , Index[15] => flag register

// Initializing the value of the registers to be equal to 0
initial registers[0] = 64'd0;
initial registers[1] = 64'd0;
initial registers[2] = 64'd0;
initial registers[3] = 64'd0;
initial registers[4] = 64'd0;
initial registers[5] = 64'd0;
initial registers[6] = 64'd0;
initial registers[7] = 64'd0;
initial registers[8] = 64'd0;
initial registers[9] = 64'd0;
initial registers[10] = 64'd0;
initial registers[11] = 64'd0;
initial registers[12] = 64'd0;
initial registers[13] = 64'd0;
initial registers[14] = 64'd0;
initial registers[15] = 64'd0;


// writing back to the register if is_write = 1
always @(posedge clk) begin
    if (is_write) begin
        registers[write_port_address] = write_data;
    end
end

// Loading the outputs in the wires
assign flag = registers[15][0:0];
assign reg1_data = registers[reg1_read_address];
assign reg2_data = registers[reg2_read_address];

endmodule //register_file