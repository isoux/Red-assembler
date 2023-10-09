# Red-assembler
Assembler for Red/System based exclusively on the Red programming language

With the Red language, the fun and enjoyment of programming is truly back to me the poor one "programmer"! 

The basic idea, as the first step and the fastest way, was to insert the code in the Red/System files that will process the assembler instruction and then pass it to the directive  #inline #{xxxx} ...

But the #inline directive does not accept any variable other than a hard-coded value of type binary! ( Like #inline #{88C3} )

That's why this simple test program as a result prints this desired form on the output, which you can copy in the %*.reds file...

The project is at the very beginning and is waiting for "positive" reactions and support and justification as to whether this is necessary at all. But Red/System as a low-level language should surely have some form of its assembler?
It will definitely benefit me...

Unfortunately, since I'm at the very beginning, so far only one MOV instruction has been processed and that's not complete.
I added the bswap instruction because I really needed it and it was easy to implement.

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
       8048428:	8a c3                	mov    al,bl
       804842a:	8a e7                	mov    ah,bh
       804842c:	8b c3                	mov    eax,ebx
       804842e:	b0 cf                	mov    al,0xcf
       8048430:	66 b8 6e a0          	mov    ax,0xa06e
       8048434:	bb a4 c3 b2 f1       	mov    ebx,0xf1b2c3a4
       8048439:	a0 48 ef cd ab       	mov    al,ds:0xabcdef48
       804843e:	8a 1d b6 c5 00 00    	mov    bl,BYTE PTR ds:0xc5b6
       8048444:	8a 25 48 ef cd ab    	mov    ah,BYTE PTR ds:0xabcdef48
       804844a:	8a 3d 48 ef cd ab    	mov    bh,BYTE PTR ds:0xabcdef48
       8048450:	8a 2d 48 ef cd ab    	mov    ch,BYTE PTR ds:0xabcdef48
       8048456:	8a 35 48 ef cd ab    	mov    dh,BYTE PTR ds:0xabcdef48
       804845c:	66 a1 4d 3c 2b 1a    	mov    ax,ds:0x1a2b3c4d
       8048462:	66 8b 1d 4d 3c 2b 1a 	mov    bx,WORD PTR ds:0x1a2b3c4d
       8048469:	66 8b 0d 4d 3c 2b 1a 	mov    cx,WORD PTR ds:0x1a2b3c4d
       8048470:	66 8b 15 4d 3c 2b 1a 	mov    dx,WORD PTR ds:0x1a2b3c4d
       8048477:	a1 98 ab dc fe       	mov    eax,ds:0xfedcab98
       804847c:	8b 1d 98 ab dc fe    	mov    ebx,DWORD PTR ds:0xfedcab98
       8048482:	8b 0d 98 ab dc fe    	mov    ecx,DWORD PTR ds:0xfedcab98
       8048488:	8b 15 98 ab dc fe    	mov    edx,DWORD PTR ds:0xfedcab98
       804848e:	0f cb                	bswap  ebx
       8048490:	90                   	nop