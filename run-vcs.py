from pathlib import Path
import os
import argparse
import shutil
import subprocess
from util import fmt

# Argparse the input in search of the flag -gui
parser = argparse.ArgumentParser()
parser.add_argument("-gui", help="Run the simulation in GUI mode", action="store_true")
parser.add_argument(
    "-sw_only", help="Compile only the SW, not the HW", action="store_true"
)
parser.add_argument("--bsp-only", help="Compile only the BSP", action="store_true")
parser.add_argument(
    "--skip-testcase-comp",
    help="Skip the compilation of the testcase.",
    action="store_true",
)
# program can either be a program name or a path to the precompiled program. The .hex and .itb files should be in the same directory as the program
parser.add_argument("-program", help="Specify the program name", default="hello-world")
parser.add_argument(
    "-no_iss", help="Run the simulation without ISS", action="store_true"
)
parser.add_argument("-mem_dump", help="Dump the memory content", action="store_true")
parser.add_argument(
    "-test",
    help="Select the UVM test",
    default="uvmt_cv32e20_firmware_test_c",
)
parser.add_argument(
    "-ld",
    help="Select the linker script",
    default=None
)
parser.add_argument("-bm", help="Enable the behavioral model", action="store_true")
parser.add_argument("-define",  help="Pass a sim define",      default="")
parser.add_argument("-march", help="March definition", default="rv32imc")
parser.add_argument("-delay", help="Fetch initial delay to give time to the TB to load data through AXI in the IMEM", default="100000")
parser.add_argument("-core", help="Name of the core to simulate, default is cv32e20", default="cv32e20")

