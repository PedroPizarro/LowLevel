# Personal project to learn low-level programmig

---

Inspired by the book: [Low-level programming: C, Assembly and program execution on Intel 64 architecture](https://www.apress.com/br/book/9781484224021), by Igor Zhirkov.

The official book GitHub can be found [here](https://github.com/Apress/low-level-programming).

## Environment

---

### Operating System
Fedora 31 x86_64

Linux kernel: 5.8.18-100

### Programs used
* __C compiler__: GCC Red Hat 9.3.1-2

* __ASM compiler__: NASM 2.14.02

* __Debugger__: GNU GDB 8.3.50.20190824-30.fc31

* __Text editor__: VSCode 1.52.1

* __Make__: GNU MAKE 4.2.1

---

### Usage 

#### Makefile

In the `AssemblyFiles` directory:
- Compile all the `.asm` files and create the `bin/` and `build/` directories.
```bash     
    make 
```
- Compile that specific `.asm` file 
```bash 
    make bin/file_name
```
- Clean all the binaries 
```bash
    make clean 
```

