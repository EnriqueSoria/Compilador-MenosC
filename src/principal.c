/*****************************************************************************/
/*  Ejemplo de un posible programa principal y tratamiento de errores        */
/*  para MenosC.16.      Jose Miguel Benedi, 2015-2016 <jbenedi@dsic.upv.es> */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "header.h"

int verbosidad=FALSE;               /* Flag para saber si se desea una traza */
int numErrores=0;                   /* Contador del numero de errores        */
/*****************************************************************************/
void yyerror(const char * msg)
/*  Tratamiento de errores.                                                  */
{
        numErrores++;
        fprintf(stdout, "Error at line %d: %s\n", yylineno, msg);
}
/*****************************************************************************/
int main (int argc, char **argv)
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{
        int i, n = 0;
        verTDS = 0;
        for (i=0; i<argc; ++i) {
                if (strcmp(argv[i], "-v")== 0) { verbosidad = TRUE; n++; }
                if (strcmp(argv[i], "-t") == 0) {verTDS = 1; n++; }
        }
        --argc; n++;
        if (argc == n) {
                if ((yyin = fopen (argv[argc], "r")) == NULL)
                        fprintf (stderr, "Fichero no valido %s\n", argv[argc]);
                else {
                        if (verbosidad == TRUE) fprintf(stdout,"%3d.- ", yylineno);
                        yyparse ();
                        if (numErrores > 0)
                                fprintf(stdout,"\nNumero de errores:      %d\n", numErrores);
                }
        }
        else fprintf (stderr, "Uso: cmc [-v] [-t] fichero\n");
}
/*****************************************************************************/
