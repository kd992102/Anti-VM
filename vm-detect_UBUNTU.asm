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
 sub   RSP, 8                                   
 sub   RSP, 32                                  
 mov   ECX, STD_OUTPUT_HANDLE
 call  GetStdHandle
 mov   qword [REL StandardHandle], RAX
 add   RSP, 32                                  
 sub   RSP, 32 + 8 + 8                          
 xor   RAX, RAX
 inc   RAX
 cpuid
 cmp   RAX, 0x1f
 jne   NOTVM
 jmp   VM



NOTVM:
 mov   RCX, qword [REL StandardHandle]          
 lea   RDX, [REL Message]                       
 mov   R8, MessageLength                        
 lea   R9, [REL Written]                        
 mov   qword [RSP + 4 * 8], NULL                
 call  WriteFile                                
 add   RSP, 48                                  
 xor   ECX, ECX
 call  ExitProcess
 
 
VM:
 mov   RCX, qword [REL StandardHandle]          
 lea   RDX, [REL Messagetwo]                   
 mov   R8, MessageTwoL                        
 lea   R9, [REL Written]                        
 mov   qword [RSP + 4 * 8], NULL                
 call  WriteFile                                
 add   RSP, 48                                  
 xor   ECX, ECX
 call  ExitProcess
