# Usage 

# make file_name: compile that specific .asm file
# make: compile all .asm files
# make clean: remove all possible* objects and all executable files
# * as make - by default - remove intermidiate files. See Chained Rules in make documentation.

# Alvos que não representam arquivos
.PHONY: clean

# Assembly compiler variable and its flags variables 
AS = nasm
ASFLAGS = -f elf64

# Linker variable
LD = ld

# All the .asm files at the directory 
SRC = $(wildcard *.asm)

# All file names without the extension
BINS = $(basename ${SRC})

all: ${BINS}

%: %.o
	@echo "Turning it into a executable"
	chmod u+x $@ $<   

%.o: %.asm
	@echo "Creating object file"
	${AS} -o $@ ${ASFLAGS} $<
	@echo "Linking"
	${LD} -o $* $@

clean:
	@echo "Cleaning up"
	rm -f *.o  ${BINS}
