// Instruction Memory Unit 

// Input : Program Counter (PC) from Address Bus 
// Output : Instruction from Instruction Memory at the given address
// Files Required : Instruction_Memory.txt (contains instructions in binary form converted by assembler)
// Parent Modules : Instruction Fetch
// Children Modules : NA

module instruction_memory(pc,instruction); // Add clk (clock) when merging
    
    input wire [7:0] pc; // Program Control
    output wire [15:0] instruction;

    reg [7:0] character; //Temporary register to store binary values as ASCII characters
    reg [15:0] temp; // Temporary Register to store instruction while iteration
    integer fd; // File handler

    always @(*) begin
        fd = $fopen("./Instruction_Memory.txt","r"); 
        for (integer i=0;i<=pc;i++) begin
            for (integer j=0;j<16;j++) begin
                character=$fgetc(fd)-48;
                temp[15-j]=character[0];
            end
        end
        $fclose(fd);
    end
    
    assign instruction = temp;
   

endmodule
