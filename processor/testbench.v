`include "register_write.v"
`include "memory_access.v"
`include "instruction_fetch.v"
`include "operand_fetch.v"
`include "register_file.v"
`include "alu.v"

module ifofexmawb();

reg [63:0] registers [15:0];              // 16 registers of 64 bit , Index[0 to 14] => General purpose registers , Index[15] => flag register

initial begin
    // Initializing the value of the registers to be equal to 0
    registers[0] = 64'd0;
    registers[1] = 64'd1;
    registers[2] = 64'd2;
    registers[3] = 64'd2;
    registers[4] = 64'd4;
    registers[5] = 64'd5;
    registers[6] = 64'd6;
    registers[7] = 64'd7;
    registers[8] = 64'd8;
    registers[9] = 64'd0;
    registers[10] = 64'd0;
    registers[11] = 64'd0;
    registers[12] = 64'd0;
    registers[13] = 64'd0;
    registers[14] = 64'd0;
    registers[15] = 64'd0;
end

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
    .Branch_Update_with_isBranch(Branching),
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

alu al(
    .clk(clk),
    .OF_output(OfEx),
    .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
    .BranchPC_with_isBranch(Branch_Update_with_isBranch)
);

reg[78:0] ExMa; // EX/MA Register
reg[8:0] Branching;
always @(*) begin
    ExMa<=Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
    Branching<=Branch_Update_with_isBranch;
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

always @(posedge clk) begin
$display("IF Output : %b",IfOf);
$display("OF Output : %b",OfEx);
$display("Ex Output : %b",ExMa);
$display("Ma Output : %b",MaRw);
$display("PC Output : %b",Branching);
end

initial begin
    $dumpfile("ifofexmawb.vcd");
    $dumpvars(0,clk);
    for (integer i=0;i<16;i++) $dumpvars(0,registers[i]);
    clk=0;
    for (integer i=0;i<900;i++) begin
        #10 clk=~clk;
    end
end


endmodule
//OF Output : 1111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110000000
