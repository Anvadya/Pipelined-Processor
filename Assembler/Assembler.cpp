#include <bits/stdc++.h>
using namespace std;

const int INSTRUCTION_BIT = 16;
const string PATH = "/Users/rudransh/Downloads/CSN_221_Project/Assembler_Input.txt";
map<string,string> opcode_table = {{"NOP","1000"},{"XOR","0100"},{"MUL","0010"},{"INC","0011"},{"LD","1101"},{"ADD","0001"},{"ST","1010"},{"RES","1100"},{"BEQ","1011"},{"JMP","1111"},{"CMP","0110"}};
map<string,int> symbol_table;
int counter = 0;

 // Refer to the opcode table:
    // NOP : 1000
    // ADD : 0001
    // MUL : 0010
    // XOR : 0100
    // INC : 0011
    // CMP : 0110
    // BEQ : 1011
    // JMP : 1111
    // LD  : 1101
    // ST  : 1010
    // RES : 1100
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
| CMP -- 10|        
|__________|

*/


class Assembly_File {
    public:
    string file_name;
    vector<string> kuch_bhi;
    string instruction_from_file;
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
                        binary_code = form(temporary,8)+binary_code;
                    }
                    // if (op2.size()>2){
                    //     binary_op2=op2; //memory address as it is
                    // }
                    else {
                        binary_op2 = form(stoi(op2.substr(1,2)),4);
                    }
                    binary_code = binary_op2 + binary_code;
                    if (opcode == "CMP")
                    {
                        binary_code = "1111" + binary_code;
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
    // bool check_for_label (string to_be_checked)
    // {
    //     for (char iterator : to_be_checked)
    //     {
    //         if (iterator == ':')
    //             return false;
    //     }
    //     return true;
    // }

    void construct_instruction() {
        
        while (getline(cin,instruction_from_file)){
            // cout<<instruction_from_file.length()<<'\n';
            kuch_bhi.push_back(instruction_from_file);
        }
        for (int i=0;i<kuch_bhi.size();i++)
        {
            string tmp = "";
            string s = kuch_bhi[i];
            for (int j=0;j<kuch_bhi[i].length();j++)
            {
                char x = kuch_bhi[i][j];
                if (x == ':')
                {
                    tmp = tmp.substr(0,j-1);
                    symbol_table[tmp] = i;                    
                    j += 2;
                    kuch_bhi[i] = kuch_bhi[i].substr(j);
                    break;
                }
                tmp += x;
            }
            // cout<<kuch_bhi[i].length()<<'\n';
        }
    }
    void output()
    {
        for (string iterator : kuch_bhi)
        {                    
            instruction_from_file = iterator;
            // if (check_for_label(instruction_from_file)) // checking if the given function is not a label or not
            // {
            Instruction object (instruction_from_file);
            object.assembly_to_object();

            // instruction_set.push_back(object);       

            string output_binary = object.object_to_binary();

            int binary_length = output_binary.size();

            // for (int i=0;i<binary_length;i++) cout<<output_binary[i];
            for (int i=0;i<(INSTRUCTION_BIT-binary_length);i++) cout<<0;
            cout<<output_binary;            

            counter++;
            // }
            
        }
    }
};
int main(){
    Assembly_File file1 (PATH);
    const char* a = (&(file1.file_name[0]));
    // freopen(a,"r",stdin);
    // freopen("/Users/rudransh/Downloads/CSN_221_Project/Assembler_Output.txt","w",stdout);
    file1.construct_instruction();
    file1.output();
    // file1.output();
}

// public,private
//std replace
//names of classes,variables,etc.
//commenting
