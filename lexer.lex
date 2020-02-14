

%{
	int line = 1;
	int col = 1;
	#include "heading.h"
	#include "tok.h"
%}

FUNCTION	function
BEGIN_PARAMS	beginparams
END_PARAMS	endparams
BEGIN_LOCALS	beginlocals
END_LOCALS	endlocals
BEGIN_BODY	beginbody
END_BODY	endbody
INTEGER		integer
ARRAY		array
OF		of
IF		if
THEN		then
ENDIF		endif
ELSE		else
WHILE		while
DO		do
FOR		for
BEGINLOOP	beginloop
ENDLOOP		endloop
CONTINUE	continue
READ		read
WRITE		write
AND		and
OR		or
NOT		not
TRUE		true
FALSE		false
RETURN		return
MAIN		main
NUMBER   	[0-9]
IDENTIFIER	[a-zA-Z]+[a-zA-Z0-9_]*[a-zA-Z0-9]|[a-zA-Z]
SEMICOLON	;
COLON		:
COMMA		,
PLUS    	\+
MINUS   	-
MULT    	\*
DIV     	\/
MOD		%
L_PAREN 	\(
R_PAREN 	\)
EQUAL		==
NEQ		<>
LT		<
GT		>
LTE		<=
GTE		>=
LSQBRACKET	\[
RSQBRACKET	\]
ASSIGN		:=
NUM_FIRST_ERROR		[0-9]+_*[a-zA-Z]+[a-zA-Z0-9_]*[a-zA-Z0-9]*
UNDERSCORE_ERROR	[a-zA-Z][a-zA-Z0-9_]*_
COMMENT		##.*
UNEXPECTED_ERROR	.

%%
{FUNCTION}	{ col += yyleng; return FUNCTION; };
{BEGIN_PARAMS}	{ col += yyleng; return BEGIN_PARAMS; };
{END_PARAMS}	{ col += yyleng; return END_PARAMS; };
{BEGIN_LOCALS}	{ col += yyleng; return BEGIN_LOCALS; };
{END_LOCALS}	{ col += yyleng; return END_LOCALS; };
{BEGIN_BODY}	{ col += yyleng; return BEGIN_BODY; };
{END_BODY}	{ col += yyleng; return END_BODY; };
{INTEGER}	{ col += yyleng; return INTEGER; };
{ARRAY}		{ col += yyleng; return ARRAY; };
{OF}		{ col += yyleng; return OF; };
{IF}            { col += yyleng; return IF;};
{THEN}          { col += yyleng; return THEN; };
{ENDIF}		{ col += yyleng; return ENDIF; };
{ELSE}		{ col += yyleng; return ELSE; }; 
{WHILE}		{ col += yyleng; return WHILE; }; 
{DO}		{ col += yyleng; return DO; }; 
{FOR}		{ col += yyleng; return FOR; }; 
{BEGINLOOP}	{ col += yyleng; return BEGINLOOP; }; 
{ENDLOOP}	{ col += yyleng; return ENDLOOP; }; 
{CONTINUE}	{ col += yyleng; return CONTINUE; };
{READ}		{ col += yyleng; return READ; };
{WRITE}		{ col += yyleng; return WRITE; };
{AND}		{ col += yyleng; return AND; };
{OR}		{ col += yyleng; return OR; };
{NOT}		{ col += yyleng; return NOT; };
{TRUE}		{ col += yyleng; return TRUE; };
{FALSE}		{ col += yyleng; return FALSE; };
{RETURN}	{ col += yyleng; return RETURN; };
{L_PAREN}       { col += yyleng; return L_PAREN; };                   //(
{R_PAREN}       { col += yyleng; return R_PAREN; };                   //)
{EQUAL}         { col += yyleng; return EQUAL; };                     //=
{PLUS}          { col += yyleng; return PLUS; };                      //+
{MINUS}         { col += yyleng; return MINUS; };                     //-
{MULT}          { col += yyleng; return MULT; };
{DIV}           { col += yyleng; return DIV; };

{MOD}		{ col += yyleng; return MOD; };	//Mod operator

{NEQ}   	{ col += yyleng; return NEQ; };	//not equal
{LTE}		{ col += yyleng; return LTE; };	//less than or equal to
{GTE}		{ col += yyleng; return GTE; };	//greater than or equal to
{LT}		{ col += yyleng; return LT; };		//less than
{GT}		{ col += yyleng; return GT; };		//greater than
{SEMICOLON}	{ col += yyleng; return SEMICOLON; };	//semicolon
{COLON}		{ col += yyleng; return COLON; };	//colon
{COMMA}		{ col += yyleng; return COMMA; };	//comma

{LSQBRACKET}	{ col += yyleng; return LSQBRACKET; };	//left square bracket
{RSQBRACKET}	{ col += yyleng; return RSQBRACKET; };	//right square bracket
{ASSIGN}	{ col += yyleng; return ASSIGN; };		//assign statement
{COMMENT}		
{NUM_FIRST_ERROR}	{ col+= yyleng; return NUM_FIRST_ERROR; };
{UNDERSCORE_ERROR}      { col += yyleng; return UNDERSCORE_ERROR; };
{IDENTIFIER}		{ yylval.tag = strdup(yytext); return IDENTIFIER; };  
{NUMBER}+       	{ col+= yyleng; yylval.dval = atoi(yytext); return NUMBER; };
"{"[\^{}}\n]*"}"`	{col++;};
[ \t]+			{ col++;};
[\n]+			{ line++; col = 1; return END; };

%%



