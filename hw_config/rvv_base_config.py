rvv_base = {
    "config_name": "rvv_base",

    "rtl_files": [],

    "rtl_incdirs": [],

    "rtl_dependencies": [
    ],

    "tb_files": [
        "lib/uvm_libs/uvml_hrtbt/uvml_hrtbt_pkg.sv",
        "lib/uvm_libs/uvml_trn/uvml_trn_pkg.sv",
        "lib/uvm_libs/uvml_logs/uvml_logs_pkg.sv",
        "lib/uvm_libs/uvml_sb/uvml_sb_pkg.sv",
        "lib/uvm_libs/uvml_mem/uvml_mem_pkg.sv",
        "lib/uvm_agents/uvma_clknrst/uvma_clknrst_pkg.sv",
        "lib/uvm_agents/uvma_interrupt/uvma_interrupt_pkg.sv",
        "lib/uvm_agents/uvma_obi_memory/src/uvma_obi_memory_pkg.sv",
        "lib/uvm_agents/uvma_debug/uvma_debug_pkg.sv",
        "lib/uvm_agents/uvma_core_cntrl/uvma_core_cntrl_pkg.sv",
        "lib/uvm_agents/uvma_rvfi/uvma_rvfi_pkg.sv",
        "lib/uvm_components/uvmc_rvfi_reference_model//uvmc_rvfi_reference_model_pkg.sv",
        "lib/uvm_components/uvmc_rvfi_scoreboard//uvmc_rvfi_scoreboard_pkg.sv",
        "cv32e20/vendor_lib/verilab/svlib/svlib/src/svlib_pkg.sv",
        "cv32e20/env/uvme/uvme_cv32e20_pkg.sv",
        "cv32e20/tb/uvmt/uvmt_cv32e20_pkg.sv",
        "cv32e20/tb/uvmt/uvmt_cv32e20_dut_wrap.sv",
        "cv32e20/tb/uvmt/uvmt_cv32e20_interrupt_assert.sv",
        "cv32e20/tb/uvmt/uvmt_cv32e20_debug_assert.sv"
    ],

    "tb_incdirs": [
        "cv32e20/tb/uvmt/",
        "lib/uvm_libs/uvml_hrtbt",
        "lib/uvm_libs/uvml_trn",
        "lib/uvm_libs/uvml_logs",
        "lib/uvm_libs/uvml_sb",
        "lib/uvm_libs/uvml_mem",
        "lib/uvm_agents/uvma_clknrst",
        "lib/uvm_agents/uvma_clknrst/cov",
        "lib/uvm_agents/uvma_clknrst/seq",
        "lib/uvm_agents/uvma_interrupt",
        "lib/uvm_agents/uvma_interrupt/cov",
        "lib/uvm_agents/uvma_interrupt/seq",
        "lib/uvm_agents/uvma_obi_memory/src",
        "lib/uvm_agents/uvma_obi_memory/src/comps",
        "lib/uvm_agents/uvma_obi_memory/src/obj",
        "lib/uvm_agents/uvma_obi_memory/src/seq",
        "lib/uvm_agents/uvma_debug",
        "lib/uvm_agents/uvma_debug/cov",
        "lib/uvm_agents/uvma_debug/seq",
        "lib/uvm_agents/uvma_core_cntrl",
        "lib/uvm_agents/uvma_rvfi",
        "lib/uvm_components/uvmc_rvfi_reference_model/",
        "lib/uvm_agents/uvma_rvfi",
        "lib/uvm_components/uvmc_rvfi_scoreboard/",
        "vendor/riscv/riscv-isa-sim/disasm/",
        "lib/uvm_agents/uvma_rvfi",
        "cv32e20/vendor_lib/verilab/svlib/svlib/src",
        "cv32e20/env/uvme",
        "cv32e20/env/uvme/cov",
        "cv32e20/env/uvme/vseq",
        "cv32e20/tb/uvmt",
        "cv32e20/tb/uvmt/../../tests/uvmt",
        "cv32e20/tb/uvmt/../../tests/uvmt/base-tests",
        "cv32e20/tb/uvmt/../../tests/uvmt/compliance-tests",
        "cv32e20/tb/uvmt/../../tests/uvmt/vseq",
        "cv32e20/tb",
    ],

    "tb_dependencies": [], #TODO The TB is based on the old DSL library so it needs ddl as well

    "verilog_wrapper": "",

    "variants": [],
}