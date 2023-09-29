Red/System [
    Title:  "Types definitions declaration and initializations"
    Author: "Isoux"
    File:   %types.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
]

#enum Types! [
    _reg8:   0
    _reg16:  1
    _reg32:  2
    _reg64:  3
    _imm8:   4
    _imm16:  5
    _imm32: _imm: 6
    _imm64:  7
    _mem8:   8
    _mem16:  9
    _mem32: _mem: 10
    _mem64:  11
]

type!: alias struct! [
    id [integer!]
]

reg8:   declare type!
reg16:  declare type!
reg32:  declare type!
;reg64: declare type!
imm8:   declare type!
imm16:  declare type!
imm32:  declare type!
imm:    declare type!
;imm64: declare type!
mem8:   declare type!
mem16:  declare type!
mem32:  declare type!
mem:    declare type!
;mem64: declare type!

reg8/id:    _reg8
reg16/id:   _reg16
reg32/id:   _reg32
imm8/id:    _imm8
imm16/id:   _imm16
imm32/id:   _imm32
imm/id:     _imm32
mem8/id:    _mem8
mem16/id:   _mem16
mem32/id:   _mem32