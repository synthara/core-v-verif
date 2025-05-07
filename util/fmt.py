google_compile_cmd = """
cd {core_dv_dir} &/home/hjk/src/rec/log/default/vcs_results/default/hello-world/0/vcs-hello-world.log& \
{VCS_HOME}/bin/vcs \
-lca \
-sverilog \
"+define+CV32E20_ASSERT_ON" \
+define+UVM \
+incdir+{VCS_HOME}/etc/uvm/src \
{VCS_HOME}/etc/uvm/src/uvm_pkg.sv \
+UVM_VERBOSITY=UVM_MEDIUM \
-ntb_opts \
uvm-1.2 \
-timescale=1ns/1ps \
-assert svaext \
-race=all \
-ignore unique_checks \
-full64 \
-q \
+define++define+CV32E20_RVFI+RVFI \
+define+CV32E20_TRACE_EXECUTION \
+incdir+{CORE_TB_PATH}/tb/uvmt \
+incdir+{CORE_RTL_PATH}/rtl/include \
+incdir+{CORE_TB_PATH}/env/corev-dv/ldgen \
+incdir+{CORE_V_VERIF}/lib/mem_region_gen \
+incdir+{CORE_TB_PATH}/env/corev-dv/target/{cv_core} \
+incdir+{CORE_TB_PATH}/vendor_lib/google/riscv-dv/user_extension \
+incdir+{CORE_V_VERIF}/lib/corev-dv \
+incdir+{CORE_TB_PATH}/env/corev-dv \
-f {CORE_V_VERIF}/lib/corev-dv/manifest.f \
-l vcs.log """

dpi_compile_cmd = """
cd {csrc_dir} && 
{GCC} -w -pipe -DVCSMX -DUVM_DPI_DO_TYPE_CHECK -DVCSMX -DUVM_DPI_DO_TYPE_CHECK -fPIC -O -I{VCS_HOME}/include -c {VCS_HOME}/etc/uvm-1.2/dpi/uvm_dpi.cc && \
{GCC} -w -pipe -DVCSMX -DUVM_DPI_DO_TYPE_CHECK -DVCSMX -DUVM_DPI_DO_TYPE_CHECK -fPIC -O -I{VCS_HOME}/include -c {VCS_HOME}/etc/uvm-1.2/verdi/dpi/uvm_verdi_dpi.cpp
"""

# *******************************************************************************************
# * Compiling the BSP
# *******************************************************************************************
bsp_compile_cmd = """
mkdir -p {bsp_dir} && \
cd {bsp_dir} && \
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {crt0_path} -o crt0.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/handlers.S -o handlers.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/syscalls.c -o syscalls.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/syscalls_kernel.c -o syscalls_kernel.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/vectors.S -o vectors.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/csr.c -o csr.o
{RISCV_EXE_PREFIX}{GCC} -Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic -c {CORE_TB_PATH}/bsp/rand.c -o rand.o
{RISCV_EXE_PREFIX}ar rcs libcv-verif.a crt0.o handlers.o syscalls.o syscalls_kernel.o vectors.o csr.o rand.o
"""

# USE The Custom Linker
# *******************************************************************************************
# * Compiling test-program {test_program_dir}/{program_name}.elf
# *******************************************************************************************
test_program_compile_cmd = """
{RISCV_EXE_PREFIX}{GXX} \
-Os \
-g \
-static \
-mabi=ilp32 \
-march={march} \
-Wall -pedantic \
-I ../../tests/asm \
-I {CORE_TB_PATH}/bsp \
-L {CORE_TB_PATH}/bsp/default \
-I {CORE_V_VERIF}/CxR_tests \
-L {bsp_dir} \
-o {test_program_dir}/{program_name}.elf \
-nostartfiles \
{c_files} \
-T {linker_script} \
-lcv-verif
"""

# *******************************************************************************************
# * Generating hexfile, readelf and objdump files
# *******************************************************************************************
hex_compile_cmd = """
{RISCV_EXE_PREFIX}objcopy -O verilog {test_program_dir}/{program_name}.elf {test_program_dir}/{program_name}.hex
{RISCV_EXE_PREFIX}readelf -aW {test_program_dir}/{program_name}.elf > {test_program_dir}/{program_name}.readelf
{RISCV_EXE_PREFIX}objdump -d -M no-aliases -M numeric -S {test_program_dir}/{program_name}.elf > {test_program_dir}/{program_name}.objdump
{RISCV_EXE_PREFIX}objdump -d -S -M no-aliases -M numeric -l {test_program_dir}/{program_name}.elf | {CORE_V_VERIF}/bin/objdump2itb - > {test_program_dir}/{program_name}.itb
"""

 
sv_compile_cmd = """
cd {vcs_out_dir} &&  \
{VCS_HOME}/bin/vcs +incdir+{VCS_HOME}/etc/uvm/src \
+incdir+{CORE_V_VERIF}/lib/dpi_dasm {VCS_HOME}/etc/uvm/src/uvm_pkg.sv \
{vcs_compile_flags} \
{vcs_defines} {CXR_VERSION_DEFINE} {args_define} +incdir+{VCS_HOME}/etc/uvm/src \
{VCS_HOME}/etc/uvm/src/uvm_pkg.sv \
+incdir+{CORE_TB_PATH}/env/uvme \
+incdir+{CORE_TB_PATH}/tb/uvmt \
+incdir+{CORE_V_VERIF} \
{test_define} \
-f {CORE_RTL_PATH}/cv32e20_manifest.flist \
-f {CORE_TB_PATH}/tb/uvmt/uvmt_cv32e20.flist \
{CORE_V_VERIF}/util/uvmt_cv32e20_model_test.sv \
{optional_flags} \
-top uvmt_{cv_core}_tb -l vcs.log
"""


sv_sim_cmd = """
mkdir -p {vcs_out_dir}/default/{program_name}/0 && \
cd {vcs_out_dir}/default/{program_name}/0 && \
{vcs_out_dir}/simv \
-licwait 20 \
-l vcs-{program_name}.log \
-cm_name {program_name} \
-sv_lib {CORE_V_VERIF}/tools/spike/lib/libriscv \
-sv_lib {CORE_V_VERIF}/tools/spike/lib/libdisasm \
-sv_lib {CORE_V_VERIF}/tools/spike/lib/libfesvr \
-sv_lib {CORE_V_VERIF}/vendor_lib/imperas/imperas_DV_COREV/bin/Linux64/imperas_CV32.dpi \
-sv_lib {CORE_TB_PATH}/vendor_lib/verilab/svlib_dpi +scoreboard_enable={scoreboard_enable} \
-assert nopostproc \
+ntb_random_seed=1 \
+USE_ISS \
{gui} \
{define_ssm_spike} \
+UVM_VERBOSITY=UVM_LOW \
+report_file={program_name}.yaml \
+signature=I-ADD-01.signature_output \
+UVM_TESTNAME={uvm_test_name} \
+fetch_initial_delay={fetch_initial_delay} \
+elf_file={elf_file} \
+firmware={hex_file} \
+itb_file={itb_file}
"""