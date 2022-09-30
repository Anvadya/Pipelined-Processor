//This is the Actual Memory Access Unit

`include "DataMemory.v"
module memory_access(
    input wire[7:0] Address,
    input wire[63:0] Value,
    input wire clk, //change type as per neccessity
    input wire[0:0] isLoad,

    output wire[63:0] write
);

wire[63:0] DMoutput;
reg[63:0] Temp_reg_for_wb_value=64'b0000000000000000000000000000000000000000000000000000000000000000;
//no need to initialize, remove later after setting clock (default value will be x)

data_memory DM(.Address(Address),.Value(Value),.DMoutput(DMoutput));

always @(posedge clk) begin
    if(isLoad) begin
        Temp_reg_for_wb_value<=DMoutput;
        $display("DMoutput : ",Temp_reg_for_wb_value);
    end else begin
        Temp_reg_for_wb_value<=Value;
        $display("Value : ",Temp_reg_for_wb_value);
    end
    $display("Temp register value : ",Temp_reg_for_wb_value);
end

assign write=Temp_reg_for_wb_value;

endmodule

// ****************************************************************************************

//Fake Data Memory for testing


//This is a sample Data Memory for testing purposes

// module DataMemory(
//     input wire[7:0] Address,
//     input wire[63:0] Value,

//     output wire[63:0] DMoutput
// );

// assign DMoutput=64'b0000000000000000000000000000000000000000000000000000000000001111;

// endmodule

// *****************************************************************************************



//TestBench for Memory Access Unit

//This is just a Testbench for testing Memory Access Unit

// `include "memory_access.v"
// module MA_tb();
//     wire[7:0] Address=8'b00010111;
//     wire[63:0] Value=64'b0000000000000000000000000000000000000000000000000000000000001001;

//     wire clk=1;
//     wire[0:0] isLoad=1'b1;
//     wire[63:0] write;

//     memory_access MAU(
//         .Address(Address),
//         .Value(Value),
//         .clk(clk),
//         .isLoad(isLoad),
//         .write(write)
//     );

// //SET REQUIRED CLOCK HERE

//     // initial begin
//     //     forever begin
//     //         clk = 0;
//     //         #10 clk = ~clk;
//     //     end
//     // end

// endmodule

