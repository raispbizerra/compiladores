%{

/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */

#include <stdio.h>
%}
/* Declaração de Tokens no formato %token NOME_DO_TOKEN */

%token NUM
%token MUL 
%token DIV 
%token ADD 
%token SUB
%token OPN 
%token CLS 
%token EOL 

%%
/* Regras de Sintaxe */
calc: 
    | calc exp EOL          { printf("=%d\n", $2) }
    ;         

exp: factor 
   | exp ADD factor         { $$ = $1 + $3 }
   | exp SUB factor         { $$ = $1 - $3 }
   ;

factor: term 
      | factor MUL term     { $$ = $1 * $3 } 
      | factor DIV term     { $$ = $1 / $3 }
      ;

term: NUM 
    | OPN term CLS          { $$ = $2 }
    | OPN exp CLS           { $$ = $2 }
    ;

%%
/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

int main (int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
