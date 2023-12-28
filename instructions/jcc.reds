Red/System [
    Title:  "Jcc instructions — Jump if Condition Is Met"
    Author: "Isoux"
    File:   %jcc.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License:    {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Jcc—Jump if Condition Is Met
        Checks the state of one or more of the status flags in the EFLAGS register 
        (CF, OF, PF, SF, and ZF) and, if the flags are in the specified state (condition),
        performs a jump to the target instruction specified by the destination operand. 
    }
    Needs: {
        #include %../system/asm-compiler.reds
        #include %../system/asm-label.reds
    }
]

relx!: alias struct![
    rel_8   [integer!]
    rel_far [integer!]
]

jcc!: alias struct! [
    opcode [relx!]
]

ja_opc: declare relx!
ja_opc/rel_8:   77h
ja_opc/rel_far: 870Fh
ja!: declare jcc!
ja!/opcode: ja_opc

jae_opc: declare relx!
jae_opc/rel_8:   73h
jae_opc/rel_far: 830Fh
jae!: declare jcc!
jae!/opcode: jae_opc

je_opc: declare relx!
je_opc/rel_8:   74h
je_opc/rel_far: 840Fh
je!: declare jcc!
je!/opcode: je_opc

jb_opc: declare relx!
jb_opc/rel_8:   72h
jb_opc/rel_far: 820Fh
jb!: declare jcc!
jb!/opcode: jb_opc

jbe_opc: declare relx!
jbe_opc/rel_8:   76h
jbe_opc/rel_far: 860Fh
jbe!: declare jcc!
jbe!/opcode: jbe_opc

jcxz_opc: declare relx!
jcxz_opc/rel_8:   E3h
jcxz_opc/rel_far: 0
jcxz!: declare jcc!
jcxz!/opcode: jcxz_opc

jg_opc: declare relx!
jg_opc/rel_8:   7Fh
jg_opc/rel_far: 8F0Fh
jg!: declare jcc!
jg!/opcode: jg_opc

jge_opc: declare relx!
jge_opc/rel_8:   7Dh
jge_opc/rel_far: 8D0Fh
jge!: declare jcc!
jge!/opcode: jge_opc

jl_opc: declare relx!
jl_opc/rel_8:   7Ch
jl_opc/rel_far: 8C0Fh
jl!: declare jcc!
jl!/opcode: jl_opc

jle_opc: declare relx!
jle_opc/rel_8:   7Eh
jle_opc/rel_far: 8E0Fh
jle!: declare jcc!
jle!/opcode: jle_opc

jne_opc: declare relx!
jne_opc/rel_8:   75h
jne_opc/rel_far: 850Fh
jne!: declare jcc!
jne!/opcode: jne_opc

jno_opc: declare relx!
jno_opc/rel_8:   71h
jno_opc/rel_far: 810Fh
jno!: declare jcc!
jno!/opcode: jno_opc

jnp_opc: declare relx!
jnp_opc/rel_8:   7Bh
jnp_opc/rel_far: 8B0Fh
jnp!: declare jcc!
jnp!/opcode: jnp_opc

jns_opc: declare relx!
jns_opc/rel_8:   79h
jns_opc/rel_far: 890Fh
jns!: declare jcc!
jns!/opcode: jns_opc

jo_opc: declare relx!
jo_opc/rel_8:   70h
jo_opc/rel_far: 800Fh
jo!: declare jcc!
jo!/opcode: jo_opc

jp_opc: declare relx!
jp_opc/rel_8:   7Ah
jp_opc/rel_far: 8A0Fh
jp!: declare jcc!
jp!/opcode: jp_opc

js_opc: declare relx!
js_opc/rel_8:   78h
js_opc/rel_far: 880Fh
js!: declare jcc!
js!/opcode: js_opc

