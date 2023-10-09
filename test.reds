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
        The processing result is printed on the command line in the 
        form #inline #{xxxx...}
    }
]

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
asm [mov al byte-ptr ABCDEF48h] ; load byte to AL from mem-location
asm [mov bl byte-ptr C5B6h]
asm [mov ah byte-ptr ABCDEF48h] 
asm [mov bh byte-ptr ABCDEF48h] 
asm [mov ch byte-ptr ABCDEF48h] 
asm [mov dh byte-ptr ABCDEF48h] 

asm [mov ax word-ptr 1A2B3C4Dh]
asm [mov bx word-ptr 1A2B3C4Dh]
asm [mov cx word-ptr 1A2B3C4Dh]
asm [mov dx word-ptr 1A2B3C4Dh]

asm [mov eax dword-ptr FEDCAB98h]
asm [mov ebx dword-ptr FEDCAB98h]
asm [mov ecx dword-ptr FEDCAB98h]
asm [mov edx dword-ptr FEDCAB98h]

; Byte swap
asm [bswap ebx]
