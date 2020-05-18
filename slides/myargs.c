#include <stdio.h>

int main(int argc, char **argv) {
	printf("ARGS: %d\n", argc);

	for (int a = 0; a < argc; a += 1) {
		printf("%s\n", argv[a]);
	}

	return 0;
}
