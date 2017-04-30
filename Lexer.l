C			[0-9a-zA-Z]
DEC 		[0-9]
HEX1 		[0][x|X]
HEX2		[0-9a-fA-F]
VAR 		[v|V][a|A][r|R][#]
SHOW 		[s|S][h|H][o|O][w|W]
SHOWH 		[s|S][h|H][o|O][w|W][h|H]
SHOWS 		[s|S][h|H][o|O][w|W][s|S]
CMP 		[c|C][m|M][p|P]
LOOP 		[l|L][o|O][o|O][p|P]

%{

#include <stdlib.h>
#include <string.h>
#include "Grammar.tab.h"
#include <ctype.h>

%}

%%

<<EOF>>     {return ENDOFFILE;}

"\n"				{ return '\n'; }
" "					{ }
"\t"				{ }

";"			{ return ';'; }
"+"					{ return '+'; }
"-"					{ return '-'; }
"*"					{ return '*'; }
"/"					{ return '/'; }
"("					{ return '('; }
")"					{ return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
"\\"				{ return '\\'; }
"^"					{ return '^'; }
","					{ return ','; }
"="					{ return '='; }


{DEC}+				{ yylval.l = atoi(yytext);					return DEC; }
{HEX1}{HEX2}+		{ yylval.l = (int)strtol(yytext, NULL, 16);  	return HEX; }
{SHOW}				{ return SHOW; }
{SHOWH}				{ return SHOWH; }
{SHOWS}				{ return SHOWS; }
{CMP}				{ return CMP; }
{LOOP}				{ return LOOP; }
{VAR}[A-Z|a-z][A-Z|a-z] {
  yylval.l = ((toupper(yytext[1]) - 65) * 26) +  (toupper(yytext[2]) - 65);
  return REG;
}
"exit"				{ return EXIT; }
{C}+				{ return STR; }
.                   { }
%%

int yywrap(void)
{
   return 0;
}

int yyerror(void)
{
    printf("! ERROR\n");
}
