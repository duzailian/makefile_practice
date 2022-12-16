#include <stdio.h>


static int a = 10;


int test(int b) {

	printf("123:%d,%d",a,b);

	return 0;
}

int main(int argc, char **argv) {
	test(10);
	return 0;
}

int printf(const char *fmt, ...) {
	return 0;
}
