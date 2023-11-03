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
       804843e:	8a 0d b6 c5 00 00    	mov    cl,BYTE PTR ds:0xc5b6
       8048444:	8a 25 48 ef cd ab    	mov    ah,BYTE PTR ds:0xabcdef48
       804844a:	8a 3d 48 ef cd ab    	mov    bh,BYTE PTR ds:0xabcdef48
       8048450:	66 a1 4d 3c 2b 1a    	mov    ax,ds:0x1a2b3c4d
       8048456:	66 8b 0d 4d 3c 2b 1a 	mov    cx,WORD PTR ds:0x1a2b3c4d
       804845d:	a1 98 ab dc fe       	mov    eax,ds:0xfedcab98
       8048462:	8b 15 98 ab dc fe    	mov    edx,DWORD PTR ds:0xfedcab98
       8048468:	a2 98 ab dc fe       	mov    ds:0xfedcab98,al
       804846d:	88 0d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,cl
       8048473:	88 25 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,ah
       8048479:	88 3d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,bh
       804847f:	66 a3 98 ab dc fe    	mov    ds:0xfedcab98,ax
       8048485:	66 89 15 98 ab dc fe 	mov    WORD PTR ds:0xfedcab98,dx
       804848c:	a3 98 ab dc fe       	mov    ds:0xfedcab98,eax
       8048491:	89 1d 98 ab dc fe    	mov    DWORD PTR ds:0xfedcab98,ebx
       8048497:	64 a2 98 ab dc fe    	mov    fs:0xfedcab98,al
       804849d:	65 88 0d 98 ab dc fe 	mov    BYTE PTR gs:0xfedcab98,cl
       80484a4:	66 36 89 1d 98 ab dc 	mov    WORD PTR ss:0xfedcab98,bx
       80484ab:	fe 
       80484ac:	66 26 89 15 98 ab dc 	mov    WORD PTR es:0xfedcab98,dx
       80484b3:	fe 
       80484b4:	3e a3 98 ab dc fe    	mov    ds:0xfedcab98,eax
       80484ba:	64 89 35 98 ab dc fe 	mov    DWORD PTR fs:0xfedcab98,esi
       80484c1:	0f cb                	bswap  ebx
       80484c3:	90                   	nop