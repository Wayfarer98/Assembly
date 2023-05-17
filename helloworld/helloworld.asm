        global      _start
        section     .text
_start:
        mov         ecx,0x700
        mov         ebx,filename
        mov         eax,8
        int         0x80
        mov         ebx,eax
        mov         eax,4
        mov         ecx,msg
        mov         edx,len
        int         0x80
        mov         eax,6
        int         0x80
        mov         eax,1
        mov         ebx,0
        int         0x80

        section     .data
msg     db          'Hello world',0xa
len     equ         $ - msg
filename db "./output.txt",0x0