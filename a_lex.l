%{
  #include <stdio.h>
%}

%option yylineno

digito [0-9]
letra [A-Za-z]

integer {digito}+
id {letra}({letra}|{digito})*
delimitador [ \t\n]+

%%

/** Control **/
"while" {ECHO; return(WHILE_);}  
"if"  {ECHO; return(IF_);}

/** Tipos basicos **/
"int"  {ECHO; return(INT_);}
"bool" {ECHO; return(BOOL_);}

/** Entrada/Salida **/
"read" {ECHO; return(READ_);}
"print" {ECHO; return(PRINT_);}

/** Constantes **/
"true" {ECHO; return(TRUE_);}
"false" {ECHO; return(FALSE_);}

/** Operadores aritmeticos**/
"+"  {ECHO; return(SUMA_);}
"-"  {ECHO; return(RESTA_);}
"*"  {ECHO; return(MULT_);}
"/"  {ECHO; return(DIV_);}

"="  {ECHO; return(ASIGNACION_);}
"+="  {ECHO; return(MASIGUAL_);}
"-="  {ECHO; return(MENOSIGUAL_);} 


/** Operadores logicos **/
"=="  {ECHO; return(IGUALDAD_);}
"&&"  {ECHO; return(COMPARADOR_AND_);}
"||"  {ECHO; return(COMPARADOR_OR_);}
"<="  {ECHO; return(MENOR_IGUAL_);}
">="  {ECHO; return(MAYOR_IGUAL_);}
"<"   {ECHO; return(MENOR_QUE_);}
">"   {ECHO; return(MAYOR_QUE_);}


/** Comentarios de una linea **/
\/\/[^\n]*\n  {}
{delimitador}  {}
";" {}


/** Signos de puntuacion **/
"("  {ECHO; return(PARENTESIS_AB_);}
")"  {ECHO; return(PARENTESIS_CERR_);}
"{"  {ECHO; return(CORCHETE_AB_);}
"}"  {ECHO; return(CORCHETE_CERR_);}

/** Identificador **/
{id}  {return ID_;}


/** Cualquier otra cosa **/
.  {yyerror("Caracter desconocido");}
  
%% 

/*** Función de error **/
int yyerror(char *c) {
  printf("%s en la linea %s", c, yyleno);
}

/*** Main ***/
int main (int argc, char *argv[]) {
  if ( (yyin=fopen(argv[1], "r")) == NULL ) {
    fprintf( stderr, "Fichero no valido %s", argv[1]);  
  }
  //yyparse();
  yylex();
  
  return 0;
}


