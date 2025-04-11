
`ifndef __uvmc_riscv_opcodes_SV__
`define __uvmc_riscv_opcodes_SV__

import riscv_instr::*;

class uvmc_riscv_opcodes extends uvm_component;

    string file_path = "";
    int mem[int];

    bit [4:0] rd;
    bit [4:0] rs1;
    bit [4:0] rs2;
    bit [11:0] imm12;
    bit [6:0] imm12hi;
    bit [4:0] imm12lo;
    bit [6:0] bimm12hi;
    bit [4:0] bimm12lo;
    bit [19:0] jimm20;
    bit [19:0] imm20;
    bit [3:0] fm;
    bit [3:0] pred;
    bit [3:0] succ;
    bit [11:0] imms;
    bit [12:0] immsb;
    bit [20:0] immuj;
    

    `uvm_component_utils_begin(uvmc_riscv_opcodes)
    `uvm_component_utils_end

    function new(string name="uvmc_riscv_opcodes", uvm_component parent=null);

        super.new(name, parent);

        $display("[%0t]Creating uvmc_riscv_opcodes instance: %s", $time, name);

	    if ($value$plusargs("firmware=%s", file_path)) begin
            $display("Firmware file: %s", file_path);
    	end else begin
            $fatal("No +firmware argument provided!");
    	end

        $readmemh(file_path, mem);

        foreach (mem[i]) begin
            decode_opcode(mem[i]);
        end

    endfunction : new



    function void decode_opcode(bit[31:0] instr);

    
        casez (instr)

            ADD : begin

                `uvm_info("ADD", "Instruction ADD detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            ADDI : begin

                `uvm_info("ADDI", "Instruction ADDI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            AND : begin

                `uvm_info("AND", "Instruction AND detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            ANDI : begin

                `uvm_info("ANDI", "Instruction ANDI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            AUIPC : begin

                `uvm_info("AUIPC", "Instruction AUIPC detected successfully", UVM_LOW)
                rd = instr[11:7];
                imm20 = instr[31:12];

            end

            BEQ : begin

                `uvm_info("BEQ", "Instruction BEQ detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            BGE : begin

                `uvm_info("BGE", "Instruction BGE detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            BGEU : begin

                `uvm_info("BGEU", "Instruction BGEU detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            BLT : begin

                `uvm_info("BLT", "Instruction BLT detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            BLTU : begin

                `uvm_info("BLTU", "Instruction BLTU detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            BNE : begin

                `uvm_info("BNE", "Instruction BNE detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};

            end

            EBREAK : begin

                `uvm_info("EBREAK", "Instruction EBREAK detected successfully", UVM_LOW)

            end

            ECALL : begin

                `uvm_info("ECALL", "Instruction ECALL detected successfully", UVM_LOW)

            end

            FENCE : begin

                `uvm_info("FENCE", "Instruction FENCE detected successfully", UVM_LOW)
                fm = instr[31:28];
                pred = instr[27:24];
                succ = instr[23:20];
                rs1 = instr[19:15];
                rd = instr[11:7];

            end

            JAL : begin

                `uvm_info("JAL", "Instruction JAL detected successfully", UVM_LOW)
                rd = instr[11:7];
                jimm20 = instr[31:12];
                immuj = {jimm20[19], jimm20[7:0], jimm20[8], jimm20[18:9], 1'b0};

            end

            JALR : begin

                `uvm_info("JALR", "Instruction JALR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            LB : begin

                `uvm_info("LB", "Instruction LB detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            LBU : begin

                `uvm_info("LBU", "Instruction LBU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            LH : begin

                `uvm_info("LH", "Instruction LH detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            LHU : begin

                `uvm_info("LHU", "Instruction LHU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            LUI : begin

                `uvm_info("LUI", "Instruction LUI detected successfully", UVM_LOW)
                rd = instr[11:7];
                imm20 = instr[31:12];

            end

            LW : begin

                `uvm_info("LW", "Instruction LW detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            OR : begin

                `uvm_info("OR", "Instruction OR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            ORI : begin

                `uvm_info("ORI", "Instruction ORI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            SB : begin

                `uvm_info("SB", "Instruction SB detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};

            end

            SH : begin

                `uvm_info("SH", "Instruction SH detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};

            end

            SLL : begin

                `uvm_info("SLL", "Instruction SLL detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SLT : begin

                `uvm_info("SLT", "Instruction SLT detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SLTI : begin

                `uvm_info("SLTI", "Instruction SLTI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            SLTIU : begin

                `uvm_info("SLTIU", "Instruction SLTIU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            SLTU : begin

                `uvm_info("SLTU", "Instruction SLTU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SRA : begin

                `uvm_info("SRA", "Instruction SRA detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SRL : begin

                `uvm_info("SRL", "Instruction SRL detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SUB : begin

                `uvm_info("SUB", "Instruction SUB detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            SW : begin

                `uvm_info("SW", "Instruction SW detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};

            end

            XOR : begin

                `uvm_info("XOR", "Instruction XOR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];

            end

            XORI : begin

                `uvm_info("XORI", "Instruction XORI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];

            end

            default: `uvm_error("UNKNOWN", "Unknown instruction detected")

        endcase


    endfunction : decode_opcode


endclass : uvmc_riscv_opcodes

`endif // __uvmc_riscv_opcodes_SV__
