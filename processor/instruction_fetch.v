//Instruction Fetch Unit

//Input: Branch_Update[first 8 bits], isBranch[last 1 bit] , clock wire
//Output: IF_Output consisting of Address(7:0)[8 bits] and Data(23:8)[16 bits] for 24 bit output


`include "instruction_memory.v"
module instruction_fetch(
    input wire[8:0] Branch_Update_with_isBranch,  //Input received from Execution Unit [Main Wire for Input]

    input wire clk,     //Clock wire

    output wire[23:0] IF_output //Main Output Wire
);
    wire[7:0] Address_Bus;
    wire[15:0] Data_Bus;
    wire[0:0] is_Branch;
    reg[7:0] Program_Counter;
    reg[7:0] Plus_4;
    
    initial Program_Counter=8'd0;
    initial Plus_4=8'd1;
    
    assign is_Branch[0:0]=Branch_Update_with_isBranch[8:8];

    always @(posedge clk) begin
        if(is_Branch[0:0]) begin
            Program_Counter =Branch_Update_with_isBranch[7:0];
        end
        else begin
            Program_Counter =Program_Counter+Plus_4;
        end
    end
    
    assign Address_Bus=Program_Counter;

    instruction_memory IM(
        .pc(Address_Bus),
        .instruction(Data_Bus)
    );

    assign IF_output[7:0]=Address_Bus[7:0];
    assign IF_output[23:8]=Data_Bus[15:0];

endmodule

//*****************************************************************************************************************************************

//Instruction Fetch TestBench

// `timescale 1ns / 1ns
// `include "instruction_fetch.v"


// module if_tb();
//     reg[8:0] Branch_Update_with_isBranch;
//     wire[15:0] Data_Bus;
//     wire[7:0] Address_Bus;
//     wire[23:0] IF_output;
//     reg clk=0;

//     instruction_fetch InFt(
//         .Branch_Update_with_isBranch(Branch_Update_with_isBranch),
//         .clk(clk),
//         .IF_output(IF_output)
//         );

//     assign Address_Bus[7:0]=IF_output[7:0];
//     assign Data_Bus[15:0]=IF_output[23:8];

//     initial begin
//         $dumpfile("if_tb.vcd");
//         $dumpvars(0,if_tb);
//         clk=0;
//         Branch_Update_with_isBranch=9'b000000000;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         Branch_Update_with_isBranch=9'b100000100;
//         #10;
//         clk=1;
//         #10;
        
//         clk=0;
//         #10;
//         clk=1;
//     end

// endmodule


//******************************************************************************************************************************
//InstructionMemory.txt for test case

// 010100000001001001010000010100100101000000010110010100000001001101010000000111110101000000010011