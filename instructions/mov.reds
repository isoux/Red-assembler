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

mov!: alias function! [arg1 [argument!] arg2 [argument!] arg3 [argument!]]

print-opcode: func [
    Opcode  [integer!]
    Prefix  [integer!]
    /local
        pref [c-string!]
        res  [c-string!]
][
    pref: ""
    res: to-hex Opcode yes
    either Prefix <> 0 [
        either all [Prefix >= 0 Prefix <= FFh] [
            pref: byte-to-hex Prefix yes
            print ["#inline #{"pref res"}" lf]
        ][
            pref: to-hex Prefix yes  ; A trick is used here, because  
            print ["#inline #{"pref] ; the allocated strings on the local - 
            res: to-hex Opcode yes   ; stack mix into each other's contents
            print [res"}" lf]        ; when to-hex is called twice in a row!?
        ]
    ][
        print ["#inline #{"res"}" lf]
    ]
]

byte-swap: func [
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
        8   [Opcode: Opcode or RegM or b a: 0]
        16  [b: byte-swap RegM RegM: b >> 16
                Opcode: Opcode or Reg or RegM 
                Opcode: Opcode or 66000000h a: 0
            ]
        32  [a: Opcode or Reg 
                b: byte-swap RegM
                Opcode: b
            ]
    ]
    print-opcode Opcode a
]

encode-moffs: func [
    Opcode  [integer!]
    mem     [integer!]
][
    mem: byte-swap mem
    print-opcode mem Opcode
]

_mov: func [
    arg1 [argument!]
    arg2 [argument!]
    arg3 [argument!]
    /local
        type   [type!]
        ModRM  [integer!]
        SIB    [integer!]
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
                    encode-imm Opcode arg1/id arg2/value Shift
                ]
                if arg2/type = mem [ 
                    type: arg3/type
                    if any [type = byte-ptr type = word-ptr type = dword-ptr][
                        switch type/id [
                            _moffs8  [
                                either arg1 = AL [
                                    Opcode: A0h
                                ][
                                    SIB: 5
                                    Opcode: arg1/id << 3 or SIB or 8A00h
                                ]
                                a: arg2/value
                            ]
                            _moffs16 []
                            _moffs32 []
                        ]
                        encode-moffs Opcode a
                    ]  
                ]
            ]
        ]
    ]
]