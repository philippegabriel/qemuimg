.PHONY: clean
targets=boot.o kernel.o myos.bin myos.iso
all: $(targets)
boot.o: boot.s
	i686-elf-as $< -o $@
kernel.o: kernel.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra
myos.bin: boot.o kernel.o
	i686-elf-gcc -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $^ -lgcc
myos.iso:
	mkdir -p isodir
	mkdir -p isodir/boot
	cp myos.bin isodir/boot/myos.bin
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
clean:
	rm -f $(targets)
