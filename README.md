# Low-level programmig

Personal project to lean low-level coding inspired by the book: [Low-level programming: C, Assembly and program execution on Intel 64 architecture](https://www.apress.com/br/book/9781484224021) - by Igor Zhirkov.  
The official GitHub of the book can be found [here](https://github.com/Apress/low-level-programming).

Besides these original idea, this project turned into an opportunity to learn more about git, makefile, GNU GDB, GNU GCC and OS principles.

## Table of Contents
1. [Environment](#environment)
2. [Usage](#usage)
3. [License](#license)

## Environment

### Operating System
- Fedora 31 x86_64

- Linux kernel: 5.8.18-100

### Programs used
* __C compiler__: GCC Red Hat 9.3.1-2

* __ASM compiler__: NASM 2.14.02

* __Debugger__: GNU GDB 8.3.50.20190824-30.fc31

* __Make__: GNU MAKE 4.2.1


## Usage 

### Makefile  
#### 1. Assembly
In the `assemblyfiles` directory:
- Compile all the `.asm` files and create the `bin/` and `build/` directories.
```bash     
    make -s
```
- Compile that specific `.asm` file 
```bash 
    make bin/file_name -s
```
- Clean all the binaries 
```bash
    make clean 
```
- Create GDB setup and commands shortcuts for debugging
```bash
    make gdb
``` 

The `-s` flag hides the commands that are executed.  
[GNU Make manual](https://www.gnu.org/software/make/manual/make.html).  

---
#### 2. C language
In the `cfiles` directory:


### GNU GDB

All the layout and initial configuration is done by the commands written in `~/.gdbinit` and `assemblyfiles/bin/.gdbinit`.  
Besides that, all the commands can be found in [GNU GDB documentation](https://www.gnu.org/software/gdb/documentation/).


## License 

None
