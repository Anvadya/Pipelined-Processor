# Pipelined-Processor
<hr>

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
* Contains the Instruction Memory.
* Its function is to fetch the binary instruction (16 bits) from the instruction memory one after another.
# Operand Fetch Unit : 
### Register File:
* Contains the 16 registers of the processor 
* Register 1 to 15 are General Purpose register and Register 16 is the flag Register
* It servers the purpose to read data from the register and write data back to the register at runtime.
### Control Unit : 
* Its function is to generate the Control signal needed in the processor
# Execution unit :
* Responsible for all the main calculations such as calculations involving operands and calculating new address after branch instruction.
# Memory access Unit :
* Contains the Data Memory.
* Its function is to handle Load Store operations by communicating with the Data memory.
# Register Writeback Unit : 
* Its function is to write the necessary data to the specified register of the Register file.

<hr>

# How To use : 

* Run the following commands
* `git clone https://github.com/Segzzee/Pipelined-Processor.git`
* This will clone the repo
* Make a txt file and write the assembly code.
* Paste the Path of the .txt file in the assembler and run the assembler this will generate a machine code (instructions) to be executed by the processor
* Install `Icarus Verilog` and `Verilog HDL` extension in VS Code and run the testbench.v file and your output will be executed. 
* The output of the memory can be seen in the `Data Memory.txt` 

# Some Examples in **gtkwave** form :

## Factorial of 19 :

![Screenshot (315)](https://user-images.githubusercontent.com/99145719/197294710-aa561ae7-6cad-4855-a140-81a9a2f599ab.png)

* Factorial(19)= 1B02B9306890000 (in Hexadecimal) = 121645100408832000 (in Decimal)
* **NOTE**: In this 5-staged Pipelined Microprocessor we can accurately calculate upto 19 Factorial.
