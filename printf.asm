section .data
    teststr db "Hello!", 0

section .text

global _start:

%include "linux.mac"

; strlen(eax) -> ecx
_strlen:
    push ebp
    mov ebp, esp

    push eax
    push ecx
    xor ecx, ecx

    strlenloop:
    cmp byte [eax], 0
    je strlendone

    inc ecx
    inc eax

    jmp strlenloop
    strlendone:

    pop ecx
    pop eax

    pop ebp
    ret

_printf:
    push ebp
    mov ebp, esp

    push eax

    printfloop:

    cmp byte [eax], 0
    je printfdone

    cmp byte [eax], 37 ; % is our trigger
    jne printfprint

    ; We have a special!


    ; Print and loop
    printfprint:
    push eax
    sys_write eax, 1 ; write the current char from buffer
    pop eax
    inc eax
    jmp printfloop

    printfdone:
    pop eax

    pop ebp
    ret

_start:
    mov eax, teststr
    call _printf

    sys_exit 0
