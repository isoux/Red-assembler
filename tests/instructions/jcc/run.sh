#!/bin/bash
redc jcc.reds
./jcc
objdump  -b binary -m i386 -M intel -D jcc.bin  > jcc.dump
