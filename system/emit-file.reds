Red/System [
    Title:  "File emitter"
    Author: "Isoux"
    File:   %emit-file.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        File emitter for simple JIT compiler at Linux for now!
    }
    Needs: {
        %asm-compiler.reds
	}
]

#include %targets/sys-defines.reds

flag_creat:  O_BINARY or O_WRONLY or O_CREAT or O_TRUNC
;flag_append: O_BINARY or O_WRONLY or O_APPEND 
modes:       S_IREAD  or S_IWRITE

file-pc: "text.bin"
fd-pc: 0
res: 0

emit_to_file: does [
    fd-pc: _open file-pc flag_creat modes
    either negative? fd-pc [
        print "Error: open failed" 
        quit 3        ;-- exit and return an error code
    ][
    print ["...opened fd    : " fd-pc lf]
    ]

    res: _write fd-pc as c-string! pc_buf  pc_size
    if negative? res [
        print "Error: write fd failed" 
        quit 3        ;-- exit and return an error code
    ]

    fd-pc: _close fd-pc
    if fd-pc = 0 [
        print ["...closed fd    : OK!" lf]
    ]

    print ["...pc_size      : " pc_size lf]
    print ["...pc_offset    : " pc_offset lf]
    print ["...writen bytes : " res lf]
]
