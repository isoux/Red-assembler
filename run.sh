#!/bin/bash
redc test.reds
./test
objdump  -b binary -m i386 -M intel -D text.bin > text.dump
#rm -f text.bin