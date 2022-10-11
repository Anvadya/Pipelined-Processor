//This is the TestBench for Integrating MA and WB units
//Required Modules: memory_access.v,register_write.v,data_memory.v,register_file.v

`include "register_write.v"
`include "memory_access.v"

module mawb();

wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
wire[68:0] reg_address_and_Value_with_is_write;
reg clk=0;

reg[7:0] Address;
reg[63:0] Value;

reg[0:0] isWrite;
reg[0:0] isLoad;
reg[0:0] isMemWrite;

reg[3:0] reg_address;

assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[7:0]=Address[7:0];
assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[71:8]=Value[63:0];
assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[75:72]=reg_address[3:0];
assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[76:76]=isLoad[0:0];
assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[77:77]=isMemWrite[0:0];
assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[78:78]=isWrite[0:0];

memory_access ma(
    .clk(clk),
    .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
    .write(reg_address_and_Value_with_is_write)
);

reg[68:0] MaRw;

always @(*) begin
MaRw<=reg_address_and_Value_with_is_write;
end

register_write rw(
    .clk(clk),
    .reg_address_and_Value_with_is_write(MaRw)
);

initial begin
    $dumpfile("mawb.vcd");
    $dumpvars(0,mawb);
    clk=0;
    Address=8'b00010001;
    Value=64'd5;
    reg_address=4'b0110;
    isLoad=1'b0;
    isMemWrite=1'b0;
    isWrite=1'b1;
    #10;
    clk=1;
    #10;
    Address=8'b00000000;
    Value=64'd0;
    reg_address=4'b000;
    isLoad=1'b0;
    isMemWrite=1'b0;
    isWrite=1'b0;
    clk=0;
    #10;
    clk=1;
    #10;
    Address=8'b00000010;
    Value=64'd3;
    reg_address=4'b010;
    isLoad=1'b0;
    isMemWrite=1'b1;
    isWrite=1'b0;
    clk=0;
    #10;
    clk=1;
    #10;
    clk=0;
    #10;
    clk=1;
    #10;
    clk=0;
    #10;
end

endmodule