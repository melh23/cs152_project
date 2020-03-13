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

	void printtable() {
		size_t elements = table.size();
		for(size_t i = 0; i < elements; i++)
			cout << table[i].id << ", " << table[i].type << endl;
	}
};
/*
struct state
{
	string* code;
	string* ret_name;
};
*/

symbolTable t;

%}

%union{
  int	dval;
  char*	tag;
  struct state st;
}

%start	program

%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY OF ARRAY
%token	IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT 
%token	TRUE FALSE RETURN MAIN INTEGER SEMICOLON COLON COMMA PLUS MINUS MULT DIV MOD
%token	L_PAREN R_PAREN EQUAL NEQ LT GT LTE GTE LSQBRACKET RSQBRACKET ASSIGN 
%token	NUM_FIRST_ERROR UNDERSCORE_ERROR UNEXPECETED_ERROR END 

%token	<tag>	IDENTIFIER
%token 	<dval> 	NUMBER

%type	<st>	function fxn_dec fxn_statem declaration dec_comma statement 
%type 	<st>	statm_else statm_loop statm_base statm_var bool_expr bool_or_loop
%type	<st>	relation_and_expression bool_and_loop relation_expr rel_exp_not
%type	<st>	comp exp exp_loop multipl_expr multipl_loop term term_minus term_exp
%type	<st>	var


%%

program:	/*empty*/ 
		| function {printf("program -> function\n");} 
		;

function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS BEGIN_LOCALS fxn_dec END_LOCALS BEGIN_BODY statement SEMICOLON fxn_statem END_BODY {printf("function -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS fxn_dec END_PARAMS BEGIN_LOCALS fxn_dec END_LOCALS BEGIN_BODY statement SEMICOLON fxn_statem END_BODY\n");
			stringstream ss;
			ss << $5.code << $8.code <<$11.code << $13.code;
			$$.code = strdup(ss.str().c_str());
			cout << $$.code;
		}
		;

fxn_dec:	/*empty*/{ printf("fxn_dec -> epsilon\n");
			$$.code = strdup("");
		}
		| declaration SEMICOLON fxn_dec {printf(" fxn_dec -> declaration SEMICOLON fxn_dec\n");
			stringstream ss;
			ss << $1.code << $3.code;
			$$.code = strdup(ss.str().c_str());
		}
		;

fxn_statem:	/*empty*/ { printf("fxn_statem -> epsilon\n");
			$$.code = strdup("");
		} 
		| statement SEMICOLON fxn_statem { printf("fxn_statem -> statement SEMICOLON fxn_statem\n");
			stringstream ss;
			ss << $1.code << $3.code;
			$$.code = strdup(ss.str().c_str());
		} 
		;

declaration:    IDENTIFIER dec_comma COLON INTEGER {/* printf("declaration -> IDENTIFIER dec_comma COLON INTEGER\n");*/
							t = t.newsymbol($1, INT);
							stringstream ss;
							ss << ". " << $1 << '\n';
							ss << $2.code;
							
							$$.code = strdup(ss.str().c_str());
							//cout << $$.code;
						   } 
                | IDENTIFIER dec_comma COLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER { //printf("declaration -> IDENTIFIER dec_comma COLON ARRAY LSQBRACKET NUMBER RSQBRACKET OF INTEGER\n");
							t = t.newsymbol($1, INT);
							stringstream ss;
							ss << ". [] " << $1 << ", " << $6 << '\n';
							ss << $2.code;

							$$.code = strdup(ss.str().c_str());
							//cout << $$.code;
							//$$->code->assign(ss.str().c_str());
							//cout << $$->code << endl;
							//$$->code = ss.str().c_str();
							//strcpy($$->code, ss.str().c_str());
						   } 
                ;

dec_comma:	/*empty*/ { //printf("dec_comma -> epsilon\n");
				stringstream ss;
				ss << "";
				$$.code = strdup(ss.str().c_str());
			  }
		| COMMA IDENTIFIER dec_comma { //printf("dec_comma -> COMMA IDENTIFIER dec_comma\n");
						t = t.newsymbol($2, INT);
						stringstream ss;
						ss << ". " << $2 << '\n';
						ss << $3.code;

						$$.code = strdup(ss.str().c_str());
		  }
		;

