# Config
ASM=nasm
ASFLAGS=
EMU=qemu-system-i386
EMUFLAGS=

all: boot

boot: boot/boot.bin
boot/boot.bin: boot/boot.asm
	$(ASM) $(ASFLAGS) -f bin boot/boot.asm -o boot/boot.bin

clean:
	rm -f boot/*.bin

test: boot
	$(EMU) $(EMUFLAGS) boot/boot.bin
debug: boot
	echo "Connect with gdb on port 1234 and than press 'c' to start execution."
	echo "Use gdb to connect 'target remote localhost:1234' and set arch 'set architecture i8086'"
	$(EMU) $(EMUFLAGS) -s -S boot/boot.bin
