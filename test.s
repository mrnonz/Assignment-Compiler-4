LC0:
	.ascii "kuy\0"
LC1:
	.ascii "kuy1\0"
LC2:
	.ascii "kuy2\0"
LC3:
	.ascii "Hello World\0"
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
	movl $45, %eax
	movl %eax, 168(%esp)
	movl	168(%esp), %edx
	movl	$45, %eax
	cmp		%eax, %edx
	jne		nxt0
	movl	$LC0, (%esp)
	call	_puts
	movl	168(%esp), %edx
	movl	$45, %eax
	cmp		%eax, %edx
	jne		nxt0
	movl	$LC1, (%esp)
	call	_puts
	nxt0:
	movl	$42, %edx
	movl	$45, %eax
	cmp		%eax, %edx
	jne		nxt1
	movl	$LC2, (%esp)
	call	_puts
	nxt1:
	nxt2:
	movl	$LC3, (%esp)
	call	_puts
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
