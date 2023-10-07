Red/System [
    Title:  "Instruction definitions declaration and initializations"
    Author: "Isoux"
    File:   %instructions.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
]

#include %../instructions/mov.reds
#include %../instructions/bswap.reds

instruction!: alias struct! [
    name  [c-string!]
    proc  [function![arg1 [argument!] arg2 [argument!] arg3 [argument!]]]
    argc  [integer!]
]

bswap: declare instruction!
mov:   declare instruction!
;etc

bswap/name: "bswap"
bswap/proc: as bswap! :_bswap

mov/name: "mov"
mov/proc: as mov! :_mov