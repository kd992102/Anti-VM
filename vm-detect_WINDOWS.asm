                                                ; Console Message, 32 bit. V1.02
NULL              EQU 0                         ; Constants
STD_OUTPUT_HANDLE EQU -11

extern _GetStdHandle@4                          ; Import external symbols
extern _WriteFile@20                            ; Windows API functions, decorated
extern _ExitProcess@4

global Start                                    ; Export symbols. The entry point

section .data                                   ; Initialized data segment
 Message        db "NOTVM", 0Dh, 0Ah
 MessageLength  EQU $-Message                   ; Address of this line ($) - address of Message
 Massage        db "VM", 0Dh, 0Ah
 MassageLength   EQU $-Massage
section .bss                                    ; Uninitialized data segment
 StandardHandle resd 1
 Written        resd 1

section .text                                   ; Code segment
Start:
 push  STD_OUTPUT_HANDLE
 call  _GetStdHandle@4
 mov   dword [StandardHandle], EAX
 xor   EAX, EAX
 inc   EAX
 cpuid
 bt    ECX, 0x1f
 jb    VM
 jmp   NOTVM

VM:
 push  NULL                                     ; 5th parameter
 push  Written                                  ; 4th parameter
 push  MassageLength                            ; 3rd parameter
 push  Massage                                  ; 2nd parameter
 push  dword [StandardHandle]                   ; 1st parameter
 call  _WriteFile@20                            ; Output can be redirect to a file using >

 push  NULL
 call  _ExitProcess@4




NOTVM:
 push  NULL                                     ; 5th parameter
 push  Written                                  ; 4th parameter
 push  MessageLength                            ; 3rd parameter
 push  Message                                  ; 2nd parameter
 push  dword [StandardHandle]                   ; 1st parameter
 call  _WriteFile@20                            ; Output can be redirect to a file using >

 push  NULL
 call  _ExitProcess@4