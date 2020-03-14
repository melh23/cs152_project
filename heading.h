#define YY_NO_UNPUT

#include <iostream>
#include <stdio.h>
#include <string>
#include <cstring>
#include <vector>
#include <cstdlib>
#include <fstream>
using namespace std;


struct state
{
	char* code;
	char* str;
	char* oper;
	char* falselabel;
	char* endlabel;
	char* index;
	bool arr;
};


