Red/System [
    Title:  "Red-Assembler compiler"
    Author: "Isoux"
    File:   %asm-compiler.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Simple binary JIT compiler
    }
]

#include %utils/int-size.reds
#include %utils/byte-swap.reds

pc_buf: allocate 2000h
pc_offset: 1
pc_size: 0

pc_increment: func [
    size [integer!]
][
    pc_size:   pc_size   + size
    pc_offset: pc_offset + size
]

emit_zero: func [
    size [integer!]
    /local
        a [integer!]
        i [integer!]
][
    i: 1
    a: pc_offset
    while [i <= size][
        pc_buf/a: as byte! 0
        a: a + 1
        i: i + 1
    ]
    pc_increment size
]

emit_opcode: func [
    Opcode  [integer!]
    Prefix  [integer!]
    /local
        a    [integer!]
        i    [integer!]
        size [integer!]
        pos  [integer!]
][
    i: 1
    pos: pc_offset
    if Prefix <> 0 [
        size: int_size? Prefix
        if size <> 1 [  ; if 1 no need for byte swap
            Prefix: byte_swap Prefix
            a: 4 - size
            if a <> 0 [
                a: a * 8
                Prefix: Prefix >> a
            ]
        ]
        while [i <= size][
            pc_buf/pos: as byte! Prefix
            Prefix: Prefix >> 8
            pos: pos + 1
            i: i + 1
        ]
        pc_increment size
    ] 
    size: int_size? Opcode
    either size <> 0 [
        i: 1
        while [i <= size][
            pc_buf/pos: as byte! Opcode
            Opcode: Opcode >> 8
            pos: pos + 1
            i: i + 1
        ]
        pc_increment size
    ][
        print ["Not allowed!" lf]
    ]
]

free_alloc: does [ free pc_buf ]
