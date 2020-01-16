
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
COMMENT		#
MAIN		main
DIGIT   	[0-9]
ID      	[a-z][a-z0-9]*
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
EQUAL   	=

%%
{FUNCTION}	printf("FUNCTION \n");
{BEGIN_PARAMS}	printf("BEGIN_PARAMS \n");
{END_PARAMS}	printf("END_PARAMS \n");
{BEGIN_LOCALS}	printf("BEGIN_LOCALSA \n");
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
{DIGIT}+        printf("DIGIT \n");                     //num
{L_PAREN}       printf("L_PAREN \n");                   //(
{R_PAREN}       printf("R_PAREN \n");                   //)
{EQUAL}         printf("EQUAL \n");                     //=
{PLUS}          printf("PLUS \n");                      //+
{MINUS}         printf("MINUS \n");                     //-
{MULT}          printf("MULT \n");
{DIV}           printf("DIV \n");
"{"[\^{}}\n]*"}"`
.               printf("unrecognized charachter! \n");
[ \t\n]+

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
