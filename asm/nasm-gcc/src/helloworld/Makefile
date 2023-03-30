
ASM=nasm

.PHONY: all

all: helloworld

helloworld: helloworld.o
	ld -o helloworld helloworld.o

helloworld.o:
	$(ASM) -f macho64 helloworld.asm