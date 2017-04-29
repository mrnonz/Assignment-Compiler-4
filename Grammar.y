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

%token AA
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
| command1 '\n'     { acc = $1; printf("= %.10g\n", $1); }
| command2 '\n'     { }

num:
DEC                 { $$ = $1; }
| HEX               { $$ = $1; }
| reg               { tmp1 = $1; $$ = var[tmp1 - 258]; }

reg :
AA                  { tmp1 = AA; $$ = tmp1; }

exp:
num                 { $$ = $1; }
| num '+' num       { $$ = $1 + $3; }
| num '-' num       { $$ = $1 - $3; }
| num '*' num       { $$ = $1 * $3; }
| num '/' num       { $$ = $1 / $3; }
| num '%' num       { $$ = fmod ($1, $3); }
| '(' num ')'       { $$ = $2; }

command1:
show
| CMP cmp           { $$ = $2; }
| LOOP loop         { $$ = $2; }
| reg '=' num       { tmp1 = $1; tmp2 = $3; var[tmp1 - 258] = tmp2; $$ = tmp2; }

command2:
showh               { }
| shows

show:
SHOW '(' reg ')'    { tmp1 = $3; $$ = var[tmp1 - 258]; }

showh:
SHOWH '(' reg ')'   { tmp1 = $3; $$ = var[tmp1 - 258]; }

shows:
SHOWH

cmp:
'(' num ',' num ')'               { tmp1 = $2; tmp2 = $4; $$ = compare(tmp1, tmp2); }

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
  for(i = 0; i < 676; i++){
    var[i] = 0;
  }
  while(1){
  	printf("> ");
  	return yyparse ();
  }
}
