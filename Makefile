#Makefile

OBJS	= bison.o lexer.o main.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic

calc:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o lexer -lfl

lexer.o:	lexer.c
		$(CC) $(CFLAGS) -c lexer.c -o lexer.o

lexer.c:	lexer.lex 
		flex lexer.lex
		cp lexer.yy.c lexer.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	parser.y
		bison -d -v parser.y
		cp parser.tab.c bison.c
		cmp -s parser.tab.h tok.h || cp parser.tab.h tok.h

main.o:		main.cc
		$(CC) $(CFLAGS) -c main.cc -o main.o

lexer.o yac.o main.o	: heading.h
lexer.o main.o		: tok.h

clean:
	rm -f *.o *~ lexer.c lexer.yy.c bison.c tok.h parser.tab.c parser.tab.h parser.output parser

