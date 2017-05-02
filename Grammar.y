%{

  #include <math.h>
  #include <stdio.h>
  #include <ctype.h>
  #include "ASM.c"
  int yylex (void);
  int yyerror(const char*);
  int tmp1;
  int tmp2;
  int acc;
  int counter;

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
file: '{''\n' input '}'	{ return 0;}
	;

input: line input
  	| %empty
  	;

line: '\n'
  	| exp ';' { counter = 0; }
    | command ';'
  	;

exp:
val                 {
  asmCode = asmConcat(asmCode,getSetTmp($1,counter));
  counter++;
  $$ = $1;
}
| '-' val           {
  asmCode = asmConcat(asmCode,getSetNegTmp($2,counter));
  counter++;
  $$ = "%eax";
}
| exp '+' exp       {
  printf("Plus %d\n",counter);
  asmCode = asmConcat(asmCode,getAdd(counter));
  counter--;
  $$ = "%eax";
}
| exp '-' exp       {
  printf("Sub\n");
  asmCode = asmConcat(asmCode,getSub(counter));
  counter--;
  $$ = "%eax";
}
| exp '*' exp       {
  printf("Mul\n");
  asmCode = asmConcat(asmCode,getMul(counter));
  counter--;
  $$ = "%eax";
}
| exp '/' exp       {
  printf("Div\n");
  asmCode = asmConcat(asmCode,getDiv(counter));
  counter--;
  $$ = "%eax";
}
| exp '%' exp       {
  printf("Mod\n");
  asmCode = asmConcat(asmCode,getMod(counter));
  counter--;
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
  printf("HEX : %d\n",tmp);
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
  printf("Assign %d\n",counter);
  asmCode = asmConcat(asmCode, getAssign($1,$3));
  counter = 0;
}
| showh
| shows
| cmp
| loop
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


cmp:
CMP conditionCmp statementCmp { printf("Cmp:\n");}
;


conditionCmp:
'(' val ',' val ')' {
  printf("CMP \n");
  asmCode = asmConcat(asmCode,getSetValue($2,1));
  asmCode = asmConcat(asmCode,getSetValue($4,2));
  asmCode = asmConcat(asmCode,getCmpCodeStart());
}
;


statementCmp:
'{' input '}' {
  asmCode = asmConcat(asmCode,getCmpCodeEnd());
}
;


loop:
LOOP conditionLoop statementLoop  { printf("Loop:\n");}


conditionLoop:
'(' val ',' val ',' '+' val ')' {
  asmCode = asmConcat(asmCode,getSetValue($2,1));
  asmCode = asmConcat(asmCode,getSetValue($4,2));
  asmCode = asmConcat(asmCode,getLoopCodeAdd($7));
  counter = 0;
}
| '(' val ',' val ',' '-' val ')' {
  asmCode = asmConcat(asmCode,getSetValue($2,1));
  asmCode = asmConcat(asmCode,getSetValue($4,2));
  asmCode = asmConcat(asmCode,getLoopCodeSub($7));
  counter = 0;
}
| '(' val ',' val ',' '*' val ')' {
  asmCode = asmConcat(asmCode,getSetValue($2,1));
  asmCode = asmConcat(asmCode,getSetValue($4,2));
  asmCode = asmConcat(asmCode,getLoopCodeMultiple($7));
  counter = 0;
}
;


statementLoop:
'{' input '}' {
  asmCode = asmConcat(asmCode,getLoopCodeEnd());
}
;


%%

int main (void)
{
  int i;
  FILE *fp = fopen("output.s","wb+");
  counter = 0;
  yyparse ();
  asmHead = asmConcat(asmHead,getMain());
  asmCode = asmConcat(asmCode,getTail());
  fputs(asmHead,fp);
  fputs(asmCode,fp);
}
