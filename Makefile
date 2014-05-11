# Config
ASM=nasm
ASFLAGS=
CC=i386-elf-gcc
CCFLAGS=-Wall -g
LD=i386-elf-ld
LDFLAGS=
EMU=qemu-system-i386
EMUFLAGS=-fdb disk/floppy.img -hdc disk/disk.img

all: boot kernel disk

boot: boot/boot.bin
boot/boot.bin: boot/boot.asm
	$(ASM) $(ASFLAGS) -f bin boot/boot.asm -o boot/boot.bin

kernel: kernel/kernel.bin
kernel/kernel.bin: kernel/kernel_entry.o kernel/kernel.o
	$(LD) $(LDFLAGS) -o kernel/kernel.bin -Ttext 0x1000 $^ --oformat binary
kernel/kernel.o: kernel/kernel.c
	$(CC) $(CCFLAGS) -ffreestanding -c $< -o $@
kernel/kernel_entry.o: kernel/kernel_entry.asm
	$(ASM) $(ASFLAGS) $< -f elf -o $@

disk: disk/simpleos.img disk/floppy.img disk/disk.img
disk/simpleos.img: boot/boot.bin kernel/kernel.bin
	cat $^ > disk/simpleos.img
	qemu-img resize disk/simpleos.img 1440K
disk/floppy.img:
	qemu-img create -f raw disk/floppy.img 1440K
disk/disk.img:
	qemu-img create -f raw disk/disk.img 32M

clean:
	rm -f boot/*.bin
	rm -f kernel/*.bin kernel/*.o
clean-disk:
	rm -f disk/*.img
clean-all: clean clean-disk

test: disk
	$(EMU) $(EMUFLAGS) disk/simpleos.img
debug: disk
	echo "Connect with gdb on port 1234 and than press 'c' in gdb to start execution."
	echo "Use 'target remote localhost:1234' in gdb to connect and set arch with 'set architecture i8086'"
	$(EMU) $(EMUFLAGS) -s -S disk/simpleos.img
