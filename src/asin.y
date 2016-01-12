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
%type <op> operadorIgualdad
%type <cent> operadorLogico
%type <cent> tipoSimple
%type <cent> operadorIncremento


%%

programa: CORCHETE_AB_ secuenciaSentencias CORCHETE_CERR_
        {
          if(verTDS) mostrarTDS();
          emite( FIN, crArgNul(), crArgNul(), crArgNul());
        }
        | CORCHETE_AB_ CORCHETE_CERR_
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
        }
        | tipoSimple ID_ CLAUDATOR_AB_ CTE_ CLAUDATOR_CERR_ PTOCOMA_ {
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
instruccionExpresion: expresion PTOCOMA_
{ $$.tipo = $1.tipo;
  $$.pos = $1.pos;  }
        | PTOCOMA_
        ;


instruccionEntradaSalida: READ_ PARENTESIS_AB_ ID_ PARENTESIS_CERR_ PTOCOMA_
                            {    SIMB s = obtenerTDS($3);
                                if(s.tipo!=T_ENTERO)
                                  yyerror("El argumento de read debe ser Entero");
                                else
                                  emite(EREAD, crArgNul(), crArgNul(), crArgPos(s.desp));
                            }

        | PRINT_ PARENTESIS_AB_ expresion PARENTESIS_CERR_ PTOCOMA_
            {
                if($3.tipo != T_ENTERO) yyerror("La expresion del 'print' debe ser 'entera'");
                emite(EWRITE, crArgNul(), crArgNul(), crArgPos($3.pos));
            }
        ;

instruccionSeleccion: IF_ PARENTESIS_AB_ expresion PARENTESIS_CERR_
                        {
                          if($3.tipo == T_ERROR || $3.tipo != T_LOGICO) yyerror("La expresion de IF debe de ser de tipo logico");
                          $<cent>$ = creaLans(si);
                          emite(EIGUAL, crArgPos($3.pos), crArgEnt(0), crArgNul());
                        }
                        instruccion
                        {
                          $<cent>$ = creaLans(si);
                          emite(GOTOS, crArgNul(), crArgNul(), crArgNul());
                          completaLans($<cent>5, crArgEtq(si));
                        }
                        ELSE_ instruccion
                        {
                            completaLans($<cent>7, crArgEtq(si));

                        }
        ;
instruccionIteracion: WHILE_{
                      $<cent>$ = si;
                      }
                    PARENTESIS_AB_ expresion PARENTESIS_CERR_
                    { if($4.tipo != T_LOGICO) yyerror("La expresion de While debe de ser Logica");
                      else{
                        //$$.tipo = $4.tipo;
                        $<cent>$ = creaLans(si);
                        emite(EIGUAL, crArgPos($4.pos), crArgEnt(0), crArgNul());
                      }
                    }
                    instruccion
                    {
                    emite(GOTOS, crArgNul(), crArgNul(), crArgEtq($<cent>2));
                    completaLans($<cent>6, crArgEtq(si));
                  }
        ;

expresion: expresionLogica
          {$$.tipo = $1.tipo;
           $$.pos = $1.pos;

            }
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
                          $$.tipo = sim.tipo;
                          $$.pos = creaVarTemp();
                          if($2 == OPASIGN){
                            emite(EASIG, crArgPos($3.pos), crArgNul(), crArgPos($$.pos));
                          }else{
                                if($2 == OPASIGNS){
                                  emite(ESUM, crArgPos($3.pos), crArgPos(sim.desp), crArgPos($$.pos));
                                }else{
                                  emite(EDIF, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                                }

                            }
                            emite(EASIG, crArgPos($$.pos), crArgNul(), crArgPos(sim.desp));
                          }
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
                  else{
                      $$.tipo = sim.telem;
                      $$.pos = creaVarTemp();
                      if($5 == OPASIGN){
                        emite(EASIG, crArgPos($6.pos), crArgNul(), crArgPos($$.pos));
                      }else{
                        if($5 == OPASIGNS){
                          emite(EAV, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                          emite(ESUM, crArgPos($$.pos), crArgPos($6.pos), crArgPos($$.pos));
                        }else{
                          emite(EAV, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                          emite(EDIF, crArgPos($$.pos), crArgPos($6.pos), crArgPos($$.pos));
                        }

                      }
                      emite(EVA, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                  }
                }
                }
              }

            }
            }
        ;

