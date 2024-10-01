reg_t lo = ((sreg_t(RS1) & 0x0000FFFF) > (sreg_t(RS2) & 0x0000FFFF) ? (RS1 & 0x0000FFFF) : (RS2 & 0x0000FFFF));
reg_t hi = ((sreg_t(RS1) & 0xFFFF0000) > (sreg_t(RS2) & 0xFFFF0000) ? (RS1 & 0xFFFF0000) : (RS2 & 0xFFFF0000));
WRITE_RD(sext_xlen(lo | hi));