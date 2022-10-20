#include <bits/stdc++.h>
using namespace std;

const int INSTRUCTION_BIT = 16;     // total instruction bit size

const string PATH = "/Users/rudransh/Downloads/CSN_221_Project/Assembler_Input.txt";    // input path

// opcode table 
map<string,string> opcode_table = {{"NOP","1000"},{"XOR","0100"},{"MUL","0010"},{"INC","0011"},{"LD","1101"},{"ADD","0001"},{"ST","1010"},{"RES","1100"},{"BEQ","1011"},{"JMP","1111"},{"CMP","0110"}};

map<string,int> symbol_table;

int counter = 0;    // for mantaining the counter (to be used for symbol table)

/*
 Refer to the opcode table:
    NOP : 1000
    ADD : 0001
    MUL : 0010
    XOR : 0100
    INC : 0011
    CMP : 0110
    BEQ : 1011
    JMP : 1111
    LD  : 1101
    ST  : 1010
    RES : 1100
*/


class Assembly_File {
    public:
    string file_name;                                   //text file storing the input instructions
    vector<string> input_instructions;                  //vector storing all the input instructions
    string instruction_from_file;                       //a single instruction
    Assembly_File(string file_name){                    
        this->file_name=file_name;
    }
        //Class containing all the possible components of an instruction
        class Instruction {
        public: 
            string opcode = "";
            string op1 = "";
            string op2 = "";
            string op3 = "";
            string input_assembly;
            Instruction(string input_assembly){
                this->input_assembly=input_assembly;
            }
            
            // function used for taking complement of a given character
            char flip(char c)
            {
                return (c == '0')? '1': '0';
            }

            // function used to convert any integer 'i' (positive or negative) into a binary string of 'bits' bits
            string form (int i, int bits)   
            {
                int j=i;
                i=abs(i);
                string s = "";
                while (i > 0)
                {
                    if (i%2)
                    {
                        s += '1';
                    }
                    else
                        s += '0';
                    i/=2;
                }                
                while (s.length() < bits)
                    s += '0';
                reverse(s.begin(),s.end());
                if(j>=0) return s;
                string ones_complement="",twos_complement="";
                for (i = 0; i < bits; i++)
                    ones_complement += flip(s[i]);
                twos_complement = ones_complement;
                for (i = bits - 1; i >= 0; i--)
                {
                    if (ones_complement[i] == '1')
                        twos_complement[i] = '0';
                    else
                    {
                        twos_complement[i] = '1';
                        break;
                    }
                }
                if (i == -1)
                    twos_complement = '1' + twos_complement;

                return twos_complement;
            }

            // method for the decomposition of input into opcode, op1, op2 and op3
            void assembly_to_object(){
                int iterator;
                int instruction_size = input_assembly.size();               //size of a particular instruction
                for (iterator=0;iterator<instruction_size;iterator++){
                    if (input_assembly[iterator]==' ') break;
                    opcode+=input_assembly[iterator];
                }
                if (iterator!=instruction_size){
                    for (++iterator;iterator<instruction_size;iterator++){
                        if (input_assembly[iterator]==',') break;
                        op1+=input_assembly[iterator];
                    }
                    if (iterator!=instruction_size){ 
                        for (++iterator;iterator<instruction_size;iterator++){
                            if (input_assembly[iterator]==',') break;
                            op2+=input_assembly[iterator];                            
                        }
                        if (iterator!=instruction_size){
                            for (++iterator;iterator<instruction_size;iterator++){
                                op3+=input_assembly[iterator];
                            }
                        }
                    }
                }
            }

            // method to convert the opcode, op1, op2 and op3 into final output form
            string object_to_binary(){
                string binary_code = "";                            //initially storing the opcode for the given instruction
                binary_code += opcode_table[opcode];
                if (opcode == "JMP"){
                    binary_code = form(symbol_table[op1]-counter,8) + "0000" + binary_code;
                    return binary_code;
                }
                if (opcode == "BEQ"){
                    binary_code = form(symbol_table[op1]-counter,8) + "1111" + binary_code;
                    return binary_code;
                }

                if (op1.size()>0){
                    string binary_op1="";
                    binary_op1 = form(stoi(op1.substr(1,2)),4);
                    binary_code = binary_op1 + binary_code;
                }
                if (op2.size()>0){
                    string binary_op2="";
                    if (opcode == "LD" || opcode == "ST")
                    {                        
                        int temporary = stoi(op2);
                        binary_code = form(temporary,8)+binary_code;        //offset of 8 bits taken in case of LD and ST
                    }                    
                    else {
                        binary_op2 = form(stoi(op2.substr(1,2)),4);
                    }
                    binary_code = binary_op2 + binary_code;
                    if (opcode == "CMP")
                    {
                        binary_code = "1111" + binary_code;                 //writing in the flag register in case of a CMP instruction
                    }
                }
                if (op3.size()>0){
                    string binary_op3="";
                    binary_op3 = form(stoi(op3.substr(1,2)),4);                    
                    binary_code = binary_op3 + binary_code;
                }
                return binary_code;
            }
        };    

    void construct_instruction() {
        
        // taking and storing input continously till end
        while (getline(cin,instruction_from_file))
            input_instructions.push_back(instruction_from_file);
        
        for (int i=0;i<input_instructions.size();i++)
        {
            string tmp = "";
            string s = input_instructions[i];

            // for mantaining symbol table 
            for (int j=0;j<input_instructions[i].length();j++)
            {
                char x = input_instructions[i][j];
                if (x == ':')
                {
                    tmp = tmp.substr(0,j-1);
                    symbol_table[tmp] = i;   // mantaining symbol table for tags to be used in BEQ and JMP                   
                    j += 2;

                    input_instructions[i] = input_instructions[i].substr(j);    // only keeping the instruction after the colon in case of tag used
                    break;
                }
                tmp += x;
            }            
        }
    }
    void output()   // for getting final output
    {
        for (string iterator : input_instructions)
        {                    
            instruction_from_file = iterator;
            
            Instruction object (instruction_from_file);

            object.assembly_to_object();    // breakdown of instruction into several parts
            

            string output_binary = object.object_to_binary();   // final conversion of decomposed parts into binary and getting a combined output

            int binary_length = output_binary.size();
                
            // printing of binary output         
            for (int i=0;i<(INSTRUCTION_BIT-binary_length);i++) 
                cout<<0;
            cout<<output_binary;            

            counter++;                        
        }
    }
};

// driver function
int main(){

    Assembly_File file1 (PATH);   // creating object of Assembly_File
    
    // const char* a = (&(file1.file_name[0]));

    // freopen(a,"r",stdin);   // for getting an input txt file

    // freopen("/Users/rudransh/Downloads/CSN_221_Project/Assembler_Output.txt","w",stdout);

    file1.construct_instruction();  // for taking input and mantaining the symbol table 
    
    file1.output();    // for extraxction and printing of output
}

// public,private
//std replace
//names of classes,variables,etc.
//commenting