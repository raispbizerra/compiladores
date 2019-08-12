%{

/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */

#include <stdio.h>
#include <stdlib.h>


typedef struct node {
    char token[50];
    struct node* r;
    struct node* l;
} node;


node* allocate_node();
void free_node(void* node);
void print_tree(node* root);
node* create_node(char[50], node*, node*);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union 
{
    int number;
    char simbolo[50];
    struct node* no;
}
%token NUM
%token ADD
%token SUB
%token MUL
%token DIV
%token APAR
%token FPAR
%token EOL

%type<no> calc
%type<no> termo
%type<no> fator
%type<no> exp
%type<simbolo> NUM
%type<simbolo> MUL
%type<simbolo> DIV
%type<simbolo> SUB
%type<simbolo> ADD


%%
/* Regras de Sintaxe */

calc: /* nothing */                      
  | calc exp EOL { printf("= %d\n", $2); }
  ;

exp: fator                
  | exp ADD fator { $$ = $1 + $3; }
  | exp SUB fator { $$ = $1 - $3; }
  ;

fator: termo            
  | fator MUL termo { $$ = $1 * $3; }
  | fator DIV termo { $$ = $1 / $3; }
  ;

termo: NUM               
  | APAR termo FPAR   { $$ = $2; }
  | APAR exp FPAR     { $$ = $2; }
  ;

%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

node* allocate_node() {
    return (node*) malloc(sizeof(node));
}

void free_node(void* node) {
    free(node);
}

node* create_node(char token[50], node* r, node* l) {
  node* n = allocate_node();
  snprintf(n->token, 50, "%s", token);
  n->r = r;
  n->l = l;

  return n;
}

void print_tree(node* root) {

  if (root == NULL) { 
    printf("***"); 
    return; 
  }
  printf("(%s)", root->token);
  printf("right>");
  print_tree(root->r);
  printf("left>");
  print_tree(root->l);
}


int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}

