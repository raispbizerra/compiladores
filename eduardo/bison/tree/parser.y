
%{
/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    char token[50];
    int num_children;
    struct Node** children;
} Node;

Node* allocate_node();
void free_node(Node* no);
void print_tree(Node* root);
Node* new_node(char[50], Node**, int);

%}
/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union 
{
    int number;
    char simbolo[50];
    struct Node* no;
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
calc:
  | calc exp EOL       { print_tree($2); } 
exp: fator               
  | exp ADD fator      {

      Node** children = (Node**) malloc(sizeof(Node*)*3);
      children[0] = $1;
      children[1] = new_node("+", NULL, 0);
      children[2] = $3;
      $$ = new_node("exp", children, 3);

    }
  | exp SUB fator      {

      Node** children = (Node**) malloc(sizeof(Node*)*3);
      children[0] = $1;
      children[1] = new_node("-", NULL, 0);
      children[2] = $3;
      $$ = new_node("exp", children, 3);

    }
  ;

fator: termo            
  | fator MUL termo    {                             

      Node** children = (Node**) malloc(sizeof(Node*)*3);
      children[0] = $1;
      children[1] = new_node("*", NULL, 0);
      children[2] = $3;
      $$ = new_node("termo", children, 3);

    }
  | fator DIV termo    {                             
      Node** children = (Node**) malloc(sizeof(Node*)*3);
      children[0] = $1;
      children[1] = new_node("/", NULL, 0);
      children[2] = $3;
      $$ = new_node("termo", children, 3);
    }
  ;

termo: NUM { $$ = new_node($1, NULL, 0); }               

%%
/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */
Node* allocate_node(int num_children) {
    return (Node*) malloc(sizeof(Node)* num_children);
}
void free_node(Node* no) {
    free(no);
}
Node* new_node(char token[50], Node** children, int num_children) {
    Node* no = allocate_node(3);
    snprintf(no->token, 50, "%s", token);
    no->num_children= num_children;
    no->children = children;
    return no;
}
void print_tree(Node* root) {

if(root == NULL) { printf("***"); return; }
    printf("(%s)", root->token);
    int i = 0;
    if (root->children != NULL) {
        printf(" -> ");
        print_tree(root->children[0]);
        print_tree(root->children[1]);
        print_tree(root->children[2]);
        printf("$\n");
    } else {
        printf(" ");
    }
}
int main(int argc, char** argv) {
    yyparse();
}
yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
