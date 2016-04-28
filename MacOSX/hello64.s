	.data
greeting:
	.asciz "Hello World (x86_64)\n"
len:
	.long len - greeting

	.text
	.globl start
start:
	movq len(%rip), %rdx
	leaq greeting(%rip), %rsi
	movq $0x1, %rdi
	movq $0x02000004, %rax
	syscall

	movq $0x0, %rdi
	movq $0x02000001, %rax
	syscall
