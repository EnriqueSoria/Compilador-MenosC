%{
#include <stdio.h>
extern int yylineno;
%}

%token ID_
%token FLOAT_
%token WHILE_
%token IF_
%token ELSE_
%token INT_
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
%token DESIGUAL_
%token COMPARADOR_AND_
%token COMPARADOR_OR_
%token MENOR_IGUAL_
%token MAYOR_IGUAL_
%token MENOR_QUE_
%token MAYOR_QUE_
%token PARENTESIS_AB_
%token PARENTESIS_CERR_
%token CORCHETE_AB_
%token CORCHETE_CERR_
%token CLAUDATOR_AB_
%token CLAUDATOR_CERR_
%token PTOCOMA_
%token CTE_
%token NEGACION_
%token INCREMENTO_
%token DECREMENTO_

%%

programa: CORCHETE_AB_ secuenciaSentencias CORCHETE_CERR_
        ;

secuenciaSentencias: sentencia
        | secuenciaSentencias sentencia
        ;

sentencia: declaracion
        | instruccion
        ;

declaracion: tipoSimple ID_ PTOCOMA_
        | tipoSimple ID_ CLAUDATOR_AB_ CTE_ CLAUDATOR_CERR_ PTOCOMA_
        ;

tipoSimple: INT_
        | BOOL_
        ;

instruccion: CLAUDATOR_AB_ listaInstrucciones CLAUDATOR_CERR_
        | instruccionExpresion
        | instruccionEntradaSalida
        | instruccionSeleccion
        | instruccionIteracion
        ;

listaInstrucciones: 
        | listaInstrucciones instruccion
        ;

instruccionExpresion: expresion PTOCOMA_
        | PTOCOMA_
        ;

instruccionEntradaSalida: READ_ PARENTESIS_AB_ ID_ PARENTESIS_CERR_ PTOCOMA_
        | PRINT_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ PTOCOMA_
        ;

instruccionSeleccion: IF_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ instruccion
        ;

instruccionSeleccion: IF_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ instruccion ELSE_ instruccion
        ;

instruccionIteracion: WHILE_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ instruccion
        ;

expresion: expresionLogica
        | ID_ operadorAsignacion expresion
        | ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_ operadorAsignacion expresion
        ;

expresionLogica: expresionIgualdad
        | expresionLogica operadorLogico expresionIgualdad
        ;

expresionIgualdad: expresionRelacional
        ;

expresionRelacional: expresionAditiva
        | expresionRelacional operadorRelacional expresionAditiva
        ;

expresionAditiva: expresionMultiplicativa
        | expresionAditiva operadorAditivo expresionMultiplicativa
        ;

expresionMultiplicativa: expresionUnaria
        | expresionMultiplicativa operadorMultiplicativo expresionUnaria
        ;

expresionUnaria: expresionSufija
        | operadorUnario expresionUnaria
        | operadorIncremento ID_
        ;

expresionSufija: ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_
        | PARENTESIS_AB_ expresion PARENTESIS_CERR_
        | ID_ 
        | ID_ operadorIncremento
        | CTE_
        | TRUE_
        | FALSE_
        ;

operadorAsignacion: ASIGNACION_
        | MASIGUAL_
        | MENOSIGUAL_
        ;

operadorLogico: COMPARADOR_AND_
        | COMPARADOR_OR_
        ;

operadorIncremento: IGUALDAD_
        | DESIGUAL_
        ;

operadorRelacional: MAYOR_QUE_
        | MENOR_QUE_
        | MAYOR_IGUAL_
        | MENOR_IGUAL_
        ;

operadorAditivo: SUMA_
        | RESTA_
        ;

operadorMultiplicativo: MULT_
        | DIV_
        ;

operadorUnario: SUMA_
        | RESTA_
        | NEGACION_
        ;

operadorIncremento: INCREMENTO_
        | DECREMENTO_
        ;

%%

/* Llamada por yyparse ante un error */
yyerror (char *s){
        printf ("Linea %d: %s\n", yylineno, s);
}

