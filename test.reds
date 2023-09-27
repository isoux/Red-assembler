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


; 8-bit
asm [MOV AL BL]
asm [mov bl al]

asm [MOV bl Cl]
asm [mov cL BL]

asm [MOV BL DL]
asm [mov Dl Bl]

asm [mov al ah]
asm [mov ah al]

asm [mov ah cl]
asm [mov cl ah]

;16-bit
asm [mov ax bx]
asm [mov bx ax]

asm [MoV AX DX]
asm [mov DX AX]

asm [MOV bx si]
asm [mov si bx]

asm [mov ax sp]
asm [mov sp ax]

asm [mov ax bp]
asm [mov bp ax]

asm [mov bp di]
asm [MOV di bp]

either in-str-table! general-regs AL/name [
    print " In string table : YES!"
][
    print " In string table : NO!"
]
print newline


