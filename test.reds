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

asm [bswap ebx]

; Register to register
asm [mov al bl]
asm [mov ah bh]
asm [mov eax ebx]

; Immediate to register
asm [mov al  CFh]
asm [mov ax  A06Eh]
asm [mov ebx F1B2C3A4h]
