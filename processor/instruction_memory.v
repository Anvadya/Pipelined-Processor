// Instruction Memory Unit 

// Input : Program Counter (PC) from Address Bus 
// Output : Instruction from Instruction Memory at the given address
// Files Required : Instruction_Memory.txt (contains instructions in binary form converted by assembler)
// Parent Modules : Instruction Fetch
// Children Modules : NA

module instruction_memory(pc,instruction); // Add clk (clock) when merging
    
    input wire [7:0] pc; // Program Control
    output wire [15:0] instruction;

    reg [15:0] temp; // Temporary Register to store instruction while iteration
    integer fd,scan; // File handler

    always @(*) begin  // Replace * with posedge clk when merging
        fd = $fopen("./Instruction_Memory.txt","r"); 
        for (integer i=0;i<=pc;i++) begin
            scan=$fscanf(fd,"%b",temp); 
        end
        $fclose(fd);
    end
    
    assign instruction = temp;
   

endmodule
