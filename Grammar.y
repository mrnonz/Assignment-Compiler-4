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
  char temp[10][100];
%}

%union {
   char* str;
   int l;
}

%type <str> val exp ST
%type <l> DEC HEX REG
/* Bison declarations.  */

%token REG SHOW SHOWH SHOWS CMP LOOP DEC HEX ST
%left '='
%left '-' '+'
%left '/' '*' '%'
%% /* The grammar follows.  */
file: '{''\n' input '}'	{ return;}
	;

input: line input
  	| %empty
  	;

line: '\n'
  	| exp ';'
    | command ';'
  	;

exp:
val                 { $$ = $1; }
| exp '+' exp       {
  printf("Plus: %s + %s\n",$1,$3);
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getAdd());
  $$ = "%eax";
}
| exp '-' exp       {
  printf("Sub: %s - %s\n",$1,$3);
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getSub());
  $$ = "%eax";
}
| exp '*' exp       {
  printf("Mul: %s * %s\n",$1,$3);
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getMul());
  $$ = "%eax";
}
| exp '/' exp       {
  printf("Div: %s / %s\n",$1,$3);
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getDiv());
  $$ = "%eax";
}
| exp '%' exp       {
  printf("Mod: %s %% %s\n",$1,$3);
  asmCode = asmConcat(asmCode,getSetValue($1,1));
  asmCode = asmConcat(asmCode,getSetValue($3,2));
  asmCode = asmConcat(asmCode,getMod());
  $$ = "%eax";
}
| '(' exp ')'       {
  $$ = "%eax";
 }
;

val:
DEC                 {
  char* tmp;
  sprintf(tmp,"$%d",$1);
  printf("DEC : %s\n",tmp);
  $$ = "";
  $$ = asmConcat($$,tmp);
}
| HEX               {
  char* tmp;
  sprintf(tmp,"$%d",$1);
  $$ = "";
  $$ = asmConcat($$,tmp);
}
| REG               {
  char* tmp;
  sprintf(tmp,"%d(%%esp)", 100 + $1 * 4);
  printf("REG : %s\n",tmp);
  $$ = "";
  $$ = asmConcat($$,tmp);
}
;


command:
show
| REG '=' exp       {
  printf("Assign : %d\n",$1);
  asmCode = asmConcat(asmCode, getAssign($1,$3));
}
| showh
| shows
/*
| CMP cmp           {  }
| LOOP loop         {  }
*/
;

show:
SHOW '(' REG ')'  {
  printf("Show\n");
  asmCode = asmConcat(asmCode,getShowCode($3));
  asmHead = asmConcat(asmHead,getShowHead());
}
;


showh:
SHOWH '(' REG ')' {
  asmCode = asmConcat(asmCode,getShowHexCode($3));
  asmHead = asmConcat(asmHead,getShowHexHead());
}
;


shows:
SHOWS '(' ST ')' {
  asmCode = asmConcat(asmCode,getShowStringCode());
  asmHead = asmConcat(asmHead,getShowStringHead($3));
}
;

/*
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
  FILE *fp = fopen("output.s","wb+");

  yyparse ();
  asmHead = asmConcat(asmHead,getMain());
  asmCode = asmConcat(asmCode,getTail());
  fputs(asmHead,fp);
  fputs(asmCode,fp);
}
