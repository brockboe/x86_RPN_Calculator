//io.c
//C functions used within the assembly program
//to get input and output from the console.
//All other actions are performed in the assembly
//code

#define MAXLEN 30

#include <stdio.h>
#include <stdlib.h>

//gets
//Grabs a string from STDIN and returns a pointer
//to the mentioned string
char * gets(){
     char * string = malloc(sizeof(char)*MAXLEN);
     fgets(string, MAXLEN, stdin);
     return string;
}

//outf
//takes a pointer to a character and then prints it
//out to STDOUT formatted as a character
void outf(char * character){
     printf("%c", character);
     return;
}

//outn
//takes a pointer to an integer and then prints it
//out to STDOUT formatted as a number
void outn(int * input){
     printf("%d\n", input);
     return;
}

//prints
//takes a pointer to a string and then prints it
//to STDOUT
void prints(char * string){
     printf("%s", string);
     return;
}

//nl
//literally just prints out the new line character
//to advance the screen
void nl(){
     printf("\n");
     return;
}
