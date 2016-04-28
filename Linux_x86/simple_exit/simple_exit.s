.section .text
	.global _start
_start:
	xor	%eax, %eax	# xor's out eax register
	xor	%ebx, %ebx	# xor's out ebx register
	movb	$1, %al		# puts '1' into lower section of eax reg, instead of taking up the entire register.
	int	$0x80		# kernel call to execute the above.
