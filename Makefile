# config
ASM=nasm
ASFLAGS=-I './boot/'
CC=i386-elf-g++
CCFLAGS=-Wall -g -Wextra
LD=i386-elf-ld
LDFLAGS=
EMU=qemu-system-i386
EMUFLAGS=-fdb disk/floppy.img -hdc disk/disk.img
EMU_IMG=qemu-img

# kernel files
CPP_FILES := $(wildcard kernel/*.cpp drivers/*.cpp)
OBJ_FILES := $(addprefix obj/,$(CPP_FILES:.cpp=.o))

# make targets
all: boot kernel disk

boot: boot/boot.bin

# kernel
kernel: kernel/kernel.bin
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ_FILES}
	$(LD) $(LDFLAGS) -o $@ -Ttext 0x1000 $^ --oformat binary

# compile c++ files
obj/kernel/%.o: kernel/%.cpp
	$(CC) $(CCFLAGS) -ffreestanding -c $< -o $@
obj/drivers/%.o: drivers/%.cpp
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
	$(EMU_IMG) resize disk/simpleos.img 1440K
disk/floppy.img:
	$(EMU_IMG) create -f raw $@ 1440K
disk/disk.img:
	$(EMU_IMG) create -f raw $@ 32M

# clean files
clean:
	rm -f boot/*.bin
	rm -f kernel/*.bin kernel/*.o
	rm -f drivers/*.o
	rm -f obj/kernel/*.o
	rm -f obj/drivers/*.o
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
