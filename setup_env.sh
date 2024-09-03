#!/bin/bash
export CV_SIMULATOR="vcs"
export PATH="/mnt/rhea_hdd_raid5/opt_non_storage/backend/toolchains/risc/rv32imc/bin:$PATH"
export VERILATOR_ROOT="/opt/verilator/v5.004/"
export PATH=$PATH:/opt/eda/riscv/tools/isa-sim/bin
export PATH=$PATH:/opt/eda/riscv/tools/isa-sim/riscv32-unknown-elf/bin
export PATH=$PATH:/opt/eda/synopsys/tools/vcs/V-2023.12-SP1/bin/
export PATH=$PATH:/opt/eda/synopsys/tools/verdi/V-2023.12-SP1/bin/
export VCS_UVMHOME_ARG=/opt/eda/synopsys/tools/vcs/V-2023.12-SP1/etc/uvm