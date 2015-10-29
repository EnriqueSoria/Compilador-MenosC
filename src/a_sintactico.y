%{
#include <stdio.h>
extern int yylineno;
%}

%token ID_ PTOCOMA_
%token INT_ FLOAT_
%token WHILE_
%token IF_
%token BOOL_
%token READ_
%token PRINT_
%token TRUE_
%token FALSE_
%token SUMA_
%token RESTA_
%token MULT_
%token DIV_
%token ASIGNACION_
%token MASIGUAL_
%token MENOSIGUAL_
%token IGUALDAD_
%token COMPARADOR_AND_
%token COMPARADOR_OR_
%token MENOR_IGUAL_
%token MENOR_QUE_
%token MAYOR_IGUAL_
%token MAYOR_QUE_
%token PARENTESIS_AB_
%token PARENTESIS_CERR_
%token CORCHETE_AB_
%token CORCHETE_CERR_
%token CTE_
%%
programa: CORCHETE_AB_ secuenciaSentencias CORCHETE_CERR_;
secuenciaSentencias: sentencia
      | secuenciaSentencias sentencia;
sentencia: declaracion | instruccion;
declaracion: tipoSimple ID_ PTOCOMA_
      | tipoSimple ID_ CLAUDATOR_AB_ CTE_ CLAUDATOR_CERR_

%%
