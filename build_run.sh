#!/bin/bash
TEST=${1:-"TEST=riscv_arithmetic_basic_test_0"}
GUI=${2:-""}

reset
cd cv32e20/sim/uvmt
make corev-dv CV_CORE=cv32e20 SIMULATOR=vcs 
make comp CV_CORE=cv32e20 SIMULATOR=vcs 

cd vcs_results/default
test_name=$(echo "$TEST" | cut -d '=' -f 2)
if [ -d "$test_name" ]; then
    rm -r $test_name
    echo "Removed previous test results: $test_name"
else
    echo "Test results not found."
fi

cd ../..
make test COREV=YES $TEST SIMULATOR=vcs GEN_START_INDEX=0 RUN_INDEX=0 USE_ISS=YES $GUI
cd ../../../