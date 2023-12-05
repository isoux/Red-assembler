Red/System [
    Title:  "Red/System/Assembler"
    Author: "Isoux"
    File:   %asm.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        For now, only instructions for Intel processors are being supported.
    }
]

#include %structures/common.reds
#include %structures/types.reds
#include %structures/registers.reds
#include %structures/instructions.reds

asm: func [
    [typed] count [integer!] list [typed-value!]
    /local
        inst [instruction!]
        arg  [argument!]
        arg1 [argument!]
        arg2 [argument!]
        arg3 [argument!]
        arg4 [argument!]
        type [type!] 
        argc [integer!]
        arg-indx [integer!]
][
    arg3: null
    arg4: null
    arg-indx: 1
    argc: count - 1
    until [
        if list/type = system/alias/instruction! [
            inst: as instruction! list/value
            inst/argc: argc
        ]
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
        ; Further processing of input arguments
        list: list + 1
        count: count - 1
        zero? count
    ]
    inst/proc arg1 arg2 arg3 arg4 ; Call procedure of detected instruction
]