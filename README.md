# Red-assembler
Assembler for Red/System based exclusively on the Red programming language

The basic idea, as the first step and the fastest way, was to insert the code in the Red/System files that will process the assembler instruction and then pass it to the directive  #inline #{xxxx} ...

But the #inline directive does not accept any variable other than a hard-coded value of type binary! ( Like #inline #{88C3} )

That's why this simple test program as a result prints this desired form on the output, which you can copy in the %x.reds file...

The project is at the very beginning and is waiting for "positive" reactions and support and justification as to whether this is necessary at all. But Red/System as a low-level language should surely have some form of its assembler?
It will definitely benefit me...

Unfortunately, since I'm at the very beginning, so far only one MOV instruction has been processed and that's only for eight-bit registers...

Try it:

        $ redc test.reds
        $ ./test
To check if the instructions are correct:

       $ redc dis_asm.reds
       $ objdump -D -z -M intel dis_asm > dis_asm.dmp
       or
       $ llvm-objdump -D -z --x86-asm-syntax=intel dis_asm > dis_asm.dmp
In the file dis_asm.dmp at the section .text: somewhere in the middle you should find similar content:

       8048426:	90                   	nop
       8048427:	8a c3                	mov    al,bl
       8048429:	8a d8                	mov    bl,al
       804842b:	8a c1                	mov    al,cl
       804842d:	8a c8                	mov    cl,al
       804842f:	8a c2                	mov    al,dl
       8048431:	8a d0                	mov    dl,al
       8048433:	8a d9                	mov    bl,cl
       8048435:	8a cb                	mov    cl,bl
       8048437:	8a da                	mov    bl,dl
       8048439:	8a d3                	mov    dl,bl
       804843b:	8a ca                	mov    cl,dl
       804843d:	8a d1                	mov    dl,cl
       804843f:	90                   	nop
       8048440:	8a c4                	mov    al,ah
       8048442:	8a e0                	mov    ah,al
       8048444:	8a e1                	mov    ah,cl
       8048446:	8a cc                	mov    cl,ah
       8048448:	8a f7                	mov    dh,bh
       804844a:	90                   	nop