%{
  #include <stdio.h>
  #include <string.h>
  #include "header.h"
  #include "asin.h"
  #define  devolver(x) if (verbosidad) ECHO; return x;
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

"while" { devolver( WHILE_);}
"if"  { devolver( IF_);}
"else" { devolver( ELSE_);}

"int"  { devolver( INT_);}
"bool" { devolver( BOOL_);}

"read" { devolver( READ_);}
"print" { devolver( PRINT_);}

"true" {yylval.cent = 1; devolver( TRUE_);}
"false" {yylval.cent = 0; devolver( FALSE_);}

"+"  { devolver( SUMA_);}
"-"  { devolver( RESTA_);}
"*"  { devolver( MULT_);}
"/"  { devolver( DIV_);}

"="  { devolver( ASIGNACION_);}
"+="  { devolver( MASIGUAL_);}
"-="  { devolver( MENOSIGUAL_);}
"++"  { devolver( INCREMENTO_);}
"--"  { devolver( DECREMENTO_);}


"=="  { devolver( IGUALDAD_);}
"!="  { devolver( DESIGUAL_);}
"!"   { devolver( NEGACION_);}
"&&"  { devolver( COMPARADOR_AND_);}
"||"  { devolver( COMPARADOR_OR_);}
"<="  { devolver( MENOR_IGUAL_);}
">="  { devolver( MAYOR_IGUAL_);}
"<"   { devolver( MENOR_QUE_);}
">"   { devolver( MAYOR_QUE_);}


{comentario}  {}
{delimitador}  {if (verbosidad) ECHO;}
";" { devolver( PTOCOMA_); }


"("  { devolver( PARENTESIS_AB_);}
")"  { devolver( PARENTESIS_CERR_);}
"{"  { devolver( CORCHETE_AB_);}
"}"  { devolver( CORCHETE_CERR_);}
"["  { devolver( CLAUDATOR_AB_);}
"]"  { devolver( CLAUDATOR_CERR_);}

{integer}	{ creaCentera(); devolver((CTE_));}

{float}		{	truncCreal();
				devolver(CTE_);
			}

{id}		{	creaNombre();
				devolver(ID_);
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
