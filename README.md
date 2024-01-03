# Red-assembler
Assembler based exclusively on the Red - Red/System programming language.

With the Red language, the fun and enjoyment of programming is truly back to me the poor one "programmer"! 

Instructions are translated into machine code and stored in binary format on disk.

So far only MOV, JCC, BSWAP and NOP instructions has been processed and that's not complete.

Try it:

        $ ./run.sh
or step by step:

        $ redc test.reds
        $ ./test
To check if the instructions are correct:

        $ objdump -b binary -m i386 -M intel -D text.bin > text.dump

In the file text.dump at the section .data: you should find the content:

          0:	8a c3                	mov    al,bl
          2:	66 0f 87 a9 00       	ja     0xb0
          7:	8a e7                	mov    ah,bh
          9:	8b c3                	mov    eax,ebx
          b:	66 0f 83 3e 00       	jae    0x4e
          10:	b0 df                	mov    al,0xdf
          12:	66 b8 6e a0          	mov    ax,0xa06e
          16:	bb a4 c3 b2 f1       	mov    ebx,0xf1b2c3a4
          1b:	a0 48 ef cd ab       	mov    al,ds:0xabcdef48
          20:	74 2c                	je     0x4e
          22:	8a 0d b6 c5 00 00    	mov    cl,BYTE PTR ds:0xc5b6
          28:	8a 25 48 ef cd ab    	mov    ah,BYTE PTR ds:0xabcdef48
          2e:	8a 3d 48 ef cd ab    	mov    bh,BYTE PTR ds:0xabcdef48
          34:	76 cc                	jbe    0x2
          36:	66 a1 4d 3c 2b 1a    	mov    ax,ds:0x1a2b3c4d
          3c:	66 8b 0d 4d 3c 2b 1a 	mov    cx,WORD PTR ds:0x1a2b3c4d
          43:	a1 98 ab dc fe       	mov    eax,ds:0xfedcab98
          48:	8b 15 98 ab dc fe    	mov    edx,DWORD PTR ds:0xfedcab98
          4e:	a2 98 ab dc fe       	mov    ds:0xfedcab98,al
          53:	88 0d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,cl
          59:	88 25 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,ah
          5f:	88 3d 98 ab dc fe    	mov    BYTE PTR ds:0xfedcab98,bh
          65:	66 a3 98 ab dc fe    	mov    ds:0xfedcab98,ax
          6b:	66 89 15 98 ab dc fe 	mov    WORD PTR ds:0xfedcab98,dx
          72:	78 3c                	js     0xb0
          74:	a3 98 ab dc fe       	mov    ds:0xfedcab98,eax
          79:	89 1d 98 ab dc fe    	mov    DWORD PTR ds:0xfedcab98,ebx
          7f:	64 a2 98 ab dc fe    	mov    fs:0xfedcab98,al
          85:	65 88 0d 98 ab dc fe 	mov    BYTE PTR gs:0xfedcab98,cl
          8c:	66 36 89 1d 98 ab dc 	mov    WORD PTR ss:0xfedcab98,bx
          93:	fe 
          94:	66 26 89 15 98 ab dc 	mov    WORD PTR es:0xfedcab98,dx
          9b:	fe 
          9c:	66 0f 8f 61 ff       	jg     0x2
          a1:	3e a3 98 ab dc fe    	mov    ds:0xfedcab98,eax
          a7:	64 89 35 98 ab dc fe 	mov    DWORD PTR fs:0xfedcab98,esi
          ae:	7b 9e                	jnp    0x4e
          b0:	0f cb                	bswap  ebx
          b2:	e3 9a                	jecxz  0x4e
          b4:	90                   	nop