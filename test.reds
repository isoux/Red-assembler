Red/System[
    Title:  "Instruction processing test"
    Author: "Isoux"
    File:   %test.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        The processing result is emitted to text.bin file like a valid binary file.
        The result is visible in the console output or text.dump file after objdump cmd. 

    }
]

#include %system/asm-compiler.reds
#include %system/emit-file.reds
#include %asm.reds

; Register to register
asm [mov al bl]
asm [mov ah bh]
asm [mov eax ebx]

; Immediate to register
asm [mov al  CFh]
asm [mov ax  A06Eh]
asm [mov ebx F1B2C3A4h]

; Memmory to register
asm [mov al byte-ptr ABCDEF48h]     ; load byte from mem-location to AL
asm [mov cl byte-ptr C5B6h]
asm [mov ah byte-ptr ABCDEF48h] 
asm [mov bh byte-ptr ABCDEF48h] 

asm [mov ax word-ptr 1A2B3C4Dh]
asm [mov cx word-ptr 1A2B3C4Dh]

asm [mov eax dword-ptr FEDCAB98h]
asm [mov edx dword-ptr FEDCAB98h]

; Register to memmory
asm [mov byte-ptr FEDCAB98h al]     ; load AL to byte ptr of mem-location   
asm [mov byte-ptr FEDCAB98h cl]
asm [mov byte-ptr FEDCAB98h ah]
asm [mov byte-ptr FEDCAB98h bh]

asm [mov word-ptr FEDCAB98h ax]
asm [mov word-ptr FEDCAB98h dx]

asm [mov dword-ptr FEDCAB98h eax]
asm [mov dword-ptr FEDCAB98h ebx]

; Register to specific memory segment
asm [mov byte-ptr fs FEDCAB98h al]  ; load AL to byte ptr of fs:mem-location
asm [mov byte-ptr gs FEDCAB98h cl]

asm [mov word-ptr ss FEDCAB98h bx]
asm [mov word-ptr es FEDCAB98h dx]

asm [mov dword-ptr ds FEDCAB98h eax]
asm [mov dword-ptr fs FEDCAB98h esi]

; Byte swap
asm [bswap ebx]

emit_to_file
free_alloc



 