jcc: func [
    [typed] count [integer!] list [typed-value!]
    /local
        a    [typed-value!]
        opc  [integer!]
        diff [integer!]
        size [integer!]
        ptr  [int-ptr!]
        type [type!]
        jxx  [jcc!]
        req  [lab_req!]
][
    type: null
    jxx:  null
    until [
        a: list
        if a/type = system/alias/type! [
            type: as type! a/value
            ptr: as int-ptr! request_ptrs
            ptr: ptr + req_offset
            req: as lab_req! ptr
            req/pc:  pc_offset
        ]
        if a/type = system/alias/jcc! [
            jxx: as jcc! a/value
        ]
        if a/type = type-int-ptr! [
            switch type/id [
                ; reserve place for opcode
                _rel8  [emit_byte _rel8  1 size: 1 opc: jxx/opcode/rel_8]
                _rel16 [emit_byte _rel16 1 size: 4 opc: jxx/opcode/rel_far]
                _rel32 [emit_byte _rel32 1 size: 5 opc: jxx/opcode/rel_far]
            ]
            emit_zero size
            req/ptr: a/value
            req/rel: opc
            request_ptr_inc 1
        ]
        if a/type = type-integer! [
            switch type/id [
                _rel8  [diff: a/value - pc_offset - 1
                    if diff < -128 [Error_rel8 quit 3]
                    opc: jxx/opcode/rel_8
                    emit_byte opc 1 emit_byte diff  1]
                _rel16 [diff: a/value - pc_offset - 4
                    if diff < -32768 [Error_rel16 quit 3]
                    opc: jxx/opcode/rel_far
                    emit_opcode opc 66h diff: diff and FFFFh 
                    emit_opcode diff 0]
                _rel32 [diff: a/value - pc_offset - 5
                    if diff < -2147483648 [Error_rel32 quit 3]
                    opc: jxx/opcode/rel_far
                    emit_opcode opc 0 emit_opcode diff 0]
            ]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

ja: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type ja! ptr]
        ]
        if list/type = type-integer! [
            jcc [type ja! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

je: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type je! ptr]
        ]
        if list/type = type-integer! [
            jcc [type je! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jae: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jae! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jae! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jb: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jb! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jb! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jbe: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jbe! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jbe! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jc: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jb! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jb! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jcxz: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jcxz! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jcxz! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jrcxz: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jcxz! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jcxz! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jecxz: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jcxz! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jcxz! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jg: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jg! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jg! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jge: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jge! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jge! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jl: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jl! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jl! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jle: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jle! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jle! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jna: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jbe! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jbe! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnae is same as jb
jnae: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jb! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jb! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnb is same as jae
jnb: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jae! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jae! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnbe is same as ja
jnbe: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type ja! ptr]
        ]
        if list/type = type-integer! [
            jcc [type ja! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnc is same as jae
jnc: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jae! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jae! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jne: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jne! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jne! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jng is same as jle
jng: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jle! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jle! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnge is same as jl
jnge: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jl! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jl! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnl is same as jge
jnl: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jge! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jge! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnle is same as jg
jnle: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jg! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jg! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jno: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jno! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jno! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jnp: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jnp! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jnp! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jns: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jns! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jns! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jnz is same as jne
jnz: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jne! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jne! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jo: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jo! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jo! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

jp: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jp! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jp! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jpe is same as jp
jpe: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jp! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jp! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jpo is same as jnp
jpo: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type jnp! ptr]
        ]
        if list/type = type-integer! [
            jcc [type jnp! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

js: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type js! ptr]
        ]
        if list/type = type-integer! [
            jcc [type js! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]

;jz is same as je
jz: func [
    [typed] count [integer!] list [typed-value!]
    /local
        type [type!]
        ptr  [int-ptr!]
][
    type: null
    until [
        if list/type = system/alias/type! [
            type: as type! list/value
        ]
        if type = null [Error_no_type quit 3]
        if list/type = type-int-ptr! [
            ptr: as int-ptr! list/value
            jcc [type je! ptr]
        ]
        if list/type = type-integer! [
            jcc [type je! list/value]
        ]
        list: list + 1
        count: count - 1
        zero? count
    ]
]