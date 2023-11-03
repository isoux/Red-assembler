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

mov!: alias function! [
    arg1 [argument!] 
    arg2 [argument!] 
    arg3 [argument!]
    arg4 [argument!]
]

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
    Opc [integer!]
    mem    [integer!]
    SegReg [integer!]
    /local  
        a [integer!]
][
    mem: byte-swap mem
    if SegReg > 0 [
        a: Opc
        if all [a >= 0 a <= FFh] [Opc: SegReg << 8 or Opc]
        if all [a > FFh a <= FFFFh] [Opc: SegReg << 16 or Opc]
        if any [a < 0 a > FFFFh] [
            Opc: SegReg << 24 or Opc
            ;a: Opc and 00660000h
            a: Opc and FFFFh
            Opc: byte-swap Opc
            Opc: Opc << 16 or a
            ;print ["a: "a "Opc: " Opc lf]
        ]
    ]
    print-opcode mem Opc
]

_mov: func [
    arg1 [argument!]
    arg2 [argument!]
    arg3 [argument!]
    arg4 [argument!]
    /local
        type  [type!]
        ModRM [integer!]
        SIB   [integer!]
        Opc   [integer!]
        Shift [integer!]
        SegReg[integer!]
        a     [integer!]  
][
    SegReg: 0
    if all [arg1 <> null arg2 <> null][ 
        either arg1/type = arg2/type [
            switch arg1/type/id [
                _reg8  [Opc: 8A00h] 
                _reg16 [Opc: 668B00h]
                _reg32 [Opc: 8B00h]
            ]
            ModRM: C0h
            encode-reg Opc ModRM arg1/id arg2/id
        ][
            type: arg1/type
            if any [type = reg8 type = reg16 type = reg32][
                a: arg2/value
                if arg2/type = imm [
                    if all [a >= 0 a <= FFh]   [Opc: B000h Shift: 8]
                    if all [a > FFh a <= FFFFh][Opc: B80000h Shift: 16]
                    if any [a < 0 a > FFFFh]   [Opc: B8h Shift: 32]
                    encode-imm Opc arg1/id arg2/value Shift
                ]
                if arg2/type = mem [ 
                    type: arg3/type
                    if any [type = byte-ptr type = word-ptr type = dword-ptr][
                        ModRM: arg1/id << 3
                        SIB: 5 Opc: 0
                        Opc: ModRM or SIB
                        switch type/id [
                            _moffs8  [either arg1 = AL  [Opc: A0h]  [Opc: Opc or 8A00h]]
                            _moffs16 [either arg1 = AX  [Opc: 66A1h][Opc: Opc or 668B00h]]
                            _moffs32 [either arg1 = EAX [Opc: A1h]  [Opc: Opc or 8B00h]]
                        ]
                        encode-moffs Opc arg2/value SegReg
                    ]  
                ]
            ]
            if type = mem [
                type: arg2/type
                if any [type = reg8 type = reg16 type = reg32][
                    if arg4 <> null [SegReg: arg4/id
                        switch SegReg [
                            _es [SegReg: 26h]
                            _cs [SegReg: 2Eh] ;Is not allowed as: (mov ptr cs:mem_loc reg)!
                            _ss [SegReg: 36h]
                            _ds [SegReg: 3Eh]
                            _fs [SegReg: 64h]
                            _gs [SegReg: 65h]
                        ]
                    ]
                    ModRM: arg2/id << 3
                    SIB: 5 Opc: 0
                    Opc: ModRM or SIB
                    switch type/id [
                        _reg8  [either arg2 = AL  [Opc: A2h]  [Opc: Opc or 8800h]] 
                        _reg16 [either arg2 = AX  [Opc: 66A3h][Opc: Opc or 668900h]]
                        _reg32 [either arg2 = EAX [Opc: A3h]  [Opc: Opc or 8900h]]
                    ]
                    encode-moffs Opc arg1/value SegReg
                ]

            ]
        ]
    ]
]