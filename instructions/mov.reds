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
    Needs: {
        #include %../system/asm-compiler.reds [
            #include %../system/utils/int-size.reds
            #include %../system/utils/byte-swap.reds
        ]	
	}
]

encode-reg: func [
    Opcode  [integer!]
    Mod     [integer!]
    Reg     [integer!]
    Reg-Mem [integer!]
    /local
        ModRM [integer!]
        size  [integer!]
        mult  [integer!]
        a     [integer!]
][
    ModRM:  Reg << 3
    Opcode: Opcode or ModRM or Mod or Reg-Mem 
    size:   int_size? Opcode
    Opcode: byte_swap Opcode
    mult:   4 - size mult: mult * 8
    Opcode: Opcode >> mult
    either  size = 2 [a: FFFFh][a: FFFFFFh]
    Opcode: Opcode and a
    emit_opcode Opcode 0
]

encode-imm: func [
    Opc    [integer!]
    Reg    [integer!]
    RegM   [integer!]
    Shift  [integer!]
    /local
        a  [integer!]
        b  [integer!]
][
    a: 0
    b: Reg << Shift
    switch Shift [
        8   [Opc: Opc or RegM or b Opc: byte_swap Opc Opc: Opc >> 16 Opc: Opc and FFFFh]
        16  [b: byte_swap RegM RegM: b >> 16 Opc: Opc or Reg or RegM Opc: Opc or 66000000h Opc: byte_swap Opc]
        32  [a: Opc or Reg Opc: RegM]
    ]
    emit_opcode Opc a
]

encode-moffs: func [
    Opc    [integer!]
    mem    [integer!]
    SegReg [integer!]
    /local  
        a  [integer!]
][
    if SegReg > 0 [
        a: Opc
        if all [a >= 0 a <= FFh] [Opc: SegReg << 8 or Opc]
        if all [a > FFh a <= FFFFh] [Opc: SegReg << 16 or Opc]
        if any [a < 0 a > FFFFh] [Opc: SegReg << 24 or Opc a: Opc and FFFFh Opc: byte_swap Opc Opc: Opc << 16 or a]
    ]
    a: int_size? mem
    emit_opcode mem Opc
    if a <> 4 [a: 4 - a emit_zero a]
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

mov: func [
    [typed] count [integer!] list [typed-value!]
    /local
        arg      [argument!]
        arg1     [argument!]
        arg2     [argument!]
        arg3     [argument!]
        arg4     [argument!] 
        arg-indx [integer!]
        type     [type!]
][
    arg3: null
    arg4: null
    arg-indx: 1
    until [
        if list/type = system/alias/argument! [
            arg: as argument! list/value
            either arg-indx = 1 [
                either arg3 <> null [
                    if arg/type = sreg3 [
                        arg4: declare argument!
                        arg4: arg
                    ]
                    arg-indx = 1
                ][
                    arg1: arg
                    arg-indx: arg-indx + 1
                ]
            ][
                arg2: arg
            ]   
        ]
        if list/type = system/alias/type! [
            type: as type! list/value
            arg3: declare argument!
            arg3/id: 0
            arg3/type: type
        ]
        if list/type = type-integer! [
            either arg-indx = 2 [
                arg2: declare argument!
                either arg3 <> null [arg2/type: mem][arg2/type: imm]
                arg2/value: list/value
            ][
                arg1: declare argument!
                either arg3 <> null [arg1/type: mem][arg1/type: imm]
                arg1/value: list/value
                arg-indx: arg-indx + 1
            ]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
    _mov arg1 arg2 arg3 arg4
]