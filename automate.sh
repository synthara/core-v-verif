#!/bin/bash

tests=("uvmt_cv32e20_firmware_test_c" "uvmt_cv32e20_model_test_c")
programs=("hello-world" "fibonacci" "riscv_arithmetic_basic_test_0")

# Get current date time and username
datetime=$(date +"%Y%m%d_%H%M%S")
username=$(whoami)

# Reset the terminal
reset

# Create the output directory
base_dir="/scratch/$username/riscv/$datetime"
mkdir -p "$base_dir"
echo "Created directory: $base_dir"

for prog in "${programs[@]}"; do
    for test in "${tests[@]}"; do
        out_dir="${test}_${prog}"
        echo "Running test: $test with program: $prog"
        python3 run-vcs.py \
            -test "$test" \
            -march rv32imc_zicsr \
            -program "$prog" \
            -out_dir "$base_dir/$out_dir"
        status=$?
        echo "Test $test with program $prog finished with exit code $status."
        if [ $status -ne 0 ]; then
            echo "Error running test $test with program $prog. Exiting script."
            exit 1
        fi
    done
done
