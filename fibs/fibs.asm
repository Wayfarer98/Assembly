      global    _start

section .bss
      digitSpace resb 100     ; The string we want to print
      digitSpacePos resb 8    ; How far along the string we are

      section   .text
_start:
      push 48            ; We want to call fibs(15)
      mov rax, 201
      syscall             ; Get start time
      mov r14, rax

      call _fibs

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

_fibs:
      push rbp          ; Caller save register that we use
      push rsi          ; Save previous param
      push rdx          ; Save previous result
      mov rbp, rsp      ; Stack is at rbp
      add rbp, 32       ; Ignore the call input
      mov rsi, [rbp]    ; rsi contains input

      cmp rsi, 1        ; Return 1 or 0, base case
      jle _base

      dec rsi
      push rsi
      inc rsi
      call _fibs
      mov rdx, rax
      sub rsi, 2
      push rsi
      add rsi, 2
      call _fibs
      add rax, rdx
      pop rsi
      pop rsi
      jmp _end

_base:
      mov rax, rsi      ; Return 1 or 0 depending on rsi

_end:
      pop rdx           ; pop previous result
      pop rsi           ; pop the previous input
      pop rbp           ; pop callee-safe register
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