section .data
    hello db "Hello, World!"
    hello_size equ $ - hello

section .text

%include "linux.mac"

global _start
_start:
    mov ebp, esp

    sys_write hello, hello_size
    sys_exit 0
