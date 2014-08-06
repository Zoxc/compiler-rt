// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "../assembly.h"

// void __probestack(du_int size);

// `size` is passed in eax and this does not clobber any registers
// including the parameter eax.

#ifndef __WIN32__
#ifdef __i386__

#if defined(__APPLE__)
	.const
#elif defined(__ELF__)
	.section .rodata
#else
	.section .rdata,"rd"
#endif

.text
.balign 4
DEFINE_COMPILERRT_FUNCTION(__probestack)
.cfi_startproc
	pushl %eax
.cfi_adjust_cfa_offset 4
.cfi_rel_offset %eax, 0
	pushl %ecx
.cfi_adjust_cfa_offset 4
.cfi_rel_offset %ecx, 0
	movl %esp, %ecx
	subl $0x100C, %eax
	jb 2f

1:
	subl $0x1000, %ecx
	orb $0, (%ecx)
	subl $0x1000, %eax
	ja 1b

2:
	popl %ecx
.cfi_adjust_cfa_offset -4
.cfi_restore %ecx
	popl %eax
.cfi_adjust_cfa_offset -4
.cfi_restore %eax
	ret
.cfi_endproc
END_COMPILERRT_FUNCTION(__probestack)

#endif // __i386__
#endif // __WIN32__
