# Core-v-verif changes by Paolo Borgis

There are here all the modifications by Paolo Borgis on the core-v-verif repo. Every single file that has been changed or created is listed below:

(base) [pab@RHEA core-v-verif]$ git status
On branch riscv-uvm-model
Your branch is up to date with 'origin/riscv-uvm-model'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
  (commit or discard the untracked or modified content in submodules)
        modified:   cv32e20 (modified content, untracked content)
        modified:   lib/uvm_components/uvmc_rvfi_reference_model/uvmc_rvfi_reference_model.sv
        modified:   lib/uvm_components/uvmc_rvfi_reference_model/uvmc_rvfi_reference_model_pkg.sv
        modified:   riscv-opcodes (untracked content)
        modified:   run-vcs.py

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        docs/SystemVerilog-model/
        lib/uvm_components/uvmc_rvfi_reference_model/uvmc_riscv_opcodes.sv

no changes added to commit (use "git add" and/or "git commit -a")
(base) [pab@RHEA core-v-verif]$ 





##  /core-v-verif/docs/SystemVerilog-model   (created)

    This folder has been created to carry this README.md


## /core-v-verif/cv32e20/tests/uvmt/base-tests/uvmt_cv32e20_base_test.sv (changed)

    Line 215, in the function void uvmt_cv32e20_base_test_c, I changed the parameter of .count from 5 to 10000, this was done because when the uvm_error reporting count was higher than 5, the simulation would have stopped. I needed to see all the uvm_error reports in order to separate the data from the instruction in the readmemh.

## /core-v-verif/lib/uvm_components/uvmc_rvfi_reference_model/uvmc_riscv_opcodes.sv  (created) (ex Mauro Cerone) 

    This is the new class that I created with the python script estrai_opcode.py


## /core-v-verif/lib/uvm_components/uvmc_rvfi_reference_model/uvmc_rvfi_reference_model_pkg.sv   (changed)

    Line 32, I added `include "uvmc_riscv_opcodes.sv" in the pkg

## /core-v-verif/lib/uvm_components/uvmc_rvfi_reference_model/uvmc_rvfi_reference_model.sv    (changed)

    Line 85, I instantiated the object uvmc_riscv_opcodes opcode_detections = new(); of the new class in the function get_and_set_cfg() of the reference model

## /core-v-verif/riscv-opcodes/config.json    (created)

    This is the json file which provide some of the parameters to format the estrai_opcode python script

## /core-v-verif/riscv-opcodes/estrai_opcode.py     (created)

    Script python to autogenerate the new systemverilog class uvmc_riscv_opcodes.sv. The class is created by formatting a template with the json file's values and some dictionaries. The formatting is performed by Valerio'function. @Valerio I changed your function in some points: I added one more parameter in input for the default statement of the case, and I made some changes in the case formatting piece of code in order to make the begin and end of each case fit the code with a proper indentation. @Valerio, please let me know if the changes are ok and, if not, what could be done better in your opinion

## /core-v-verif/run-vcs.py    (changed)

    From line 243 to line 253, I added those lines to include the SystemVerilog file "inst.sverilog" in the compilation process for the VCS simulator



## PS @Valerio There were some other minor changes, but I think they were of no interest, it was just me trying some stuff and see if it worked so before pushing I cleaned them. Also the simulation now is failing because of the uvm_error macro, which is reporting as an error every "instruction" which is not really an instruction, but a data from the memory (they are 5213 if you see the quit count report). The other instructions (I,M,C) are already separated and listed