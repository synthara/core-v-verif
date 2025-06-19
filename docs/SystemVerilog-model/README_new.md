This is an environment to launch simulations of a RTL core with VCS using a Spike model or Synthara's self contained UVM model

You can launch a single simulation with

`python run-vcs.py`

Run 

`python run-vcs.py -h`

to display all the possible flags.

The run-vcs script
- builds the Spike directory if it has never been built
- checks out the correct version of the RTL and TB repos
- compiles the SW (support libraries, C, asm)
- launches the `parse.py` script with info coming from the `config.json` file

The script `automate.sh` is used in order to run regressions and compare the result of Spike vs UVM model.

## Simulation time mismatch

VCS simulation time was different between Spike and UVM model. This made impossible to compare the actual simulation times.
To solve the following changes took place

1. In `lib/uvm_agents/uvma_obi_memory/src/comps/uvma_obi_memory_drv.sv`
- line 449 `repeat (0) begin`
- line 473 `repeat (0) begin`
- line 303 `int unsigned effective_latency = 0;`
2. In `cv32e20/env/uvme/uvme_cv32e20_cfg.sv`
- line 170 `obi_memory_data_cfg.drv_slv_gnt_mode    == UVMA_OBI_MEMORY_DRV_SLV_GNT_MODE_CONSTANT;`
- line 174 `obi_memory_data_cfg.drv_slv_rvalid_mode == UVMA_OBI_MEMORY_DRV_SLV_RVALID_MODE_CONSTANT;`