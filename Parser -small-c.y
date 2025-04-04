%{
#include <stdio.h>
#include <string.h>

int yylex (void);
void yyerror (char const *);
extern char *yytext;

%}

%define api.value.type {char *}

%token AND		1001
%token AND_AND		1002
%token BANG		1003
%token BREAK		1004
%token COLON		1005
%token COMMA		1006
%token CONST		1007
%token CONTINUE		1008
%token DIVIDE		1009
%token DO		1010
%token ELSE		1011
%token EQUALS		1012
%token EQUALS_EQUALS	1013
%token FLOAT		1014
%token FOR		1015
%token GE		1016
%token GREATER		1017
%token IDENTIFIER	1018
%token IF		1019
%token INT		1020
%token INT_CONST	1021
%token LBRACE		1022
%token LE		1023
%token LESS		1024
%token LPAREN		1025
%token MINUS		1026
%token MINUS_MINUS	1027
%token MOD		1028
%token NE		1029
%token NEWLINE		1030
%token OR		1031
%token OR_OR		1032
%token PLUS		1033
%token PLUS_PLUS	1034
%token QUESTION		1035
%token RBRACE		1036
%token READINT		1037
%token REAL_CONST	1038
%token RETURN		1039
%token RPAREN		1040
%token SEMICOLON	1041
%token STRING_CONST	1042
%token TIMES		1043
%token WHILE		1044
%token WRITEINT		1045
%token WRITESTRING	1046

%%

smallc_program	:  global_decl_list 
	        ;

global_decl_list: global_decl
                | global_decl global_decl_list
                ;

global_decl	: function_decl
	        | var_decl 
                ;

function_decl	: type_specifier id LPAREN opt_params RPAREN compound_stmt
	      	  { printf("Found function definition: %s\n", $2); }
		;

type_specifier	: INT 
	        | CONST INT
	        | FLOAT
	        | CONST FLOAT
		;

id		: IDENTIFIER
    		  { $$ = strdup(yytext); }
		;

opt_params 	: param_decl_list
	    	|
		 ; 

param_decl_list : param_decl
		| param_decl COMMA param_decl_list
		 ;

param_decl 	: type_specifier id
	    	 ;

compound_stmt	: LBRACE var_decl_list stmt_list RBRACE 
	          { printf("Found a compound statement\n"); }
		;

var_decl_list 	: 
	       	| var_decl var_decl_list
		 ;

var_decl 	: type_specifier var_id_list SEMICOLON
	  	  { printf("Found a variable declaration %s\n", $2); }
	  	 ;

var_id_list 	: variable_id
	     	| variable_id COMMA var_id_list
			 ;

variable_id	: id
	          { printf("Defined variable %s\n", $1); }
		| id EQUALS expr
		;

stmt_list 	: 
	   	| stmt stmt_list
		 ;

stmt		: compound_stmt
      		| cond_stmt
		| while_stmt
		  { printf("Found a while statment\n"); }
		| do_stmt
		  { printf("Found a do statement\n");   }
		| for_stmt
		  { printf("found a for loop\n");	}
		| expr SEMICOLON
		| BREAK SEMICOLON
		  { printf("Found a break\n"); 		}
		| CONTINUE SEMICOLON
		  { printf("Found a continue\n");	}
		| RETURN expr SEMICOLON
		  { printf("Found a return\n"); 		}
		| READINT LPAREN id RPAREN SEMICOLON
		| WRITEINT LPAREN expr RPAREN SEMICOLON
		| WRITESTRING LPAREN string_constant RPAREN SEMICOLON
		 ;

cond_stmt 	: IF LPAREN expr RPAREN stmt
	   	| IF LPAREN expr RPAREN stmt ELSE stmt
		 ;

while_stmt 	: WHILE LPAREN expr RPAREN stmt
	    	 ;

do_stmt 	: DO stmt WHILE LPAREN expr RPAREN SEMICOLON
	 	 ;

for_stmt 	: FOR LPAREN expr_list SEMICOLON expr SEMICOLON expr_list RPAREN stmt
	  	 ;

expr_list	: expr
	  	| expr COMMA expr_list

expr		: id EQUALS expr
	      	  { printf("Found assignment expression for: %s\n", $1); }
		| expr QUESTION expr COLON expr
		  { printf("Found a ternary operator (?:)\n"); 	}
		| expr OR_OR expr
                  { printf("Found an OR OR operat (||)\n"); 	}
		| expr AND_AND expr
                  { printf("Found an AND AND operator (&&)\n"); }
		| expr AND expr
                  { printf("Found an AND operator (&)\n"); 	}
		| expr OR expr
                  { printf("Found an OR operator (|)\n"); 	}
		| expr EQUALS_EQUALS expr
                  { printf("Found an EQUALS EQUALS operator (==)\n"); 	}
		| expr NE expr
                  { printf("Found a NOT EQUALS (!=)\n"); 	}
		| expr LESS expr
                  { printf("Found a LESS THAN operator (<)\n"); }
		| expr GREATER expr
                  { printf("Found a GREATE THAN operator (>)\n"); 	}
		| expr LE expr
                  { printf("Found a LESS THAN EQUALS operator (<=)\n");	}
		| expr GE expr
                  { printf("Found a GREATER THAN EQUALS operator (>=()\n");	}
		| expr PLUS expr
                  { printf("Found a PLUS operator (+)\n"); }
		| expr MINUS expr
                  { printf("Found a PLUS operator (-)\n"); }
		| expr TIMES expr
                  { printf("Found a MULTIPLICATION operator (*)\n"); 	}
		| expr DIVIDE expr
                  { printf("Found a DIVISION operator (/)\n");	}
		| expr MOD expr
                  { printf("Found a MODULUS operator (%)\n");	}
		| BANG expr
                  { printf("Found a NOT operator (!)\n");	}
		| MINUS expr
                  { printf("Found a NEGATIVE operator(-)\n");	}
		| AND expr
                  { printf("Found an AND exp operator (& expr)\n"); 	}
		| integer_constant
		| float_constant
		| string_constant
		| id
		| id PLUS_PLUS
		| id MINUS_MINUS
		| LPAREN expr RPAREN
		| id LPAREN RPAREN
		| id LPAREN arg_list RPAREN
		 ;

float_constant : REAL_CONST
	       	;
integer_constant : INT_CONST
		  ;

string_constant : STRING_CONST
		  ;

arg_list	: expr
	 	| expr COMMA arg_list
		 ;

%%

