%{

  #include <math.h>
  #include <stdio.h>
  int yylex (void);

  int tmp1;
  int tmp2;
  int acc;
  int var[676];
  int compare(int n1, int n2);

%}
/* Bison declarations.  */

%token REG
%token SHOW
%token SHOWH
%token SHOWS
%token CMP
%token LOOP
%token DEC
%token HEX
%token EXIT
%token STR
%define api.value.type {double}
%left '-' '+'
%left '*' '/' '\\'
%precedence NEG   /* negation--unary minus */
%right '^'        /* exponentiation */



%% /* The grammar follows.  */
input: %empty
  | input line  { printf ("> "); }
  | error       { yyerror(); }
  ;

line:
'\n'
| exp '\n'          { acc = $1; printf("= %.10g\n", $1); }
| command '\n'     { acc = $1; printf("= %.10g\n", $1); }

num:
DEC                 { $$ = $1; }
| HEX               { $$ = $1; }
| REG               { $$ = var[$1]; }

exp:
num                 { $$ = $1; }
| num '+' num       { $$ = $1 + $3; }
| num '-' num       { $$ = $1 - $3; }
| num '*' num       { $$ = $1 * $3; }
| num '/' num       { $$ = $1 / $3; }
| num '%' num       { $$ = fmod ($1, $3); }
| '(' num ')'       { $$ = $2; }

command:
show
| showh
| shows
| CMP cmp           { $$ = $2; }
| LOOP loop         { $$ = $2; }
| REG '=' num       { var[$1] = $2 }

show:
SHOW '(' reg ')'    {  }

showh:
SHOWH '(' reg ')'   { tmp1 = $3; $$ = var[tmp1 - 258]; }

shows:
SHOWS

cmp:
'(' num ',' num ')'               { $$ = compare($2, $4); }

loop:
//'(' num ',' num ',' inc ')'       {}

%%

#include <ctype.h>

int compare(int n1, int n2){
  if(n1 != n2) return 0;
  else return 1;
}

int main (void)
{
  int i;
  FILE *fp = fopen("test.s","wb+");

  for(i = 0; i < 676; i++){
    var[i] = 0;
  }
  while(1){
  	printf("> ");
  	return yyparse ();
  }
}
