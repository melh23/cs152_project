# cs152_project

## Flex commands:  
flex -o lexer.c lexer.lex <br/>
gcc lexer.c -lfl -o lexer

## Bison commands:
make <br/>
./parser <filename.min>

compile bison <br/>
bison -v -d --file-prefix=y parser.y.



## compile
g++ lexer.c main.cc bison.c parser.tab.c -lfl -o lexer

## Emacs shortcuts

File: <br/>
Ctrl-X, Ctrl-F	Open <br/>
Ctrl-X, Ctrl-S	Save <br/>
Ctrl-X, Ctrl-W	Save As <br/>
Ctrl-X, S	Save All <br/>
Ctrl-X, Ctrl-V	Revert to File <br/>
Meta-X, revert-buffer	Revert Buffer <br/>
Ctrl-X, Ctrl-C	Exit <br/>

Edit: <br/>
Ctrl-_	Undo <br/>
Ctrl-Y	Paste <br/>
Ctrl-SPC	Begin Selection <br/>
DEL	Delete <br/>
Ctrl-D	Fwd Delete <br/>
Meta-DEL	Delete Word <br/>
Meta-D	Fwd Delete Word <br/>
Ctrl-K	Delete Line <br/>
Ctrl-W	Delete Selection <br/>
