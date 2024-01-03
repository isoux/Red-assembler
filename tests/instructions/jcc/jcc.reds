Red/System[
    Title:  "JCC instructions tests"
    Author: "Isoux"
    File:   %jcc.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Testing the jcc-jxx instructions for relative offsets.
        NOP instructions are used here to get the desired 
        code size in a simple way.
    }
    Result: {
        After cmd ./run check the file jcc.dump for result.
    }
]

#include %../../../system/asm-compiler.reds
#include %../../../system/asm-label.reds
#include %../../../system/emit-file.reds
#include %../../../instructions/jcc.reds
#include %../../test.reds

; Emit nop isnstruction 4 times
emit_byte 90h 4

; Declaration of label
lab0: label!

; A request for a label declaration 
; that will be declared and linked later in the code.
lab1: request!
lab3: request!
; A necessary way to jump on the label 
; that will be declared in the future
JA [rel8 :lab1]

; Emit nop isnstruction 4 times
emit_byte 90h 4

; lab3 position in the code is biger than 
; 16-bit relative offset, so you need rel32
JLE [rel32 :lab3]

; Emit nop isnstruction 40 times
emit_byte 90h 40

; Declaration of label
lab1: label!

; Emit nop isnstruction 70 times
emit_byte 90h 70

; Jump to a label that has already been declared
JE [rel8 lab0]

; Emit nop isnstruction 8 times
emit_byte 90h 8

; Declaration of label
lab2: label!
emit_byte 90h 2

; At this point of the code, the program counter overrides 
; the 8-bit relative offset, so you must use rel16.
;jne [rel8 lab0] 
; ERROR! Should choose rel16 for label.
JNE [rel16 lab0]

; Emit nop isnstruction 32768 times
emit_byte 90h 32768
; For test put lab3 positinon over the 16-bit programm counter
lab3: label!

; Emit nop isnstruction 4 times
emit_byte 90h 4

; Need for linking labels properly,
; like a second stage of compilation
link_labels

; Emit binary code at file in manner of JIT compiler
emit_to_file "jcc.bin"  pc_buf    pc_size

; Free the allocated memory
free_compiler
free_labels