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

encode: func [
    Opcode  [integer!]
    Mod     [integer!]
    Reg     [integer!]
    Reg-Mem [integer!]
    return: [integer!]
    /local
        ModRM [integer!]
][
    ModRM: Reg << 3
    Opcode: Opcode or ModRM or Mod or Reg-Mem 
    Opcode
]

_mov: func [
    arg1 [argument!]
    arg2 [argument!]
    /local
        ModRM  [integer!]
        Opcode [integer!]
        result [c-string!]
][
    if all [arg1 <> null arg2 <> null][ 
        either arg1/type = arg2/type [
            switch arg1/type/id [
                _reg8 [
                    ModRM:  C0h   ; 1100 0000
                    Opcode: 8A00h ; 0100 1010 ...
                    Opcode: encode Opcode ModRM arg1/id arg2/id
                    result: to-hex Opcode yes
                    print ["#inline #{"result"}" lf]
                ]
            ]
        ][
            print ["Error! Different types!" lf]
        ]
    ]
]