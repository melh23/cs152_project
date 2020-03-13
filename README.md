# cs152_project
Ashly Hernandez </br>
Melanie Henneessee </br>

***mil code is generated and output to a file called output.mil


## Working Features
1. Declarations (scalar and array)
2. Input/output statements
3. Arithmetic operations
4. Comparison operations
5. Logical operator statements
6. Delcaring labels
7. If then else statemetns
8. Write statements
9. Read statements
10. While loop
11. Do while
12. Return


## Not implemented features
1. For loop
2. Assign 


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
