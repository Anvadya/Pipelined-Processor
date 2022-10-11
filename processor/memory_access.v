//This is the Actual Memory Access Unit

//Input : Address(7:0)[8 bits] and Value(71:8)[64 bits] for operation, clock, isLoad MUX selector, isMemWrite MUX selector
//Output: Value after operation from MA unit
//Files required: Data Memory file

//NOTE: The Data_Memory.txt must be consisting of total 256 lines

`include "data_memory.v"
module memory_access(
    input wire[73:0] Address_and_Value_with_isLoad_and_isMemWrite, //From OF/EX Register

    input wire clk, //Clock Wire

    output wire[63:0] write //Output Wire
);
wire[7:0] Address;
wire[63:0] Value;
wire[0:0] isLoad;
wire[0:0] isMemWrite;

assign Address[7:0]=Address_and_Value_with_isLoad_and_isMemWrite[7:0];
assign Value[63:0]=Address_and_Value_with_isLoad_and_isMemWrite[71:8];
assign isLoad[0:0]=Address_and_Value_with_isLoad_and_isMemWrite[72:72];
assign isMemWrite[0:0]=Address_and_Value_with_isLoad_and_isMemWrite[73:73];

wire[63:0] DMoutput;
reg[63:0] Temp_reg_for_wb_value=64'b0000000000000000000000000000000000000000000000000000000000000000;

data_memory DM(.memaddress(Address),.inputdata(Value),.ismemwrite(isMemWrite),.outputdata(DMoutput));

always @(posedge clk) begin
    if(isLoad[0:0]) begin
        Temp_reg_for_wb_value<=DMoutput;
    end else begin
        Temp_reg_for_wb_value<=Value;
    end
end

assign write=Temp_reg_for_wb_value;

endmodule

// *****************************************************************************************



//TestBench for Memory Access Unit

//This is just a Testbench for testing Memory Access Unit
// `include "memory_access.v"
// module MA_tb();
//     reg[7:0] Address;
//     reg[63:0] Value=64'd9;

//     reg clk=0;
//     wire[0:0] isLoad=1;
//     wire[63:0] write;
//     wire[0:0] isMemWrite=1;     
//     wire[73:0] Address_and_Value_with_isLoad_and_isMemWrite;

//     initial begin
//     Address[7:0]=8'd0;
//     end

//     assign Address_and_Value_with_isLoad_and_isMemWrite[7:0]=Address[7:0];
//     assign Address_and_Value_with_isLoad_and_isMemWrite[71:8]=Value[63:0];
//     assign Address_and_Value_with_isLoad_and_isMemWrite[72:72]=isLoad[0:0];
//     assign Address_and_Value_with_isLoad_and_isMemWrite[73:73]=isMemWrite[0:0];
    
//     memory_access MAU(
//         .Address_and_Value_with_isLoad_and_isMemWrite(Address_and_Value_with_isLoad_and_isMemWrite),
//         .write(write),
//         .clk(clk)
//     );

//     initial begin
//         $dumpfile("MA_tb.vcd");
//         $dumpvars(0,MA_tb);
//         clk=0;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         Address=8'b00000001;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         Address=8'b00000011;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         Address=8'b00000010;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         Address=8'b00000100;
//     end

// endmodule

//The Data_Memory.txt is too long to be added for sample