statement:	var ASSIGN exp {printf("statement -> var ASSIGN exp\n");
				stringstream ss;
				ss << $1.code << $3.code;
				$$.code = strdup(ss.str().c_str());
				$$.str = strdup("");
			}
		| IF bool_expr THEN statm_loop statm_else ENDIF {
			//printf("statement -> IF bool_expr THEN statm_loop statm_else ENDIF\n");
			
			    stringstream ss;
			    string truelabel = newlabel();

			    ss << $2.code;
			    ss << "?:= " << truelabel << "," << $2.str << endl;
			    if($5.falselabel) {			//if there is an else
			    	ss << ":= " << $5.falselabel << endl;
			    } else {				//if there isn't an else
				ss << ":= " << $5.endlabel << endl;
			    }
			    ss << "    : " << truelabel << endl;
			    ss << $4.code;

			    if($5.falselabel) { 		//if there's an else
			 	ss << "    : " << $5.falselabel << endl;
				ss << $5.code;
			    }

			    ss << "    : " << $5.endlabel << endl;

			    $$.code = strdup(ss.str().c_str());
			    //cout << $$.code;
			
			}
		| WHILE bool_expr BEGINLOOP statm_loop ENDLOOP {printf("statement -> WHILE bool_expr BEGINLOOP statm_loop ENDLOOP\n");
				string truelabel = newlabel();
				string beginlabel = newlabel();
				string endlabel = newlabel();
				stringstream ss;

				ss << "    : " << beginlabel << endl;
				ss << $2.code;
				ss << "?:= " << truelabel << ", " << $2.str << endl;
				ss << ":= " << endlabel << endl;
				ss << "    : " << truelabel << endl;
				ss << $4.code;
				ss << ":= " << beginlabel << endl;
				ss << "    : " << endlabel << endl;

				$$.code = strdup(ss.str().c_str());
				$$.str = strdup("");
			}
		| DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr {printf("statement -> DO BEGINLOOP statm_loop ENDLOOP WHILE bool_expr\n");
				string beginlabel = newlabel();
				stringstream ss;                                                                                                                          
				ss << $3.code << $6.code;

				ss << "    : " << beginlabel << endl;
				ss << $3.code;
				ss << $6.code;
				ss << "?:= " << beginlabel << ", " << $3.str << endl;

				$$.code = strdup(ss.str().c_str());
				$$.str = strdup("");
			}
		| FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP 
		  {//printf("statement -> FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statm_loop ENDLOOP\n");
			stringstream ss;
			ss << $2.code << $6.code << $8.code << $10.code << $12.code;
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup("");
			}
		| READ var statm_var {//printf("statement -> READ var statm_var\n");
			string dest = newtemp();
			stringstream ss;
			ss << $2.code << $3.code;
			
			if($2.index) {	
				ss << ".[]< " << dest << ", " << $2.index << endl;
			} else {
				ss << ".< " << dest << endl;
			}

			$$.code = strdup(ss.str().c_str());
			$$.str = strdup(dest.c_str());
		}
		| WRITE var statm_var {//printf("statemnt -> WRITE var statm_var\n");
			stringstream ss;
			ss << $2.code << $3.code;
			if($2.index) {
				ss << ".[]> " << $2.str << ", " << $2.index << endl;
			} else {
				ss << ".> " << $2.str << endl;
			}
			
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup("");
		}
		| CONTINUE {//printf("statement -> CONTINUE\n");
			$$.code = strdup("");
			$$.str = strdup("");	
		}
		| RETURN exp {//printf("statement -> RETURN exp\n");
			$$.str = strdup($2.str);
			stringstream ss;
			ss << $2.code;
			ss << "ret " << $2.str << endl;
			$$.code = strdup(ss.str().c_str());
		}
		;

