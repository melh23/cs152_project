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

/*%start	input 

%token	<int_val>	INTEGER_LITERAL		/* %token: used to declare token/type name without associativity/precedence. Is also a type tag.*/

%token	<tag>	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY OF ARRAY
%token	<tag>	IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT 
%token	<tag>	TRUE FALSE RETURN MAIN INTEGER SEMICOLON COLON COMMA PLUS MINUS MULT DIV MOD
%token	<tag>	L_PAREN R_PAREN EQUAL NEQ LT GT LTE GTE LSQBRACKET RSQBRACKET ASSIGN 
%token	<tag>	NUM_FIRST_ERROR UNDERSCORE_ERROR UNEXPECETED_ERROR END
%token 	<dval> 	NUMBER IDENTIFIER
/*%token	<tag>	program function declaration statement bool_expr relation_and_expression relation_expression comp exp multipl_expr term var*/

%type  	<tag>	program
%type  	<tag>	function
%type	<tag>	declaration
%type	<tag>	statement
%type	<tag>	bool_expr
%type	<tag>	relation_and_expression
%type	<tag>	relation_expr
%type	<tag>	comp
%type	<tag>	exp
%type	<tag>	multipl_expr
%type	<tag>	term
%type	<tag>	var
/*%type	exp			/* %type: When using %union to specify multiple value types, declare value type for each nonterminal symbol*/
/*%left	PLUS*/					/* %left: denotes a left associatve operator*/
/*%left	MULT*/


%%

program:	function;

function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declaration SEMICOLON END_PARAMS 
		BEGIN_LOCALS declaration SEMICOLON END_LOCALS
		BEGIN_BODY statement SEMICOLON END_BODY
		;

multipl_expr:	term
		| term MULT multipl_expr
		| term DIV multipl_expr
		| term MOD multipl_expr
		;

declaration:    IDENTIFIER COMMA declaration
                | IDENTIFIER SEMICOLON INTEGER
                | IDENTIFIER SEMICOLON ARRAY LSQBRACKET NUMBER RSQBRACKET
                ;


statement:	var ASSIGN exp
		| IF bool_expr THEN statement SEMICOLON ENDIF
		| WHILE bool_expr BEGINLOOP statement SEMICOLON ENDLOOP
		| DO BEGINLOOP statement SEMICOLON ENDLOOP WHILE bool_expr
		| FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statement SEMICOLON ENDLOOP
		| READ var
		| CONTINUE
		| RETURN exp
		;

bool_expr:      relation_and_expression
                | relation_and_expression OR relation_and_expression
                ;

relation_and_expression:        relation_expr
                                | relation_expr AND relation_expr
                                ;

relation_expr:  NOT relation_expr
                | exp comp exp
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

multipl_expr:	term MULT term
		| term DIV term
		| term MOD term
		;

term:		MINUS var
		| var
		| MINUS NUMBER
		| NUMBER
		| MINUS L_PAREN exp R_PAREN
		| L_PAREN exp R_PAREN
		| IDENTIFIER L_PAREN exp R_PAREN
		;

var:		IDENTIFIER
		| IDENTIFIER LSQBRACKET exp RSQBRACKET
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


