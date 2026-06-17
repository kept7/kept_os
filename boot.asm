global main
extern printf

section .data
    msg db "Hello, World!", 0x0A, 0

section .text
main:
    sub rsp, 40
    lea rcx, [rel msg]
    call printf
    add rsp, 40
    xor eax, eax
    ret