statm_else:	/*empty*/ {printf("statm_else -> epsilon\n");
			$$.code = strdup("");
			$$.str = strdup("");
			$$.endlabel = strdup(newlabel().c_str());
		}
		| ELSE statm_loop {printf("statm_else -> ELSE statm_loop\n");
			$$.code = strdup($2.code);
			$$.str = strdup("");
			$$.endlabel = strdup(newlabel().c_str());
			$$.falselabel = strdup(newlabel().c_str());
		}
		;

statm_loop:	statm_base {printf("statm_loop -> statm_base\n");
			$$.code = strdup($1.code);
			$$.str = strdup("");
		}
		| statm_base statm_loop {printf("statm_loop -> statm_base statm_loop\n");
			stringstream ss;
			ss << $1.code << $2.code;
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup("");
		}
		;

statm_base:	statement SEMICOLON {printf("statm_base -> statement SEMICOLON\n");
			$$.code = strdup($1.code);
			$$.str = strdup("");
		}
		;

statm_var:	/*empty*/ {printf("statm_var -> epsilon\n");
			$$.code = strdup("");
			$$.str = strdup("");
		}
		| COMMA var statm_var {printf("statm_var -> COMMA var statm_var\n");
			stringstream ss;
			ss << $2.code << $3.code;
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup("");
		}
		;

bool_expr:      relation_and_expression bool_or_loop {printf("bool_expr -> relation_expression bool_or_loop\n");
			stringstream ss;
			//string dest = newtemp();
			ss << $1.code << $2.code;

			if($2.oper == "||") {
				string dest = newtemp();
				ss << $2.oper << dest << ", " << $1.str << ", " << $2.str << endl;
			}
			$$.code = strdup(ss.str().c_str());
		};

bool_or_loop:	/*empty*/ {printf("bool_or_loop -> epsilon\n");
			$$.code = strdup("");
		}
		| OR relation_and_expression bool_or_loop {printf("bool_or_loop -> OR relation_and_expression bool_or_loop\n");
			$$.oper = strdup("||");
			stringstream ss;                                                                                                                                                           
			ss << $2.code << $3.code;
			
			if($3.oper == "||") {
				string dest = newtemp();
				ss << "|| " << dest << ", " << $2.str << ", " << $3.str << endl;
				$$.str = strdup(dest.c_str());
			} else {
				$$.str = strdup($2.str);
			}
			$$.code = strdup(ss.str().c_str());
		}
		;

relation_and_expression:  	relation_expr bool_and_loop {printf("relation_and_expression -> relation_expr bool_and_loop\n");
					stringstream ss;                                                                                                               
					ss << $1.code << $2.code;       
					//$$.code = strdup(ss.str().c_str());
					
					if($2.oper == "&&") {
						string dest = newtemp();
						ss << "&& " << dest << ", " << $1.str << ", " << $2.str << endl;
						$$.str = strdup(dest.c_str());
					} else {
						$$.str = strdup($1.str);
					}
					$$.code = strdup(ss.str().c_str());
				};

bool_and_loop:			/*empty*/ {printf("bool_and_loop -> epsilon\n");
					$$.str = strdup("");
					$$.code = strdup("");
				}
				| AND relation_expr bool_and_loop {printf("bool_and_loop -> AND relation_expr bool_and_loop\n");
					string dest = newtemp();
					stringstream ss;
					ss << $2.code;
					$$.oper = strdup("&&");
					if($3.oper == "&&") {
						ss << $3.code;	
						ss << "&& " << dest << ", " << $2.str << ", " << $3.str << endl;
						$$.str = strdup(dest.c_str());
					} else {
						$$.str = $2.str;
					}
					$$.code = strdup(ss.str().c_str());
				}
				;

relation_expr:  NOT rel_exp_not {printf("relation_expr -> NOT rel_exp_not\n");
			string dest = newtemp();
			stringstream ss;
			ss << $2.code;
			ss << "!" << dest << ", " << $2.str;
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup(dest.c_str());
		}
                | rel_exp_not {printf("relation_expr -> rel_exp_not\n");
			$$.code = strdup($1.code);
			$$.str = strdup($1.str);
		}
                ;

