/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

%token	<int_val>	INTEGER_LITERAL		/* %token: used to declare token/type name without associativity/precedence. Is also a type tag.*/
%type	<int_val>	exp			/* %type: When using %union to specify multiple value types, declare value type for each nonterminal symbol*/
%left	PLUS					/* %left: denotes a left associatve operator*/
%left	MULT


%%

input:		/* empty */
		| exp	{ cout << "Result: " << $1 << endl; }
		;

exp:		INTEGER_LITERAL	{ $$ = $1; }
		| exp PLUS exp	{ $$ = $1 + $3; }
		| exp MULT exp	{ $$ = $1 * $3; }
		;

multipl_expr:	term
		| term MULT multipl_exp
		| trem DIV multipl_expr
		| term MOD multipl_expr
		;

expression:	multipl_expr
		| multipl_expr PLUS expression
		| multipl_expr MINUS expression
		;

declaration:	IDENTIFIER COMMA declaration
		| IDENTIFIER SEMICOLON INTEGER
		| IDENTIFIER SEMICOLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET
		;

comp:		EQ | NEQ | LT | GT | LTE | GTE;

var:		IDENTIFIER
		| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET

relation_and_expression:	relation_expr
				| relation_expr AND relation_expr
				;

bool_expr:	relation_and_expression
		| relation_and_expression OR relation_and_expression
		;

relation_expr:	NOT relation_expr
		| expression comp expression
		| true
		| false
		| L_PAREN bool_expr R_PAREN
		


%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}


