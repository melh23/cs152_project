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
		| function {printf("program -> function\n");} 
		;

function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS 
		BEGIN_LOCALS fxn_dec END_LOCALS
		BEGIN_BODY statement SEMICOLON fxn_statem END_BODY {printf("FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS BEGIN_LOCALS fxn_dec END_LOCALS BEGIN_BODY statement SEMICOLON fxn_statem END_BODY\n");}
		;

fxn_dec:	/*empty*/{ printf("fxn_dec -> epsilon\n");}
		| declaration SEMICOLON fxn_dec {printf(" fxn_dec -> declaration SEMICOLON fxn_dec\n");}
		;

fxn_statem:	/*empty*/ { printf("fxn_statem -> epsilon\n");} 
		| statement SEMICOLON fxn_statem { printf("fxn_dec -> statement SEMICOLON fxn_statem\n");} 
		;

declaration:    IDENTIFIER dec_comma SEMICOLON INTEGER { printf("declaration -> IDENTIFIER dec_comma SEMICOLON INTEGER\n");} 
                | IDENTIFIER dec_comma SEMICOLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER { printf("declaration -> IDENTIFIER dec_comma SEMICOLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER\n");} 
                ;

dec_comma:	/*empty*/ {printf("dec_comma -> epsilon\n");}
		| COMMA IDENTIFIER dec_comma {printf("dec_comma -> COMMA IDENTIFIER dec_comma\n");}
		;

statement:	var ASSIGN exp {printf("statement -> var ASSIGN exp\n");}
		| IF bool_expr THEN statm_else ENDIF {printf("statement -> IF bool_expr THEN statm_else ENDIF\n");}
		| WHILE bool_expr BEGINLOOP statm_loop ENDLOOP {printf("statement -> WHILE bool_expr BEGINLOOP statm_loop ENDLOOP\n");}
		| DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr {printf("statement -> DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr\n");}
		| FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP {printf("statement -> FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP\n");}
		| READ var statm_var {printf("statement -> READ var statm_var\n");}
		| WRITE var statm_var {printf("statemnt -> WRITE var statm_var\n");}
		| CONTINUE {printf("statement -> CONTINUE\n");}
		| RETURN exp {printf("statement -> RETURN exp\n");}
		;

statm_else:	ELSE statm_loop {printf("statm_else -> ELSE statm_loop\n");}
		| statm_base {printf("statm_else -> statm_base\n");}
		;

statm_loop:	statm_base {printf("statm_loop -> statm_base\n");}
		| statm_base statm_loop {printf("statm_loop -> statm_base statm_loop\n");}
		;

statm_base:	statement SEMICOLON {printf("statm_base -> statement SEMICOLON\n");}
		;

statm_var:	/*empty*/ {printf("statm_var -> epsilon\n");}
		| COMMA var {printf("statm_var -> COMMA var\n");}
		;

bool_expr:      relation_and_expression {printf("bool_expr -> relation_and_expression");}
                | relation_and_expression OR relation_and_expression {printf("bool_expr -> relation_expression OR relation_and_expression\n");}
                ;

relation_and_expression:        relation_expr {printf("relation_expression -> relation_expr\n");}
                                | relation_expr AND relation_expr {printf("relation_and_expression -> relation_expr AND relation_expr\n");}
                                ;

relation_expr:  NOT rel_exp_not {printf("relation_expr -> NOT rel_exp_not\n");}
                | rel_exp_not {printf("relation_expr -> rel_exp_not\n");}
                ;

rel_exp_not:	exp comp exp {printf("rel_exp_not -> exp comp exp\n");}
		| TRUE {printf("rel_exp_not -> TRUE\n");}
		| FALSE {printf("rel_exp_not -> FALSE\n");}
		| L_PAREN bool_expr R_PAREN  {printf("rel_exp_not -> L_PAREN bool_expr R_PAREN\n");}
		;

comp:            EQUAL {printf("comp -> EQUAL\n");}
		| NEQ {printf("comp -> NEQ\n");}
		| LT {printf("comp -> LT\n");}
		| GT {printf("comp -> GT\n");}
		| LTE {printf("comp -> LTE\n");}
		| GTE {printf("comp -> GTE\n");}
		;

exp:		multipl_expr { printf("exp -> multipl_expr\n");}
		| multipl_expr PLUS multipl_expr {printf("exp -> multipl_expr PLUS multipl_expr\n");}
		| multipl_expr MINUS multipl_expr {printf("exp -> multipl_expr MINUS multipl_expr\n");}
		;

multipl_expr:	term {printf("multiple_expr -> term\n");}
		| term MULT term { printf("multipl_expr -> term MULT term\n");}
		| term DIV term  {printf("multipl_expr -> term DIV term\n");}
		| term MOD term {  printf("multipl_expr -> term MOD term\n");}
		;

term:		term_minus { printf("term -> MINUS term_minus\n");} 
		| MINUS term_minus { printf("term -> term_minus\n");}
		| IDENTIFIER L_PAREN term_exp R_PAREN { printf("term -> identifier L_PAREN exp R_PAREN\n");}
		;

term_minus:	var {printf("term_minus -> var\n");}
		| NUMBER {printf("term_minus -> NUMBER\n");}
		| L_PAREN exp R_PAREN {printf("term_minus -> L_PAREN exp R_PAREN\n");}
		;

term_exp:	/*empty*/ { printf("term_exp -> epsilon\n");}
		| exp { printf("term_exp -> exp\n");} 
		| exp COMMA term_exp { printf("term_exp -> exp COMMA term_exp\n");} 
		;

var:		IDENTIFIER { printf("var -> IDENTIFIER\n");} 
		| IDENTIFIER LSQBRACKET exp RSQBRACKET { printf("var -> IDENTIFIER LSQBRACKET exp RSQBRACKET\n");}  
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



