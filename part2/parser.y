
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

void free_node(Node* node);
void print_tree(Node* root);
Node* allocate_node();
Node* new_node(char[50], Node**, int);
Node** allocate_children(int num_children);

%}
/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union {
	int number;
	char symbol[50];
	struct Node* node;
}

%token PARENTHESES_O
%token PARENTHESES_C
%token MOD
%token REL_OP
%token LOG_OP
%token ASS_OP
%token EXPONENTIAL
%token MUL
%token DIV
%token DIV_INT
%token ADD
%token SUB
%token INTEGER
%token FLOAT
%token ID
%token EOL

%type<node> calc
%type<node> term
%type<node> factor
%type<node> exp
%type<node> operator
%type<node> open
%type<node> close

%type<symbol> ID
%type<symbol> INTEGER
%type<symbol> FLOAT
%type<symbol> MUL
%type<symbol> MOD
%type<symbol> DIV
%type<symbol> DIV_INT
%type<symbol> SUB
%type<symbol> ADD
%type<symbol> ASS_OP
%type<symbol> REL_OP
%type<symbol> LOG_OP
%type<symbol> PARENTHESES_O
%type<symbol> PARENTHESES_C

%%
/* Regras de Sintaxe */
calc: %empty
	| calc exp EOL	{ print_tree($2); printf("]\n"); } 
exp: factor
	| exp ADD factor{
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("+", NULL, 0);
		children[2] = $3;
		$$ = new_node("exp", children, 3);
	}
	| exp SUB factor{
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("-", NULL, 0);
		children[2] = $3;
		$$ = new_node("exp", children, 3);
	}
	| exp operator factor{
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = $2;
		children[2] = $3;
		$$ = new_node("exp", children, 3);
	}
	| exp ASS_OP factor{
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("=", NULL, 0);
		children[2] = $3;
		$$ = new_node("exp", children, 3);
	}
	| open exp close{
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = $2;
		children[2] = $3;
		$$ = new_node("exp", children, 3);
	}
;

factor: term            
	| factor MUL term {                         
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("*", NULL, 0);
		children[2] = $3;
		$$ = new_node("factor", children, 3);
	}
	| factor DIV term {                             
		Node** children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("/", NULL, 0);
		children[2] = $3;
		$$ = new_node("factor", children, 3);
	}
	| factor DIV_INT term {
		Node **children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("//", NULL, 0);
		children[2] = $3;
		$$ = new_node("factor", children, 3);
	}
	| factor MOD term {
		Node **children = allocate_children(3);
		children[0] = $1;
		children[1] = new_node("%", NULL, 0);
		children[2] = $3;
		$$ = new_node("factor", children, 3);
	}
;

operator : REL_OP { $$ = new_node($1, NULL, 0); }
	| LOG_OP { $$ = new_node($1, NULL, 0); }
;

open : PARENTHESES_O { $$ = new_node($1, NULL, 0); };
close : PARENTHESES_C { $$ = new_node($1, NULL, 0); };

term : INTEGER { $$ = new_node($1, NULL, 0); }
	| FLOAT { $$ = new_node($1, NULL, 0); }
	| ID { $$ = new_node($1, NULL, 0); }
;

%%
/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */
Node** allocate_children(int num_children){
	return (Node **)malloc(sizeof(Node *) * num_children);
}
Node* allocate_node() {
	return (Node*) malloc(sizeof(Node));
}
void free_node(Node* node) {
	free(node);
}
Node* new_node(char token[50], Node** children, int num_children) {
	Node* node = allocate_node();
	snprintf(node->token, 50, "%s", token);
	node->children = children;
	node->num_children= num_children;
	return node;
}
void print_tree(Node* root) {
	printf("[%s", root->token);
	if (root->children != NULL) {
		for (int n = 0 ; n < root->num_children; n++){
			print_tree(root->children[n]);
		}
	} else{
		printf("]");
	}
}
int main(int argc, char** argv) {
	yyparse();
}
yyerror(char *s) {
	fprintf(stderr, "error: %s\n", s);
}
