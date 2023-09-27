Red/System[
	Title:	"Instruction processing test"
	Author: "Isoux"
	File: 	%test.reds
	Tabs: 	4
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

asm [MOV AL BL]
asm [mov bl al]

asm [mov al cl]
asm [mov cl al]

asm [MoV AL DL]
asm [mov Dl Al]
;--------------
asm [MOV bl Cl]
asm [mov cL BL]

asm [MOV BL DL]
asm [mov Dl Bl]
;--------------

asm [MOV CL DL]
asm [mov Dl Cl]
;--------------

asm [mov al ah]
asm [mov ah al]

asm [mov ah cl]
asm [mov cl ah]

asm [mov DH BH]
; etc

either in-str-table! general-regs AL/name [
    print " In string table : YES!"
][
    print " In string table : NO!"
]
print newline


