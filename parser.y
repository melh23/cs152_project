/* Parser */
/* parser.y */

%{
#include "heading.h"
extern void yyerror(const char *s);
extern int line;
extern int col;
extern int yylex();
//extern int yylineno;  // defined and maintained in lex.c
  //extern char *yytext;  // defined and maintained in lex.c

%}

%union{
  int		dval;
  char*	tag;
}

%start	program

%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY OF ARRAY
%token	IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT 
%token	TRUE FALSE RETURN MAIN INTEGER SEMICOLON COLON COMMA PLUS MINUS MULT DIV MOD
%token	L_PAREN R_PAREN EQUAL NEQ LT GT LTE GTE LSQBRACKET RSQBRACKET ASSIGN 
%token	NUM_FIRST_ERROR UNDERSCORE_ERROR UNEXPECETED_ERROR END 

%token	<tag>	IDENTIFIER
%token 	<dval> 	NUMBER

%type	<tag>	multipl_expr
%type	<tag>	exp 
%type 	<tag>	var term

%%

program:	/*empty*/
		| function 
		;

function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS 
		BEGIN_LOCALS fxn_dec END_LOCALS
		BEGIN_BODY statement SEMICOLON fxn_statem END_BODY
		;

fxn_dec:	/*empty*/
		| declaration SEMICOLON fxn_dec
		;

fxn_statem:	/*empty*/
		| statement SEMICOLON fxn_statem
		;

declaration:    IDENTIFIER dec_comma SEMICOLON INTEGER
                | IDENTIFIER dec_comma SEMICOLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER
                ;

dec_comma:	/*empty*/
		| COMMA IDENTIFIER dec_comma
		;

statement:	var ASSIGN exp
		| IF bool_expr THEN statm_else ENDIF
		| WHILE bool_expr BEGINLOOP statm_loop ENDLOOP
		| DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr
		| FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP
		| READ var statm_var
		| WRITE var statm_var
		| CONTINUE
		| RETURN exp
		;

statm_else:	ELSE statm_loop
		| statm_base
		;

statm_loop:	statm_base
		| statm_base statm_loop
		;

statm_base:	statement SEMICOLON;

statm_var:	/*empty*/
		| COMMA var
		;

bool_expr:      relation_and_expression
                | relation_and_expression OR relation_and_expression
                ;

relation_and_expression:        relation_expr
                                | relation_expr AND relation_expr
                                ;

relation_expr:  NOT rel_exp_not
                | rel_exp_not
                ;

rel_exp_not:	exp comp exp
		| TRUE
		| FALSE
		| L_PAREN bool_expr R_PAREN
		;

comp:           EQUAL 
		| NEQ 
		| LT 
		| GT 
		| LTE 
		| GTE
		;

exp:		multipl_expr
		| multipl_expr PLUS multipl_expr 
		| multipl_expr MINUS multipl_expr
		;

multipl_expr:	term 
		| term MULT term 
		| term DIV term 
		| term MOD term
		;

term:		term_minus
		| MINUS term_minus
		| IDENTIFIER L_PAREN term_exp R_PAREN
		;

term_minus:	var
		| NUMBER 
		| L_PAREN exp R_PAREN
		;

term_exp:	/*empty*/
		| exp
		| exp COMMA term_exp
		;

var:		IDENTIFIER 
		| IDENTIFIER LSQBRACKET exp RSQBRACKET 
		;



%%

extern void yyerror(const char *s)
{
 // extern int yylineno;	// defined and maintained in lex.c
  //extern char *yytext;	// defined and maintained in lex.c
  
 // cerr << "ERROR: " << s << " at symbol \"" << yytext;
  //cerr << "\" on line " << yylineno << endl;
  //exit(1);

    printf("ERROR at line %d, position %d: %s\n ", line, col, s );
}
//extern int yyparse();

int main(int argc, char **argv)
{
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
    return 1;
  }

  yyparse();

  return 0;
}
/*extern void yyerror(const char *s)
{
  return yyerror(string(s));
}*/



