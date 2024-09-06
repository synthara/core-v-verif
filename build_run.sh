#!/bin/bash
TEST=${1:-"TEST=riscv_arithmetic_basic_test_0"}
GUI=${2:-""}

cd cv32e20/sim/uvmt && \
make corev-dv CV_CORE=cv32e20 SIMULATOR=vcs && \
make comp CV_CORE=cv32e20 SIMULATOR=vcs && \
make test COREV=YES $TEST SIMULATOR=vcs GEN_START_INDEX=0 RUN_INDEX=0 USE_ISS=YES $GUI