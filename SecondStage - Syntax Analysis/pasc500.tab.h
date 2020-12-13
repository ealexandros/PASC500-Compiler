/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PASC500_TAB_H_INCLUDED
# define YY_YY_PASC500_TAB_H_INCLUDED
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
    T_EOF = 0,
    T_PROGRAM = 258,
    T_BEGIN = 259,
    T_END = 260,
    T_PROCEDURE = 261,
    T_FUNCTION = 262,
    T_FORWARD = 263,
    T_CONST = 264,
    T_TYPE = 265,
    T_ARRAY = 266,
    T_VAR = 267,
    T_INTEGER = 268,
    T_REAL = 269,
    T_BOOLEAN = 270,
    T_RECORD = 271,
    T_CHAR = 272,
    T_SET = 273,
    T_IF = 274,
    T_WHILE = 275,
    T_DO = 276,
    T_FOR = 277,
    T_ELSE = 278,
    T_THEN = 279,
    T_DOWNTO = 280,
    T_TO = 281,
    T_OF = 282,
    T_WITH = 283,
    T_READ = 284,
    T_WRITE = 285,
    T_RELOP = 286,
    T_ADDOP = 287,
    T_OROP = 288,
    T_MULDIVANDOP = 289,
    T_NOTOP = 290,
    T_INOP = 291,
    T_LPAREN = 292,
    T_RPAREN = 293,
    T_DOT = 294,
    T_COMMA = 295,
    T_EQU = 296,
    T_COLON = 297,
    T_LBRACK = 298,
    T_RBRACK = 299,
    T_ASSIGN = 300,
    T_DOTDOT = 301,
    T_SEMI = 302,
    T_ID = 303,
    T_ICONST = 304,
    T_RCONST = 305,
    T_BCONST = 306,
    T_CCONST = 307,
    T_SCONST = 308,
    T_COMMENT = 309
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 12 "pasc500.y"

  int intval;
  float floatval;
  char charval;
  char *strval;

#line 120 "pasc500.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PASC500_TAB_H_INCLUDED  */
