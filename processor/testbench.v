`include "register_write.v"
`include "memory_access.v"
`include "instruction_fetch.v"
`include "operand_fetch.v"
`include "register_file.v"
`include "alu.v"
//We have included the required modules

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


//Temporary wires to store the output from various modules(they are passed to the appropriate module)
wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite;
wire[68:0] reg_address_and_Value_with_is_write;
wire[23:0] IF_output;
wire[156:0] OF_output;
reg [1:0] stalling_control_signal;
reg clk=0;
wire[8:0] Branch_Update_with_isBranch;
reg[3:0] reg_address;


//Initialising the various stages of the pipeline
initial begin
    IfOf=24'b000000000000100000000000;
    OfEx=157'd0;
    ExMa=79'd0;
    MaRw=69'd0;
end


//Creating the various modules of the pipeline
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
    #0.5; //The Delay was necessary to allow the value to be updated by OF before being used by EX
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


//<--------------Stalling Unit------------------->

//Creating the registers required for the stalling unit
reg data_stall;
reg control_stall;
reg [3:0] opcode;

always @(posedge clk) begin
    //Reseting the hazard signals at the begining of each new cycle
    control_stall=0;
    data_stall = 0;
    stalling_control_signal=0;

    //Generating the signals required to determine whether a data hazard exists
    opcode = IfOf [11:8]; //This is the opcode which will be processed by the OF in the current cycle

    if (!opcode[3]) begin
        stalling_control_signal[1]=1; 
        if(!(opcode[1]&opcode[0]))
            stalling_control_signal[0]=1;
    end
    else if (!(opcode[0]&opcode[1])) begin
        if (opcode[1])
            stalling_control_signal[1]=1; 
    end


    //Determining whether a data hazard occurs

    //Condition 1
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

    //Condition 2
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

    //Condition 3
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


    //Determining whether a control hazard occurs
    #2;
    //Control hazard occurs if branching has to be done, this is the confition being checked below
    if(Branching[8]) begin
        control_stall = 1;
    end
end


//This is required for handling data haazards, as the same value of IF-OF register has to be provided again, 
//hence the value is stored in a temporary register and looped back to IF-OF reg if a data hazard occurs
reg [23:0] prev_IfOf;


//We do updations at negative edge to avoid race conditions
always @(negedge clk) begin
    //Dealing with data stalls
    if(data_stall) begin
        IfOf = prev_IfOf;
        OfEx = 157'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
    end

    //Dealing with control stalls
    if(control_stall) begin
        IfOf = 24'b000000000000100000000000;
        OfEx = 157'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
    end
    prev_IfOf = IfOf;
end




//Code which can be used for debugging
// always @(posedge clk) begin
// $display("IF Output : %b",IfOf);
// $display("OF Output : %b",OfEx);
// $display("Ex Output : %b",ExMa);
// $display("Ma Output : %b",MaRw);
// // $display("PC Output : %b",Branching);
//     // $display(÷)
// end




//<------Code for setting up and starting the simulation---------->
initial begin
    $dumpfile("ifofexmawb.vcd"); //The name of the vcd file
    $dumpvars(0,clk);
    for (integer i=0;i<16;i++) $dumpvars(0,registers[i]);
    clk=0;
    for (integer i=0;i<900;i++) begin
        #10 clk=~clk;
    end
end


endmodule


//Lines useful for debugging:
    // $dumpvars(0,clk,control_stall,data_stall,of.OF_output,of.IF_output_reg,stalling_control_signal,prev_IfOf,OfEx,Branching,IfOf,inf.Program_Counter);
