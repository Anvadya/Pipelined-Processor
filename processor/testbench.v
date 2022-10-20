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
reg [1:0] stalling_control_signal;
reg clk=0;

wire[8:0] Branch_Update_with_isBranch;

reg[3:0] reg_address;

initial begin
    IfOf=24'b000000000000100000000000;
    OfEx=157'd0;
    ExMa=79'd0;
    MaRw=69'd0;
end


instruction_fetch inf(
    .data_stall(data_stall),
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
    .OF_output(OF_output)
    );

reg[156:0] OfEx; // OF/EX Register

always @(posedge clk) begin
#0.5;
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
always @(posedge clk) begin
    #0.5;
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

reg data_stall;
reg control_stall;
reg [3:0] opcode;

//Stalling Unit 

always @(posedge clk) begin
    // #0.5;
    // OfEx = OF_output;
    control_stall=0;
    data_stall = 0;
    stalling_control_signal=0;
    opcode = IfOf [11:8];
    if (!opcode[3]) begin
        stalling_control_signal[1]=1; 
        if(!(opcode[1]&opcode[0]))
            stalling_control_signal[0]=1;
    end
    else if (!(opcode[0]&opcode[1])) begin
        if (opcode[1])
            stalling_control_signal[1]=1; 
    end
    if (stalling_control_signal[1]==1) begin
        if (OfEx[6]==1 && OfEx[156:153]==IfOf[15:12]) begin
            data_stall = 1;
            $display("1");
        end
        else if (ExMa[74]==1 && ExMa[78:75]==IfOf[15:12])  begin
            data_stall = 1;
            $display("2");
        end
        else if (MaRw[68]==1 && MaRw[67:64]==IfOf[15:12]) begin
            data_stall = 1;
            $display("3");
        end
    end
    if (stalling_control_signal[0]==1) begin
        if (OfEx[6]==1 && OfEx[156:153]==IfOf[19:16])  begin
            data_stall = 1;
            $display("4");
        end
        else if (ExMa[74]==1 && ExMa[78:75]==IfOf[19:16]) begin
            data_stall = 1;
            $display("5");
        end
        else if (MaRw[68]==1 && MaRw[67:64]==IfOf[19:16]) begin
            data_stall = 1;
            $display("6");
        end
    end
    if(opcode == 4'b1011) begin
        if (OfEx[6]==1 && OfEx[156:153]==4'b1111)  begin
            data_stall = 1;
            $display("7");
        end
        else if (ExMa[74]==1 && ExMa[78:75]==4'b1111) begin
            data_stall = 1;
            $display("8");
        end
        else if (MaRw[68]==1 && MaRw[67:64]==4'b1111) begin
            data_stall = 1;
            $display("9");
        end
    end

    #2;
    if(Branching[8]) begin
        control_stall = 1;
    end

    // #2;
    // if(Branching[8]) begin
    //     OfEx = 157'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
    //     IfOf = 24'b000000000000100000001000;
        
    // end
end

reg [23:0] prev_IfOf;

always @(negedge clk) begin
    // if(!Branching[8]) begin
    if(data_stall) begin
        // Branching[8] = 1;
        // Branching[7:0] = IfOf[7:0];
        IfOf = prev_IfOf;
        OfEx = 157'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
//dekh le syntax Tejas upar wale line ka, neeche wala ka bhi kr hi le; this should conclude data stalling
    end
    // $display("if %b",IfOf);

    //Starting control hazard stalling code
    //I want this lower code to run after the upper code as control hazard condition will supercede the data hazard condition
    // yaha yeh variable pr check lagana theek hai?
    // if(Branch_Update_with_isBranch[8]) begin
    //     OfEx = 157'b1111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000010000000;
    //     IfOf = 24'b000000000000100000001000;
    // end
    //Solve the compile error,line 152 and 162
    // end
    if(control_stall) begin
        IfOf = 24'b000000000000100000000000;
        OfEx = 157'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
    end
    prev_IfOf = IfOf;
end

// always @(negedge data_stall) begin
//     Branching[8]=1;
//     Branching[7:0]=IfOf[7:0]+2;
// end
always @(posedge clk) begin
$display("IF Output : %b",IfOf);
$display("OF Output : %b",OfEx);
$display("Ex Output : %b",ExMa);
$display("Ma Output : %b",MaRw);
// $display("PC Output : %b",Branching);
    // $display(÷)
end

initial begin
    $dumpfile("ifofexmawb.vcd");
    $dumpvars(0,clk,control_stall,data_stall,of.OF_output,of.IF_output_reg,stalling_control_signal,prev_IfOf,OfEx,Branching,IfOf,inf.Program_Counter);
    for (integer i=0;i<16;i++) $dumpvars(0,registers[i]);
    clk=0;
    for (integer i=0;i<900;i++) begin
        #10 clk=~clk;
    end
end


endmodule
//OF Output : 1111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110000000
