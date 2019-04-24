%{
	int counter = 0;
  enum yytokentype {
    MULTILINE_COMM,
    RESERVED,
    ASS_OP,
    MATH_OP,
    REL_OP,
    LOG_OP,
    DOT_OP,
    STRING,
    NUMBERS,
    SIGNAL,
    INTEGER,
    FLOAT,
    WHITESPACE,
    PARENTHESES_O,
    PARENTHESES_C,
    BRACKETS_O,
    BRACKETS_C,
    BLOCK_START,
    ID
  };
%}

MULTILINE_COMM  \"{3}[\x00-\x7F]*\"{3}
SINGLELINE_COMM "#"[^\n]*
RESERVED        "and"|"as"|"assert"|"break"|"class"|"continue"|"del"|"elif"|"else"|"except"|"exec"|"finally"|"for"|"from"|"global"|"if"|"import"|"in"|"is"|"lambda"|"nonlocal"|"not"|"or"|"pass"|"raise"|"return"|"try"|"while"|"with"|"yield"|"True"|"False"|"None"
DATA_TYPE       "int"|"float"|"complex"|"str"|"list"|"tuple"|"dict"
ASS_OP          "="
MATH_OP         "+"|"-"|"*"|"/"|"**"|"//"|"%"
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
FUNCTION_D      "def"{WHITESPACE}*{ID}{WHITESPACE}*{TUPLE}{BLOCK_START}
FUNCTION_C      {ID}{WHITESPACE}*{TUPLE}

%%
  /* 
  * Rules 
  */
{MULTILINE_COMM}  {printf("\n<Multiline commentary , %s >", yytext); counter++;}
{SINGLELINE_COMM} {printf("\n<Singleline commentary , %s >", yytext); counter++;}
{RESERVED}        {printf("\n<Reserved word , %s >", yytext); counter++;}
{FUNCTION_D}      {printf("\n<Function definition, %s >", yytext); counter++;}
{FUNCTION_C}      {printf("\n<Function call, %s >", yytext); counter++;}
{LIST}            {printf("\n<List , %s >", yytext); counter++;}
{TUPLE}           {printf("\n<Tuple , %s >", yytext); counter++;}
{DICT}            {printf("\n<Dict , %s >", yytext); counter++;}
{PARENTHESES_O}   {printf("\n<Open parentheses , %s >", yytext); counter++;}
{PARENTHESES_C}   {printf("\n<Close parentheses , %s >", yytext); counter++;}
{BRACKETS_O}      {printf("\n<Open brackets , %s >", yytext); counter++;}
{BRACKETS_C}      {printf("\n<Close brackets , %s >", yytext); counter++;}
{COMMA}           {printf("\n<Comma , %s >", yytext); counter++;}
{BLOCK_START}     {printf("\n<Block start , %s >", yytext); counter++;}
{INTEGER}         {printf("\n<Integer , %s >", yytext); counter++;}
{FLOAT}           {printf("\n<Float , %s >", yytext); counter++;}
{MATH_OP}         {printf("\n<Mathematical operator , %s >", yytext); counter++;}
{REL_OP}          {printf("\n<Relational operator , %s >", yytext); counter++;}
{ASS_OP}          {printf("\n<Assignment operator , %s >", yytext); counter++;}
{DOT_OP}          {printf("\n<Dot operator , %s >", yytext); counter++;}
{ID}              {printf("\n<Identifier , %s >", yytext); counter++;}
<<EOF>>           return 0;
  
%%

int yywrap() {}

int main() {
  printf("Iniciando Análise Léxica...\n---\n");
  yylex();
  printf("\n\nForam encontradas %d ocorrências.\n", counter);
  printf("---\nÁnalise Finalizada!\n");
  return 0;
}
