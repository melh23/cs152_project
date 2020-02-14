# cs152_project

## Flex commands:  
flex -o lexer.c lexer.lex <br/>
gcc lexer.c -lfl -o lexer

## Bison commands:
make <br/>
./parser <filename.min>

compile bison <br/>
bison -v -d --file-prefix=y parser.y.



##compile
g++ lexer.c main.cc bison.c parser.tab.c -lfl -o lexer
