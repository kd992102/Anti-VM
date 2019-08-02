NULL              EQU 0
STD_OUTPUT_HANDLE EQU -11

extern GetStdHandle
extern WriteFile
extern ExitProcess

global Start

section .data
    Message       db "NotVM", 0Dh, 0Ah
    MessageLength EQU $-Message
    Messagetwo    db "It is VM", 0Dh, 0Ah
    MessageTwoL   EQU $-Messagetwo

section .bss
align 8
    StandardHandle resd 1
    Written        resd 1

section .text
Start:
Start:
 sub   RSP, 8                                   ; Align the stack to a multiple of 16 bytes

 sub   RSP, 32                                  ; 32 bytes of shadow space
 mov   ECX, STD_OUTPUT_HANDLE
 call  GetStdHandle
 mov   qword [REL StandardHandle], RAX
 add   RSP, 32                                  ; Remove the 32 bytes

 sub   RSP, 32 + 8 + 8                          ; Shadow space + 5th parameter + align stack
                                                ; to a multiple of 16 bytes

 xor   RAX, RAX
 inc   RAX
 cpuid
 cmp   RAX, 0x1f
 jne   NOTVM
 jmp   VM



NOTVM:
 mov   RCX, qword [REL StandardHandle]          ; 1st parameter
 lea   RDX, [REL Message]                       ; 2nd parameter
 mov   R8, MessageLength                        ; 3rd parameter
 lea   R9, [REL Written]                        ; 4th parameter
 mov   qword [RSP + 4 * 8], NULL                ; 5th parameter
 call  WriteFile                                ; Output can be redirect to a file using >
 add   RSP, 48                                  ; Remove the 48 bytes

 xor   ECX, ECX
 call  ExitProcess
VM:
mov   RCX, qword [REL StandardHandle]          ; 1st parameter
 lea   RDX, [REL Messagetwo]                       ; 2nd parameter
 mov   R8, MessageTwoL                        ; 3rd parameter
 lea   R9, [REL Written]                        ; 4th parameter
 mov   qword [RSP + 4 * 8], NULL                ; 5th parameter
 call  WriteFile                                ; Output can be redirect to a file using >
 add   RSP, 48                                  ; Remove the 48 bytes

 xor   ECX, ECX
 call  ExitProcess