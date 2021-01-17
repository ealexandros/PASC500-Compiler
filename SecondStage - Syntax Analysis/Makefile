all: pasc500

pasc500.tab.c pasc500.tab.h: pasc500.y
	bison -v -d pasc500.y

lex.yy.c: pasc500.l pasc500.tab.h
	flex pasc500.l

hashtbl.o: ./extra/hashtbl.c ./extra/hashtbl.h
	gcc -o ./extra/hashtbl.o -c ./extra/hashtbl.c

pasc500: lex.yy.c pasc500.tab.c pasc500.tab.h ./extra/hashtbl.o
	gcc pasc500.tab.c lex.yy.c ./extra/hashtbl.o -lm

clean:
	rm pasc500.output pasc500.tab.c lex.yy.c pasc500.tab.h ./extra/hashtbl.o a.out