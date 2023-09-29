# Red-assembler
Assembler for Red/System based exclusively on the Red programming language

With the Red language, the fun and enjoyment of programming is truly back to me the poor one "programmer"! 

The basic idea, as the first step and the fastest way, was to insert the code in the Red/System files that will process the assembler instruction and then pass it to the directive  #inline #{xxxx} ...

But the #inline directive does not accept any variable other than a hard-coded value of type binary! ( Like #inline #{88C3} )

That's why this simple test program as a result prints this desired form on the output, which you can copy in the %x.reds file...

The project is at the very beginning and is waiting for "positive" reactions and support and justification as to whether this is necessary at all. But Red/System as a low-level language should surely have some form of its assembler?
It will definitely benefit me...

Unfortunately, since I'm at the very beginning, so far only one MOV instruction has been processed and that's only for general registers and immediate transfers to registers ... not yet for memory locations.

Try it:

        $ ./run.sh
or step by step:

        $ redc test.reds
        $ ./test
To check if the instructions are correct:

       $ redc dis_asm.reds
       $ objdump -d -z -M intel dis_asm > dis_asm.dmp
       or
       $ llvm-objdump -d -z --x86-asm-syntax=intel dis_asm > dis_asm.dmp
In the file dis_asm.dmp at the section .text: somewhere in the middle you should find similar content:

       8048427:	90                   	nop
       8048428:	0f cb                	bswap  ebx
       804842a:	8a c3                	mov    al,bl
       804842c:	8a e7                	mov    ah,bh
       804842e:	8b c3                	mov    eax,ebx
       8048430:	b0 cf                	mov    al,0xcf
       8048432:	66 b8 6e a0          	mov    ax,0xa06e
       8048436:	bb a4 c3 b2 f1       	mov    ebx,0xf1b2c3a4
       804843b:	90                   	nop