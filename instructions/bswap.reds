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
]

bswap!: alias function! [arg1 [argument!] arg2 [argument!]]

_bswap: func [
    arg1 [argument!]
    arg2 [argument!]
    /local
        opcode  [integer!] 
        res [c-string!] 
][
    if all [arg1 <> null][ 
        either arg1/type = reg32 [
            opcode: 0FC8h or arg1/id
            res: to-hex opcode yes
            print ["#inline #{0"res"}" lf]
        ][
            print ["Error!: Argument must be a 32-bit register!" lf]
        ]
    ]
]