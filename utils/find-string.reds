Red/System [
    Title:  "Is string in string table?"
    Author: "Isoux"
    File:   %find-string.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
	}
    Note: {
        Check is the string in string table only if is declared as 
        multiline between: {...}
    }
]

#define SPACE #" " 
#define TAB   #"^(09)"

in-str-table!: func [
    table       [c-string!]
    string      [c-string!]
    return:     [logic!]
    /local
        a       [integer!]
        b       [byte!]
        c       [integer!]
        count   [integer!]
        start   [integer!]
        size    [integer!]
        in-size [integer!]
        ready   [logic!]
][
    in-size: size? string
    in-size: in-size - 1
    size:  0
    start: 0
    count: 0
    a: 0
    c: 0
    ready: false
    until [
        a: a + 1
        b: table/a
        either all [b <> SPACE b <> TAB b <> lf b <> cr][
            if not ready [start: a]
            ready: true
            if a <> size? table [
                size: size + 1
                count: count + 1
            ]
        ][ 
            ready: false
        ]
        if all [not ready size > 0][
           if  size = in-size [
                c: start
                start: 1
                while [count > 0][
                    if string/start <> table/c [break]
                    c: c + 1
                    start: start + 1
                    count: count - 1
                    if count = 0 [return true]
                ]
            ]
            size: 0
            count: 0
        ]
        a = size? table
    ]
    return false
]