CV_SW_TOOLCHAIN  ?= /opt/riscv
RISCV            ?= $(CV_SW_TOOLCHAIN)
RISCV_EXE_PREFIX ?= $(RISCV)/bin/riscv32-unknown-elf-
RISCV_GCC = $(RISCV_EXE_PREFIX)gcc
RISCV_AR = $(RISCV_EXE_PREFIX)ar
SRC = crt0.S syscalls.c
OBJ = crt0.o syscalls.o
LIBCV-VERIF = libcv-verif.a
#CFLAGS ?= -static -mabi=$(RISCV_MABI) -march=$(RISCV_MARCH) -Wall -pedantic  -std=gnu99 -static -O2 -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns $(RISCV_USER_CFLAGS)
CFLAGS ?= -Os -g -static -mabi=$(RISCV_MABI) -march=$(RISCV_MARCH) -Wall -pedantic

all: $(LIBCV-VERIF)

$(LIBCV-VERIF): $(OBJ)
	$(RISCV_AR) rcs $@ $(OBJ)

%.o : %.c
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

%.o : %.S
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(LIBCV-VERIF)


vars:
	@echo "make bsp variables:"
	@echo "   CV_SW_TOOLCHAIN  = $(CV_SW_TOOLCHAIN)"
	@echo "   RISCV            = $(RISCV)"
	@echo "   RISCV_EXE_PREFIX = $(RISCV_EXE_PREFIX)"
	@echo "   RISCV_GCC        = $(RISCV_GCC)"

