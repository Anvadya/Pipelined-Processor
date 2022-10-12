//This is the TestBench for Integrating IF, MA and WB units
//Required Modules: memory_access.v,register_write.v,data_memory.v,register_file.v,instruction_fetch.v,instruction_memory.v
//Other required files: Data_Memory.txt,Instruction_Memory.txt

`include "register_write.v"
`include "memory_access.v"
`include "instruction_fetch.v"

module ifmawb();

wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
wire[68:0] reg_address_and_Value_with_is_write;
wire[23:0] IF_Output;

reg clk=0;

wire[8:0] Branch_Update_with_isBranch;

reg[7:0] Branch_Update;
reg[0:0] is_Branch;

assign Branch_Update_with_isBranch[7:0]=Branch_Update[7:0];
assign Branch_Update_with_isBranch[8:8]=is_Branch[0:0];

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


instruction_fetch inf(
    .clk(clk),
    .Branch_Update_with_isBranch(Branch_Update_with_isBranch),
    .IF_output(IF_Output)
);

memory_access ma(
    .clk(clk),
    .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
    .write(reg_address_and_Value_with_is_write)
);

reg[68:0] MaRw; // MA/WB Register

always @(*) begin
MaRw<=reg_address_and_Value_with_is_write;
end

register_write rw(
    .clk(clk),
    .reg_address_and_Value_with_is_write(MaRw)
);

initial begin
    $dumpfile("ifmawb.vcd");
    $dumpvars(0,ifmawb);
    clk=0;
    Branch_Update=8'b00000111;
    Address=8'b00010001;
    Value=64'd5;
    reg_address=4'b0110;
    isLoad=1'b0;
    isMemWrite=1'b0;
    isWrite=1'b1;
    is_Branch=1'b0;
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