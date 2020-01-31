

%{
	int line = 1;
	int col = 1;
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
RSBRACKET	\]
ASSIGN		:=
NUM_FIRST_ERROR		[0-9]+_*[a-zA-Z]+[a-zA-Z0-9_]*[a-zA-Z0-9]*
UNDERSCORE_ERROR	[a-zA-Z][a-zA-Z0-9_]*_
COMMENT		##.*

%%
{FUNCTION}	{printf("FUNCTION \n"); col += yyleng; };
{BEGIN_PARAMS}	{printf("BEGIN_PARAMS \n"); col += yyleng; };
{END_PARAMS}	{printf("END_PARAMS \n"); col += yyleng; };
{BEGIN_LOCALS}	{printf("BEGIN_LOCALS \n"); col += yyleng; };
{END_LOCALS}	{printf("END_LOCALS \n"); col += yyleng; };
{BEGIN_BODY}	{printf("BEGIN_BODY \n"); col+= yyleng; };
{END_BODY}	{printf("END_BODY \n"); col+= yyleng;};
{INTEGER}	{printf("INTEGER \n"); col+= yyleng; };
{ARRAY}		{printf("ARRAY \n"); col+= yyleng; };
{OF}		{printf("OF \n"); col+= yyleng; };
{IF}            {printf("IF \n"); col+= yyleng; };
{THEN}          {printf("THEN \n"); col+= yyleng; };
{ENDIF}		{printf("ENDIF \n"); col+= yyleng; };
{ELSE}		{printf("ELSE \n"); col+= yyleng; }; 
{WHILE}		{printf("WHILE \n"); col+= yyleng; }; 
{DO}		{printf("DO \n"); col+= yyleng; }; 
{FOR}		{printf("FOR \n"); col+= yyleng; }; 
{BEGINLOOP}	{printf("BEGINLOOP \n"); col+= yyleng; }; 
{ENDLOOP}	{printf("ENDLOOP \n"); col+= yyleng; }; 
{CONTINUE}	{printf("CONTINUE \n"); col+= yyleng; };
{READ}		{printf("READ \n"); col+= yyleng; };
{WRITE}		{printf("WRITE \n"); col+= yyleng; };
{AND}		{printf("AND \n"); col+= yyleng; };
{OR}		{printf("OR \n"); col+= yyleng; };
{NOT}		{printf("NOT \n"); col+= yyleng; };
{TRUE}		{printf("TRUE \n"); col+= yyleng; };
{FALSE}		{printf("FALSE \n"); col+= yyleng; };
{RETURN}	{printf("RETURN \n"); col+= yyleng; };
{L_PAREN}       {printf("L_PAREN \n"); col+= yyleng; };                   //(
{R_PAREN}       {printf("R_PAREN \n"); col+= yyleng; };                   //)
{EQUAL}         {printf("EQUAL \n"); col+= yyleng; };                     //=
{PLUS}          {printf("PLUS \n"); col+= yyleng; };                      //+
{MINUS}         {printf("MINUS \n"); col+= yyleng; };                     //-
{MULT}          {printf("MULT \n"); col+= yyleng; };
{DIV}           {printf("DIV \n"); col+= yyleng; };

{MOD}		{printf("MOD\n"); col+= yyleng; };	//Mod operator

{NEQ}   	{printf("NEQ\n"); col+= yyleng; };	//not equal
{LTE}		{printf("LTE\n"); col+= yyleng; };	//less than or equal to
{GTE}		{printf("GTE\n"); col+= yyleng; };	//greater than or equal to
{LT}		{printf("LT\n"); col+= yyleng; };		//less than
{GT}		{printf("GT\n"); col+= yyleng; };		//greater than
{SEMICOLON}	{printf("SEMICOLON\n"); col+= yyleng; };	//semicolon
{COLON}		{printf("COLON\n"); col+= yyleng; };	//colon
{COMMA}		{printf("COMMA\n"); col+= yyleng; };	//comma

{LSQBRACKET}	{printf("L_SQUARE_BRACKET\n"); col+= yyleng; };	//left square bracket
{RSBRACKET}	{printf("R_SQUARE_BRACKET\n"); col+= yyleng; };	//right square bracket
{ASSIGN}	{printf("ASSIGN\n"); col+= yyleng; };		//assign statement
{COMMENT}		
{NUM_FIRST_ERROR}	{printf("error at line %d, column %d: identifier \"%s\" must begin with a letter \n", line, col, yytext); col+= yyleng; };
{UNDERSCORE_ERROR}      {printf("error at line %d, column %d: identifier \"%s\" must not end with an underscore \n", line, col, yytext); col += yyleng; };
{IDENTIFIER}		{printf("IDENTIFIER %s \n", yytext);}  
{NUMBER}+       	{printf("NUMBER %s \n", yytext); col+= yyleng; };
"{"[\^{}}\n]*"}"`	{col++;};
[ \t]+		{col++;}
[\n]+		{line++; col = 1;};
.               {printf("error at line %d, column %d: unknown input \"%s\"  \n", line, col, yytext); col+= yyleng; };

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


