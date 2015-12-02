/*****************************************************************************/
/**  Definiciones de las constantes y estructuras auxiliares usadas en      **/
/**  la librería <<libtds>>, asi como el perfil de las funciones de         **/
/**  manipulación de la  TDS.                                               **/
/**                     Jose Miguel Benedi, 2015-2016 <jbenedi@dsic.upv.es> **/
/*****************************************************************************/
/*****************************************************************************/
#ifndef _LIBTDS_H
#define _LIBTDS_H

/************************* Constantes para los tipos en la Tabla de Simbolos */
#define T_VACIO       0
#define T_ENTERO      1
#define T_LOGICO      2
#define T_ARRAY       3
#define T_ERROR       4
/*************************** Variables globales de uso en todo el compilador */
int dvar;                     /* Desplazamiento en el Segmento de Variables  */

typedef struct simb /******************************** Estructura para la TDS */
{
  int   tipo;            /* Tipo del objeto                                  */
  int   desp;            /* Desplazamiento relativo en el segmento variables */
  int   telem;           /* Tipo elementos si array o tvavio si tipo simple  */
  int   nelem;           /* Numero elementos si array o 0 si tipo simple     */
} SIMB;

/************************************* Operaciones para la gestion de la TDS */
int insertarTSimpleTDS(char *nom, int tipo, int desp) ;
/* Inserta en la TDS toda la informacion asociada con un simbolo de tipo 
   simple: nombre, "nom"; tipo, "tipo" y desplazamiento relativo en el 
   segmento de variables, "desp". Si el identificador ya existe devuelve 
   el valor "FALSE=0" ("TRUE=1" en caso contrario).                          */

int insertarTVectorTDS(char *nom, int tipo, int desp, int telem, int nelem) ;
/* Inserta en la TDS toda la informacion asociada con un simbolo de tipo 
   vector: nombre, "nom"; tipo, "tipo"; desplazamiento relativo en el 
   segmento de variables, "desp"; tipo de los elementos, "telem" y numero de 
   elemnetos, "nelem". Si el identificador ya existe devuelve el valor 
   "FALSE=0" ("TRUE=1" en caso contrario).                                   */

SIMB obtenerTDS (char *nom) ;
/* Obtiene toda la informacion asociada con un objeto de nombre "nom" y la
   devuelve en una estructura de tipo "SIMB". Si el objeto no está declarado, 
   devuelve "T_ERROR" en el campo "tipo".                                    */

void mostrarTDS () ;
/* Muestra toda la informacion de la TDS.                                    */

#endif  /* _LIBTDS_H */
/*****************************************************************************/
