global main
extern GetStdHandle
extern WriteConsoleA

section .data
    msg: db "So come rain on my parade, i think its too late", 0x0A

section .bss
    written resd 1

section .text
main:
; пушим в стек адрес, куда должны вернуться после нашей программы
    push rbx
; выделяем 64 байта в стеке - важно вернуть столько же, чтобы программа не крашнулась
    sub  rsp, 64

; здесь по WindowsAPI кладем статус код -11 в ecx для GetStdHandle(ecx)
    mov  ecx, -11
; читает ecx и возвращает номер дескриптора в rax
    call GetStdHandle

; сохраняем id дескриптора в rcx, потому что WriteConsoleA затрет rax (вернет туда ответ)
    mov  rcx, rax
; loadeffectiveaddress - загрузить адрес. Вычесляем адрес и исп в качестве аргумента, откуда WriteConsoleA брать строку для принта
; [...] - обозначение "по этому адресу". rel - определяет адрес относительно текущего положения кода (RIP-регистр)
    lea  rdx, [rel msg]
; помещаем количество символов для принта (используется в качестве аргумента в WriteConsoleA)
    mov  r8d, 32
; это для того, чтобы WriteConsoleA вернула кол-во выведенных символов (обязательно нужно для этой функции)
    lea  r9, [rel written]
; помещаем в адрес rsp + 32 значение 0 в виде 8 байт (rsp) - пятый аргумент для WriteConsoleA
    mov  qword [rsp+32], 0
; вызов функции для принта строки
    call WriteConsoleA

; вовзращаем все взад
    add  rsp, 64
    pop  rbx
; обнуляем eax, чтобы был return 0 для C
    xor  eax, eax
    ret

; Регситры общего назначения: 
;   AX - arithmetic operation
;   BX - pointer
;   CX - counter
;   DX - data for extended arithmetic opertions
; Индексные регистры: 
;   SI - source index
;   DI - destination index
; Регистраы-указатели: 
;   SP - stack pointer - начало
;   BP - base pointer - конец
;   IP - instruction pointer
; Сегментные регистры: 
;   CS - 
;   DS - 
;   SS - 
;   ES - 
;   GS -  
;   FS - 
; Регистры управления: FLAGS
; r8-r15

; DH + Dl = DX (8 бит + 8 бит = 16 бит)
; DX + DX = EDX (32 бита)
; EDX + EDX = RDX (64 бита)


; cmd op1, op2:
; mov ax, 5 - поместить в регистр ax число 5
; mov ax, bx - скопировать из bx в ax
; mov  rdx, [rel msg] - иди по адресу msg и принеси то, что там лежит (содержимое)
; lea  rdx, [rel msg] - просто вычисли сам адрес msg и положи его (никуда не ходит)