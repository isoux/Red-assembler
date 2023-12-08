Red/System [
    Title:  "BSWAP instruction"
    Author: "Isoux"
    File:   %bswap.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License:    {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Reverses the byte order of a 32-bit (destination) register.
    }
    Needs: {
        #include %../system/asm-compiler.reds [
            #include %../system/utils/byte-swap.reds
        ]
    }
]

bswap: func [
    arg1 [argument!]
    /local
        opcode [integer!] 
][
    if arg1 <> null [ 
        either arg1/type = reg32 [
            opcode: 0FC8h or arg1/id
            opcode: byte_swap opcode
            opcode: opcode >> 16 and FFFFh
            emit_opcode opcode 0
        ][
            print ["Error!: Argument must be a 32-bit register!" lf]
        ]
    ]
]