%{
  #include "parser.tab.h"
%}

MULTILINE_COMM  \"{3}[\x00-\x7F]*\"{3}
SINGLELINE_COMM "#"[^\n]*
RESERVED        "as"|"assert"|"break"|"class"|"continue"|"del"|"elif"|"else"|"except"|"exec"|"finally"|"for"|"from"|"global"|"if"|"import"|"in"|"is"|"lambda"|"nonlocal"|"pass"|"raise"|"return"|"try"|"while"|"with"|"yield"|"True"|"False"|"None"
DATA_TYPE       "int"|"float"|"complex"|"str"|"list"|"tuple"|"dict"
ASS_OP          "="
EXPONENTIAL     "**"
MUL             "*"
DIV             "/"
DIV_INT         "//"
MOD             "\%"
ADD             "+"
SUB             "-"
REL_OP          ">"|"<"|"=="|">="|"<="|"!="
LOG_OP          "and"|"or"|"not"
DOT_OP          \.
NUMBERS         [0-9]
SIGNAL          [-+]?
CHARACTER       [a-zA-Z]
WHITESPACE      [ \t\n]
PARENTHESES_O   "("
PARENTHESES_C   ")"
BRACKETS_O      "["
BRACKETS_C      "]"
KEYS_O          "{"
KEYS_C          "}"
BLOCK_START     ":"
COMMA           ","
STRING          (\'([^\\\"]|\\.)*\')|(\"([^\\\"]|\\.)*\")
ID              ({CHARACTER}|_)+({CHARACTER}|{NUMBERS}|_)*
INTEGER         {SIGNAL}{NUMBERS}+
FLOAT           {SIGNAL}({NUMBERS}+\.{NUMBERS}*|{NUMBERS}*\.{NUMBERS}+)
ELEMENT         {STRING}|{INTEGER}|{FLOAT}|{ID}|{DATA_TYPE}
LIST            {BRACKETS_O}{WHITESPACE}*(({ELEMENT})({WHITESPACE}*{COMMA}{WHITESPACE}*({ELEMENT}){WHITESPACE}*)*)*{BRACKETS_C}
TUPLE           {PARENTHESES_O}{WHITESPACE}*({ELEMENT}({WHITESPACE}*{COMMA}{WHITESPACE}*{ELEMENT}{WHITESPACE}*)*)*{PARENTHESES_C}
DICT            {KEYS_O}{WHITESPACE}*({STRING}{WHITESPACE}*{BLOCK_START}{WHITESPACE}*{ELEMENT}({WHITESPACE}*{COMMA}{WHITESPACE}*{STRING}{WHITESPACE}*{BLOCK_START}{WHITESPACE}*{ELEMENT}{WHITESPACE}*)*)*{KEYS_C}
FUNCTION_D      "def"{WHITESPACE}+{ID}{WHITESPACE}*{TUPLE}
FUNCTION_C      {ID}{WHITESPACE}*{TUPLE}

%%
  /* 
  * Rules 
  */

{PARENTHESES_O}     {strncpy(yylval.symbol, yytext, 50); return PARENTHESES_O;}
{PARENTHESES_C}     {strncpy(yylval.symbol, yytext, 50); return PARENTHESES_C;}
{MOD}               {strncpy(yylval.symbol, yytext, 50); return MOD;}
{REL_OP}            {strncpy(yylval.symbol, yytext, 50); return REL_OP;}
{LOG_OP}            {strncpy(yylval.symbol, yytext, 50); return LOG_OP;}
{ASS_OP}            {return ASS_OP;}
{EXPONENTIAL}       {return EXPONENTIAL;}
{MUL}               {return MUL;}
{DIV}               {return DIV;}
{DIV_INT}           {return DIV_INT;}
{ADD}               {return ADD;}
{SUB}               {return SUB;}
{INTEGER}           {strncpy(yylval.symbol, yytext, 50); return INTEGER;}
{FLOAT}             {strncpy(yylval.symbol, yytext, 50); return FLOAT;}
{ID}                {strncpy(yylval.symbol, yytext, 50); return ID;}
"\n"                {return EOL;}

%%

int yywrap() {}