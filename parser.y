/* Parser */
/* parser.y */

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
%type   <int_val>	program
%type   <int_val>	function
%type	<int_val>	multipl_expr
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

program:	function;

function:	FUNCTION IDENT SEMICOLON BEGINPARAMS declaration SEMICOLON ENDPARAMS 
		BEGINLOCALS declaration SEMICOLON ENDLOCALS
		BEGINBODY statement SEMICOLON ENDBODY
		;

multipl_expr:	term
		| term MULT multipl_exp
		| trem DIV multipl_expr
		| term MOD multipl_expr
		;

declaration:    IDENTIFIER COMMA declaration
                | IDENTIFIER SEMICOLON INTEGER
                | IDENTIFIER SEMICOLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET
                ;


statement:	var ASSIGNMENT expression
		| IF bool_expr THEN statement SEMICOLON ENDIF
		| WHILE bool_expr BEGINLOOP statement SEMICOLON ENDLOOP
		| DO BEGINLOOP statement SEMICOLON ENDLOOP WHILE bool_expr
		| FOR var ASSIGNMENT NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGNMENT expression BEGINLOOP statement SEMICOLON endloop
		| READ var
		| CONTINUE
		| RETURN expression
		;

bool_expr:      relation_and_expression
                | relation_and_expression OR relation_and_expression
                ;

relation_and_expression:        relation_expr
                                | relation_expr AND relation_expr
                                ;

relation_expr:  NOT relation_expr
                | expression comp expression
                | true
                | false
                | L_PAREN bool_expr R_PAREN
                ;

comp:           EQ | NEQ | LT | GT | LTE | GTE;

expression:	multipl_expr
		| multipl_expr PLUS multipl_expr
		| multipl_expr MINUS multipl_expr
		;

multipl_expr:	term MULT term
		| term DIV term
		| term MOD term
		;

term:		MINUS var
		| var
		| MINUS NUMBER
		| NUMBER
		| MINUS L_PAREN expression R_PAREN
		| L_PAREN expression R_PAREN
		| identifier L_PAREN expression R_PAREN
		;

var:		IDENTIFIER
		| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET
		;



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


