//This is the Register Write-Back Unit

//Input : Register Address to be written,Value from Memory Unit, Value from ALU, MUX selector, clk
//Output : Register Address to be written, Value to be written on the address

module register_write(
    input wire[3:0] reg_address,
    input wire[63:0] MA_value,
    input wire[63:0] ALU_value,
    input wire MUX,
    input wire clk,

    output wire[3:0] reg_address_to_be_written,
    output wire[63:0] final_value
);

reg[63:0] final;

always @(posedge clk) begin
if(MUX) begin
final<=ALU_value;
end
else begin
final<=MA_value;
end
end
assign final_value=final;
assign reg_address_to_be_written=reg_address;
endmodule

//************************************************************************************************

//TestBench for WriteBack Unit

// `include "register_write.v"
// module wb_tb();
// wire[3:0] reg_address=4'b0101;
// reg[63:0] MA_value=64'b0000000000000000000000000000000000000000000000000000000000001011;
// reg[63:0] ALU_value=64'b0000000000000000000000000000000000000000000000000000000000001000;
// reg clk=0;
// reg MUX=1;
// wire[63:0] final_value;
// wire[3:0] reg_address_to_be_written;
// register_write wb(
//     .reg_address(reg_address),
//     .MA_value(MA_value),
//     .ALU_value(ALU_value),
//     .MUX(MUX),
//     .clk(clk),

//     .reg_address_to_be_written(reg_address_to_be_written),
//     .final_value(final_value)
//     );

// initial begin
//         $dumpfile("wb_tb.vcd");
//         $dumpvars(0,wb_tb);
//         clk=0;
//         #10;
//         clk=1;
//         #10;
//         $display("Final1 : ",final_value);
//         clk=0;
//         MA_value=64'd14;
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//         $display("Final2 : ",final_value);
//         #10;
//         clk=1;
//         #10;
//         clk=0;
//     end
// endmodule