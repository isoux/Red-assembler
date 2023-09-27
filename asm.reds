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

#include %utils/to-hex.reds
#include %utils/find-string.reds
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
        argc [integer!]
        arg-indx [integer!]
][
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
                arg1: arg
                arg-indx: arg-indx + 1
            ][
                arg2: arg
            ]   
       ]
       ; Further processing of input arguments
       list: list + 1
       count: count - 1
       zero? count
    ]
    inst/proc arg1 arg2 ; Call procedure of detected instruction
]