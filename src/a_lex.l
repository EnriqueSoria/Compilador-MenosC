%{
  #include <stdio.h>
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

"int"  {ECHO; return INT_;}
"bool" {ECHO; return BOOL_;}

"read" {ECHO; return READ_;}
"print" {ECHO; return PRINT_;}

"true" {ECHO; return TRUE_;}
"false" {ECHO; return FALSE_;}

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


{comentario}  {}
{delimitador}  {}
";" { return PTOCOMA_; }


"("  {ECHO; return PARENTESIS_AB_;}
")"  {ECHO; return PARENTESIS_CERR_;}
"{"  {ECHO; return CORCHETE_AB_;}
"}"  {ECHO; return CORCHETE_CERR_;}
"["  {ECHO; return CLAUDATOR_AB_;}
"]"  {ECHO; return CLAUDATOR_CERR_;}
{integer} { yyval.cent = atoi( yytext );
            return CTE_;}
{float} {yyval.cent = atoi( yytext );
          return CTE_;}

{id}  {return ID_;}
.  {yyerror("Caracter desconocido");}

%%

int yyerror(char *c) {
  printf("%s en la linea %s", c, yyleno);
}

int main (int argc, char *argv[]) {
  if ( (yyin=fopen(argv[1], "r")) == NULL ) {
    fprintf( stderr, "Fichero no valido %s", argv[1]);
  }
  yyparse();

  return 0;
}
