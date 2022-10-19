//This is the Register Write-Back Unit

//Input : Value[64 bits],Register Address[next 4 bits], is_write[next 1 bit] {total 69 bits}, clk
//Child Module: Register File

// `include "register_file.v"
module register_write(
    input wire[68:0] reg_address_and_Value_with_is_write,
    input wire clk
);
reg [3:0] reg_address;
reg [63:0] value;
reg [0:0] is_write;

register_file rf(.clk(clk),.write_data(value),.is_write(is_write),.write_port_address(reg_address));

always @(posedge clk) begin
    #1;
    reg_address[3:0]=reg_address_and_Value_with_is_write[67:64];
    value[63:0]=reg_address_and_Value_with_is_write[63:0];
    is_write[0:0]=reg_address_and_Value_with_is_write[68:68];
end


endmodule

//This is the Test bench for WriteBack

// `include "register_write.v"
// module rw_tb();

// reg[3:0] reg_address;
// reg[63:0] value;
// reg[0:0] is_write;
// reg clk=0;

// wire[68:0] reg_address_and_Value_with_is_write;

// assign reg_address_and_Value_with_is_write[67:64]=reg_address[3:0];
// assign reg_address_and_Value_with_is_write[63:0]=value[63:0];
// assign reg_address_and_Value_with_is_write[68:68]=is_write[0:0];

// register_write rl(.reg_address_and_Value_with_is_write(reg_address_and_Value_with_is_write),.clk(clk));

// initial begin

//     $dumpfile("rw_tb.vcd");
//     $dumpvars(0,rw_tb);

//     reg_address=4'd6;
//     value=64'd50;
//     is_write=1'b1;
//     clk=0;
//     #10;
//     clk=1;
//     #10;
//     clk=0;
//     is_write=1'b1;
//     #10;
//     clk=1;
//     is_write=1'b0;
//     value=64'd25;
//     #10;
//     clk=0;
//     reg_address=4'd3;
//     #10;
//     clk=1;
//     #10;
//     clk=0;
// end

// endmodule