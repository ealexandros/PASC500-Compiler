all: pasc500

pasc500.tab.c pasc500.tab.h: pasc500.y
	bison -v -d pasc500.y

lex.yy.c: pasc500.l pasc500.tab.h
	flex pasc500.l

pasc500: lex.yy.c pasc500.tab.c pasc500.tab.h
	gcc pasc500.tab.c lex.yy.c -lm

clean:
	rm pasc500 pasc500.tab.c lex.yy.c pasc500.tab.h
	rm pasc500.output