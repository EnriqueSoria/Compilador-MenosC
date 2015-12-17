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
%type <tipoYpos> instruccionIteracion
%type <tipoYpos> instruccionExpresion
%type <tipoYpos> instruccionSeleccion
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
        {if(verTDS) mostrarTDS();
        }
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
        | BOOL_ { $$ = T_LOGICO; }
        ;

instruccion: CORCHETE_AB_ listaInstrucciones CORCHETE_CERR_
        | instruccionExpresion
        | instruccionEntradaSalida
        | instruccionSeleccion
        | instruccionIteracion
        ;

listaInstrucciones:
        | listaInstrucciones instruccion
        ;
instruccionExpresion: expresion PTOCOMA_{ $$.tipo = $1.tipo;  }
        | PTOCOMA_
        ;


instruccionEntradaSalida: READ_ PARENTESIS_AB_ ID_ PARENTESIS_CERR_ PTOCOMA_
                            {    SIMB s = obtenerTDS($3);
                                if(s.tipo!=T_ENTERO) yyerror("El argumento de read debe ser Entero");

                            }

        | PRINT_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ PTOCOMA_
            {
                if($3.tipo != T_ENTERO) yyerror("La expresion del 'print' debe ser 'entera'");

            }
        ;

instruccionSeleccion: IF_ PARENTESIS_AB_ expresion PARENTESIS_CERR_
                        { if($3.tipo == T_ERROR){
                          $$.tipo = T_ERROR;
                        }else{
                          $$.tipo = T_LOGICO;
                        }

                      }


instruccion ELSE_ instruccion

        ;
instruccionIteracion: WHILE_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ instruccion
                    { if($3.tipo != T_LOGICO) yyerror("La expresion de While debe de ser Logica");
                      else $$.tipo = $3.tipo;
                  }
        ;

expresion: expresionLogica
          {$$.tipo = $1.tipo; }
        | ID_ operadorAsignacion expresion
        { if($3.tipo == T_ERROR){
           $$.tipo = T_ERROR;
        }else{
          SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
          if (sim.tipo == T_ERROR) yyerror("Objeto no declarado");
          else{if ((($3.tipo == T_ENTERO) || ($3.tipo == T_LOGICO)) &&
                        ((sim.tipo == T_ENTERO) || (sim.tipo == T_LOGICO)) &&
                        (sim.tipo == $3.tipo))
                        {
                          $$.tipo = sim.tipo;}
                        else yyerror("Error en la asignacion");
          }
        }
        }
        | ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_ operadorAsignacion expresion
          {
            if($6.tipo == T_ERROR){$$.tipo = T_ERROR;}
            else{
            SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
            if(sim.tipo == T_ERROR) yyerror("Objeto no declarado");
            else {
              if(sim.tipo != T_ARRAY) yyerror("La variable debe de ser T_ARRAY");
              else {
                if($3.tipo != T_ENTERO) yyerror("Error en el indice de la array");
                else{
                  if(sim.telem != $6.tipo) yyerror("Error en el tipo de la asignacion");
                }
                }
              }

            }
            }
        ;

expresionLogica: expresionIgualdad
        {$$.tipo = $1.tipo;}
        | expresionLogica operadorLogico expresionIgualdad
          {$$.tipo = T_ERROR;

           if($1.tipo == T_LOGICO && $3.tipo == T_LOGICO){
             $$.tipo = $1.tipo;
           }else{ yyerror("Error en el operador Logico");}

         }
        ;

expresionIgualdad: expresionRelacional
        {
          $$.tipo = $1.tipo;
        }
	| expresionIgualdad operadorIgualdad expresionRelacional
      {}
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
            {$$.tipo = $1.tipo;
            }
        | expresionAditiva operadorAditivo expresionMultiplicativa
			{
				if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO) $$.tipo = T_ENTERO;
				else {yyerror ("Tipos no validos 229");
              $$.tipo = T_ERROR;
      }
			}
        ;

expresionMultiplicativa: expresionUnaria
						{
                $$.tipo = $1.tipo;
            }
        | expresionMultiplicativa operadorMultiplicativo expresionUnaria
			{if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO){
					$$.tipo = T_ENTERO;}
			else{	yyerror ("Error en expresion multiplicativa");
              			$$.tipo = T_ERROR;
				}
			}
        ;

expresionUnaria: expresionSufija
				{
            $$.tipo = $1.tipo;
          }
        | operadorUnario expresionUnaria
          {
            if($2.tipo != T_LOGICO){
              $$.tipo = T_ERROR;
              yyerror("Error en expresionUnaria");
            }

        }

        | operadorIncremento ID_{
			      SIMB id = obtenerTDS( $2 );
			      if(id.tipo == T_ENTERO) $$.tipo = T_ENTERO;
			      else  $$.tipo = T_ERROR;
		               }
        ;

expresionSufija: ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_
        {
          $$.tipo = T_ERROR; SIMB sim = obtenerTDS($1);
          if(sim.telem == T_ENTERO ) $$.tipo = T_ENTERO;
          if(sim.telem == T_LOGICO) $$.tipo = T_LOGICO;
        }
        | PARENTESIS_AB_ expresion PARENTESIS_CERR_
        {
          $$.tipo = $2.tipo;
        }
        | ID_ { SIMB sim = obtenerTDS($1);
                $$.tipo = sim.tipo;
        }
        | ID_ operadorIncremento {SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
                                    if(sim.tipo == T_ENTERO){$$.tipo = T_ENTERO;}

        }
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
