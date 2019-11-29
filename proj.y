%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	int sym[26],store[26];
	int cnt=0;
	int ns=0, switchar[100], switchval[100], defaultval=0;
  	int yylex (void);

  	struct node {
		char *name;
		int val;
	} var[100];

	int setval(int val, char *varname, int n) {
		int i=0;
		for(i=0; i<n; i++){
			if(strcmp(varname, var[i].name)==0){
				var[i].val = val;
				return;
			}
		}
		printf("\nVariable %s not declared!", varname);
	}

	int declare(int i, char *varname) {
		if(checkRedeclaratn(i, varname)) {
			printf("\nVariable %s re-declared!", varname);
		}
		var[i].name = varname;
		printf("\n%s declared at index %d", var[i].name, i);
	}

	int checkRedeclaratn(int n, char *varname) {
		int i=0;
		for(i=0; i<n; i++){
			if(strcmp(varname, var[i].name)==0)
				return 1;
		}
		return 0;
	}

	int getval(int n, char *varname) {
		int i=0;
		for(i=0; i<n; i++){
			if(strcmp(varname, var[i].name)==0)
				return var[i].val;
		}printf("\nVariable %s not declared in getval!", varname);
	}

%}

%union {
    char *ch;
	int IN;  
}

%token<ch>LINE
%token<ch>VAR
%token<IN>NUM

%type<IN>expression
%type<IN>statement
%type<IN>ifstatement
%type<IN>conditional_statement

%token INT FLOAT CHAR EOS CM EQ LP RP LB RB ADD SUB MUL DIV GT LT MAIN PRINT IF ELSE EE LOOP INC SWITCH CASE BREAK DEFAULT COLON
%nonassoc IFX
%nonassoc ELSE
%left LT GT EE
%left VAR
%left ADD SUB
%left MUL DIV

%%
/*need changes here*/
program: MAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
	 ;

cstatement: 
	| statement cstatement
	| cdeclaration cstatement
	| iostmt cstatement
	| conditional_statement cstatement
	;
	
cdeclaration: TYPE ID EOS { printf("\nvalid declaration\n"); }
			;

statement:  VAR EQ expression EOS { $$ = $3; setval($3, $1, cnt); }
	;

ifstatement:  expression EQ expression EOS { $$ = $3; }
	;

expression : NUM {$$ = $1;}
			| VAR 	{ $$ = getval(cnt, $1); }
			| expression ADD expression {$$ = $1 + $3;}
			| expression SUB expression {$$ = $1 - $3;}
			| expression MUL expression {$$ = $1 * $3;}
			| expression DIV expression  {
											if($3) {
					 							$$ = $1 / $3;
												}
									  		else {
												$$ = 0;
												printf("\nRuntime Error: division by zero\t");
												exit(0);
									  		} 
										}
			| expression LT expression { $$ = $1 < $3; }
			| expression GT expression { $$ = $1 > $3; }
			| expression EE expression { if($1==$3) $$ = 1; else $$ = 0; }
			;

conditional_statement : 
	| IF LP expression RP LB conditional_statement RB ELSE LB conditional_statement RB {
							if($3) {
								$$ = $6;
								printf("true condition in if block of if-else %d\n", $6);
							} else {
								$$ = $10;
								printf("true condition in else block %d\n", $6);
							}				
						}
	| IF LP expression RP LB conditional_statement RB {
							if($3) {
								$$ = $6;
								printf("true condition in if block %d\n", $6);
							}
						}
	| ifstatement conditional_statement {  
							$$ = $1;
						}
	| LOOP LP VAR EQ NUM CM VAR LT NUM CM VAR INC RP LB conditional_statement RB {
																	int ii = $5, cn = $9, inc = getval(cnt, $11), cnti = 0, k = 0;
																	for( k = ii; k < cn; k ++ ){
																		cnti++;
																	}
																	printf("Entered loop total %d times \n",cnti);
																}
	| SWITCH LP VAR RP LB BODY RB {
					int k;
			    	for( k = 0 ; k < ns ; k++ )
					{
						if(switchar[k]==getval(cnt, $3)) {
							printf("true in case for %d and found value = %d\n",switchar[k],switchval[k]);
							defaultval = 1;
						}
					}
					if( !defaultval )
					{
						printf("Default value otherwise is : %d\n", defaultval);
					}
					
			}
	;

BODY : 
	| casestmt defstmt
	| casestmt BODY
	;

casestmt : CASE NUM COLON statement BREAK EOS { 	
  									switchar[ns]=$2;
									switchval[ns]=$4;
									ns++; 
								}
  ;

defstmt : DEFAULT COLON statement BREAK EOS { defaultval = $3; }
   ;
			
TYPE : INT
     | FLOAT
     | CHAR
     ;

ID  : ID CM VAR	{ declare(cnt,$3);cnt++; }
    | VAR	{ declare(cnt,$1);cnt++; }
     ;

iostmt: PRINT VAR EOS { printf("\n%s = %d", $2, getval(cnt,$2)); }
	| PRINT LINE EOS { printf("\n%s\n", $2); }
	;

%%

int yywrap()
{
	return 1;
}

yyerror(char *s){
	printf( "%s\n", s);
}