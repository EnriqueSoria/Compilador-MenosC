/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_ASIN_H_INCLUDED
# define YY_YY_ASIN_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYERROR_VERBOSE_ = 258,
    ID_ = 259,
    FLOAT_ = 260,
    WHILE_ = 261,
    IF_ = 262,
    INT_ = 263,
    BOOL_ = 264,
    READ_ = 265,
    PRINT_ = 266,
    TRUE_ = 267,
    FALSE_ = 268,
    SUMA_ = 269,
    RESTA_ = 270,
    MULT_ = 271,
    ELSE_ = 272,
    DIV_ = 273,
    ASIGNACION_ = 274,
    MASIGUAL_ = 275,
    MENOSIGUAL_ = 276,
    IGUALDAD_ = 277,
    DESIGUAL_ = 278,
    COMPARADOR_AND_ = 279,
    COMPARADOR_OR_ = 280,
    MENOR_IGUAL_ = 281,
    MAYOR_IGUAL_ = 282,
    MENOR_QUE_ = 283,
    MAYOR_QUE_ = 284,
    PARENTESIS_AB_ = 285,
    PARENTESIS_CERR_ = 286,
    CORCHETE_AB_ = 287,
    CORCHETE_CERR_ = 288,
    CLAUDATOR_AB_ = 289,
    CLAUDATOR_CERR_ = 290,
    PTOCOMA_ = 291,
    CTE_ = 292,
    NEGACION_ = 293,
    INCREMENTO_ = 294,
    DECREMENTO_ = 295
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 9 "./src/asin.y" /* yacc.c:1909  */

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

#line 108 "asin.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ASIN_H_INCLUDED  */
