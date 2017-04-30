%{

  #include <math.h>
  #include <stdio.h>
  #include <ctype.h>
  #include "ASM.c"
  int yylex (void);

  int tmp1;
  int tmp2;
  int acc;

  char* asmHead="";
  char* asmCode="";
  int compare(int n1, int n2);

%}

%union {
   char* str;
   int l;
}

%type <str> val
%type <str> exp
%type <l> DEC
%type <l> HEX
%type <l> REG
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
%token ENDOFFILE

%left '-' '+'
%left '*' '/'
%precedence NEG   /* negation--unary minus */
%right '^'        /* exponentiation */



%% /* The grammar follows.  */
file: '{''\n' input '}'	{ return;}
	;

input: line input
  	| %empty
  	;

line: '\n'
  	| exp ';'
  	;

exp:
val                 {printf("b"); $$ = $1; }
| exp '+' exp       {
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getAdd());
  $$ = "%eax";
}
| exp '-' exp       {  }
| exp '*' exp       {  }
| exp '/' exp       {  }
| exp '%' exp       {  }
| '(' exp ')'       {  }
;

val:
DEC                 {
  char* tmp;
  sprintf(tmp,"$%d",$1);
  printf("a");
  $$ = tmp;
}
| HEX               {
  char* tmp;
  sprintf(tmp,"$%d",$1);
  $$ = tmp;
}
| REG               {
  char* tmp;
  sprintf(tmp,"%d(%esp)", 100 + $1 * 4);
  $$ = tmp;
}
;

/*
command:
show
| showh
| shows
| CMP cmp           {  }
| LOOP loop         {  }
| REG '=' exp       { }
;

show:
;


showh:
;


shows:
SHOWS
;

cmp:
'(' exp ',' exp ')'               {  }
;

loop:
;
//'(' exp ',' exp ',' inc ')'       {}
*/
%%


/*
int compare(int n1, int n2){
  if(n1 != n2) return 0;
  else return 1;
}
*/
int main (void)
{
  int i;
  FILE *fp = fopen("test.s","wb+");

  yyparse ();

  printf("%s \nEND",asmHead);
  fputs(asmHead,fp);
  fputs(asmCode,fp);

}
