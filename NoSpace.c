#include <string.h>
#include <stdio.h>
#include <unistd.h>

int main( int argc, char *argv[] ) {

	// Check for only one argument
	if ( argc != 2 ) {
		printf("Format is: NoSpace <filename>\n");
		return(0);
	}
	// Check if filename has spaces
	else if ( strstr( argv[1], " ") == NULL) {
		printf("No space character in file: %s\n",argv[1]);
		return(0);
	}
	// Check if file exists
	else if ( access(argv[1], R_OK) == -1 ) {
		printf("Unable to read file: %s \n", argv[1]);
		return(0);
	}

	int	filename_size = strlen(argv[1]);
	char file_name_old[filename_size], file_name_new[filename_size];

	strcpy(file_name_old, argv[1]);
	strcpy(file_name_new, argv[1]);

	/* Find space and change to underscore
	   ASCII 32 = space; ACII 95 = underscore */
	for( int pos = 0; pos < filename_size; pos++) {
		if ( file_name_new[pos] == 32)  {
			file_name_new[pos] = 95;
		}
	}
	
	rename(file_name_old,file_name_new);
	return(0);
}
