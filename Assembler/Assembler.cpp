#include <bits/stdc++.h>
using namespace std;

const int INSTRUCTION_BIT = 16;
map<string,string> opcode_table = {{"NOP","0000"},{"XOR","0001"},{"MUL","0010"},{"INC","0011"},{"LD","0100"},{"ADD","0101"},{"ST","0110"},{"RES","0111"},{"BEQ","1000"},{"JMP","1001"}};
map<string,int> symbol_table;
int counter = 0;
/* 
 __________
| NOP -- 0 |
| XOR -- 1 |
| MUL -- 2 |
| INC -- 3 |
| LD --  4 | 
| ADD -- 5 | 
| ST --  6 |
| RES -- 7 |
| BEQ -- 8 |
| JMP -- 9 |        
|__________|

*/


class Assembly_File {
    public:
    string file_name;
    // map<string,int> symbol_table;
    Assembly_File(string file_name){
        this->file_name=file_name;
    }
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
            char flip(char c) {return (c == '0')? '1': '0';}

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
                // cout<<s.length()<<' '<<bits<<'\n';
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

            void assembly_to_object(){
                int iterator;
                int instruction_size = input_assembly.size();
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
            string object_to_binary(){
                string binary_code = "";
                binary_code += opcode_table[opcode];
                // cout<<opcode<<"1 "<<op1<<"2 "<<op2<<"3 "<<op3<<endl;
                if (opcode == "BEQ" || opcode == "JMP"){
                    binary_code += "0000"+ form(symbol_table[op1]-counter,8);
                    return binary_code;
                }

                if (op1.size()>0){
                    string binary_op1="";
                    binary_op1 = form(int(op1[1])-int('0'),4);
                    binary_code+=binary_op1;
                }
                if (op2.size()>0){
                    string binary_op2="";
                    if (op2.size()>2){
                        binary_op2=op2; //memory address as it is
                    }
                    else {
                        binary_op2 = form(int(op2[1])-int('0'),4);
                    }
                    binary_code+=binary_op2;
                }
                if (op3.size()>0){
                    string binary_op3="";
                    binary_op3 = form(int(op3[1])-int('0'),4);                    
                    binary_code+=binary_op3;
                }
                return binary_code;
            }
        };
    vector<Instruction> instruction_set;
    void construct_instruction() {
        string instruction_from_file;
        vector<string> kuch_bhi;
        while (getline(cin,instruction_from_file)){
            kuch_bhi.push_back(instruction_from_file);
        }
        for (int i=0;i<kuch_bhi.size();i++)
        {
            string tmp = "";
            string s = kuch_bhi[i];
            for (char x : kuch_bhi[i])
            {
                if (x == ':')
                {
                    symbol_table[tmp] = i;
                }
                tmp += x;
            }
        }
        for (string iterator : kuch_bhi)
        {
            instruction_from_file = iterator;
            Instruction object (instruction_from_file);
            object.assembly_to_object();
            instruction_set.push_back(object);   
            counter++;
        }
    }
    void output()
    {
        for (auto x: instruction_set){
            string output_binary = x.object_to_binary();
            int binary_length = output_binary.size();
            for (int i=0;i<binary_length;i++) cout<<output_binary[i];
            for (int i=0;i<(INSTRUCTION_BIT-binary_length);i++) cout<<0;
        }
    }
};
int main(){
    Assembly_File file1 ("/Users/rudransh/Downloads/CSN_221_Project/Assembler_Input.txt");
    const char* a = (&(file1.file_name[0]));
    freopen(a,"r",stdin);
    file1.construct_instruction();
    file1.output();
}

// public,private
//std replace
//names of classes,variables,etc.
//commenting