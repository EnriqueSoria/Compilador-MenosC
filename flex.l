%{
    #include <stdio.h>
}%

%option yylineno

digito [0-9]
letra  [A-Za-z]

/* Tipos de variable */
integer {digito}+
boolean "true"|"false"
variable integer|boolean
id {letra}({letra}|{digito})*

%%
    /* Control */
    "while" {ECHO; return(WHILE_);}    
    "if"    {ECHO; return(IF_);}
    
    /* Tipos basicos */
    "int"   {ECHO; return(INT_);}
    "bool"  {ECHO; return(BOOL_);}
    
    /* Entrada/Salida */
    "read"    {ECHO; return(READ_);}
    "print" {ECHO; return(PRINT_);}
    
    /* Constantes */
    "true"    {ECHO; return(TRUE_);}
    "false"   {ECHO; return(FALSE_);}
    
    /* Operadores aritmeticos*/
    "+"    {ECHO; return(SUMA_);}
    "-"    {ECHO; return(RESTA_);}
    "*"    {ECHO; return(MULT_);}
    "/"    {ECHO; return(DIV_);}
    
    "="    {ECHO; return(ASIGNACION_);}
    "+="   {ECHO; return(MASIGUAL_);}
    "-="   {ECHO; return(MENOSIGUAL_);} 
    
    
    /* Operadores logicos */
    "=="    {ECHO; return(IGUALDAD_);}
    "&&"    {ECHO; return(COMPARADOR_AND_);}
    "||"    {ECHO; return(COMPARADOR_OR_);}
    "<="    {ECHO; return(MENOR_IGUAL_);}
    ">="    {ECHO; return(MAYOR_IGUAL_);}
    "<"     {ECHO; return(MENOR_QUE_);}
    ">"     {ECHO; return(MAYOR_QUE_);}
    
    numeroentero {printf("He trobat un numero");}
    
    /* Operadores unarios */
    "+"({id}|{integer})
    
    /* Comentarios de una linea */
    "//"(.*)"\n" {printf("");}
    
    
%% 


