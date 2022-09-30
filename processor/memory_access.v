//This is the Actual Memory Access Unit

//Input : Address in memory, Value for operation, clock, isLoad MUX selector, isMemWrite MUX selector
//Output: Value after operation from MA unit
//Files required: Data Memory file

`include "data_memory.v"
module memory_access(
    input wire[7:0] Address,
    input wire[63:0] Value,
    input wire clk, //change type as per neccessity
    input wire[0:0] isLoad,
    input wire[0:0] isMemWrite,

    output wire[63:0] write
);

wire[63:0] DMoutput;
reg[63:0] Temp_reg_for_wb_value=64'b0000000000000000000000000000000000000000000000000000000000000000;
//no need to initialize, remove later after setting clock (default value will be x)

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