expresionLogica: expresionIgualdad
        {$$.tipo = $1.tipo;
         $$.pos = $1.pos;
        }
        | expresionLogica operadorLogico expresionIgualdad
          {$$.tipo = T_ERROR;
           if($1.tipo == T_LOGICO && $3.tipo == T_LOGICO){
             $$.tipo = $1.tipo;
             $$.pos = creaVarTemp();
             if($2 == OPAND){
                emite(EMULT, crArgPos($1.pos), crArgPos($3.pos), crArgPos($$.pos));
             }else{
                emite(ESUM, crArgPos($1.pos), crArgPos($3.pos), crArgPos($$.pos));
                emite(EMENEQ, crArgPos($$.pos), crArgEnt(1), crArgEtq(si+2));
                emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
             }

           }else{ yyerror("Error en el operador Logico");}
         }
        ;

expresionIgualdad: expresionRelacional
        {
          $$.tipo = $1.tipo;
          $$.pos = $1.pos;
        }
	| expresionIgualdad operadorIgualdad expresionRelacional
      {
        $$.tipo = T_ERROR;
        if((($1.tipo == T_ENTERO) || ($1.tipo == T_LOGICO)) &&
            (($3.tipo == T_ENTERO) || ($3.tipo == T_LOGICO)) &&
              ($1.tipo == $3.tipo)) {
                $$.tipo = T_LOGICO;
                $$.pos = creaVarTemp();
                emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
                emite($2, crArgPos($1.pos), crArgPos($3.pos), crArgEtq(si+2));
                emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
        }else{
          if($1.tipo == T_ERROR || $3.tipo == T_ERROR){
            noop;
          }else{
            yyerror("No se pueden comparar objetos de distinto tipo");
          }
        }
      }
        ;

expresionRelacional: expresionAditiva
              {
                $$.tipo = $1.tipo;
                $$.pos = $1.pos;
              }
        | expresionRelacional operadorRelacional expresionAditiva
        {

          if($1.tipo != T_ENTERO || $3.tipo != T_ENTERO){
            yyerror("No se pueden comparar objetos de tipos diferentes");
            $$.tipo = T_ERROR;
          }
          else{
            $$.tipo = T_LOGICO;
            $$.pos = creaVarTemp();
            emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
            emite($2, crArgPos($1.pos),crArgPos($3.pos), crArgEtq(si+2));
            emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
          }
        }
        ;

expresionAditiva: expresionMultiplicativa
            {
              $$.tipo = $1.tipo;
              $$.pos = $1.pos;
            }
        | expresionAditiva operadorAditivo expresionMultiplicativa
			{
				if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO){
          $$.tipo = T_ENTERO;
          $$.pos = creaVarTemp();
          emite($2, crArgPos($1.pos), crArgPos($3.pos), crArgPos($$.pos));
        }
				else {yyerror ("Tipos no validos");
              $$.tipo = T_ERROR;
      }
			}
        ;

expresionMultiplicativa: expresionUnaria
						{
                $$.tipo = $1.tipo;
                $$.pos = $1.pos;
            }
        | expresionMultiplicativa operadorMultiplicativo expresionUnaria
  			     {
               if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO){
  					          $$.tipo = T_ENTERO;
                      $$.pos = creaVarTemp();
                      emite($2, crArgPos($1.pos), crArgPos($3.pos), crArgPos($$.pos));
                    }
  			      else{
                yyerror ("Error en expresion multiplicativa");
                $$.tipo = T_ERROR;
  				    }
  			  }
        ;

expresionUnaria: expresionSufija
				{
            $$.tipo = $1.tipo;
            $$.pos = $1.pos;
          }
        | operadorUnario expresionUnaria
          {
            $$.tipo = T_ERROR;
            if($2.tipo != T_LOGICO && $2.tipo != T_ENTERO){
              yyerror("Error en expresionUnaria");
            }else{
              if($1 == OPNOT){
                if($2.tipo == T_LOGICO){
                  $$.tipo = T_LOGICO;
                  $$.pos = creaVarTemp();
                  emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
                  emite(EDIST, crArgPos($2.pos), crArgEnt(0), crArgEtq(si+2));
                  emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
                }else{
                  if($2.tipo == T_ERROR)
                    noop;
                  else
                    yyerror("La variable debe de ser logica");
                }
              }else{
                if($2.tipo == T_ENTERO){
                  $$.tipo = T_ENTERO;
                  $$.pos = creaVarTemp();
                  if($1 == OPPOS){
                    emite(EASIG, crArgPos($2.pos), crArgNul(), crArgPos($$.pos));
                  }else{
                    emite($1, crArgPos($2.pos), crArgNul(), crArgPos($$.pos));
                  }
                }
              }
            }

        }

        | operadorIncremento ID_{
			      SIMB id = obtenerTDS($2);
			      $$.tipo = T_ERROR;
            if(id.tipo == T_ERROR){
              yyerror("Variable no declarado");
            }else{
              if(id.tipo != T_ENTERO){
                yyerror("La variable debe de ser entera");
              }else{
                $$.tipo = T_ENTERO;
                $$.pos = creaVarTemp();
                emite(ESUM, crArgPos(id.desp), crArgEnt($1), crArgPos(id.desp));
                emite(EASIG, crArgPos(id.desp), crArgNul(), crArgPos($$.pos));
              }
            }
		      }
        ;

