Red/System [
    Title:  "Common structures and definitions"
    Author: "Isoux"
    File:   %common.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
]

#enum LegacyPrefixes! [
    grp1: 66h   
    grp2: 67h   
    grp3: F2h
    grp4: F3h
]

argument!: alias struct! [
    id    [integer!]
    value [integer!]
    type  [type!]
    name  [c-string!]
]










