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

"while" { return WHILE_;}
"if"  { return IF_;}
"else" { return ELSE_;}

"int"  { return INT_;}
"bool" { return BOOL_;}

"read" { return READ_;}
"print" { return PRINT_;}

"true" {yylval.cent = 1; return TRUE_;}
"false" {yylval.cent = 0; return FALSE_;}

"+"  { return SUMA_;}
"-"  { return RESTA_;}
"*"  { return MULT_;}
"/"  { return DIV_;}

"="  { return ASIGNACION_;}
"+="  { return MASIGUAL_;}
"-="  { return MENOSIGUAL_;}
"++"  { return INCREMENTO_;}
"--"  { return DECREMENTO_;}


"=="  { return IGUALDAD_;}
"!="  { return DESIGUAL_;}
"!"   { return NEGACION_;}
"&&"  { return COMPARADOR_AND_;}
"||"  { return COMPARADOR_OR_;}
"<="  { return MENOR_IGUAL_;}
">="  { return MAYOR_IGUAL_;}
"<"   { return MENOR_QUE_;}
">"   { return MAYOR_QUE_;}


{comentario}  {}
{delimitador}  {}
";" { return PTOCOMA_; }


"("  { return PARENTESIS_AB_;}
")"  { return PARENTESIS_CERR_;}
"{"  { return CORCHETE_AB_;}
"}"  { return CORCHETE_CERR_;}
"["  { return CLAUDATOR_AB_;}
"]"  { return CLAUDATOR_CERR_;}

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
