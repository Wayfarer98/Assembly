        global _start

        section .data
msg	db	'Copy this string',0xa,0x0
dest	times 100 db 0x0
sys_write equ       1
sys_exit  equ       60
fp_stdout equ       1

        section .text
_start: 
        xor rcx, rcx		; Zero rcx

_getsize:
        inc rcx
        movzx r8, byte [msg + rcx - 1]
        cmp byte r8b, byte 0x0			    ; Check if current byte is terminating byte
        jnz _getsize

        xor r8, r8                    ; Zero r8
_loop:
        inc r8
        mov rsi, [msg + r8 - 1]
        mov [dest + r8], rsi
        cmp r8, rcx
        jnz _loop

_print:
        mov rdi, fp_stdout
        mov rsi, dest
        mov rdx, rcx
        mov rax, sys_write
        syscall

_exit:
        mov rax, sys_exit
        mov rdi, 0
        syscall