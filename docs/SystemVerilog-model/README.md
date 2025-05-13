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

## 25/04/2025 push

Added csr implementation in the impl_dict.json (I used a new register file of 4096 refister not initialized). I inserted arg_lut.csv in the model, so I deleted field_specs dictionary which was containing the fields. I obtained the fields length by subtracting start and end bit ( ex rd -> 11:7  => 11-7 = 4 => bit [4:0] rd  (bit[start-end:0] rd)). I also changed the for loop in which the case is created: now every time there is a new instruction, all the variable fields of arg_lut are confronted with the ones of the instruction, and if there is a match, that particular variable fields is written down. So all the dictionaries with instruction type should not be useful anymore, but I decided to left them because I'm still using some of them to do the reconstruction of the immediate (SB, S and UJ instr.) in lines 321 - 326 of estrai_opcode.py. I also changed implementations of branches instructions, jal and jalr (jalr probably still not correct but better than before)


## 30/04/2025 push

Complete debug of all instructions in the program hello-world. I corrected instruction that use to work with the memory (load and store instructions), and I made some immediate extensions where it was needed because some operations were failing (such as the branches operations that add an immediate that needs to be extended (it's signed not unsigned), and also some addi and andi, ori). I resolved the store instructions problem, because all the registers outside the memory are on 32 bit, while every memory location is one byte, so for example when a store occours, 4 access in the memory are performed. Dual reason for load instructions. I verified all the instructions of program "Hello-world", verified with the file "uvm_test_top.env.rvfi_agent.trn.log". Unfortunately in this file  not all the instructions of the set are there ( example m-instructions are never used, and also other instructions such as lb, slt, slti, sra ecc.), but all the instructions that are in this file have been verified and they are all completely correct...   P.S. c-instructions still missing


## 02/05/2025 push

All the model is now able to decide if using a clock or not. In particularin the python script two blocks have been instantiated, one that permits the model to work with a clock and another without. You can decide to use the clock by setting the flag --set_clock, otherwise the model would work without the clock by default if no flag is inserted. N.B. without the clock the simulation stops right after wfi instruction has been detected ( I imposed this end otherwise without the clock the simulation is running forever because of the final jal), while with the clock, a lot of jal are executed before the program finishes to run, and I quite cannot explain this behaviour, but this is not compromising the correctness of the result of the simulation. In the sysverilog class there is a bit SENSE_CLK, that is not really used, but it's only for the user to know if he is in the clock mode or the no clock mode

## 07/05/2025

Model has been connected to the scoreboard as a substitute for the default reference model, in particular in my model (uvmc_riscv_opcodes) it has been created a rvfi_instr_seq_item to collect all the transactions from the model and a uvm_analysis port to send them to the scoreboard. In the uvme_cv32e20_env.sv class, all the instances about the default reference model have been commented, and new instances about the new reference model have been added, and by the end in the function connect_scoreboard, I commented the lines that were connecting the reference model for obvious reasons and I added the connection to my model. In the scoreboard I changed the check that was starting the comparison between dut and rm. I did this because rm begins to filling the transactions' queue before the core, if the check is done on the rm, when we're trying to pop the core's first element there will be nothing inside, and so it returns a null object error. ( With spike it was working because spike waits for the first core's transaction and then it's doing his own as a result )

## 09/05/2025 push

Program counter initial value has been added in the model by the parent class ( it's not hardwired anymore ), the function build_phase is taking care of it. Function step is inserted in the model, this function just waits for a transaction by the core, and only then the transaction by the reference model is happening. The decode opcode function has been inserted inside the step, that is then inserted inside a write_rvfi_instr, that provides the new transaction to the scoreboard by using the analysis_port. The python now has 3 run modes: one using the while (the reference model is generating the transactions instantly), with a clock ( the reference model is generating a new transaction after a clock cycle)    N.B These 2 ref models are generating new transactions faster than the core ( because some instructions could handle 2 or more clk cycles to be executed ). The last run mode has been setted as default and waits for a core transaction to produce a ref model transaction. In this way we can do again the check on the ref model in the scoreboard and not anymore on the core (because core was alwaays last to finish with 2 last modes, but now it's always ahead)

## 13/05/2025 push

C instructions added to the model, in particular all the instructions in the hello world test are now working and the test is arriving to the end succesfully (Test says failed because there is the wfi instruction that is not in the model but it's not a problem). It has been added in the python script a function that sorts the instructions in the case, in particular there was a problem for the c.jalr instruction, infact it was unable to access the case because it has the same encoding of the c.add instruction (c.jalr is a c.add that has rs2 = 0, but since c.add don't care about the value in rs2 and the check on the c.add is done before the check on the c.jalr, the instruction ,be it a c.jalr or a c.add, was always entering the c.add branch). The new function brings all the case_dict and it split the condition (name of the instruction), by the assign (implementation), and it's confronting it with the file opcode_priority.json. In this file youu can put, in order, the fìinstruction that you want to be put at the beginning of the case. In this way I was able to put the c.jalr before the c.add and not having the problem explained before.