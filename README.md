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
File
-----
Ctrl-X, Ctrl-F	Open
Ctrl-X, Ctrl-S	Save
Ctrl-X, Ctrl-W	Save As
Ctrl-X, S	Save All
Ctrl-X, Ctrl-V	Revert to File
Meta-X, revert-buffer	Revert Buffer
Ctrl-X, Ctrl-C	Exit
<br/>
Edit
----
Ctrl-_	Undo
Ctrl-Y	Paste
Ctrl-SPC	Begin Selection
DEL	Delete
Ctrl-D	Fwd Delete
Meta-DEL	Delete Word
Meta-D	Fwd Delete Word
Ctrl-K	Delete Line
Ctrl-W	Delete Selection
