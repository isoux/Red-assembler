Red/System [
    Title:  "Red-Assembler emiter"
    Author: "Isoux"
    File:   %int-size.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Gives the size of integer 
    }
]

int_size?: func [
    val      [integer!]
    return:  [integer!]
    /local
        size [integer!]
][
    size: 0
    if any [val < 0 val > FFFFFFh val <= FFFFFFFFh][size: 4]
    if all [val > FFFFh val <= FFFFFFh][size: 3]
    if all [val > FFh val <= FFFFh][size: 2]
    if all [val > 0 val <= FFh][size: 1] 
    size
]