rel_exp_not:	exp comp exp {
			printf("rel_exp_not -> exp comp exp\n");
			string dest = newtemp();
			stringstream ss;
			ss << $1.code << $3.code;
			ss << $2.oper << " " << dest << ", " << $1.str << ", " << $3.str << "\n";
			$$.code = strdup(ss.str().c_str());
			$$.str = strdup(dest.c_str());
			//cout << $$.code;
		}
		| TRUE {printf("rel_exp_not -> TRUE\n");
			string dest = newtemp();
			$$.str = strdup(dest.c_str());
			$$.code = strdup("");
		}
		| FALSE {printf("rel_exp_not -> FALSE\n");
			string dest = newtemp();                                                                                                                                                                                           $$.str = strdup(dest.c_str()); 
			$$.code = strdup("");
		}
		| L_PAREN bool_expr R_PAREN  {printf("rel_exp_not -> L_PAREN bool_expr R_PAREN\n");
			$$.code = strdup($2.code);
			$$.str = strdup(newtemp().c_str());
		}
		;

comp:            EQUAL {$$.oper = strdup("==");}
		| NEQ { //printf("comp -> NEQ\n");
			$$.oper = strdup("!=");
		}
		| LT { //printf("comp -> LT\n");
			//stringstream ss;
			//ss << "<";
                        //$$.code = strdup(ss.str().c_str()); 
			//cout << $$.code;
			$$.oper = strdup("<");
		}
		| GT { //printf("comp -> GT\n");
			//stringstream ss;
			//ss << ">";
                        //$$.code = strdup(ss.str().c_str()); 
			//cout << $$.code;
			$$.oper = strdup(">");
		}
		| LTE { //printf("comp -> LTE\n");
			/*stringstream ss;
			ss << "<=";
                        $$.code = strdup(ss.str().c_str()); 
			cout << $$.code;*/
			$$.oper = strdup("<=");
		}
		| GTE { //printf("comp -> GTE\n");
			/*stringstream ss;
			ss << ">=";
                        $$.code = strdup(ss.str().c_str()); 
			cout << $$.code;*/
			$$.oper = strdup(">=");
		}
		;

exp:		multipl_expr exp_loop {//printf("exp -> multipl_expr exp_loop\n");
				stringstream ss, sstr;
				ss << $1.code;

				if($2.oper) {				
                                	string dest = newtemp();
					ss << $2.oper << " " << dest << ", " << $1.str << ", " << $2.str << endl;
					$$.str = strdup(dest.c_str());
				} else {
					$$.str = strdup($1.str);
				}

				//sstr << $1.str << $2.str;
				//$$.str = strdup(sstr.str().c_str());

				$$.code = strdup(ss.str().c_str());
				//cout << $$.code << endl;
				//cout << $$.str << endl;
			};

exp_loop:	/*empty*/ {printf("exp_loop -> epsilon\n");
			$$.str = "";
		}
		| PLUS exp {/*printf("exp_loop -> PLUS exp\n");*/
				//string temp = newtemp();
				$$.str = strdup($2.str);
				$$.oper = strdup("+");
				//cout << $$.code;
			}
		| MINUS exp { //printf("exp_loop -> MINUS exp\n");
			$$.str = strdup($2.str);
			$$.oper = strdup("-");
			//cout << $$.code;
		}
		;

multipl_expr:	term multipl_loop {//printf("multiple_expr -> term multipl_loop\n");
			stringstream ss;

			if($2.oper) {
                                string dest = newtemp();
				ss << $1.code << $2.code;
				ss << $2.oper << " " << dest << ", " << $1.str << ", " << $2.str << endl;
				$$.code = strdup(ss.str().c_str());

				$$.str = strdup(dest.c_str());
				//cout << $$.code;
			} else {
				$$.str = strdup($1.str);
				$$.code = strdup($1.code);
			}
		};

