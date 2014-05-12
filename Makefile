# config
ASM=nasm
ASFLAGS=
CC=i386-elf-gcc
CCFLAGS=-Wall -g
LD=i386-elf-ld
LDFLAGS=
EMU=qemu-system-i386
EMUFLAGS=-fdb disk/floppy.img -hdc disk/disk.img

# kernel files
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# TODO: Make sources dep on all header files.
OBJ = ${C_SOURCES:.c=.o}

# make targets
all: boot kernel disk

boot: boot/boot.bin

# kernel
kernel: kernel/kernel.bin
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	$(LD) $(LDFLAGS) -o $@ -Ttext 0x1000 $^ --oformat binary

# compile c files
%.o: %.c ${HEADERS}
	$(CC) $(CCFLAGS) -ffreestanding -c $< -o $@

#compile asm files
%.bin: %.asm
	$(ASM) $(ASFLAGS) -f bin $< -o $@
%.o: %.asm
	$(ASM) $(ASFLAGS) -f elf $< -o $@

# create disk images
disk: disk/simpleos.img disk/floppy.img disk/disk.img
disk/simpleos.img: boot/boot.bin kernel/kernel.bin
	cat $^ > disk/simpleos.img
	qemu-img resize disk/simpleos.img 1440K
disk/floppy.img:
	qemu-img create -f raw $@ 1440K
disk/disk.img:
	qemu-img create -f raw $@ 32M

# clean files
clean:
	rm -f boot/*.bin
	rm -f kernel/*.bin kernel/*.o
clean-disk:
	rm -f disk/*.img
clean-all: clean clean-disk

# test / debug os
test: disk
	$(EMU) $(EMUFLAGS) disk/simpleos.img
debug: disk
	echo "Connect with gdb on port 1234 and than press 'c' in gdb to start execution."
	echo "Use 'target remote localhost:1234' in gdb to connect and set arch with 'set architecture i8086'"
	$(EMU) $(EMUFLAGS) -s -S disk/simpleos.img
