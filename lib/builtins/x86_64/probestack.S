// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "../assembly.h"

// du_int __probestack(du_int size, du_int guard_size);

// `size` is passed in rax, `guard_size` is passed in rbx,
// and this does not clobber any registers but rax.
// `size` is returned in rax aligned up to 16 bytes.

#ifndef __WIN32__
#ifdef __x86_64__

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
	// Align size to 16 bytes
	addq $15, %rax
	andq $-16, %rax

	pushq %rax
.cfi_adjust_cfa_offset 8
.cfi_rel_offset %rax, 0
	pushq %r11
.cfi_adjust_cfa_offset 8
.cfi_rel_offset %r11, 0

	// Load the pre-call RSP into R11
	leaq 24(%rsp), %r11

1:
	subq %rbx, %r11
	orb $0, (%r11)
	subq %rbx, %rax
	ja 1b

	popq %r11
.cfi_adjust_cfa_offset -8
.cfi_restore %r11
	popq %rax
.cfi_adjust_cfa_offset -8
.cfi_restore %rax
	ret
.cfi_endproc
END_COMPILERRT_FUNCTION(__probestack)

#endif // __x86_64__
#endif // __WIN32__
