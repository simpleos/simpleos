# Config
ASM=nasm
ASFLAGS=
EMU=qemu-system-i386

all: boot

boot: boot/boot.bin
boot/boot.bin: boot/boot.asm
	$(ASM) $(ASFLAGS) -f bin boot/boot.asm -o boot/boot.bin

clean:
	rm -f boot/*.bin

test: boot
#	make clean
#	make
	$(EMU) boot/boot.bin