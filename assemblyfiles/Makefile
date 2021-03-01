# usage 

# make bin/file_name  compile that specific .asm file
# make                compile all .asm files to ./bin directory
# make clean          remove all possible* objects in . and all executable files in ./bin
# make gdb            setup all the files and commands for debugging with gdb
#-s: * as make - by default - remove intermidiate files. See Chained Rules in make documentation.

#
# Variables 
#

# assembly compiler variable and its flags variables 
AS = nasm
ASFLAGS = -f elf64 -gdwarf 
# -f select "elf64" output format
# -gdarf generate  debugging information in "dwarf" format

# linker variable
LD = ld

# all the .asm files at the directory
SRC_DIR = src
SRC = $(wildcard $(SRC_DIR)/*.asm)

# all file names without the extension
BINS_DIR = bin
BINS = $(notdir $(basename $(SRC)))

# all object files
BUILD_DIR = build

# all executable files to compile
LIST = $(addprefix $(BINS_DIR)/, $(BINS))

#
# Targets 
#

# targes that do not represent archives
.PHONY: clean gdb 

all: $(LIST)

$(BINS_DIR)/%: $(BUILD_DIR)/%.o
	@chmod u+x $@  

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p bin/ build/            
	@$(AS) -o $@ $(ASFLAGS) $<
	@$(LD) -o $(BINS_DIR)/$* $@
# mkdir -p creates the directory as needed

gdb: $(BINS_DIR)/.gdbinit
	@if grep -q 'set auto-load safe-path $(PWD)/$(BINS_DIR)' ~/.gdbinit; then \
		:; \
	else \
		echo "set auto-load safe-path $(PWD)/$(BINS_DIR)" >> ~/.gdbinit; \
	fi
# : is the no-op command in shell

$(BINS_DIR)/.gdbinit: ~/.gdbinit
	@touch $(BINS_DIR)/.gdbinit
	@echo "set disassembly-flavor intel" >> $@
	@echo "dir $(PWD)/$(SRC_DIR)" >> $@
	@echo "b _start" >> $@
	@echo "start" >> $@
	@echo "layout asm" >> $@
	@echo "layout regs" >> $@
	@echo "GDB setup completed"

~/.gdbinit:
	@touch $@
	@echo "set auto-load safe-path $(PWD)/$(BINS_DIR)" >> $@

clean:
	@echo "Cleaning up"
	rm -f $(LIST)

#*****************************************************************************
# cheat-sheet about makefile:
#$(wildcard pattern) = expansion to all files that match that "pattern"

#$(notdir ) = takes away the path from the file name

#$(basename ) = extract all things but those after the period

#$(addprefix prefix, names) = "prefix" is prepended to the front of each individual name in "names"
#                             and concatenate "prefix/name1" with "prefix/name2" with single space 

#$@ = the file name of the target
#$< = name of the first prerequisite
#$* = matches the target file name without the extension
