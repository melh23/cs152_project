
DIGIT   [0-9]
ID      [a-z][a-z0-9]*
PLUS    \+
MINUS   -
MULT    \*
DIV     \/
L_PAREN \(
R_PAREN \)
EQUAL   =

%%
{DIGIT}+        printf("DIGIT \n");                     //num
{L_PAREN}       printf("L_PAREN \n");                   //(
{R_PAREN}       printf("R_PAREN \n");                   //)
{EQUAL}         printf("EQUAL \n");                     //=
{PLUS}          printf("PLUS \n");                      //+
{MINUS}         printf("MINUS \n");                     //-
{MULT}          printf("MULT \n");
{DIV}           printf("DIV \n");
"{"[\^{}}\n]*"}"
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
