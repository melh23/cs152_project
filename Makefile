#Makefile

OBJS	= bison.o lexer.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic -std=c++11

parser:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o parser -lfl

lexer.o:	lexer.c
		$(CC) $(CFLAGS) -c lexer.c -o lexer.o

lexer.c:	lexer.lex 
		flex lexer.lex
		cp lex.yy.c lexer.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	parser.y
		bison -d -v parser.y
		cp parser.tab.c bison.c
		cmp -s parser.tab.h tok.h || cp parser.tab.h tok.h

lexer.o yac.o		: heading.h
lexer.o 		: tok.h

clean:
	rm -f *.o *~ lexer.c lex.yy.c bison.c tok.h parser.tab.c parser.tab.h parser.output parser

