Red/System [
    Title:  "MOV instruction"
    Author: "Isoux"
    File:   %mov.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License:    {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Each instruction, like this one, will have its own algorithm 
        for processing input arguments and emitting code.
    }
]

mov!: alias function! [arg1 [argument!] arg2 [argument!]]

print-opcode: func [
    Opcode  [integer!]
    Extend  [integer!]
    /local
        res [c-string!]
        ext [c-string!]
][
    ext: ""
    res: to-hex Opcode yes
    if Extend <> 0 [
        ext: byte-to-hex Extend yes
    ]
    print ["#inline #{"ext res"}" lf]
]

bswap: func [
    a [integer!]
    return: [integer!]
][
    system/cpu/eax: a
    #inline #{0FC8} ; bswap eax
    a: system/cpu/eax
    a
]

encode-reg: func [
    Opcode  [integer!]
    Mod     [integer!]
    Reg     [integer!]
    Reg-Mem [integer!]
    /local
        ModRM [integer!]
][
    ModRM:  Reg << 3
    Opcode: Opcode or ModRM or Mod or Reg-Mem 
    print-opcode Opcode 0
]

encode-imm: func [
    Opcode  [integer!]
    Reg     [integer!]
    RegM    [integer!]
    Shift   [integer!]
    /local
        a   [integer!]
        b   [integer!]
][
    b: Reg << Shift
    switch Shift [
        8   [Opcode: Opcode or RegM or b]
        16  [b: bswap RegM RegM: b >> 16
                Opcode: Opcode or Reg or RegM 
                Opcode: Opcode or 66000000h a: 0
            ]
        32  [a: Opcode or Reg 
                b: bswap RegM
                Opcode: b
            ]
    ]
    print-opcode Opcode a
]

_mov: func [
    arg1 [argument!]
    arg2 [argument!]
    /local
        ModRM  [integer!]
        Opcode [integer!]
        Shift  [integer!]
        a      [integer!]  
][
    if all [arg1 <> null arg2 <> null][ 
        either arg1/type = arg2/type [
            switch arg1/type/id [
                _reg8  [ModRM: C0h Opcode: 8A00h] 
                _reg16 [ModRM: C0h Opcode: 668B00h]
                _reg32 [ModRM: C0h Opcode: 8B00h]
            ]
            encode-reg Opcode ModRM arg1/id arg2/id
        ][
            if any [arg1/type = reg8 arg1/type = reg16 arg1/type = reg32][
                a: arg2/value
                if arg2/type = imm [
                    if all [a >= 0 a <= FFh]   [Opcode: B000h Shift: 8]
                    if all [a > FFh a <= FFFFh][Opcode: B80000h Shift: 16]
                    if any [a < 0 a > FFFFh]   [Opcode: B8h Shift: 32]
                ]
                encode-imm Opcode arg1/id arg2/value Shift
                if arg2/type = mem [
                    print ["Find mem!" lf]
                ]
            ]
        ]
    ]
]