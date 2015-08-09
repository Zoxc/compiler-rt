// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "../assembly.h"

// du_int __probestack(du_int size, du_int guard_size);

// `size` is passed in eax, `guard_size` is passed in ebx,
// and this does not clobber any registers but eax.
// `size` is returned in eax aligned up to 4 bytes.

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
	// Align size to 4 bytes
	addl $3, %eax
	andl $-4, %eax

	pushl %eax
.cfi_adjust_cfa_offset 4
.cfi_rel_offset %eax, 0
	pushl %ecx
.cfi_adjust_cfa_offset 4
.cfi_rel_offset %ecx, 0

	// Load the pre-call ESP into ECX
	leal 12(%esp), %ecx

1:
	subl %ebx, %ecx
	orb $0, (%ecx)
	subl %ebx, %eax
	ja 1b

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
