Red/System [
    Title:  "Registers definitions declaration and initializations"
    Author: "Isoux"
    File:   %registers.reds
    Tabs:   4
    Rights: "Copyright (C) 2023 Isoux isa@isoux.org. All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/isoux/Red-assembler/blob/main/LICENSE
    }
]

;The general-purpose registers
#enum GeneralRegs! [                  
    _AL: _AX: _EAX: _MM0: _XMM0: 0
    _CL: _CX: _ECX: _MM1: _XMM1: 1
    _DL: _DX: _EDX: _MM2: _XMM2: 2
    _BL: _BX: _EBX: _MM3: _XMM3: 3
    _AH: _SP: _ESP: _MM4: _XMM4: 4
    _CH: _BP: _EBP: _MM5: _XMM5: 5
    _DH: _SI: _ESI: _MM6: _XMM6: 6
    _BH: _DI: _EDI: _MM7: _XMM7: 7
]

#enum SegmentRegs! [
    _ES: 0
    _CS: 1
    _SS: 2
    _DS: 3
    _FS: 4
    _GS: 5
]

general-regs: {
    AL AX EAX MM0 XMM0 
    CL CX ECX MM1 XMM1 
    DL DX EDX MM2 XMM2
    BL BX EBX MM3 XMM3
    AH SP ESP MM4 XMM4
    CH BP EBP MM5 XMM5 
    DH SI ESI MM6 XMM6
    BH DI EDI MM7 XMM7
}

segment-regs: {
    ES CS SS DS FS GS 
}

AL: declare argument!
BL: declare argument!
CL: declare argument!
DL: declare argument!

AH: declare argument!
BH: declare argument!
CH: declare argument!
DH: declare argument!

AX: declare argument!
BX: declare argument!
CX: declare argument!
DX: declare argument!

SP: declare argument!
BP: declare argument!
SI: declare argument!
DI: declare argument!

EAX: declare argument!
EBX: declare argument!
ECX: declare argument!
EDX: declare argument!

ESP: declare argument!
EBP: declare argument!
ESI: declare argument!
EDI: declare argument!

ES: declare argument!
CS: declare argument!
SS: declare argument!
DS: declare argument!
FS: declare argument!
GS: declare argument!

AL/id:   _AL
AL/name: "AL"
AL/type: reg8

BL/id:   _BL
BL/name: "BL"
BL/type: reg8

CL/id:   _CL
CL/name: "CL"
CL/type: reg8

DL/id:   _DL
DL/name: "DL"
DL/type: reg8

AH/id:   _AH
AH/name: "AH"
AH/type: reg8

BH/id:   _BH
BH/name: "BH"
BH/type: reg8

CH/id:   _CH
CH/name: "CH"
CH/type: reg8

DH/id:   _DH
DH/name: "DH"
DH/type: reg8

AX/id:   _AX
AX/name: "AX"
AX/type: reg16

BX/id:   _BX
BX/name: "BX"
BX/type: reg16

CX/id:   _CX
CX/name: "CX"
CX/type: reg16

DX/id:   _DX
DX/name: "DX"
DX/type: reg16

SP/id:   _SP
SP/name: "SP"
SP/type: reg16

BP/id:   _BP
BP/name: "BP"
BP/type: reg16

SI/id:   _SI
SI/name: "SI"
SI/type: reg16

DI/id:   _DI
DI/name: "DI"
DI/type: reg16

EAX/id:   _EAX
EAX/name: "EAX"
EAX/type: reg32

EBX/id:   _EBX
EBX/name: "EBX"
EBX/type: reg32

ECX/id:   _ECX
ECX/name: "ECX"
ECX/type: reg32

EDX/id:   _EDX
EDX/name: "EDX"
EDX/type: reg32

ESP/id:   _ESP
ESP/name: "ESP"
ESP/type: reg32

EBP/id:   _EBP
EBP/name: "EBP"
EBP/type: reg32

ESI/id:   _ESI
ESI/name: "ESI"
ESI/type: reg32

EDI/id:   _EDI
EDI/name: "EDI"
EDI/type: reg32

ES/id:   _ES
ES/name: "ES"
ES/type: sreg3

CS/id:   _CS
CS/name: "CS"
CS/type: sreg3

SS/id:   _SS
SS/name: "SS"
SS/type: sreg3

DS/id:   _DS
DS/name: "DS"
DS/type: sreg3

FS/id:   _FS
FS/name: "FS"
FS/type: sreg3

GS/id:   _GS
GS/name: "GS"
GS/type: sreg3
