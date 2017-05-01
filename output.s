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
	movl	$2, %edx
	movl	$9, %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	$7, %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	$2, %eax
	addl	%edx, %eax
	movl %eax, 100(%esp)
	movl	$1, %edx
	movl	$1, %eax
	cmp		%eax, %edx
	jne		nxt0
	movl	100(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	nxt0:
	movl	$LC1, (%esp)
	call	_puts
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
