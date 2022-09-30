// Data Memory Unit 

// Input : Memory Address from Address Bus , Input Data from Data Bus, Write-Enabling Signal from Control Unit
// Output : Output Data from Data Memory at the given memory address
// Files Required : Data_Memory.txt (contains data indexed according to an 8-bit memory address)
// Parent Modules : Memory Access
// Children Modules : NA

module data_memory(ismemwrite,memaddress,inputdata,outputdata); // Add clk (clock) when merging
    
    input wire ismemwrite;
    input wire [7:0] memaddress; 
    input wire [63:0] inputdata;
    output wire [63:0] outputdata; 

    reg [63:0] temp [0:255]; // Temporary Register Array to store data from text file
    integer fd; // File handler

    initial begin
        $readmemb("./Data_Memory.txt",temp,0,255); // Initializes temp array
    end
    
    always @ (*) begin
        if (ismemwrite) begin
            temp[memaddress] <= inputdata;
            fd = $fopen("./Data_Memory.txt","r+"); 
            for (integer i=0;i<256;i++) begin 
                $fdisplay(fd,"%b",temp[i]);
            end
            $fclose(fd);
        end
        else begin
            $readmemb("./Data_Memory.txt",temp,0,255);
        end
    end

    assign outputdata = temp[memaddress] ; 

endmodule