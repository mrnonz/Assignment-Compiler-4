LC0:
	.ascii "%d\12\0"
LC1:
	.ascii "Hello world\0"
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
	movl $1, %eax
	neg %eax
	movl %eax, 52(%esp)
	movl $5, %eax
	movl %eax, 56(%esp)
	movl $9, %eax
	movl %eax, 60(%esp)
	movl 56(%esp), %eax
	cltd
	idivl	60(%esp)
	movl %edx, 56(%esp)
	movl %edx, %eax
	movl 52(%esp), %eax
	movl 56(%esp), %edx
	addl	%edx, %eax
	movl %eax, 52(%esp)
	movl $4, %eax
	neg %eax
	movl %eax, 56(%esp)
	movl $12, %eax
	movl %eax, 60(%esp)
	movl 56(%esp), %eax
	movl 60(%esp), %edx
	addl	%edx, %eax
	movl %eax, 56(%esp)
	movl $5, %eax
	movl %eax, 60(%esp)
	movl 56(%esp), %eax
	movl 60(%esp), %edx
	imul	%edx, %eax
	movl %eax, 56(%esp)
	movl 52(%esp), %eax
	movl 56(%esp), %edx
	addl	%edx, %eax
	movl %eax, 52(%esp)
	movl %eax, 100(%esp)
	movl	100(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	movl	$LC1, (%esp)
	call	_puts
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
