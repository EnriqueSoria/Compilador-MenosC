/*****************************************************************************/
/**   Ejemplo de un posible fichero de cabeceras ("header.h") donde situar  **/
/** las definiciones de constantes, variables y estructuras para MenosC.16  **/
/** Los alumos deberan adaptarlo al desarrollo de su propio compilador.     **/
/*****************************************************************************/
#ifndef _HEADER_H
#define _HEADER_H
/****************************************************** Constantes generales */
#define TRUE  1
#define FALSE 0
#define TALLA_TIPO_SIMPLE     1
#define MAX_LENGTH 14
/************************************* Variables externas definidas en el AL */
extern FILE *yyin;
extern int   yylineno;
extern int   yydebug;
extern char *yytext;
//extern int   yyleng;
//extern int   yylval;
/********************* Variables externas definidas en el Programa Principal */
extern int verbosidad;              /* Flag para saber si se desea una traza */
extern int numErrores;              /* Contador del numero de errores        */
//extern int verTDS;                 /* Flag para saber si mostrar la TDS     */
int verTDS;
/***************************** Variables externas definidas en las librerias */
extern int dvar;              /* Desplazamiento en el Segmento de Variables  */

/********************************************************************************/
 /* Comprueba que el identificador no exceda la talla maxima (14) o lo trunca    */
void creaNombre();
/********************************************************************************/
/* Transforma una subcadena a la constante entera que representa                */
void creaCentera();
/********************************************************************************/
/* Transforma una subcadena a una constante entera truncandola.                 */
void truncCreal();
/********************************************************************************/

#endif  /* _HEADER_H */
/*****************************************************************************/
