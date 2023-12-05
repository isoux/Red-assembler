Red/System [
	Title:	"Sys calls defines"
	Author: "Isoux"
	File: 	%sys-defines.reds
	Tabs: 	4
	Rights: "Copyright (C) 2023 Isoux. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

#define O_RDONLY    0
#define O_WRONLY    1
#define O_RDWR      2
#define O_BINARY    0
#define O_CREAT     64
#define O_EXCL      128
#define O_TRUNC     512
#define O_APPEND    1024

#define S_IREAD     256
#define S_IWRITE    128
#define S_IRGRP     32
#define S_IWGRP     16
#define S_IROTH     4
;S_IRWXU  00700

#define SYS_C_exit   1
#define SYS_C_fork   2
#define SYS_C_read   3
#define SYS_C_write  4
#define SYS_C_open   5
#define SYS_C_close  6

#syscall [
   _write: SYS_C_write [
       fd      [integer!]  ;-- file descriptor, like STDOUT = 1
       buffer  [c-string!]
       count   [integer!]
       return: [integer!]
   ]
   _quit: 1 [              ;-- "exit" syscall, no return value
       status  [integer!]
   ]
]

#syscall [
	_open: SYS_C_open  [
		filename [c-string!]
		flags    [integer!]
		mode     [integer!]
		return:  [integer!]
	]
]

#syscall [
 _close: SYS_C_close  [
	fd          [integer!]
	return:     [integer!]
	]
]
