bison -d Grammar.y
flex Lexer.l
gcc -o compiler lex.yy.c Grammar.tab.c
compiler < input.txt
gcc -o prog output.s
