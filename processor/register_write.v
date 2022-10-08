//This is the Register Write-Back Unit

//Input : Register Address[4 bits] and Value[next 64 bits] [68 bits total], clk
//Output : Register Address to be written, Value to be written on the address

module register_write(
    input wire[75:0] reg_address_and_Value_with_Control_Rod,
    input wire clk,

    output wire final_reg_address_and_Value
);

register_file rf();

always @(posedge clk) begin
    final_reg_address_and_Value<=reg_address_and_Value;
end

endmodule

//May need changes after discussion