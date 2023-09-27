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

instruction!: alias struct! [
    name  [c-string!]
    proc  [function![arg1 [argument!] arg2 [argument!]]]
    argc  [integer!]
]

mov: declare instruction!
;add: declare instruction!
;etc

mov/name: "mov"
mov/proc: as mov! :_mov
;add/name: "add"
