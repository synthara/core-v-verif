# CVA6: Verification Environment for the CVA6 CORE-V processor core

- [Directories](#directories)
- [Prerequisites](#prerequisites)
- [Test execution](#test-execution)
- [Environment variables](#environment-variables)
- [32-bit configuration](#32-bit-configuration)

## Directories:
- **bsp**:   board support package for test-programs compiled/assembled/linked for the CVA6.
This BSP is used by both `core` testbench and `uvmt_cva6` UVM verification environment.
- **regress**: scripts to install tools, test suites, CVA6 code and to execute tests
- **sim**:   simulation environment (e.g. riscv-dv)
- **tb**:    testbench module instancing the core
- **tests**: source of test cases and test lists

There are README files in each directory with additional information.

## Quick Start Guide

### Requirements

Many people who come to `CORE-V-VERIF <https://github.com/openhwgroup/core-v-verif>`_ for the first time
are anxious to 'get something running' and this section is written to satisfy that itch.

Note: in several places in this chapter a reference is made to $CORE_V_VERIF.
This is used as short hand for the absolute path to your local working directory.
You will not need to set this shell environment variable yourself.

In order to run the CVA6 with a RISCV test you will need:

- A Linux machine (CORE-V-VERIF has been successfully run under Debian and CentOS).
- Python3 and a set of plug-ins.
- A GCC system-compiler with version equal or greater than 8 with support for the standard c++17.
- A GCC cross-compiler (aka "the [Toolchain](https://github.com/openhwgroup/core-v-verif/blob/master/mk/TOOLCHAIN.md#core-v-toolchain). Even if you already have a RISC-V toolchain, please do follow that link and read `TOOLCHAIN.md <https://github.com/openhwgroup/core-v-verif/blob/master/mk/TOOLCHAIN.md>`_ for recommended ENV variables to point to it. Be aware that only gcc 11.1.0 or newer are supported in core-v-verif repository.
- [Verilator](https://veripool.org/guide/latest/install.html>). It will be installed in case it is not detected in the system.

An easy way to get the Python plug-ins installed on your machine is::

```
   $ pip3 install pyyaml
```

**Note:** Virtual python environments can be used if desired.

To make the scripts the following variables must be set:

- `export RISCV=/path/to/installation/directory`

### To execute

To execute CVA6, currently we use a system of bash scripts which do all the
necessary to execute once the principal requirements are fullfiled.

Run one of the shell scripts:

- `bash cva6/regress/smoke-tests.sh`
- `bash cva6/regress/dv-riscv-compliance.sh`:
[riscv-compliance](https://github.com/riscv/riscv-compliance) test suite,
- `bash cva6/regress/dv-riscv-tests.sh`:
[riscv-tests](https://github.com/riscv/riscv-tests) test suite.


## Environment variables
Other environment variables can be set to overload default values
provided in the different scripts.

The default values are:

- `RISCV_GCC`: `$RISCV/bin/riscv-none-elf-gcc`
- `RISCV_OBJCOPY`: `$RISCV/bin/riscv-none-elf-objcopy`
- `VERILATOR_ROOT`: `../tools/verilator-4.110` to install in core-v-verif/tools
- `SPIKE_ROOT`: `../tools/spike` to install in core-v-verif/tools

- `CVA6_REPO`: `https://github.com/openhwgroup/cva6.git`
- `CVA6_BRANCH`: `master`
- `CVA6_HASH`: see value in `regress/install-cva6.sh`
- `CVA6_PATCH`: no default value
- `COMPLIANCE_REPO`: `https://github.com/riscv/riscv-compliance.git`
- `COMPLIANCE_BRANCH`: `master`
- `COMPLIANCE_HASH`: `220e78542da4510e40eac31e31fdd4e77cdae437`
- `COMPLIANCE_PATCH`: no default value
- `TESTS_REPO`: `https://github.com/riscv/riscv-tests.git`
- `TESTS_BRANCH`: `master`
- `TESTS_HASH`: `f92842f91644092960ac7946a61ec2895e543cec`
- `DV_REPO`: `https://github.com/google/riscv-dv.git`
- `DV_BRANCH`: `master`
- `DV_HASH`: `0ce85d3187689855cd2b3b9e3fae21ca32de2248`
- `DV_PATCH`: no default value
- `DV_TARGET`: `cv64a6_imafdc_sv39`
- `DV_SIMULATORS`: `veri-core,spike`
- `DV_TESTLISTS`: `../tests/testlist_riscv-tests-$DV_TARGET-p.yaml
../tests/testlist_riscv-tests-$DV_TARGET-v.yaml`
- `DV_OPTS`: no default value

## 32-bit configuration
To test the CVA6 in 32-bit configuration, use `DV_TARGET` with
a 32-bit variant (e.g. `cv32a6_imac_sv0`).

The following environment variables have to be modified before executing
test script.

- `DV_TARGET`: `cv32a6_imac_sv0`
