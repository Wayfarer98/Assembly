        global      _start
        section     .text

_start: 
        call        _creat_file

_creat_file:
        pop         esi
        pop         esi
        pop         esi
        mov         edi,filename

loop:
        mov         al,[esi]
        mov         bl,[edi]
        mov         ecx,[esi]
        int         0x80
        mov         bl,al
        add         edi,1
        add         esi,1
        test        al,0x0
        jnz         loop

        mov         ecx,0x700
        mov         ebx,filename
        mov         eax,sys_creat
        int         0x80
        mov         ebx,eax
        mov         eax,sys_write
        mov         ecx,msg
        mov         edx,len
        int         0x80
        mov         eax,sys_close
        int         0x80
        mov         eax,sys_exit
        mov         ebx,0
        int         0x80

section     .data
msg     db          'Hello world',0xa
len     equ         $ - msg
filename times 100 db 0
sys_write equ       4
sys_exit  equ       1
fp_stdout equ       1
sys_close equ       6
sys_creat  equ      8