expresionSufija: ID_ CLAUDATOR_AB_ expresion CLAUDATOR_CERR_
        {
          $$.tipo = T_ERROR;
          SIMB sim = obtenerTDS($1);
          if(sim.tipo == T_ERROR){
            yyerror("Identificadro no declarado");
          }
          else{
            if($3.tipo != T_ENTERO){
              yyerror("El índice debe de ser entero");
            }else{
              $$.tipo = sim.telem;
              $$.pos = creaVarTemp();
              emite(EAV, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
            }
          }
        }
        | PARENTESIS_AB_ expresion PARENTESIS_CERR_
        {
          printf("Valor pos expresion: %d linea: %d si: %d \n", $2.pos, yylineno, si);
          $$.tipo = $2.tipo;
          $$.pos = $2.pos;
        }
        | ID_
            {
              SIMB id = obtenerTDS($1);
             if( id.tipo != T_ERROR){
                  $$.tipo = id.tipo;
                  $$.pos = id.desp;
                  }else{
                    $$.tipo = T_ERROR;
                  }
            }
        | ID_ operadorIncremento {
          SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
          if(sim.tipo == T_ERROR){ yyerror("Variable no declarada");
          }else{
          if(sim.tipo != T_ENTERO){
            yyerror("Error en el tipo de la variable");
          }else{
            $$.tipo = sim.tipo;
            $$.pos = creaVarTemp();
            emite(EASIG, crArgPos(sim.desp), crArgNul(), crArgPos($$.pos));
            emite(ESUM, crArgPos(sim.desp), crArgEnt($2), crArgPos(sim.desp));
            }
          }
        }
        | CTE_ {$$.tipo = T_ENTERO;
                $$.pos = creaVarTemp();
                printf("Hola soy una constante %d, %d, %d \n", $$.pos, si, yylineno );
                emite(EASIG, crArgEnt($1), crArgNul(), crArgPos($$.pos));
        }
        | TRUE_ {$$.tipo = T_LOGICO;
                 $$.pos = creaVarTemp();
                 emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
              }
        | FALSE_ {
            $$.tipo = T_LOGICO;
            $$.pos = creaVarTemp();
            emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
          }
        ;

operadorAsignacion: ASIGNACION_ {$$ = OPASIGN;}
        | MASIGUAL_ {$$ = OPASIGNS;}
        | MENOSIGUAL_{$$ = OPASIGND;}
        ;

operadorLogico: COMPARADOR_AND_ {$$ = OPAND;}
        | COMPARADOR_OR_ {$$ = OPOR;}
        ;

operadorIgualdad: IGUALDAD_ {$$ = EIGUAL;}
        | DESIGUAL_ {$$ = EDIST;}
        ;

operadorRelacional: MAYOR_QUE_ {$$ = EMAY;}
        | MENOR_QUE_ {$$ = EMEN;}
        | MAYOR_IGUAL_ {$$ = EMAYEQ;}
        | MENOR_IGUAL_ {$$ = EMENEQ;}
        ;

operadorAditivo: SUMA_ {$$ = ESUM;}
        | RESTA_ {$$ = EDIF;}
        ;

operadorMultiplicativo: MULT_ {$$ = EMULT;}
        | DIV_ {$$ = EDIVI;}
        ;

operadorUnario: SUMA_ {$$ = OPPOS;}
        | RESTA_ {$$ = ESIG;}
        | NEGACION_ {$$ = OPNOT;}
        ;

operadorIncremento: INCREMENTO_ {$$ = 1;}
        | DECREMENTO_ {$$ = -1; }
        ;

%%
