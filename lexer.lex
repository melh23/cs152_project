
FUNCTION	function
BEGIN_PARAMS	beginparams
END_PARAMS	endparams
BEGIN_LOCALS	beginlocals
END_LOCALS	endlocals
BEGIN_BODY	endbody
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
