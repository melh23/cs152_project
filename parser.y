/* Parser */
/* parser.y */

%{
#include "heading.h"
#include <sstream>

extern void yyerror(const char *s);
extern int line;
extern int col;
extern int yylex();
//extern int yylineno;  // defined and maintained in lex.c
  //extern char *yytext;  // defined and maintained in lex.c

int countL = 0;
int countT = 0;
enum TYPE{
        INT, STRING, DEFAULT
};

string newlabel(){
    stringstream ss;
    string toReturn;
    
    ss << countL;
    string number;
    ss >> number;
	toReturn = "label_" + number;
    countL++;
    return toReturn;
}

string newtemp(){
    string toReturn;
    stringstream ss;

    ss << countT;
    string number;
    ss >> number;
    toReturn = "temp_" + number;
    countT++;
    return toReturn;
}

struct symbol
{
	string id;
	TYPE type;
	symbol(string i, TYPE t):id(i), type(t) {}
};

struct symbolTable
{
	vector<symbol> table;
	symbolTable newsymbol(string id, TYPE t) {
		symbol newSymbol(id, t);
		table.push_back(newSymbol);
		return *this;
	}
};

%}

%union{
  int	dval;
  char*	tag;
}

%start	program

%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY OF ARRAY
%token	IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT 
%token	TRUE FALSE RETURN MAIN INTEGER SEMICOLON COLON COMMA PLUS MINUS MULT DIV MOD
%token	L_PAREN R_PAREN EQUAL NEQ LT GT LTE GTE LSQBRACKET RSQBRACKET ASSIGN 
%token	NUM_FIRST_ERROR UNDERSCORE_ERROR UNEXPECETED_ERROR END 

%token	<tag>	IDENTIFIER
%token 	<tag> 	NUMBER

%type	<tag>	multipl_expr
%type	<tag>	exp 
%type 	<tag>	var term

%%

program:	/*empty*/
		| function {printf("program -> function\n");} 
		;

function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS BEGIN_LOCALS fxn_dec END_LOCALS BEGIN_BODY statement SEMICOLON fxn_statem END_BODY {printf("function -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS BEGIN_LOCALS fxn_dec END_LOCALS BEGIN_BODY statement SEMICOLON fxn_statem END_BODY\n");}
		;

fxn_dec:	/*empty*/{ printf("fxn_dec -> epsilon\n");}
		| declaration SEMICOLON fxn_dec {printf(" fxn_dec -> declaration SEMICOLON fxn_dec\n");}
		;

fxn_statem:	/*empty*/ { printf("fxn_statem -> epsilon\n");} 
		| statement SEMICOLON fxn_statem { printf("fxn_statem -> statement SEMICOLON fxn_statem\n");} 
		;

declaration:    IDENTIFIER dec_comma COLON INTEGER { printf("declaration -> IDENTIFIER dec_comma COLON INTEGER\n");} 
                | IDENTIFIER dec_comma COLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER { printf("declaration -> IDENTIFIER dec_comma COLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER\n");} 
                ;

dec_comma:	/*empty*/ {printf("dec_comma -> epsilon\n");}
		| COMMA IDENTIFIER dec_comma {printf("dec_comma -> COMMA IDENTIFIER dec_comma\n");}
		;

statement:	var ASSIGN exp {printf("statement -> var ASSIGN exp\n");}
		| IF bool_expr THEN statm_loop statm_else ENDIF {printf("statement -> IF bool_expr THEN statm_loop statm_else ENDIF\n");}
		| WHILE bool_expr BEGINLOOP statm_loop ENDLOOP {printf("statement -> WHILE bool_expr BEGINLOOP statm_loop ENDLOOP\n");}
		| DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr {printf("statement -> DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr\n");}
		| FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP {printf("statement -> FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP\n");}
		| READ var statm_var {printf("statement -> READ var statm_var\n");}
		| WRITE var statm_var {printf("statemnt -> WRITE var statm_var\n");}
		| CONTINUE {printf("statement -> CONTINUE\n");}
		| RETURN exp {printf("statement -> RETURN exp\n");}
		;

statm_else:	/*empty*/ {printf("statm_else -> epsilon\n");}
		| ELSE statm_loop {printf("statm_else -> ELSE statm_loop\n");}
		;

statm_loop:	statm_base {printf("statm_loop -> statm_base\n");}
		| statm_base statm_loop {printf("statm_loop -> statm_base statm_loop\n");}
		;

statm_base:	statement SEMICOLON {printf("statm_base -> statement SEMICOLON\n");}
		;

statm_var:	/*empty*/ {printf("statm_var -> epsilon\n");}
		| COMMA var statm_var {printf("statm_var -> COMMA var statm_var\n");}
		;

bool_expr:      relation_and_expression bool_or_loop {printf("bool_expr -> relation_expression bool_or_loop\n");};

bool_or_loop:	/*empty*/ {printf("bool_or_loop -> epsilon\n");}
		| OR relation_and_expression bool_or_loop {printf("bool_or_loop -> OR relation_and_expression bool_or_loop\n");}
		;

relation_and_expression:  	relation_expr bool_and_loop {printf("relation_and_expression -> relation_expr bool_and_loop\n");};

bool_and_loop:			/*empty*/ {printf("bool_and_loop -> epsilon\n");}
				| AND relation_expr bool_and_loop {printf("bool_and_loop -> AND relation_expr bool_and_loop\n");}
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

exp:		multipl_expr exp_loop {printf("exp -> multipl_expr exp_loop\n");};

exp_loop:	/*empty*/ {printf("exp_loop -> epsilon\n");}
		| PLUS exp {printf("exp_loop -> PLUS exp\n");}
		| MINUS exp {printf("exp_loop -> MINUS exp\n");}
		;

multipl_expr:	term multipl_loop {printf("multiple_expr -> term multipl_loop\n");};

multipl_loop:	/*empty*/ {printf("multipl_loop -> epsilon\n");} 
		| MULT term {printf("multipl_loop -> MULT term\n");} 
		| DIV term {printf("multipl_loop -> DIV term\n");}
		| MOD term {printf("multipl_loop -> MOD term\n");}
		;

term:		term_minus { printf("term -> term_minus\n");} 
		| MINUS term_minus { printf("term -> MINUS term_minus\n");}
		| IDENTIFIER L_PAREN term_exp R_PAREN { printf("term -> IDENTIFIER L_PAREN term_exp R_PAREN\n");}
		;

term_minus:	var {printf("term_minus -> var\n");}
		| NUMBER {printf("term_minus -> NUMBER\n");}
		| L_PAREN exp R_PAREN {printf("term_minus -> L_PAREN exp R_PAREN\n");}
		;

term_exp:	/*empty*/ { printf("term_exp -> epsilon\n");}
		| exp { printf("term_exp -> exp\n");} 
		| exp COMMA term_exp { printf("term_exp -> exp COMMA term_exp\n");} 
		;

var:		IDENTIFIER { printf("var -> IDENTIFIER %s\n", $1);} 
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



