bison -d Grammar.y
flex Lexer.l
gcc lex.yy.c Grammar.tab.c
