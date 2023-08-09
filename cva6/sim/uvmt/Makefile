###############################################################################
#
# Copyright 2020 OpenHW Group
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://solderpad.org/licenses/
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
#
###############################################################################
#
# Makefile for the CV32E40P "uvmt_cv32" testbench.  Substantially modified
# from the original Makefile for the RI5CY testbench.
#
###############################################################################
#
# Copyright 2019 Claire Wolf
# Copyright 2019 Robert Balas
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# Original Author: Robert Balas (balasr@iis.ee.ethz.ch)
#
###############################################################################

# "Constants"
MAKE                  = make
MAKE_PATH            := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
export CORE_V_VERIF   = $(abspath $(MAKE_PATH)/../../..)
export CV_CORE       ?= cva6

DPI_DASM_SPIKE_REPO  ?= https://github.com/riscv/riscv-isa-sim.git
CV_SW_TOOLCHAIN      ?= /opt/riscv
CV_SW_PREFIX         ?= " "

DV_TARGET=uvmt

export CVA6_UVMT_DIR          = $(CORE_V_VERIF)/cva6/tb/uvmt
export CVA6_UVMT_PATH         = $(CORE_V_VERIF)/cva6/tb/uvmt
export CVA6_UVME_PATH         = $(CORE_V_VERIF)/cva6/env/uvme

export DV_UVMT_PATH           = $(CORE_V_VERIF)/$(CV_CORE_LC)/tb/uvmt
export DV_UVME_PATH           = $(CORE_V_VERIF)/$(CV_CORE_LC)/env/uvme
export DV_UVML_HRTBT_PATH     = $(CORE_V_VERIF)/lib/uvm_libs/uvml_hrtbt
export DV_UVMA_CORE_CNTRL_PATH = $(CORE_V_VERIF)/lib/uvm_agents/uvma_core_cntrl
export DV_UVMA_RVFI_PATH      = $(CORE_V_VERIF)/lib/uvm_agents/uvma_rvfi
export DV_UVMA_ISACOV_PATH    = $(CORE_V_VERIF)/lib/uvm_agents/uvma_isacov
export DV_UVMA_CLKNRST_PATH   = $(CORE_V_VERIF)/lib/uvm_agents/uvma_clknrst
export DV_UVMA_CVXIF_PATH     = $(CORE_V_VERIF)/lib/uvm_agents/uvma_cvxif
export DV_UVMA_AXI_PATH       = $(CORE_V_VERIF)/lib/uvm_agents/uvma_axi
export DV_UVMA_INTERRUPT_PATH = $(CORE_V_VERIF)/lib/uvm_agents/uvma_interrupt
export DV_UVMA_DEBUG_PATH     = $(CORE_V_VERIF)/lib/uvm_agents/uvma_debug
export DV_UVMA_OBI_PATH       = $(CORE_V_VERIF)/lib/uvm_agents/uvma_obi
export DV_UVML_TRN_PATH       = $(CORE_V_VERIF)/lib/uvm_libs/uvml_trn
export DV_UVML_MEM_PATH       = $(CORE_V_VERIF)/lib/uvm_libs/uvml_mem
export DV_UVML_LOGS_PATH      = $(CORE_V_VERIF)/lib/uvm_libs/uvml_logs
export DV_UVML_SB_PATH        = $(CORE_V_VERIF)/lib/uvm_libs/uvml_sb

export CV_CORE_PKG            = $(CORE_V_VERIF)/core-v-cores/$(CV_CORE_LC)
export CVA6_REPO_DIR          = $(CV_CORE_PKG)
export CVA6_TB_DIR            = $(CVA6_UVMT_PATH)/../core/
export DESIGN_RTL_DIR         = $(CV_CORE_PKG)/rtl

export TARGET_CFG=cv64a6_imafdc_sv39
#export TARGET_CFG=cv32a60x

VCS_USER_COMPILE_ARGS = +define+UNSUPPORTED_WITH+ -assert svaext -race=all -ignore unique_checks -full64
VCS_RUN_FLAGS = -sv_lib $(CV_CORE_PKG)/work-dpi/ariane_dpi +debug_disable=1 \
		+ntb_random_seed=1 +signature=I-ADD-01.signature_output

VLOG_USER_FLAGS = +define+UNSUPPORTED_WITH+ -svinputport=relaxed -suppress 2583
VSIM_USER_FLAGS =  -suppress 3838 -sv_lib $(CV_CORE_PKG)/work-dpi/ariane_dpi \
		    +ntb_random_seed=1 +debug_disable=1 +signature=I-ADD-01.signature_output

USER_CFLAGS = -static -mcmodel=medany -static -std=gnu99 -static -O2  -fno-builtin-printf -fno-tree-loop-distribute-patterns -DPREALLOCATE=1


CV_SW_MARCH=rv32gc
CV_SW_MABI=ilp32f

include ../ExternalRepos.mk
include $(CORE_V_VERIF)/mk/uvmt/uvmt.mk
