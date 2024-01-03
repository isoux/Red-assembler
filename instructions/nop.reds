Red/System [
    Title:  "NOP instruction"
    Author: "Isoux"
    File:   %nop.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License:    {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        This instruction performs no operation. It is a one-byte or 
        multi-byte NOP that takes up space in the instruction stream but 
        does not impact machine context, except for the EIP register.
    }
    Needs: {
        #include %../system/asm-compiler.reds
    }
]

nop: does [
    emit_byte 90h 1
]
