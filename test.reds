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
mov [al bl]
mov [ah bh]
mov [eax ebx]

; Immediate to register
mov [al  CFh]
mov [ax  A06Eh]
mov [ebx F1B2C3A4h]

; Memmory to register
mov [al byte-ptr ABCDEF48h]     ; load byte from mem-location to AL
mov [cl byte-ptr C5B6h]
mov [ah byte-ptr ABCDEF48h] 
mov [bh byte-ptr ABCDEF48h] 

mov [ax word-ptr 1A2B3C4Dh]
mov [cx word-ptr 1A2B3C4Dh]

mov [eax dword-ptr FEDCAB98h]
mov [edx dword-ptr FEDCAB98h]

; Register to memmory
mov [byte-ptr FEDCAB98h al]     ; load AL to byte ptr of mem-location   
mov [byte-ptr FEDCAB98h cl]
mov [byte-ptr FEDCAB98h ah]
mov [byte-ptr FEDCAB98h bh]

mov [word-ptr FEDCAB98h ax]
mov [word-ptr FEDCAB98h dx]

mov [dword-ptr FEDCAB98h eax]
mov [dword-ptr FEDCAB98h ebx]

; Register to specific memory segment
mov [byte-ptr fs FEDCAB98h al]  ; load AL to byte ptr of fs:mem-location
mov [byte-ptr gs FEDCAB98h cl]

mov [word-ptr ss FEDCAB98h bx]
mov [word-ptr es FEDCAB98h dx]

mov [dword-ptr ds FEDCAB98h eax]
mov [dword-ptr fs FEDCAB98h esi]

; Byte swap
bswap ebx

emit_to_file
free_alloc



 