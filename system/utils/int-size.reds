Red/System [
    Title:  "Gives integer size"
    Author: "Isoux"
    File:   %int-size.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Gives the size of integer: 1, 2, 3, or 4 bytes
    }
]

int_size?: func [
    val      [integer!]
    return:  [integer!]
][
    if any [val < 0 val > FFFFFFh val <= FFFFFFFFh][return 4]
    if all [val > FFFFh val <= FFFFFFh][return 3]
    if all [val > FFh val <= FFFFh][return 2]
    ;if all [val > 0 val <= FFh][return 1] 
    return 1
]
