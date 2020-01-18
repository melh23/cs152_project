
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
RSBRACKET	\]
ASSIGN		:=
COMMENT		##.*

%%
{FUNCTION}	printf("FUNCTION \n");
{BEGIN_PARAMS}	printf("BEGIN_PARAMS \n");
{END_PARAMS}	printf("END_PARAMS \n");
{BEGIN_LOCALS}	printf("BEGIN_LOCALS \n");
{END_LOCALS}	printf("END_LOCALS \n");
{BEGIN_BODY}	printf("BEGIN_BODY \n");
{END_BODY}	printf("END_BODY \n");
{INTEGER}	printf("INTEGER \n");
{ARRAY}		printf("ARRAY \n");
{OF}		printf("OF \n");
{IF}            printf("IF \n");
{THEN}          printf("THEN \n");
{ENDIF}		printf("ENDIF \n");
{ELSE}		printf("ELSE \n"); 
{WHILE}		printf("WHILE \n"); 
{DO}		printf("DO \n"); 
{FOR}		printf("FOR \n"); 
{BEGINLOOP}	printf("BEGINLOOP \n"); 
{ENDLOOP}	printf("ENDLOOP \n"); 
{CONTINUE}	printf("CONTINUE \n");
{READ}		printf("READ \n");
{WRITE}		printf("WRITE \n");
{AND}		printf("AND \n");
{OR}		printf("OR \n");
{NOT}		printf("NOT \n");
{TRUE}		printf("TRUE \n");
{FALSE}		printf("FALSE \n");
{RETURN}	printf("RETURN \n");
{NUMBER}+       printf("NUMBER %s \n", yytext);                     //num
{L_PAREN}       printf("L_PAREN \n");                   //(
{R_PAREN}       printf("R_PAREN \n");                   //)
{EQUAL}         printf("EQUAL \n");                     //=
{PLUS}          printf("PLUS \n");                      //+
{MINUS}         printf("MINUS \n");                     //-
{MULT}          printf("MULT \n");
{DIV}           printf("DIV \n");

{MOD}		printf("MOD\n");	//Mod operator

{NEQ}   	printf("NEQ\n");	//not equal
{LTE}		printf("LTE\n");	//less than or equal to
{GTE}		printf("GTE\n");	//greater than or equal to
{LT}		printf("LT\n");		//less than
{GT}		printf("GT\n");		//greater than
{SEMICOLON}	printf("SEMICOLON\n");	//semicolon
{COLON}		printf("COLON\n");	//colon
{COMMA}		printf("COMMA\n");	//comma

{LSQBRACKET}	printf("L_SQUARE_BRACKET\n");	//left square bracket
{RSBRACKET}	printf("R_SQUARE_BRACKET\n");	//right square bracket
{ASSIGN}	printf("ASSIGN\n");		//assign statement
{COMMENT}
{IDENTIFIER}	printf("IDENTIFIER %s \n", yytext);  
"{"[\^{}}\n]*"}"`
[ \t\n]+
.               printf("unrecognized charachter!\n");

%%

int main(int argc, char **argv) {
        ++argv, --argc; /* skip over program name */
        if ( argc > 0 )
                yyin = fopen( argv[0], "r" );
        else
                yyin = stdin;
        yylex();
        return 0;
}


