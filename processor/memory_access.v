//This is the Actual Memory Access Unit

//Input : Address(7:0)[8 bits] and Value(71:8)[64 bits] ,RegAddressTobeWritten[4 bits], isLoad,isMemWrite,isWrite[next 3 bits] 
//Output: Value after operation from MA unit[64 bits] and RegAddresstoBeWritten [next 4 bits]

//Files required: Data Memory file

//NOTE: The Data_Memory.txt must be consisting of total 256 lines

`include "data_memory.v"
module memory_access(
    input wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite, 
    //From OF/EX Register

    input wire clk, //Clock Wire

    output wire[68:0] write //Output Wire
);
wire[7:0] Address;
wire[63:0] Value;
wire[0:0] isLoad;
wire[0:0] isMemWrite;
reg [3:0] Reg_to_be_written;
wire[0:0] isWrite;
reg [0:0] isWritetemp;

assign Address[7:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[7:0]; //8 bits
assign Value[63:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[71:8]; //64 bits
assign isLoad[0:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[72:72]; // 1 bit
assign isMemWrite[0:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[73:73]; // 1 bit
assign isWrite[0:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[74:74]; // 1 bit

wire[63:0] DMoutput;
reg[63:0] Temp_reg_for_wb_value;

data_memory DM(.memaddress(Address),.inputdata(Value),.ismemwrite(isMemWrite),.outputdata(DMoutput));

always @(posedge clk) begin
    isWritetemp = isWrite;
    Reg_to_be_written[3:0]=Address_Value_RegAddress_isLoad_isMemWrite_isWrite[78:75];
    if(isLoad[0:0]) begin
        Temp_reg_for_wb_value<=DMoutput;
    end 
    else begin
        Temp_reg_for_wb_value<=Value;
    end
end

assign write[63:0]=Temp_reg_for_wb_value[63:0];
assign write[67:64]=Reg_to_be_written[3:0];
assign write[68:68]=isWritetemp;

endmodule

// *****************************************************************************************



//TestBench for Memory Access Unit

//This is just a Testbench for testing Memory Access Unit

// `include "memory_access.v"
// module MA_tb();
//     reg[7:0] Address;
//     reg[63:0] Value=64'd9;
//     reg[3:0] Reg_to_be_written=4'b0000;
//     reg clk=0;
//     wire[0:0] isWrite=0;
//     wire[0:0] isLoad=1;
//     wire[67:0] write;
//     wire[0:0] isMemWrite=1;     
//     wire[78:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite;

//     initial begin
//     Address[7:0]=8'd0;
//     end

//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[7:0]=Address[7:0];
//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[71:8]=Value[63:0];
//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[75:72]=Reg_to_be_written[3:0];
//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[76:76]=isLoad[0:0];
//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[77:77]=isMemWrite[0:0];
//     assign Address_Value_RegAddress_isLoad_isMemWrite_isWrite[78:78]=isWrite[0:0];

//     memory_access MAU(
//         .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
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

//The Data_Memory.txt should be of 256 lines and initially containing only all zeroes.