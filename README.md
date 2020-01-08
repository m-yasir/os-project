# Operating Systems Lab (CS3220/CS3221) Project Repository
This repository was created in order to coordinate and synchronize modules being implemented by the group members working on the xv6 kernel.

This project requires ELF supported GCC compiler in order to compile it, which will not work on MACOSX due to non-ELF CLANG compiler implemented in MACOSX, unless you follow a workaround which won't be explained here.

### Tools required to build the kernel

- ELF-supported gcc compiler
- qemu (installation for a real device isn't explained or shown here though it is indeed possible)
- make
- utils needed to execute make

#### Installation on Linux:

```
sudo apt install make gcc binutils qemu
```


- In order to build code
```
make
```
- Run it on an emulator, in this case, qemu (use qemu-nox if you want to use your terminal as opposed to qemu's).
```
make qemu
```
