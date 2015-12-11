%{
#include <stdio.h>
#include <string.h>
#include "libtds.h"
#include "libgci.h"
#include "header.h"
%}

%union{
      char* ident; /* Nombre del ID */
      int tipo; /* Tipo de la expresion */
		  int cent; /* Valor constante */
      int pos;
      int op;	 /* Operacion */
      int uni; /* Tipo del operador unario */
      struct {
        int tipo;
        int pos;
      }tipoYpos;
}

%token YYERROR_VERBOSE_
%token <ident> ID_
%token FLOAT_
%token WHILE_
%token IF_
%token INT_
%token BOOL_
%token READ_
%token PRINT_
%token <cent> TRUE_
%token <cent> FALSE_
%token SUMA_
%token RESTA_
%token MULT_
%token ELSE_
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
%token <cent> CTE_
%token <uni> NEGACION_
%token <uni> INCREMENTO_
%token <uni> DECREMENTO_


%type <tipoYpos> expresion
%type <tipoYpos> expresionIgualdad
%type <tipoYpos> expresionLogica
%type <tipoYpos> expresionAditiva
%type <tipoYpos> expresionMultiplicativa
%type <tipoYpos> expresionUnaria
%type <tipoYpos> expresionSufija
%type <tipoYpos> expresionRelacional

%type <uni> operadorUnario
%type <op> operadorAditivo
%type <op> operadorMultiplicativo
%type <op> operadorAsignacion
%type <op> operadorRelacional
%type <cent> operadorLogico
%type <cent> tipoSimple
%type <cent> operadorIncremento


%%

programa: CORCHETE_AB_ secuenciaSentencias CORCHETE_CERR_
        ;

secuenciaSentencias: sentencia
        | secuenciaSentencias sentencia
        ;

sentencia: declaracion
        | instruccion
        ;

declaracion: tipoSimple ID_ PTOCOMA_ {
                if (! insertarTSimpleTDS($2, $1, dvar)){
                        yyerror ("Identificador repetido");
					}
                else {dvar += TALLA_TIPO_SIMPLE;}
        }|
        tipoSimple ID_ CLAUDATOR_AB_ CTE_ CLAUDATOR_CERR_ PTOCOMA_ {
                int numelem = $4;
                if ($4 <= 0){
                        yyerror("Talla inapropiada");
                        numelem = 0;
                }
                if (! insertarTVectorTDS ($2, T_ARRAY, dvar, $1, numelem))
                        yyerror("Identificador repetido");
                else dvar += numelem * TALLA_TIPO_SIMPLE;

        };

tipoSimple: INT_ { $$ = T_ENTERO; }
        | BOOL_ { $$ = T_LOGICO; };

instruccion: CORCHETE_AB_ listaInstrucciones CORCHETE_CERR_
        | instruccionExpresion
        | instruccionEntradaSalida
        | instruccionSeleccion
        | instruccionIteracion
        ;

listaInstrucciones:
        | listaInstrucciones instruccion
        ;

instruccionExpresion: expresion PTOCOMA_{ if ($1.tipo == T_LOGICO) yyerror ("Tipo no valido"); }
        | PTOCOMA_
        ;


instruccionEntradaSalida: READ_ PARENTESIS_AB_ ID_ PARENTESIS_CERR_ PTOCOMA_
                            {    SIMB s = obtenerTDS($3);
                                if(s.tipo!=T_ENTERO || s.tipo != T_LOGICO) yyerror("Tipo no valido");

                            }

        | PRINT_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ PTOCOMA_
            {
                if($3.tipo != T_ENTERO || $3.tipo != T_LOGICO) yyerror("Tipo no valido");

            }
        ;

instruccionSeleccion: IF_ PARENTESIS_AB_ expresion PARENTESIS_CERR_
                        { if($3.tipo != T_LOGICO) yyerror("Tipo no valido");}


instruccion ELSE_ instruccion
        ;
instruccionIteracion: WHILE_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ instruccion
                    { if($3.tipo != T_LOGICO) yyerror("Tipo no valido");}
        ;

expresion: expresionLogica
          {$$.tipo = $1.tipo;}
        | ID_ operadorAsignacion expresion
        { SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
          if (sim.tipo == T_ERROR) yyerror("Objeto no declarado");
          else if (!(($3.tipo == T_ENTERO) || ($3.tipo == T_LOGICO)) &&
                        ((sim.tipo == T_ENTERO) || (sim.tipo == T_LOGICO)) &&
                        (sim.tipo == $3.tipo))
                yyerror("Error de tipos en la 'asignacion'");
          else $$.tipo = sim.tipo;
        }
        | ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_ operadorAsignacion expresion

        ;

expresionLogica: expresionIgualdad
        {$$.tipo = $1.tipo;}
        | expresionLogica operadorLogico expresionIgualdad
        ;

expresionIgualdad: expresionRelacional
        {
          $$.tipo = $1.tipo
        }
	| expresionIgualdad operadorIgualdad expresionRelacional
    {
      printf("Soy una expresion");
    }
        ;

expresionRelacional: expresionAditiva
              {
                $$.tipo = $1.tipo;
              }
        | expresionRelacional operadorRelacional expresionAditiva
        {
          if($1.tipo != T_ENTERO || $3.tipo != T_ENTERO){
            yyerror("No se pueden comparar objetos de tipos diferentes");
            $$.tipo = T_ERROR;
          }
          else{$$.tipo = T_LOGICO;}
        }
        ;

expresionAditiva: expresionMultiplicativa
        | expresionAditiva operadorAditivo expresionMultiplicativa
			{
				if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO) $$.tipo = T_ENTERO;
				else {yyerror ("Tipos no validos");
              $$.tipo = T_ERROR;
      }
			}
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
        | ID_ { SIMB sim = obtenerTDS($1);
                $$.tipo = sim.tipo;
        }
        | ID_ operadorIncremento
        | CTE_ {$$.tipo = T_ENTERO}
        | TRUE_ {$$.tipo = T_LOGICO}
        | FALSE_ {$$.tipo = T_LOGICO}
        ;

operadorAsignacion: ASIGNACION_
        | MASIGUAL_
        | MENOSIGUAL_
        ;

operadorLogico: COMPARADOR_AND_
        | COMPARADOR_OR_
        ;

operadorIgualdad: IGUALDAD_
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
