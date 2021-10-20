# CKCat @ 2021.10.19

MAKEFLAGS = -sR
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

ASM		= nasm
CC		= gcc
LD		= ld
OBJCOPY	= objcopy

ASMBFLAGS	= -f elf -w-orphan-labels
CFLAGS		= -c -Os -std=c99 -m32 -Wall -Wshadow -W -Wconversion -Wno-sign-conversion  -fno-stack-protector -fomit-frame-pointer -fno-builtin -fno-common  -ffreestanding  -Wno-unused-parameter -Wunused-variable
LDFLAGS		= -s -static -T hello.lds -n -Map HelloOS.map 
OJCYFLAGS	= -S -O binary

HELLOOS_OBJS :=
HELLOOS_OBJS += entry.o main.o vgastr.o
HELLOOS_ELF = HelloOS.elf
HELLOOS_BIN = HelloOS.bin

# 定义伪目标
.PHONY : build clean all link bin

# 伪目标 all 依赖于伪目标 clean build link bin
all: clean build link bin

clean:
	$(RM) -f *.o *.bin *.elf *.map

build: $(HELLOOS_OBJS)

link: $(HELLOOS_ELF)
$(HELLOOS_ELF): $(HELLOOS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(HELLOOS_OBJS)

bin: $(HELLOOS_BIN)
$(HELLOOS_BIN): $(HELLOOS_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@

%.o : %.asm
	$(ASM) $(ASMBFLAGS) -o $@ $<
%.o : %.c
	$(CC) $(CFLAGS) -o $@ $<

KERNEL = kernel

update_image:
ifneq ($(wildcard $(KERNEL)/.*),)
	 @echo "Found $(KERNEL)."
else
	@echo "mkdir $(KERNEL)."
	@mkdir $(KERNEL)
endif
	sudo mount floppy.img $(KERNEL)
	sudo cp $(HELLOOS_BIN) $(KERNEL)/hx_kernel
	sleep 1
	sudo umount $(KERNEL)

qemu:
	qemu-system-i386 -fda floppy.img -boot a

