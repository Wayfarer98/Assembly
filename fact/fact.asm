      global    _start

section .bss
      digitSpace resb 100     ; The string we want to print
      digitSpacePos resb 8    ; How far along the string we are

      section   .text
_start:
      push 10            ; We want to call fact(5)
      call _fact
      call _printRAX

_exit:
      mov rax, 60
      mov rdi, 0
      syscall

_fact:
      push rbp          ; Caller save register that we use
      push rsi          ; Save previous param
      mov rbp, rsp      ; Stack is at rbp
      add rbp, 24       ; Ignore the call input
      mov rsi, [rbp]    ; rsi contains input

      cmp rsi, 0        ; If rsi is 0, then we return 1
      je _base

      dec rsi           ; Decrement rsi for function call
      push rsi          ; Push next param on the stack
      inc rsi           ; Restore the current param
      call _fact        ; Recursive call
      mul rsi           ; Make the calculation. Result is in rax
      pop rsi           ; Remember to pop as much as we push
      jmp _end


_base:
      mov rax, 1

_end:
      pop rsi           ; Restore the previous param
      pop rbp           ; Restore the caller/callee safe register
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