multipl_loop:	/*empty*/ { //printf("multipl_loop -> epsilon\n");
			$$.str = "";
		} 
		| MULT term { //printf("multipl_loop -> MULT term\n");
			//string dest = newtemp();
			//stringstream ss;
			//ss << "* " << $2.str;
			//$$.code = strdup(ss.str().c_str());
			//cout << $$.code;
			//$$.str = strdup(ss.str().c_str());
			$$.oper = strdup("*");
			$$.rhs = strdup($2.str);
			$$.code = strdup($2.code);
		} 
		| DIV term { //printf("multipl_loop -> DIV term\n");
			//string dest = newtemp();
			//stringstream ss;
			//ss << "/ " << $2.str;
			//$$.code = strdup(ss.str().c_str());
			//cout << $$.code;
			//$$.str = strdup(ss.str().c_str());
			$$.oper = strdup("/");
			$$.rhs = strdup($2.str);
			$$.code = strdup($2.code);
		}
		| MOD term { //printf("multipl_loop -> MOD term\n");
			//string dest = newtemp();
			//stringstream ss;
			//ss << "% " << $2.str;
			//cout << $$.code;
			//$$.str = strdup(ss.str().c_str());
			$$.oper = strdup("%");
			$$.rhs = strdup($2.str);
			$$.code = strdup($2.code);
		}
		;

term:		term_minus { //printf("term -> term_minus\n");
			stringstream ss;
			ss << $1.str;
			$$.str = strdup(ss.str().c_str());
			$$.code = strdup($1.code);
		} 
		| MINUS term_minus { //printf("term -> MINUS term_minus\n");
			//cout << "***"  << $2.str << endl;
			stringstream ss;
			ss << "-" << $2.str;
			$$.str = strdup(ss.str().c_str());
			$$.code = strdup($2.code);
		}
		| IDENTIFIER L_PAREN term_exp R_PAREN { //printf("term -> IDENTIFIER L_PAREN term_exp R_PAREN\n");
			//cout << "***"  << $3.str << endl;
			stringstream ss;
			ss << $1 << "(" << $3.str << ")";
			$$.str = strdup(ss.str().c_str());
			$$.code = strdup($3.code);
		}
		;

term_minus:	var {//printf("term_minus -> var\n");
			stringstream ss;
			ss << $1.str;
			$$.str = strdup(ss.str().c_str());
			$$.code = strdup($1.code);
		}
		| NUMBER { //printf("term_minus -> NUMBER\n");
			string temp = newtemp();
			$$.str = strdup(temp.c_str());
			$$.code = strdup("");
		}
		| L_PAREN exp R_PAREN {//printf("term_minus -> L_PAREN exp R_PAREN\n");
			string temp = newtemp();
			$$.str = strdup(temp.c_str());
			$$.code = $2.code;
		}
		;

term_exp:	/*empty*/ { //printf("term_exp -> epsilon\n");
			$$.str = "";
		}
		| exp { //printf("term_exp -> exp\n");
			stringstream ss;
			ss << $1.str;
			$$.str = strdup(ss.str().c_str());
			$$.code = strdup($1.code);
		} 
		| exp COMMA term_exp { printf("term_exp -> exp COMMA term_exp\n");
			stringstream ss, sscode;
			ss << $1.str << ", " << $3.str;
			$$.str = strdup(ss.str().c_str());
			sscode << $1.code << $3.code;
			$$.code = strdup(sscode.str().c_str());
		} 
		;

var:		IDENTIFIER { //printf("var -> IDENTIFIER %s\n", $1);
				stringstream ss;
				ss << $1;
				$$.str = strdup(ss.str().c_str());
				$$.code = strdup("");
			   } 
		| IDENTIFIER LSQBRACKET exp RSQBRACKET { printf("var -> IDENTIFIER LSQBRACKET exp RSQBRACKET\n");
			string temp = newtemp();
			$$.str = strdup(temp.c_str());
			$$.index = strdup($3.str);
			/*stringstream ss;
			ss << $1 << "[" << $3.str << "]";
			$$.str = strdup(ss.str().c_str());*/
			$$.code = strdup($3.code);
		}  
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

  //t.printtable();

  return 0;
}
/*extern void yyerror(const char *s)
{
  return yyerror(string(s));
}*/



