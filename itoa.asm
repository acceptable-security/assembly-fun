section .text

%include "linux.mac"
extern malloc, free, puts

; log10
; eax = log10(eax)
global log10
_log10:
    push ebp
    mov ebp, esp

    ; Setup the function
    ; Move the value into eax and 0 ebx
    xor ebx, ebx
    mov ecx, 10

    log10loop:
    xor edx, edx
    ; if ebx is 0, stop
    cmp eax, 0
    je done

    ; divide the value by 10, increase the counter, and keep going.
    div ecx
    inc ebx
    jmp log10loop

    done:
    mov eax, ebx
    mov esp, ebp
    pop ebp
    ret

global itoa
_itoa:
    push ebp
    mov ebp, esp

    ; Store value in ebx and get length in eax
    push eax
    call _log10
    pop ebx

    ; Leave room for a null byte and allocate.
    push ebx ; hold the value >-----------------------+
                                                      ;
    inc eax                                           ; malloc will garble
    push eax ; >---+                                  ; eax, ebx, and ecx
    call malloc    ; Keeps the value for              ; and put it's value
    pop ecx  ; <---+ offsets                          ;
    mov esi, eax ; Store the buffer in esi            ; store the input in
    mov byte [eax + ecx], 0                           ; the stack.
    dec ecx ; Don't want null byte                    ;
    pop eax ; put back into eax <---------------------+

    mov ebx, 10  ; divisor

    itoaloop:
    ; if we've hit 0, stop.
    cmp eax, 0
    je endloop

    xor edx, edx ; Dont want anything here
    ; divide/mod eax by 10
    ; result is in eax, and remainder is in edx.
    div ebx
    add edx, 48 ; 4 is the first number in ASCII
    dec ecx ; decrement i
    mov [esi + ecx], dl ; Store in the string
    jmp itoaloop

    endloop:

    mov eax, esi ; Store buffer in eax

    mov esp, ebp
    pop ebp
    ret

global _start
_start:
    mov eax, 45236
    call _itoa

    push eax
    call puts
    pop eax

    push eax
    call free
    add esp, 4

    mov eax, 0
    sys_exit 0
