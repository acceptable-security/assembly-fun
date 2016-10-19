#/bin/bash

function compile {
    {
        nasm -g -f elf32 $1.asm && \
        ld -melf_i386 -L/usr/lib32 -I/usr/lib32/ld-linux.so.2 -lc -o $1 $1.o && \
        rm $1.o && \
        echo "Successfuly compiled $1"
    } || {
        echo "Failed to compile $1"
    }
}

if [ -z $1 ]
then
    echo "Usage $0 program"
else
    compile $1
fi
