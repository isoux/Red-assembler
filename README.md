# Red-assembler
Assembler based exclusively on the Red - Red/System programming language

With the Red language, the fun and enjoyment of programming is truly back to me the poor one "programmer"! 

Instructions are translated into machine code and stored in binary format on disk.

Unfortunately, since I'm at the very beginning, so far only one MOV instruction has been processed and that's not complete.
I added the bswap instruction because I really needed it and it was easy to implement.

Try it:

        $ ./run.sh
or step by step:

        $ redc test.reds
        $ ./test
To check if the instructions are correct:

        $ objdump -b binary -m i386 -M intel -D text.bin > text.dump

In the file text.dump at the section .data: you should find the content:

          0:	8a c3                	mov    al,bl
          2:	8a e7                	mov    ah,bh
          4:	8b c3                	mov    eax,ebx
          6:	b0 cf                	mov    al,0xcf
          8:	66 b8 6e a0          	mov    ax,0xa06e
          c:	bb a4 c3 b2 f1       	mov    ebx,0xf1b2c3a4
         11:	a0 48 ef cd ab       	mov    al,ds:0xabcdef48
         16:	8a 0d b6 c5 00 00    	mov    cl,BYTE PTR ds:0xc5b6
         1c:	8a 25 48 ef cd ab    	mov    ah,BYTE PTR ds:0xabcdef48
         22:	8a 3d 48 ef cd ab    	mov    bh,BYTE PTR ds:0xabcdef48
         28:	66 a1 4d 3c 2b 1a    	mov    ax,ds:0x1a2b3c4d
         2e:	66 8b 0d 4d 3c 2b 1a 	mov    cx,WORD PTR ds:0x1a2b3c4d
         35:	a1 98 ab dc fe       	mov    eax,ds:0xfedcab98
         3a:	8b 15 98 ab dc fe    	mov    edx,DWORD PTR ds:0xfedcab98
         40:	a2 98 ab dc fe       	mov    ds:0xfedcab98,al
         45:	88 0d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,cl
         4b:	88 25 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,ah
         51:	88 3d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,bh
         57:	66 a3 98 ab dc fe    	mov    ds:0xfedcab98,ax
         5d:	66 89 15 98 ab dc fe 	mov    WORD PTR ds:0xfedcab98,dx
         64:	a3 98 ab dc fe       	mov    ds:0xfedcab98,eax
         69:	89 1d 98 ab dc fe    	mov    DWORD PTR ds:0xfedcab98,ebx
         6f:	64 a2 98 ab dc fe    	mov    fs:0xfedcab98,al
         75:	65 88 0d 98 ab dc fe 	mov    BYTE PTR gs:0xfedcab98,cl
         7c:	66 36 89 1d 98 ab dc 	mov    WORD PTR ss:0xfedcab98,bx
         83:	fe 
         84:	66 26 89 15 98 ab dc 	mov    WORD PTR es:0xfedcab98,dx
         8b:	fe 
         8c:	3e a3 98 ab dc fe    	mov    ds:0xfedcab98,eax
         92:	64 89 35 98 ab dc fe 	mov    DWORD PTR fs:0xfedcab98,esi
         99:	0f cb                	bswap  ebx