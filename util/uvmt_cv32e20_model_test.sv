`ifndef __UVMT_CV32E20_MODEL_TEST_SV__
`define __UVMT_CV32E20_MODEL_TEST_SV__

import uvmc_rvfi_reference_model_pkg::*;

class uvmt_cv32e20_model_test_c extends uvmt_cv32e20_firmware_test_c;

    `uvm_component_utils_begin(uvmt_cv32e20_model_test_c)
    `uvm_object_utils_end

    function new(string name="uvmt_cv32e20_model_test", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("TEST", "This is the MODEL TEST", UVM_NONE)
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("model_test", "Overriding Reference Model with UVM model", UVM_NONE)
        set_type_override_by_type(uvmc_rvfi_reference_model#()::get_type(), uvmc_riscv_opcodes#()::get_type());

    endfunction: build_phase

endclass: uvmt_cv32e20_model_test_c

`endif  // __UVMT_CV32E20_MODEL_TEST_SV__
