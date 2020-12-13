flex ../lexer.l
gcc lex.yy.c -lm
./a.out $1