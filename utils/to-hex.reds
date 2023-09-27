Red/System [
    Title:  "To_hex functions"
    Author: "Isoux"
    File:   %to-hex.reds
    Tabs:   4
    Rights: "Copyright (C) 2011-2018 Red Foundation. All rights reserved."
    License:    {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/red/red/blob/master/red-system/runtime/BSL-License.txt
    }
    Note:   {
        In order to make the project mainly based on Red/System, 
        I downloaded this useful code from:
        https://github.com/red/red/blob/master/runtime/datatypes/string.reds
    }
]

#define max-char-codepoint	0010FFFFh   ;-- upper limit for a codepoint value.

byte-to-hex: func [
        byte    [integer!]
        return: [c-string!]
        /local
            ss  [c-string!]
            h   [c-string!]
            i   [integer!]
	][
        ss: "00"
        h: "0123456789ABCDEF"

        i: byte and 15 + 1          ;-- byte // 16 + 1
        ss/2: h/i
        i: byte >> 4 and 15 + 1     ;-- byte // 16 + 1
        ss/1: h/i
        ss
	]
 
    to-hex: func [
        value	 [integer!]
        char?	 [logic!]
        return:  [c-string!]
        /local
            s    [c-string!]
            h    [c-string!]
            c    [integer!]
            i    [integer!]
            sign [integer!]
            cp   [integer!]
	][
		
        s: "00000000"
        h: "0123456789ABCDEF"

        c: 8
        sign: either negative? value [-1][0]
        cp: value
        while [cp <> sign][
            i: cp and 15 + 1                            ;-- cp // 16 + 1
            s/c: h/i
            cp: cp >> 4
            c: c - 1
        ]

        either char? [
            assert cp <= max-char-codepoint
            if zero? value [
                s/7: #"0"
                s/8: #"0"
                return s + 6
            ]
            s + c
        ][
            i: 1
            while [i <= c][                             ;-- fill leading with #"0" or #"F"
                s/i: either negative? sign [#"F"][#"0"]
                i: i + 1
            ]
            s
        ]
    ] 