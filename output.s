LC0:
	.ascii "%d\12\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$2804, %esp
	call	___main
	movl $4, %eax
	movl %eax, 52(%esp)
	movl $4, 104(%esp)
	movl $1, %eax
	movl %eax, 52(%esp)
	movl $1, 208(%esp)
	movl 104(%esp), %eax
	movl %eax, 52(%esp)
	movl 208(%esp), %eax
	movl %eax, 56(%esp)
	movl 52(%esp), %eax
	movl 56(%esp), %edx
	addl	%edx, %eax
	movl %eax, 52(%esp)
	movl %eax, 316(%esp)
	movl	316(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
