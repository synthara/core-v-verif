
    
    
`ifndef __uvmc_riscv_opcodes_SV__
`define __uvmc_riscv_opcodes_SV__

import riscv_instr::*;

class uvmc_riscv_opcodes extends uvm_component;

    string file_path = "";
	int mem[int];

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
        	end

        	ADDI : begin
                `uvm_info("ADDI", "Instruction ADDI detected successfully", UVM_LOW)
        	end

        	AND : begin
                `uvm_info("AND", "Instruction AND detected successfully", UVM_LOW)
        	end

        	ANDI : begin
                `uvm_info("ANDI", "Instruction ANDI detected successfully", UVM_LOW)
        	end

        	AUIPC : begin
                `uvm_info("AUIPC", "Instruction AUIPC detected successfully", UVM_LOW)
        	end

        	BEQ : begin
                `uvm_info("BEQ", "Instruction BEQ detected successfully", UVM_LOW)
        	end

        	BGE : begin
                `uvm_info("BGE", "Instruction BGE detected successfully", UVM_LOW)
        	end

        	BGEU : begin
                `uvm_info("BGEU", "Instruction BGEU detected successfully", UVM_LOW)
        	end

        	BLT : begin
                `uvm_info("BLT", "Instruction BLT detected successfully", UVM_LOW)
        	end

        	BLTU : begin
                `uvm_info("BLTU", "Instruction BLTU detected successfully", UVM_LOW)
        	end

        	BNE : begin
                `uvm_info("BNE", "Instruction BNE detected successfully", UVM_LOW)
        	end

        	C_ADD : begin
                `uvm_info("C_ADD", "Instruction C_ADD detected successfully", UVM_LOW)
        	end

        	C_ADDI : begin
                `uvm_info("C_ADDI", "Instruction C_ADDI detected successfully", UVM_LOW)
        	end

        	C_ADDI16SP : begin
                `uvm_info("C_ADDI16SP", "Instruction C_ADDI16SP detected successfully", UVM_LOW)
        	end

        	C_ADDI4SPN : begin
                `uvm_info("C_ADDI4SPN", "Instruction C_ADDI4SPN detected successfully", UVM_LOW)
        	end

        	C_AND : begin
                `uvm_info("C_AND", "Instruction C_AND detected successfully", UVM_LOW)
        	end

        	C_ANDI : begin
                `uvm_info("C_ANDI", "Instruction C_ANDI detected successfully", UVM_LOW)
        	end

        	C_BEQZ : begin
                `uvm_info("C_BEQZ", "Instruction C_BEQZ detected successfully", UVM_LOW)
        	end

        	C_BNEZ : begin
                `uvm_info("C_BNEZ", "Instruction C_BNEZ detected successfully", UVM_LOW)
        	end

        	C_EBREAK : begin
                `uvm_info("C_EBREAK", "Instruction C_EBREAK detected successfully", UVM_LOW)
        	end

        	C_J : begin
                `uvm_info("C_J", "Instruction C_J detected successfully", UVM_LOW)
        	end

        	C_JALR : begin
                `uvm_info("C_JALR", "Instruction C_JALR detected successfully", UVM_LOW)
        	end

        	C_JR : begin
                `uvm_info("C_JR", "Instruction C_JR detected successfully", UVM_LOW)
        	end

        	C_LI : begin
                `uvm_info("C_LI", "Instruction C_LI detected successfully", UVM_LOW)
        	end

        	C_LUI : begin
                `uvm_info("C_LUI", "Instruction C_LUI detected successfully", UVM_LOW)
        	end

        	C_LW : begin
                `uvm_info("C_LW", "Instruction C_LW detected successfully", UVM_LOW)
        	end

        	C_LWSP : begin
                `uvm_info("C_LWSP", "Instruction C_LWSP detected successfully", UVM_LOW)
        	end

        	C_MV : begin
                `uvm_info("C_MV", "Instruction C_MV detected successfully", UVM_LOW)
        	end

        	C_NOP : begin
                `uvm_info("C_NOP", "Instruction C_NOP detected successfully", UVM_LOW)
        	end

        	C_OR : begin
                `uvm_info("C_OR", "Instruction C_OR detected successfully", UVM_LOW)
        	end

        	C_SUB : begin
                `uvm_info("C_SUB", "Instruction C_SUB detected successfully", UVM_LOW)
        	end

        	C_SW : begin
                `uvm_info("C_SW", "Instruction C_SW detected successfully", UVM_LOW)
        	end

        	C_SWSP : begin
                `uvm_info("C_SWSP", "Instruction C_SWSP detected successfully", UVM_LOW)
        	end

        	C_XOR : begin
                `uvm_info("C_XOR", "Instruction C_XOR detected successfully", UVM_LOW)
        	end

        	DIV : begin
                `uvm_info("DIV", "Instruction DIV detected successfully", UVM_LOW)
        	end

        	DIVU : begin
                `uvm_info("DIVU", "Instruction DIVU detected successfully", UVM_LOW)
        	end

        	EBREAK : begin
                `uvm_info("EBREAK", "Instruction EBREAK detected successfully", UVM_LOW)
        	end

        	ECALL : begin
                `uvm_info("ECALL", "Instruction ECALL detected successfully", UVM_LOW)
        	end

        	FENCE : begin
                `uvm_info("FENCE", "Instruction FENCE detected successfully", UVM_LOW)
        	end

        	JAL : begin
                `uvm_info("JAL", "Instruction JAL detected successfully", UVM_LOW)
        	end

        	JALR : begin
                `uvm_info("JALR", "Instruction JALR detected successfully", UVM_LOW)
        	end

        	LB : begin
                `uvm_info("LB", "Instruction LB detected successfully", UVM_LOW)
        	end

        	LBU : begin
                `uvm_info("LBU", "Instruction LBU detected successfully", UVM_LOW)
        	end

        	LH : begin
                `uvm_info("LH", "Instruction LH detected successfully", UVM_LOW)
        	end

        	LHU : begin
                `uvm_info("LHU", "Instruction LHU detected successfully", UVM_LOW)
        	end

        	LUI : begin
                `uvm_info("LUI", "Instruction LUI detected successfully", UVM_LOW)
        	end

        	LW : begin
                `uvm_info("LW", "Instruction LW detected successfully", UVM_LOW)
        	end

        	MUL : begin
                `uvm_info("MUL", "Instruction MUL detected successfully", UVM_LOW)
        	end

        	MULH : begin
                `uvm_info("MULH", "Instruction MULH detected successfully", UVM_LOW)
        	end

        	MULHSU : begin
                `uvm_info("MULHSU", "Instruction MULHSU detected successfully", UVM_LOW)
        	end

        	MULHU : begin
                `uvm_info("MULHU", "Instruction MULHU detected successfully", UVM_LOW)
        	end

        	OR : begin
                `uvm_info("OR", "Instruction OR detected successfully", UVM_LOW)
        	end

        	ORI : begin
                `uvm_info("ORI", "Instruction ORI detected successfully", UVM_LOW)
        	end

        	REM : begin
                `uvm_info("REM", "Instruction REM detected successfully", UVM_LOW)
        	end

        	REMU : begin
                `uvm_info("REMU", "Instruction REMU detected successfully", UVM_LOW)
        	end

        	SB : begin
                `uvm_info("SB", "Instruction SB detected successfully", UVM_LOW)
        	end

        	SH : begin
                `uvm_info("SH", "Instruction SH detected successfully", UVM_LOW)
        	end

        	SLL : begin
                `uvm_info("SLL", "Instruction SLL detected successfully", UVM_LOW)
        	end

        	SLT : begin
                `uvm_info("SLT", "Instruction SLT detected successfully", UVM_LOW)
        	end

        	SLTI : begin
                `uvm_info("SLTI", "Instruction SLTI detected successfully", UVM_LOW)
        	end

        	SLTIU : begin
                `uvm_info("SLTIU", "Instruction SLTIU detected successfully", UVM_LOW)
        	end

        	SLTU : begin
                `uvm_info("SLTU", "Instruction SLTU detected successfully", UVM_LOW)
        	end

        	SRA : begin
                `uvm_info("SRA", "Instruction SRA detected successfully", UVM_LOW)
        	end

        	SRL : begin
                `uvm_info("SRL", "Instruction SRL detected successfully", UVM_LOW)
        	end

        	SUB : begin
                `uvm_info("SUB", "Instruction SUB detected successfully", UVM_LOW)
        	end

        	SW : begin
                `uvm_info("SW", "Instruction SW detected successfully", UVM_LOW)
        	end

        	XOR : begin
                `uvm_info("XOR", "Instruction XOR detected successfully", UVM_LOW)
        	end

        	XORI : begin
                `uvm_info("XORI", "Instruction XORI detected successfully", UVM_LOW)
        	end

        	default: `uvm_error("UNKNOWN", "Unknown instruction detected")
        endcase


    endfunction : decode_opcode


endclass : uvmc_riscv_opcodes

`endif // __uvmc_riscv_opcodes_SV__
