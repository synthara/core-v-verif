## Changes about estrai_opcode.py ( Only relevant changes are about this script )

I created 7 dictionaries, one for each instruction format (R, I ,S, ecc.), and a separate dictionary which contain all these dictionaries (format_dicts)

Starting from line 214, this script is extracting from the json (instr_dict is "instr_dict.json" content) all the content and throw away all that is not variable fields, and create a dictionary named only_variable_fields that contains key = instruction's name and val = list of variable fields of that instruction

The script that starts from line 222 has been created in order to set the type of the instructions in the dictionary "only_variable_fields", in particular, based on the variable fields that every instruction own, it decide if this operation is R type, I type ecc.  Example: only_variable_fields = 'add': ['rd', 'rs1', 'rs2'], 'addi': ['rd', 'rs1', 'imm12'], ecc.     So this script will output instruction_format = 'add':R, 'addi':I, ecc.

The script that starts from line 248 is si creating the bitfield mapping. In this for, for each instruction, line 249 is deciding the instruction type (R, I, ecc.), and in line 250, based on the previous decision, I am extracting the varible fields of that particular type instruction. Then I am printing them in bitfield_mapping
Example of fmt_name and fmt_dict for 'add' and 'addi':
R
{'rd': '11:7', 'rs1': '19:15', 'rs2': '24:20'}
I
{'rd': '11:7', 'rs1': '19:15', 'imm12': '31:20'}


The script that starts from line 256 is filling the casez_dict which will contain all the stuff to be put in the case, in particular if the instruction name extracted from the file instr.sverilog (in opcode_dict) is equal to the one extracted from the json (in only_variable_fields)  (NB it has been used .lower because instruction were capital letter in inst.sverilog, while not in instr_dict.json). For the SB, S and UJ instruction I had to reconstruct the immediate, so I added an if for each of these cases.

Output file is /core-v-verif/lib/uvm_components/uvmc_rvfi_reference_model/uvmc_riscv_pcodes.sv" and seems correct and is also compiling with run_vcs (It says failed cause of the uvm_error in the default case, but it's ok because M and C instructions are missing and datas in the memory are also present)


## 15/04/2025 push

Added m instructions to the model using parse.py, added implementations for each i,m instruction in the file impl_dict.json. In line 288,289 in estrai_opcode.py implementations are added alongside variable fields. Added the reg_file to be accessed, the pc for instructions that require that and reg_mul to store all the result for the mul instructions ( 32 x 32 = 64)

## 23/04/2025 push

Added rv32_i instructions (pseudo instructions that were missing in i format) and csr instructions to the model. Added implementation for rv32_i instructions, but not for csr (I tried but was not sure about what I've done, I have a backup copy on my PC about csr implementation, we can discuss about it). I did not push run_vcs.py. I am trying to verify the correct behaviour of the code, but it's not running in the correct way yet ( I think some instruction implementation is not correct).