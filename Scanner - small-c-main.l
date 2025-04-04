%option noyywrap

%{
#include "tokens.h"
%}


%option yylineno

%%
	// Keywords
break 		{ return BREAK;		}

int		{ return INT;		}

continue 	{ return CONTINUE;	}

const 		{ return CONST; 	}

do 		{ return DO; 		}

else 		{ return ELSE; 		}

float 		{ return FLOAT; 	}

for 		{ return FOR; 		}

if 		{ return IF; 		}

readint 	{ return READINT; 	}

return 		{ return RETURN;	}

while 		{ return WHILE; 	}

writeint 	{ return WRITEINT; 	}

writestring 	{ return WRITESTRING;	}

	/* Punctuation */
"("		{ return LPAREN;	}

")"		{ return RPAREN;	}

"{"		{ return LBRACE;	}

"}"		{ return RBRACE;	}

"="		{ return EQUALS;	}

";"		{ return SEMICOLON;	}

"," 		{ return COMMA;		}

"&"		{ return AND; 		}

"&&" 		{ return AND_AND;	}

"<"		{ return LESS;		}

">"		{ return GREATER; 	}

"<=" 		{ return LE; 		}

">=" 		{ return GE;		}

"==" 		{ return EQUALS_EQUALS; }

"!=" 		{ return NE; 		}

":" 		{ return COLON; 	}

"+" 		{ return PLUS; 		}

"-" 		{ return MINUS; 	}

"*" 		{ return TIMES; 	}

"/" 		{ return DIVIDE; 	}

"%" 		{ return MOD;		}

"++" 		{ return PLUS_PLUS; 	}

"--" 		{ return MINUS_MINUS; 	}

"?" 		{ return QUESTION; 	}

"!" 		{ return BANG; 		}

"||" 		{ return OR_OR;		}

	/* Constants: Integer, real and string */
[-+]?[0-9]+	{ return INT_CONST;	}

[-+]?[0-9]*\.[0-9]+ { return REAL_CONST;	}

\".*\" 		{ return STRING_CONST;	}


	/* Identifiers */

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER;	} 

	/* New-line is used in the Scanner only for tracking lines */
"\n"		{ return NEWLINE; }


	/* Ignored stuff: macros, comments, whitespace (tab, newline, carriage return, space) */
^#.*		

[ \t\n\r\f]

\/\/.*
	/* Anything not matches in a lexical error. */
.		{ printf("%d: Lexical Error: '%c'\n", yylineno, yytext[0]); exit(0); }

%%


