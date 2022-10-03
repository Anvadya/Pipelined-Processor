//This is the Register Write-Back Unit

//Input : Register Address to be written,Value, clk
//Output : Register Address to be written, Value to be written on the address

module register_write(
    input wire[67:0] reg_address_and_Value,
    input wire clk,

    output wire final_reg_address_and_Value
);

always @(posedge clk) begin
    final_reg_address_and_Value<=reg_address_and_Value;
end

endmodule

//May need changes after discussion