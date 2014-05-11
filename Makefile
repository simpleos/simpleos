# Config
ASM=nasm
ASFLAGS=
EMU=qemu-system-i386
EMUFLAGS=-fdb disk/floppy.img -hdc disk/disk.img

all: boot disk

boot: boot/boot.bin
boot/boot.bin: boot/boot.asm
	$(ASM) $(ASFLAGS) -f bin boot/boot.asm -o boot/boot.bin

disk: disk/disk.img disk/floppy.img
disk/disk.img:
	qemu-img create -f raw disk/disk.img 32M
disk/floppy.img:
	qemu-img create -f raw disk/floppy.img 1440K

clean:
	rm -f boot/*.bin
clean-disk:
	rm -f disk/*.img
clean-all: clean clean-disk

test: boot disk
	$(EMU) $(EMUFLAGS) boot/boot.bin
debug: boot disk
	echo "Connect with gdb on port 1234 and than press 'c' in gdb to start execution."
	echo "Use 'target remote localhost:1234' in gdb to connect and set arch with 'set architecture i8086'"
	$(EMU) $(EMUFLAGS) -s -S boot/boot.bin
