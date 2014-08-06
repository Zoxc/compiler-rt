// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "../assembly.h"

// void __probestack(du_int size);

// `size` is passed in rax and this does not clobber any registers
// including the parameter rax.

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
	pushq %rax
.cfi_adjust_cfa_offset 8
.cfi_rel_offset %rax, 0
	pushq %r11
.cfi_adjust_cfa_offset 8
.cfi_rel_offset %r11, 0
	movq %rsp, %r11
	subq $0x1018, %rax
	jb 2f

1:
	subq $0x1000, %r11
	orb $0, (%r11)
	subq $0x1000, %rax
	ja 1b

2:
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
