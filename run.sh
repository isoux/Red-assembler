red-tc test.reds
./test
red-tc dis_asm.reds
objdump -d -z -M intel dis_asm > dis_asm.dmp
