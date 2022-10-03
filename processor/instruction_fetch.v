`include "instruction_memory.v"
module instruction_fetch(
    input wire[7:0] Branch_Update,  //Input received from Execution Unit
    input wire is_Branch,  //Input received from Control Unit
    input wire clk,     //Clock wire

    output wire[23:0] IF_output
);
    wire[7:0] Address_Bus;
    wire[15:0] Data_Bus;
    reg[7:0] Program_Counter;
    reg[7:0] Plus_4;
    
    initial Program_Counter=8'd0;
    initial Plus_4=8'd1;    //Add according to convention of Assembler
    
    always @(posedge clk) begin
        if(is_Branch) begin
            Program_Counter<=Branch_Update;
        end
        else begin
            Program_Counter<=Program_Counter+Plus_4;
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


// module IF_tb();
//     reg[7:0] Branch_Update;
//     reg is_Branch;
//     wire[15:0] Data_Bus;
//     wire[7:0] Address_Bus;
//     wire[23:0] IF_output;
//     reg clk=0;

//     InstructionFetch InFt(
//         .Branch_Update(Branch_Update),
//         .is_Branch(is_Branch),
//         .clk(clk),
//         .IF_output(IF_output)
//         );

//     assign Address_Bus[7:0]=IF_output[7:0];
//     assign Data_Bus[15:0]=IF_output[23:8];

//     initial begin
//         $dumpfile("IF_tb.vcd");
//         $dumpvars(0,IF_tb);
//         clk=0;
//         is_Branch=0;
//         Branch_Update=4;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         is_Branch=1;
//         #10;
//         clk=1;
//         #10;
//         is_Branch=0;
//         clk=0;
//         #10;
//         clk=1;
//     end
// endmodule


//******************************************************************************************************************************
//InstructionMemory.txt for test case

// 0000000000001111
// 0000000011110000
// 0000111100001111
// 0000000011111111
// 0000111100000000
// 0000000000000111
// 0000000000001110
// 0111000011110001
// 0000111100001011