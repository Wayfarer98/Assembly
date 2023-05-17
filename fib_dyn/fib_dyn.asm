      global    _start

section .bss
      digitSpace resb 100     ; The string we want to print
      digitSpacePos resb 8    ; How far along the string we are
      fib_arr resq 1000       ; Reserve space for 1000 8 bit ints, for the fibs array


      section   .text
_start:
      push 1000            ; We want to call fibs(15)
      mov rax, 201
      syscall             ; Get start time
      mov r14, rax


      call _fibs_dyn

      push rax
      mov rax, 201
      syscall             ; Get end time
      mov r15, rax

      pop rax
      call _printRAX      ; Print fibs result
      sub r15, r14
      mov rax, r15
      call _printRAX      ; Print time result

_exit:
      mov rax, 60
      mov rdi, 0
      syscall

_fibs_dyn:
      mov rcx, fib_arr
      mov r10, 0
      mov [rcx], r10
      add rcx, 8
      mov r10, 1
      mov [rcx], r10
      add rcx, 8
      mov rsi, [rsp + 8]
      mov rdx, 2

_fib_loop:
      cmp rsi, rdx
      jl _end_fibs

      mov r10, [rcx - 1 * 8]
      mov r11, [rcx - 2 * 8]
      add r10, r11
      mov [rcx], r10
      add rcx, 8
      inc rdx
      jmp _fib_loop

_end_fibs:
      mov rax, [fib_arr + rsi * 8]
      ret


_printRAX:
      mov rcx, digitSpace
      mov rbx, 10             ; Newline character
      mov [rcx], rbx          ; Move the newline into the string
      inc rcx
      mov [digitSpacePos], rcx ; Increment digitSpacePos

_printRAXLoop:
      mov rdx, 0              ; Division will concat rdx:rax, so set to 0 for no weirdness
      mov rbx, 10
      div rbx                 ; Divide rax with 10, to isolate least significant digit in rdx
      push rax                ; Store rest of string for later use
      add rdx, 48             ; convert rdx from int to char

      mov rcx, [digitSpacePos]
      mov [rcx], dl           ; move the lowest byte of rdx into the digit space, this is our char
      inc rcx                 ; One char done, increment digit space position
      mov [digitSpacePos], rcx; Put the incremented pos into the digit space position

      pop rax                 ; Pop the remaining digits back into rax
      cmp rax, 0              ; Check if we are done
      jne _printRAXLoop       ; If not done, we loop again

_printRAXLoop2:
      mov rcx, [digitSpacePos]

      mov rax, 1
      mov rdi, 1
      mov rsi, rcx
      mov rdx, 1
      syscall

      mov rcx, [digitSpacePos]
      dec rcx
      mov [digitSpacePos], rcx

      cmp rcx, digitSpace
      jge _printRAXLoop2

      ret