if __name__ == "__main__":
    
    # Default define
    test_define = ""
    
    subprocess.run(["reset"])

    args = parser.parse_args()

    # Get path to the current directory
    CORE_V_VERIF = os.path.dirname(os.path.realpath(__file__))
    
    # Print default values if no flag is passed
    for action in parser._actions:
        if action.default is not None and not any(arg in action.option_strings for arg in vars(parser.parse_args())):
            print(f"\033[93mUsing default value for {action.dest}: {action.default}\033[0m")

    #####################################################################################
    ##################### Select all the desired parameters #############################
    #####################################################################################

    # Get input flags
    march = args.march
    uvm_test_name = args.test
    fetch_initial_delay = args.delay # Use +fetch_initial_delay to give time to the jtag to write into the IMEM
    cv_core = args.core # Select the desired core
    
    if args.mem_dump is True:
        test_define += "+define+DUMP_MEMORY"
        
    if args.bm is True:
        test_define += "+define+BEHAVIORAL_MODEL"

    # If the flag -gui is set, run the simulation in GUI mode
    if args.gui:
        kdb = "-debug_access+all+class+verbose -kdb"
        gui = "-gui"
    else:
        kdb = ""
        gui = ""

    if args.no_iss:
        scoreboard_enable = "0"
        define_ssm_spike = ""
    else:
        scoreboard_enable = "1"
        define_ssm_spike = "+define+SSM_SPIKE"

    #####################################################################################

    # Main subrepos paths
    # TODO: For the moment CORE V VERIF is aside of the RVV, should maybe become a submodule
    CORE_RTL_PATH = f"{CORE_V_VERIF}/core-v-cores/{args.core}"
    CORE_TB_PATH = f"{CORE_V_VERIF}/{args.core}"

    os.environ["CORE_V_VERIF"] = CORE_V_VERIF
    os.environ["CORE_RTL_PATH"] = CORE_RTL_PATH
    os.environ["NOVAS_RC"] = "/opt/eda/synopsys/tools/verdi/V-2023.12/etc/custom_rovas.rc"

    VCS_HOME                      = "/opt/eda/synopsys/tools/vcs/latest"
    
    if args.march not in ["rv32imc", "rv32im_zicsr"]:
        print("\033[91m" + f"Error: {args.march} is not a valid march definition. Exiting..." + "\033[0m")
        exit()
    
    # rv32im_zicsr we need to use another toolchain due to this issue 
    # https://docs.google.com/document/d/12kw4BVbr0RyuAvPRr8CXgR33H9AQaPSzJ4StCifH044/edit?tab=t.0#heading=h.afilqthi1rq8
    if args.march == "rv32im_zicsr":
        RISCV_EXE_PREFIX              = f"/home/vcl/compiler/riscv-toolchain/riscv-gnu-toolchain/riscv/bin/riscv32-unknown-elf-"
        CV_SW_TOOLCHAIN               = f"/home/vcl/compiler/riscv-toolchain/riscv-gnu-toolchain/riscv/"
    else:
        RISCV_EXE_PREFIX              = f"/mnt/rhea_hdd_raid5/opt_non_storage/backend/toolchains/risc/{march}/bin/riscv32-unknown-elf-"
        CV_SW_TOOLCHAIN               = f"/mnt/rhea_hdd_raid5/opt_non_storage/backend/toolchains/risc/{march}"

    os.environ["VCS_HOME"]        = VCS_HOME
    os.environ["CV_SW_TOOLCHAIN"] = CV_SW_TOOLCHAIN
    os.environ["SPIKE_PATH"]      = f"{CORE_V_VERIF}/vendor/riscv/riscv-isa-sim"

    GCC = "gcc"  # BSP is compiled with gcc
    GXX = "g++"  # Test program is compiled with g++

    # CORE type setup
    CV_CORE_LC = cv_core
    os.environ["CV_CORE_LC"] = CV_CORE_LC

    # export DV_UVMT_PATH           = $(CORE_V_VERIF)/$(CV_CORE_LC)/tb/uvmt
    os.environ["DV_UVMT_PATH"] = f"{CORE_V_VERIF}/{CV_CORE_LC}/tb/uvmt"
    # export DV_UVME_PATH           = $(CORE_V_VERIF)/$(CV_CORE_LC)/env/uvme
    os.environ["DV_UVME_PATH"] = f"{CORE_V_VERIF}/{CV_CORE_LC}/env/uvme"
    # export DV_UVML_HRTBT_PATH     = $(CORE_V_VERIF)/lib/uvm_libs/uvml_hrtbt
    os.environ["DV_UVML_HRTBT_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_hrtbt"
    # export DV_UVMA_ISACOV_PATH    = $(CORE_V_VERIF)/lib/uvm_agents/uvma_isacov
    os.environ["DV_UVMA_ISACOV_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_isacov"
    # export DV_UVMA_CLKNRST_PATH   = $(CORE_V_VERIF)/lib/uvm_agents/uvma_clknrst
    os.environ["DV_UVMA_CLKNRST_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_clknrst"
    # export DV_UVMA_INTERRUPT_PATH = $(CORE_V_VERIF)/lib/uvm_agents/uvma_interrupt
    os.environ["DV_UVMA_INTERRUPT_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_interrupt"
    # export DV_UVMA_DEBUG_PATH     = $(CORE_V_VERIF)/lib/uvm_agents/uvma_debug
    os.environ["DV_UVMA_DEBUG_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_debug"
    # export DV_UVML_TRN_PATH       = $(CORE_V_VERIF)/lib/uvm_libs/uvml_trn
    os.environ["DV_UVML_TRN_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_trn"
    # export DV_UVML_LOGS_PATH      = $(CORE_V_VERIF)/lib/uvm_libs/uvml_logs
    os.environ["DV_UVML_LOGS_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_logs"
    # export DV_UVML_SB_PATH        = $(CORE_V_VERIF)/lib/uvm_libs/uvml_sb
    os.environ["DV_UVML_SB_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_sb"

    # export DV_OVPM_HOME           = $(CORE_V_VERIF)/vendor_lib/imperas
    os.environ["DV_OVPM_HOME"] = f"{CORE_V_VERIF}/vendor_lib/imperas"
    # export DV_OVPM_MODEL          = $(DV_OVPM_HOME)/imperas_DV_COREV
    os.environ["DV_OVPM_MODEL"] = f"{os.environ['DV_OVPM_HOME']}/imperas_DV_COREV"
    # export DV_OVPM_DESIGN         = $(DV_OVPM_HOME)/design
    os.environ["DV_OVPM_DESIGN"] = f"{os.environ['DV_OVPM_HOME']}/design"

    # UVM Environment
    os.environ["DV_UVMT_PATH"] = f"{CORE_V_VERIF}/{CV_CORE_LC}/tb/uvmt"
    os.environ["DV_UVME_PATH"] = f"{CORE_V_VERIF}/{CV_CORE_LC}/env/uvme"
    os.environ["DV_UVML_HRTBT_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_hrtbt"
    os.environ["DV_UVMA_CORE_CNTRL_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_core_cntrl"
    os.environ["DV_UVMA_ISACOV_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_isacov"
    os.environ["DV_UVMA_RVFI_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_rvfi"
    os.environ["DV_UVMA_RVVI_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_rvvi"
    os.environ["DV_UVMA_RVVI_OVPSIM_PATH"] = (
        f"{CORE_V_VERIF}/lib/uvm_agents/uvma_rvvi_ovpsim"
    )
    os.environ["DV_UVMA_CLKNRST_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_clknrst"
    os.environ["DV_UVMA_INTERRUPT_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_interrupt"
    os.environ["DV_UVMA_DEBUG_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_debug"
    os.environ["DV_UVMA_PMA_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_pma"
    os.environ["DV_UVMA_OBI_MEMORY_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_obi_memory"
    os.environ["DV_UVMA_FENCEI_PATH"] = f"{CORE_V_VERIF}/lib/uvm_agents/uvma_fencei"
    os.environ["DV_UVML_TRN_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_trn"
    os.environ["DV_UVML_LOGS_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_logs"
    os.environ["DV_UVML_SB_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_sb"
    os.environ["DV_UVML_MEM_PATH"] = f"{CORE_V_VERIF}/lib/uvm_libs/uvml_mem"

    os.environ["DV_UVMC_RVFI_SCOREBOARD_PATH"] = (
        f"{CORE_V_VERIF}/lib/uvm_components/uvmc_rvfi_scoreboard/"
    )
    os.environ["DV_UVMC_RVFI_REFERENCE_MODEL_PATH"] = (
        f"{CORE_V_VERIF}/lib/uvm_components/uvmc_rvfi_reference_model/"
    )

    os.environ["DV_OVPM_HOME"] = f"{CORE_V_VERIF}/vendor_lib/imperas"
    os.environ["DV_OVPM_MODEL"] = f"{os.environ['DV_OVPM_HOME']}/imperas_DV_COREV"

    os.environ["DV_OVPM_DESIGN"] = f"{os.environ['DV_OVPM_HOME']}/design"

    os.environ["DV_SVLIB_PATH"] = f"{CORE_V_VERIF}/{CV_CORE_LC}/vendor_lib/verilab"

    # TB source files for the CV32E core
    TBSRC_HOME = f"{CORE_V_VERIF}/{CV_CORE_LC}/tb"
    os.environ["TBSRC_HOME"] = TBSRC_HOME

    # RTL source files for the CV32E core
    # DESIGN_RTL_DIR is used by CV32E40P_MANIFEST file
    CV_CORE_PKG = CORE_RTL_PATH
    CV_CORE_MANIFEST = f"{CV_CORE_PKG}/{CV_CORE_LC}_manifest.flist"
    os.environ["DESIGN_RTL_DIR"] = f"{CV_CORE_PKG}/rtl"

    os.environ["DPI_DASM_ROOT"] = "{CORE_V_VERIF}/lib/dpi_dasm"

    ## DRI DEFINITION
    # The output root directory for the compilation and simulation
    out_dir = (
        os.path.join(CORE_V_VERIF, "log")
        if not args.skip_testcase_comp
        else Path(args.program).parent / "log"
    )

    program_name = args.program

    vcs_out_dir      = os.path.join(out_dir, "default", "vcs_results")
    core_dv_dir      = os.path.join(out_dir, "default", "corev-dv")
    csrc_dir         = os.path.join(vcs_out_dir, "csrc")
    test_program_dir = os.path.join(vcs_out_dir, "default", program_name, "0", "test_program")
    bsp_dir          = os.path.join(test_program_dir, "bsp")

    # If the program is a path, extract the program name
    program_path = Path(args.program)
    if program_path.is_absolute() or program_path.parent != Path('.'):
        elf_file = Path(args.program).parent / f"{Path(args.program).name}"
        hex_file = Path(args.program).parent / f"{Path(args.program).stem}.hex"
        itb_file = Path(args.program).parent / f"{Path(args.program).stem}.itb"
        program_name = Path(elf_file).stem
        test_program_dir = (
            Path(vcs_out_dir) / "default" / program_name / "0" / "test_program"
        )
        bsp_dir = test_program_dir / "bsp"
        test_program_dir.mkdir(parents=True, exist_ok=True)
        for file in [elf_file, hex_file, itb_file]:
            # copy the file to the test_program_dir
            shutil.copy(file, test_program_dir)
    else:
        elf_file = Path(test_program_dir) / f"{program_name}.elf"
        hex_file = Path(test_program_dir) / f"{program_name}.hex"
        itb_file = Path(test_program_dir) / f"{program_name}.itb"

    if not os.path.exists(core_dv_dir):
        os.makedirs(core_dv_dir)
    if not os.path.exists(csrc_dir):
        os.makedirs(csrc_dir)
    if not os.path.exists(bsp_dir):
        os.makedirs(bsp_dir)

    ## VCS define is needed for the ifdef in the AXI crossbar
    vcs_defines = "+define+VCS +define+GNT "
    # vcs_defines += "+define+__UVMT_CV32E20_TB_SV__ "  # NOTE: we define __UVMT_CV32E20_TB_SV__ so that the top module of the OpenHW is not compiled, we want to compile our own top module
    # vcs_defines += "+define+__UVMT_CV32E20_DUT_WRAP_SV__ "  # NOTE: we define __UVMT_CV32E20_DUT_WRAP_SV__ so we avoid compiling the cor wrapper of OpenHW, which we do not use
    CXR_VERSION_DEFINE = "+define+BASE"

    # mkdir {CORE_V_VERIF}/log/ &&  \
    args_define = f"+define+{args.define}"
    vcs_compile_flags = "+define++define+CV32E20_RVFI+RVFI +define+CV32E20_TRACE_EXECUTION +USE_ISS -lca -sverilog +define+CV32E20_ASSERT_ON -ntb_opts uvm-1.2 -timescale=1ns/1ps -assert svaext -race=all -ignore unique_checks -full64 -reportstats -notice -line -fgp=multisocket +define+UVM"

            # Trova il percorso assoluto del file inst.sverilog
    inst_file_path = os.path.abspath(os.path.join(CORE_V_VERIF,"riscv-opcodes", "inst.sverilog"))

    # Aggiungi il path della directory di inst.sverilog al +incdir
    vcs_compile_flags += f" +incdir+{os.path.dirname(inst_file_path)} "

    # Includi direttamente il file inst.sverilog nella compilazione
    vcs_compile_flags += f" {inst_file_path} "
    

    optional_flags = "-suppress=PCTI-L -suppress=UII-L -kdb=common_elab -debug_acc+all -debug_region+cell+encrypt -fgp=num_threads:8 -fgp=auto_affinity:allowHyperThreadCpu +gc+high_threshold+5 +UVM_NO_RELNOTES"

    ###################################################################
    ################ SELECT THE CRT0 AND LINKER #######################
    ###################################################################
    if program_name == "riscv_arithmetic_basic_test_0":
        crt0_path = f"{CORE_V_VERIF}/tests/programs/custom/riscv_arithmetic_basic_test_0/riscv_arithmetic_basic_test_0.S"
    else:
        crt0_path = f"{CORE_TB_PATH}/bsp/crt0.S"

    # This test is not present anymore, use the default linker
    # # If the test is rec_tb_cor_axi_test_drive_both_computeram_no_fw_preload,
    # # The system need a .ld and crt0.S file wo handle the bootloader
    # if uvm_test_name == "rec_tb_cor_axi_test_drive_both_computeram_no_fw_preload":
    #     crt0_path = f"{CORE_V_VERIF}/design/top/rec/scripts/c/dram_system/crt0.S"

    if program_name in ["riscv_arithmetic_basic_test_0", "hello-world"]:
        c_files = f"{CORE_TB_PATH}/tests/programs/custom/{program_name}/{program_name}.c"
    elif program_name == "coremark":
        c_files = f"-DITERATIONS=1 \
            -DVALIDATION_RUN=1 \
            -DFLAGS_STR='\"-Os -g -static -mabi=ilp32 -march={march} -Wall -pedantic\"' \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/coremark.h \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_portme.h \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_portme.c \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_list_join.c \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_state.c \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_util.c\
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_matrix.c \
            {CORE_TB_PATH}/tests/programs/custom/{program_name}/core_main.c"
    elif program_name == "test_read_write":
        linker_script = f"{CORE_V_VERIF}/design/top/rec/scripts/c/link_big_heap.ld"
        c_files = f"{CORE_V_VERIF}/CxR_tests/stream_read_write.cc \
            {CORE_V_VERIF}/CxR_tests/computeram.c \
            {CORE_V_VERIF}/CxR_tests/hardware_tests_utils.cc \
            {CORE_V_VERIF}/CxR_tests/chip_config.c"
    elif program_name == "test_trigger_compute":
        linker_script = f"{CORE_V_VERIF}/design/top/rec/scripts/c/link_big_heap.ld"
        c_files = f"{CORE_V_VERIF}/CxR_tests/trigger_compute.cc \
            {CORE_V_VERIF}/CxR_tests/computeram.c \
            {CORE_V_VERIF}/CxR_tests/hardware_tests_utils.cc \
            {CORE_V_VERIF}/CxR_tests/chip_config.c"
    elif program_name == "simple_test":
        linker_script = f"{CORE_V_VERIF}/design/top/rec/scripts/c/link_big_heap.ld"
        c_files = f"{CORE_V_VERIF}/CxR_tests/simple_test.cc \
            {CORE_V_VERIF}/CxR_tests/computeram.c \
            {CORE_V_VERIF}/CxR_tests/hardware_tests_utils.cc \
            {CORE_V_VERIF}/CxR_tests/chip_config.c"
    else:
        c_files = ""
        print(f"Program {program_name} not found. Assuming it is a precompiled program.")

    if args.ld:
        linker_script = args.ld
    else:
        linker_script = f"{CORE_TB_PATH}/bsp/link.ld"

    # This test is not present anymore, use the default linker
    # # If the test is rec_tb_cor_axi_test_drive_both_computeram_no_fw_preload,
    # # The system need a .ld and crt0.S file wo handle the bootloader
    # if uvm_test_name == "rec_tb_cor_axi_test_drive_both_computeram_no_fw_preload":
    #     linker_script = f"{CORE_V_VERIF}/design/top/rec/scripts/c/dram_system/link.ld"


    ###################################################################
    ################ FORMAT COMMANDS TEMPLATE   #######################
    ###################################################################
    
    # Put all the information flags into a single dictionary
    # With this dictionary you will format the commands
    fmt_dict = {
        "CORE_V_VERIF": CORE_V_VERIF,
        "CORE_V_VERIF": CORE_V_VERIF,
        "VCS_HOME": VCS_HOME,
        "cv_core": cv_core,
        "CORE_RTL_PATH": CORE_RTL_PATH,
        "CORE_TB_PATH": CORE_TB_PATH,
        "RISCV_EXE_PREFIX": RISCV_EXE_PREFIX,
        "GCC": GCC,
        "GXX": GXX,
        "march": march,
        "core_dv_dir": core_dv_dir,
        "csrc_dir": csrc_dir,
        "vcs_out_dir": vcs_out_dir,
        "vcs_compile_flags": vcs_compile_flags,
        "vcs_defines": vcs_defines,
        "CXR_VERSION_DEFINE": CXR_VERSION_DEFINE,
        "args_define": args_define,
        "test_define": test_define,
        "kdb": kdb,
        "optional_flags": optional_flags,
        "bsp_dir": bsp_dir,
        "crt0_path": crt0_path,
        "test_program_dir": test_program_dir,
        "program_name": program_name,
        "c_files": c_files,
        "linker_script": linker_script,
        "scoreboard_enable": scoreboard_enable,
        "gui": gui,
        "define_ssm_spike": define_ssm_spike,
        "uvm_test_name": uvm_test_name,
        "fetch_initial_delay": fetch_initial_delay,
        "elf_file": elf_file,
        "hex_file": hex_file,
        "itb_file": itb_file,
    }

    google_compile_cmd = fmt.google_compile_cmd.format(**fmt_dict)

    dpi_compile_cmd = fmt.dpi_compile_cmd.format(**fmt_dict)

    bsp_compile_cmd = fmt.bsp_compile_cmd.format(**fmt_dict)

    test_program_compile_cmd = fmt.test_program_compile_cmd.format(**fmt_dict)

    hex_compile_cmd = fmt.hex_compile_cmd.format(**fmt_dict)

    sv_compile_cmd = fmt.sv_compile_cmd.format(**fmt_dict)

    sv_sim_cmd = fmt.sv_sim_cmd.format(**fmt_dict)

    sw_cmd_dict = {"bsp_compile_cmd": bsp_compile_cmd}

    ###################################################################
    ################ CREATE THE COMMAND DICT    #######################
    ###################################################################
    if args.bsp_only:
        args.sw_only = True
    elif args.skip_testcase_comp:
        sw_cmd_dict |= {
            # "google_compile_cmd": google_compile_cmd,
            "dpi_compile_cmd": dpi_compile_cmd,
        }
    else:
        sw_cmd_dict |= {
            # "google_compile_cmd": google_compile_cmd,
            "dpi_compile_cmd": dpi_compile_cmd,
            "test_program_compile_cmd": test_program_compile_cmd,
            "hex_compile_cmd": hex_compile_cmd,
        }

    hw_cmd_dict = {"sv_compile_cmd": sv_compile_cmd, "sv_sim_cmd": sv_sim_cmd}

    for cmd_idx, (key, cmd) in enumerate(sw_cmd_dict.items()):
        print("\n**********************************************************")
        print(f"{key}:\n{cmd}")
        print("**********************************************************")

        process = subprocess.Popen(cmd, shell=True)
        process.wait()

        if process.returncode != 0:
            print("\033[91m" + f"Error occurred in {key}. Exiting..." + "\033[0m")
            exit()

    if args.sw_only:
        exit()

    for cmd_idx, (key, cmd) in enumerate(hw_cmd_dict.items()):
        print("\n**********************************************************")
        print(f"{key}:\n{cmd}")
        print("**********************************************************")

        process = subprocess.Popen(cmd, shell=True)
        process.wait()

        if process.returncode != 0:
            print("\033[91m" + f"Error occurred in {key}. Exiting..." + "\033[0m")
            exit()
