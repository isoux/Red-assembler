Red/System [
    Title:  "Red-Assembler label management"
    Author: "Isoux"
    File:   %asm-label.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
    Note: {
        Labels initializing and linking management for jcc instructions
    }
    Needs: {
        #include %asm-compiler.reds
    }
]

lab_req!: alias struct![
    pc  [integer!]
    ptr [integer!]
    opc [integer!]
]

request_ptrs: allocate 3000h
req_offset: 0
req_size: 0

lab_ptrs: allocate 1000h
ptrs_offset: 1
ptrs_size: 0

request_ptr_inc: func [
    size [integer!]
][
    req_size:   req_size   + size
    req_offset: req_offset + 3
]

lab_ptr_inc: func [
    size [integer!]
][
    ptrs_size:   ptrs_size   + size
    ptrs_offset: ptrs_offset + 4
]

request!: func[return: [integer!]][0]

label!: func [
    return: [integer!]
    /local
        ptr  [int-ptr!]
][
    ptr: as int-ptr! lab_ptrs
    ptr: ptr + ptrs_size
    ptr/value: pc_size
    lab_ptr_inc 1
    print ["Allocated label: lab_" ptrs_size lf]
    print ["PC_offset      : " ptr/value lf]
    pc_size
]

link_labels: func [
    /local
        i     [integer!]
        a     [integer!]
        rel   [integer!]
        diff  [integer!]
        offset[integer!]
        ptr   [int-ptr!]
        label [int-ptr!]
        req   [lab_req!]
        buf_pc[byte-ptr!]
][
    i: 1
    ptr: as int-ptr! request_ptrs
    buf_pc:  pc_buf
    while [i <= req_size][ 
        req: as lab_req! ptr 
        a: req/pc
        rel: as integer! buf_pc/a 
        label: as int-ptr! req/ptr
        offset: label/value
        switch rel [
            _rel8[diff: offset - a - 1
                if diff > 127 [ Error_rel8 quit 3 ]
                buf_pc/a: as byte! req/opc a: a + 1
                buf_pc/a: as byte! diff]
            _rel16[diff: offset - a - 4
                if diff > 32767 [ Error_rel16 quit 3 ]
                buf_pc/a: as byte! 66h     a: a + 1
                buf_pc/a: as byte! req/opc a: a + 1
                req/opc: req/opc >> 8
                buf_pc/a: as byte! req/opc a: a + 1
                buf_pc/a: as byte! diff    a: a + 1
                diff: diff >> 8 
                buf_pc/a: as byte! diff
                ]
            _rel32[diff: offset - a - 5
                if diff > 2147483647 [ Error_rel32 quit 3 ]
                buf_pc/a: as byte! req/opc a: a + 1
                req/opc: req/opc >> 8
                buf_pc/a: as byte! req/opc a: a + 1
                buf_pc/a: as byte! diff    a: a + 1
                diff: diff >> 8 
                buf_pc/a: as byte! diff    a: a + 1
                diff: diff >> 8
                buf_pc/a: as byte! diff    a: a + 1
                diff: diff >> 8
                buf_pc/a: as byte! diff
                ]
        ]
        ptr: ptr + 3
        i: i + 1
    ]
]

free_labels: does [ 
    free lab_ptrs
    free request_ptrs
]

Error_lf: does [print [lf"ERROR!"lf]]

Error_rel8: does [ Error_lf
    print ["Should choose rel16 for label."lf lf]
]

Error_rel16: does [ Error_lf
    print ["Should choose rel32 for label."lf lf]
]

Error_rel32: does [ Error_lf
    print ["The relative offset exceeds the limits of the 32-bit system."lf lf]
]

Error_no_type: does [ Error_lf
    print ["Should specify a relative offset."lf]
    print ["Like: jxx [rel8 labx]."lf lf]
]