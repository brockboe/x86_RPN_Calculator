gcc -c -g -o io.o io.c
gcc -g -o  input_test input_test.c
nasm -f  elf64 -g -F dwarf -o calc.o calc.asm
gcc -m64 -g io.o calc.o -o calculator
./calculator
