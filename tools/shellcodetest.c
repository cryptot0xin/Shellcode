/*shellcodetest.c*/ 
char code[] =	"SHELLCODE HERE";

int main(int argc, char **argv)
{
	int (*func)();
	func = (int (*)()) code;
	(int)(*func)();
}
