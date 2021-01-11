# Usage 

# make bin/file_name: compile that specific .asm file
# make: compile all .asm files to ./bin directory
# make clean: remove all possible* objects in . and all executable files in ./bin
# * as make - by default - remove intermidiate files. See Chained Rules in make documentation.

#*
#* Variables 
#*

# Assembly compiler variable and its flags variables 
AS = nasm
ASFLAGS = -f elf64

# Linker variable
LD = ld

# All the .asm files at the directory
SRC_DIR = src
SRC = $(wildcard $(SRC_DIR)/*.asm)

# All file names without the extension
BINS_DIR = bin
BINS = $(notdir $(basename $(SRC)))

# All object files
BUILD_DIR = build

# All executable files to compile
LIST = $(addprefix $(BINS_DIR)/, $(BINS))


#*
#* Targets 
#*

# Alvos que não representam arquivos
.PHONY: clean

all: $(LIST)

$(BINS_DIR)/%: $(BUILD_DIR)/%.o
	@echo "Turning it into a executable"
	chmod u+x $@  

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@echo "Creating object file"
	$(AS) -o $@ $(ASFLAGS) $<
	@echo "Linking"
	$(LD) -o $(BINS_DIR)/$* $@

clean:
	@echo "Cleaning up"
	rm -f *.o  $(LIST)


# Cheat-sheet:
#$(wildcard pattern) = expansion to all files that match that "pattern"

#$(notdir ) = takes away the path from the file name

#$(basename ) = extract all things before the period

#$(addprefix prefix, names) = "prefix" is prepended to the front of each individual name in "names"
#                             and concatenate "prefix/name1" with "prefix/name2" with single space 

#$@ = the file name of the target
#$< = name of the first prerequisite
#$* = matches the target file name without the extension

