# Pipelined-Processor
<hr>
1. About
2. ISA
3. Folder Structure
4. Harek Unit
5. How to use

# About
**Segzzee** is a Simulation of a 64 bit 5-staged Pipelined Microprocessor. 

**Contents :** 
* Processor Simmulator written in Verilog 
* Assembler written in C++

**Specifications:**
* Instruction Size : 16 bits
* Register size : 64 bits
* Address size : 8 bits

 ### What can it compute ?
 It's a learning Project whose main aim is to execute basic programs like Basic mathematical operations, Factorial, Finding Prime Number, Fibonacci, n to the power m etc.
 
 
 # ISA
 
 * We have designed our own Simplified Instruction set.
 
 ![](https://i.imgur.com/dWSFZLe.png)

# Folder Structure
* **Assembler Machine Code** : Contains Sample code that can be executed on the processor
* **Assembler** : Contains the C++ code of Assembler to convert the Assembly code to machine code which can be simulated by the Processor
* **TestBenches** : Contains the Testbenches for all the units of the processor.
* **Processor** : Contains the Main Processor written in verilog.

<hr>

# Instruction Fetch Unit :
# Operand Fetch Unit : 
### Register File:
* Contains the 16 registers of the processor 
* Register 1 to 15 are General Purpose register and Register 16 is the flag Register
* It servers the purpose to read data from the register and write data back to the register at runtime.
### Control Unit : 
* Its function is to generate the Control signal needed in the processor
# Execution unit :
# Memory access Unit :
# Register Writeback Unit : 

<hr>

# How To use : 

* Run the following commands
* `git clone https://github.com/Segzzee/Pipelined-Processor.git`
* This will clone the repo
* Make a txt file and write the assembly code.
* Paste the Path of the .txt file in the assembler and run the assembler this will generate a machine code (instructions) to be executed by the processor
* Install `Icarus Verilog` and `Verilog HDL` extension in VS Code and run the testbench.v file and your output will be executed. 
* The output of the memory can be seen in the `Data Memory.txt` 
