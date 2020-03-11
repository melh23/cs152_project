#define YY_NO_UNPUT

#include <iostream>
#include <stdio.h>
#include <string>
#include <cstring>
#include <cstdlib>
#include <vector>
using namespace std;


struct state
{
	char* code;
	char* str;
	char* oper;
	char* dest;
	char* lhs;
	char* rhs;
	char* truelabel;
	char* falselabel;
	char* endlabel;
};

/*
int countL = 0; 
int countT = 0;
enum TYPE{
	INT, STRING, DEFAULT
};

extern string newlabel(){

    string toReturn;
    toReturn = "label_" + itoa( countL );
    countL++;
    return toReturn;
}

extern string newtemp(){
    string toReturn;
    toReturn = "temp_" + to_string( countT );
    countT++;
    return toReturn;
}
*/
