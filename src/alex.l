%{
  #include <stdio.h>
  #include <string.h>
  #include "header.h"
  #include "asin.h"
%}

%option yylineno

digito [0-9]
letra [A-Za-z]
integer {digito}+
float ({digito}+)\.{digito}+
id {letra}({letra}|{digito})*
delimitador [ \t\n]+
comentario \/\/[^\n]*\n
%%

"while" {ECHO; return WHILE_;}
"if"  {ECHO; return IF_;}
"else" {ECHO; return ELSE_;}

"int"  {ECHO; return INT_;}
"bool" {ECHO; return BOOL_;}

"read" {ECHO; return READ_;}
"print" {ECHO; return PRINT_;}

"true" {yylval.cent = 1; return TRUE_;}
"false" {yylval.cent = 0; return FALSE_;}

"+"  {ECHO; return SUMA_;}
"-"  {ECHO; return RESTA_;}
"*"  {ECHO; return MULT_;}
"/"  {ECHO; return DIV_;}

"="  {ECHO; return ASIGNACION_;}
"+="  {ECHO; return MASIGUAL_;}
"-="  {ECHO; return MENOSIGUAL_;}
"++"  {ECHO; return INCREMENTO_;}
"--"  {ECHO; return DECREMENTO_;}


"=="  {ECHO; return IGUALDAD_;}
"!="  {ECHO; return DESIGUAL_;}
"!"   {ECHO; return NEGACION_;}
"&&"  {ECHO; return COMPARADOR_AND_;}
"||"  {ECHO; return COMPARADOR_OR_;}
"<="  {ECHO; return MENOR_IGUAL_;}
">="  {ECHO; return MAYOR_IGUAL_;}
"<"   {ECHO; return MENOR_QUE_;}
">"   {ECHO; return MAYOR_QUE_;}


{comentario}  {ECHO;}
{delimitador}  {ECHO;}
";" {ECHO; return PTOCOMA_; }


"("  {ECHO; return PARENTESIS_AB_;}
")"  {ECHO; return PARENTESIS_CERR_;}
"{"  {ECHO; return CORCHETE_AB_;}
"}"  {ECHO; return CORCHETE_CERR_;}
"["  {ECHO; return CLAUDATOR_AB_;}
"]"  {ECHO; return CLAUDATOR_CERR_;}

{integer}	{ creaCentera(); return(CTE_);}

{float}		{	truncCreal();
				return(CTE_);
			}

{id}		{	creaNombre();
				return(ID_);
			}

.  		{yyerror("Caracter desconocido");}

%%

void creaNombre(){
  char *t;
  if (yyleng > MAX_LENGTH) {
    fprintf(stdout,"\nWarning at line %d: identificador truncado a longitud %d\n",
    yylineno, MAX_LENGTH);
    yyleng=MAX_LENGTH;
    }
  t = (char *)malloc(yyleng+1);
  strncpy(t, yytext, yyleng);
  t[yyleng] = '\0'; yylval.ident = t;
}

void creaCentera(){
  	yylval.cent = atoi(yytext);
}

void truncCreal(){
  yylval.cent = atoi(yytext);
  fprintf(stdout,"\nWarning at line %d: constante real truncada a entera %d\n",
  yylineno,yylval.cent);
}
