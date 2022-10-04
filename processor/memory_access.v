//This is the Actual Memory Access Unit

//Input : Address(7:0)[8 bits] and Value(71:8)[64 bits] for operation, clock, isLoad MUX selector, isMemWrite MUX selector
//Output: Value after operation from MA unit
//Files required: Data Memory file

`include "data_memory.v"
module memory_access(
    input wire[79:0] Address_and_Value_with_ControlRod, //From OF/EX Register

    input wire clk, //Clock Wire

    output wire[63:0] write
);
wire[7:0] Address;
wire[63:0] Value;
wire[0:0] isLoad;
wire[0:0] isMemWrite;

assign Address[7:0]=Address_and_Value_with_ControlRod[7:0];
assign Value[63:0]=Address_and_Value_with_ControlRod[71:8];
assign isLoad[0:0]=Address_and_Value_with_ControlRod[76:76];
assign isMemWrite[0:0]=Address_and_Value_with_ControlRod[77:77];

wire[63:0] DMoutput;
reg[63:0] Temp_reg_for_wb_value=64'b0000000000000000000000000000000000000000000000000000000000000000;

data_memory DM(.memaddress(Address),.inputdata(Value),.ismemwrite(isMemWrite),.outputdata(DMoutput));

always @(posedge clk) begin
    if(isLoad) begin
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
//     reg[7:0] Address=8'b00000000;
//     reg[63:0] Value=64'b0000000000000000000000000000000000000000000000000000000000001001;

//     reg clk=1;
//     wire[0:0] isLoad=0;
//     wire[63:0] write;
//     wire[0:0] isMemWrite=0;
//     reg[71:0] Address_and_Value;     
//     initial begin
//     Address_and_Value[7:0]=Address[7:0];
//     Address_and_Value[71:8]=Value[63:0];
//     end
//     
//     memory_access MAU(
//         .Address(Address),
//         .Value(Value),
//         .clk(clk),
//         .isLoad(isLoad),
//         .isMemWrite(isMemWrite),

//         .write(write)
//     );

//     initial begin
//         $dumpfile("MA_tb.vcd");
//         $dumpvars(0,MA_tb);
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

// *****************************************************************************************

// Sample Data_Memory.txt

// 0000000000000000000000000000000000000000000000000000000000000001
// 0000000000000000000000000000000000000000000000000000000000001111
// 0000000000000000000000000000000000000000000000000000000000000011
// 0000000000000000000000000000000000000000000000000000000000000111
// 0000000000000000000000000000000000000000000000000000000000000010
// 0000000000000000000000000000000000000000000000000000000000100001
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000