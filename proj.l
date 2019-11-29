%{
	#include <stdio.h>
	#include <string.h>
	#include "proj.tab.h"
%}

%%

"int"	{ return INT;   }
"float"	{ return FLOAT; }
"char"	{ return CHAR;  }

";"		{ return EOS; }
","		{ return CM;  }
"="		{ return EQ;  }

"if"	{ return IF;    }
"else" 	{ return ELSE;  }
"loop"  { return LOOP;  }

"check" 	{ return SWITCH;  }
"for_case"	{ return CASE; 	  }
"otherwise" { return DEFAULT; }
"done"		{ return BREAK;   }

"("		{ return LP;  }
")"		{ return RP;  }
"{"		{ return LB;  }
"}"		{ return RB;  }
"+"		{ return ADD; }
"-"		{ return SUB; }
"*"		{ return MUL; }
"/"		{ return DIV; }
">"		{ return GT;  }
"<"		{ return LT;  }
"=="	{ return EE;  }
"++"	{ return INC;  }
":"		{ return COLON;}

"void mainf"	{ return MAIN;  }
"out->"			{ return PRINT; }

[0-9]+	{
			yylval.IN = atoi(yytext);
			return NUM;
		}

[a-z]+	{
			yylval.ch = strdup(yytext);
			return	VAR;
		}

[a-zA-Z0-9_!&,.]+    { yylval.ch = yytext; return LINE; }

[\t\n]*	;

%%

int main()
{
	yyin = freopen("a.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
}