/* 
Crie um Analisador Léxico utilizando Flex que consiga gerar os tokens
do arquivo de entrada "exercicio01.in" que consiste em um código na
linguagem C. O analisador deverá identificar todos os tokens referentes a:

1. Identificadores
2. Números Inteiros
3. Números de Ponto Flutuante
4. Palavras reservadas
5. Operadores Matemáticos e Relacionais
6. Chaves, Colchetes e Chaves

utilize os exemplos no diretório "flex" como ponto de partida.
*/

%{
	int counter = 0;
%}

VAR [_a-zA-Z][_a-zA-Z0-9]*
STRING [']([_a-zA-Z0-9]+)[']
ATTRIBUTION "="
NUMBER [0-9]+
FUNCTION "def"
ARGS [_a-zA-Z][_a-zA-Z0-9]*
%%
  /* 
  * Rules 
  */
{VAR}+" "+{ATTRIBUTION}  {printf("<variable, %s>", yytext); counter++;}
{STRING} {printf("<string, %s>", yytext); counter++;}
{FUNCTION}+" "+{VAR}+"(" {printf("<function , %s>", yytext); counter++;}
<<EOF>>                return 0;
    
%%

int yywrap() {}

int main() {
    printf("Iniciando Análise Léxica...\n---\n");
    yylex();
    printf("Foram encontradas %d ocorrências de identificadores.\n", counter);
    printf("---\nÁnalise Finalizada!\n");
    return 0;
}
