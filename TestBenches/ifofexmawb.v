`include "register_write.v"
`include "memory_access.v"
`include "instruction_fetch.v"
`include "operand_fetch.v"
`include "register_file.v"
`include "alu.v"

module ifofexmawb();

wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
wire[68:0] reg_address_and_Value_with_is_write;
wire[23:0] IF_output;
wire[156:0] OF_output;
wire[1:0] stalling_control_signal;
reg clk=0;

wire[8:0] Branch_Update_with_isBranch;

reg[3:0] reg_address;

initial begin
    IfOf=24'd0;
    OfEx=157'd0;
    ExMa=79'd0;
    MaRw=69'd0;
end


instruction_fetch inf(
    .clk(clk),
    .Branch_Update_with_isBranch(Branch_Update_with_isBranch),
    .IF_output(IF_output)
);

reg[23:0] IfOf; // IF/OF Register

always @(*) begin
IfOf<=IF_output;
end

operand_fetch of(
    .clk(clk),
    .IF_output(IfOf),
    .OF_output(OF_output),
    .stalling_control_signal(stalling_control_signal)
    );

reg[156:0] OfEx; // OF/EX Register

always @(*) begin
OfEx<=OF_output;
end

always @(posedge clk) begin
$display("OF Output : ",OF_output);
end

alu al(
    .clk(clk),
    .OF_output(OfEx),
    .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
    .BranchPC_with_isBranch(Branch_Update_with_isBranch)
);

reg[78:0] ExMa; // EX/MA Register

always @(*) begin
ExMa<=Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
end

memory_access ma(
    .clk(clk),
    .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(ExMa),
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
    $dumpfile("ifofexmawb.vcd");
    $dumpvars(0,ifofexmawb);
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
    clk=1;
    #10;
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
    clk=1;
    #10;
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
    clk=1;
    #10;
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
    clk=1;
    #10;
    clk=0;
    #10;
end

endmodule