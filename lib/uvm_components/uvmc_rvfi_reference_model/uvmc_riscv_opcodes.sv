
`ifndef __uvmc_riscv_opcodes_SV__
`define __uvmc_riscv_opcodes_SV__

import riscv_instr::*;

class uvmc_riscv_opcodes extends uvm_component;

    string file_path = "";
    int mem[int];
    int incr;

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
    bit [31:0] immuj;
    bit [31:0] pc;
    bit [63:0] reg_mul;
    bit [4:0] shamtw;
    bit [11:0] csr;
    bit [4:0] zimm5;
    bit [31:0] reg_file[31:0];
    

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

        for (int pc = 2147483648; pc < 2147552788; pc += incr) begin
            logic [31:0] instruction;
            instruction = {mem[pc+3][7:0], mem[pc+2][7:0], mem[pc+1][7:0], mem[pc][7:0]};
            $display("Instruction: %h", instruction);
            $display("Il valore del program counter di questa istruzione è: %h", pc);

            pc = decode_opcode(instruction, pc);
        end

    endfunction : new



    function bit [31:0] decode_opcode(bit[31:0] instr, bit[31:0] pc);

        incr = 4;

    
        casez (instr)

            ADD : begin

                `uvm_info("ADD", "Instruction ADD detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] + reg_file[rs2];

            end

            ADDI : begin

                `uvm_info("ADDI", "Instruction ADDI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = reg_file[rs1] + imm12;

            end

            AND : begin

                `uvm_info("AND", "Instruction AND detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] & reg_file[rs2];

            end

            ANDI : begin

                `uvm_info("ANDI", "Instruction ANDI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = reg_file[rs1] & imm12;

            end

            AUIPC : begin

                `uvm_info("AUIPC", "Instruction AUIPC detected successfully", UVM_LOW)
                rd = instr[11:7];
                imm20 = instr[31:12];
                reg_file[rd] = pc + (imm20 << 12);

            end

            BEQ : begin

                `uvm_info("BEQ", "Instruction BEQ detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if (reg_file[rs1] == reg_file[rs2])
					pc = pc + immsb;

            end

            BGE : begin

                `uvm_info("BGE", "Instruction BGE detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if ($signed(reg_file[rs1]) >= $signed(reg_file[rs2]))
					pc = pc + immsb;

            end

            BGEU : begin

                `uvm_info("BGEU", "Instruction BGEU detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if (reg_file[rs1] >= reg_file[rs2])
					pc = pc + immsb;

            end

            BLT : begin

                `uvm_info("BLT", "Instruction BLT detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if ($signed(reg_file[rs1]) < $signed(reg_file[rs2]))
					pc = pc + immsb;

            end

            BLTU : begin

                `uvm_info("BLTU", "Instruction BLTU detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if (reg_file[rs1] < reg_file[rs2])
					pc = pc + immsb;

            end

            BNE : begin

                `uvm_info("BNE", "Instruction BNE detected successfully", UVM_LOW)
                bimm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                bimm12lo = instr[11:7];
                immsb = {bimm12hi[6], bimm12lo[0], bimm12hi[5:0], bimm12lo[4:1], 1'b0};
                if (reg_file[rs1] != reg_file[rs2])
					pc = pc + immsb;

            end

            CSRRC : begin

                `uvm_info("CSRRC", "Instruction CSRRC detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                csr = instr[31:20];
                //csrrc;

            end

            CSRRCI : begin

                `uvm_info("CSRRCI", "Instruction CSRRCI detected successfully", UVM_LOW)
                rd = instr[11:7];
                csr = instr[31:20];
                zimm5 = instr[19:15];
                //csrrci;

            end

            CSRRS : begin

                `uvm_info("CSRRS", "Instruction CSRRS detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                csr = instr[31:20];
                //csrrs;

            end

            CSRRSI : begin

                `uvm_info("CSRRSI", "Instruction CSRRSI detected successfully", UVM_LOW)
                rd = instr[11:7];
                csr = instr[31:20];
                zimm5 = instr[19:15];
                //csrrsi;

            end

            CSRRW : begin

                `uvm_info("CSRRW", "Instruction CSRRW detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                csr = instr[31:20];
                //csrrw;

            end

            CSRRWI : begin

                `uvm_info("CSRRWI", "Instruction CSRRWI detected successfully", UVM_LOW)
                rd = instr[11:7];
                csr = instr[31:20];
                zimm5 = instr[19:15];
                //csrrwi;

            end

            DIV : begin

                `uvm_info("DIV", "Instruction DIV detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = $signed(reg_file[rs1]) / $signed(reg_file[rs2]);

            end

            DIVU : begin

                `uvm_info("DIVU", "Instruction DIVU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] / reg_file[rs2];

            end

            EBREAK : begin

                `uvm_info("EBREAK", "Instruction EBREAK detected successfully", UVM_LOW)
                // ebreak;

            end

            ECALL : begin

                `uvm_info("ECALL", "Instruction ECALL detected successfully", UVM_LOW)
                // ecall;

            end

            FENCE : begin

                `uvm_info("FENCE", "Instruction FENCE detected successfully", UVM_LOW)
                fm = instr[31:28];
                pred = instr[27:24];
                succ = instr[23:20];
                rs1 = instr[19:15];
                rd = instr[11:7];
                // fence;

            end

            JAL : begin

                `uvm_info("JAL", "Instruction JAL detected successfully", UVM_LOW)
                rd = instr[11:7];
                jimm20 = instr[31:12];
                immuj = {{11{jimm20[19]}},jimm20[19], jimm20[7:0], jimm20[8], jimm20[18:9], 1'b0};
                incr = 0;
                reg_file[rd] = pc + 4;
				pc = pc + immuj;

            end

            JALR : begin

                `uvm_info("JALR", "Instruction JALR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = pc + 4;
				pc = (reg_file[rs1] + imm12) & ~1;

            end

            LB : begin

                `uvm_info("LB", "Instruction LB detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = {{24{mem[reg_file[rs1] + imm12][7]}}, mem[reg_file[rs1] + imm12][7:0]};;

            end

            LBU : begin

                `uvm_info("LBU", "Instruction LBU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = {24'b0, mem[reg_file[rs1] + imm12][7:0]};

            end

            LH : begin

                `uvm_info("LH", "Instruction LH detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = {{16{mem[reg_file[rs1] + imm12][15]}}, mem[reg_file[rs1] + imm12][15:0]};;

            end

            LHU : begin

                `uvm_info("LHU", "Instruction LHU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = {16'b0, mem[reg_file[rs1] + imm12][15:0]};

            end

            LUI : begin

                `uvm_info("LUI", "Instruction LUI detected successfully", UVM_LOW)
                rd = instr[11:7];
                imm20 = instr[31:12];
                reg_file[rd] = imm20 << 12;

            end

            LW : begin

                `uvm_info("LW", "Instruction LW detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = mem[reg_file[rs1] + imm12];

            end

            MUL : begin

                `uvm_info("MUL", "Instruction MUL detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_mul = $signed(reg_file[rs1]) * $signed(reg_file[rs2]);
				reg_file[rd] = reg_mul[31:0];

            end

            MULH : begin

                `uvm_info("MULH", "Instruction MULH detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_mul = $signed(reg_file[rs1]) * $signed(reg_file[rs2]);
				reg_file[rd] = reg_mul[63:32];

            end

            MULHSU : begin

                `uvm_info("MULHSU", "Instruction MULHSU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_mul = $signed(reg_file[rs1]) * reg_file[rs2];
				reg_file[rd] = reg_mul[63:32];

            end

            MULHU : begin

                `uvm_info("MULHU", "Instruction MULHU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_mul = reg_file[rs1] * reg_file[rs2];
				reg_file[rd] = reg_mul[63:32];

            end

            OR : begin

                `uvm_info("OR", "Instruction OR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] | reg_file[rs2];

            end

            ORI : begin

                `uvm_info("ORI", "Instruction ORI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = reg_file[rs1] | imm12;

            end

            REM : begin

                `uvm_info("REM", "Instruction REM detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = $signed(reg_file[rs1]) % $signed(reg_file[rs2]);

            end

            REMU : begin

                `uvm_info("REMU", "Instruction REMU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] % reg_file[rs2];

            end

            SB : begin

                `uvm_info("SB", "Instruction SB detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};
                mem[reg_file[rs1] + imms][7:0] = reg_file[rs2];

            end

            SH : begin

                `uvm_info("SH", "Instruction SH detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};
                mem[reg_file[rs1] + imms][15:0] = reg_file[rs2];

            end

            SLL : begin

                `uvm_info("SLL", "Instruction SLL detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] << reg_file[rs2];

            end

            SLLI : begin

                `uvm_info("SLLI", "Instruction SLLI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                shamtw = instr[24:20];
                reg_file[rd] = reg_file[rs1] << shamtw;

            end

            SLT : begin

                `uvm_info("SLT", "Instruction SLT detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                if ($signed(reg_file[rs1]) < $signed(reg_file[rs2]))
					reg_file[rd] = 1;
				else
					reg_file[rd] = 0;;

            end

            SLTI : begin

                `uvm_info("SLTI", "Instruction SLTI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                if ($signed(reg_file[rs1]) < $signed(imm12))
					reg_file[rd] = 1;
				else
					reg_file[rd] = 0;;

            end

            SLTIU : begin

                `uvm_info("SLTIU", "Instruction SLTIU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                if (reg_file[rs1] < imm12)
					reg_file[rd] = 1;
				else
					reg_file[rd] = 0;;

            end

            SLTU : begin

                `uvm_info("SLTU", "Instruction SLTU detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                if (reg_file[rs1] < reg_file[rs2])
					reg_file[rd] = 1;
				else
					reg_file[rd] = 0;;

            end

            SRA : begin

                `uvm_info("SRA", "Instruction SRA detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] >>> reg_file[rs2];

            end

            SRAI : begin

                `uvm_info("SRAI", "Instruction SRAI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                shamtw = instr[24:20];
                reg_file[rd] = reg_file[rs1] >>> shamtw;

            end

            SRL : begin

                `uvm_info("SRL", "Instruction SRL detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] >> reg_file[rs2];

            end

            SRLI : begin

                `uvm_info("SRLI", "Instruction SRLI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                shamtw = instr[24:20];
                reg_file[rd] = reg_file[rs1] >> shamtw;

            end

            SUB : begin

                `uvm_info("SUB", "Instruction SUB detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] - reg_file[rs2];

            end

            SW : begin

                `uvm_info("SW", "Instruction SW detected successfully", UVM_LOW)
                imm12hi = instr[31:25];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                imm12lo = instr[11:7];
                imms = {imm12hi, imm12lo};
                mem[reg_file[rs1] + imms] = reg_file[rs2];

            end

            XOR : begin

                `uvm_info("XOR", "Instruction XOR detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                reg_file[rd] = reg_file[rs1] ^ reg_file[rs2];

            end

            XORI : begin

                `uvm_info("XORI", "Instruction XORI detected successfully", UVM_LOW)
                rd = instr[11:7];
                rs1 = instr[19:15];
                imm12 = instr[31:20];
                reg_file[rd] = reg_file[rs1] ^ imm12;

            end

            default: begin
                `uvm_error("UNKNOWN", "Unknown instruction detected")
                    incr = 2;
                end


        endcase


        return pc;

    endfunction : decode_opcode


endclass : uvmc_riscv_opcodes

`endif // __uvmc_riscv_opcodes_SV__
