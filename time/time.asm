global _start

section .text

_start:
      mov rax, 201
      syscall
_time:
      mov rdx, rax
      mov rax, 201
      syscall
      mov rdi, rax
      sub rdi, rdx
_time1:
      mov rax, 60
      mov rdi, 0
      syscall