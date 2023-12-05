Red/System [
    Title:  "Red-Assembler emiter"
    Author: "Isoux"
    File:   %byte-swap.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Swap the byte 
    }
]

byte_swap: func [
    a [integer!]
    return: [integer!]
][
    system/cpu/eax: a
    #inline #{0FC8} ; bswap eax
    a: system/cpu/eax
    a
]
