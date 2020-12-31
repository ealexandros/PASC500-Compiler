%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "extra/hashtbl.h"

  extern FILE *yyin;
  extern int yylex();
  extern void yyerror(const char *err);

  HASHTBL *hashtbl;
  int scope = 0;
%}

%define parse.error verbose

%union {
  int intval;
  float floatval;
  char charval;
  char *strval;
}
  
%token <strval>   T_PROGRAM       "PROGRAM"       
%token <strval>   T_BEGIN         "BEGIN"         
%token <strval>   T_END           "END"           
%token <strval>   T_PROCEDURE     "PROCEDURE"     
%token <strval>   T_FUNCTION      "FUNCTION"      
%token <strval>   T_FORWARD       "FORWARD"       
%token <strval>   T_CONST         "CONST"         
%token <strval>   T_TYPE          "TYPE"          
%token <strval>   T_ARRAY         "ARRAY"  
%token <strval>   T_VAR           "VAR"  
%token <strval>   T_INTEGER       "INTEGER"  
%token <strval>   T_REAL          "REAL"  
%token <strval>   T_BOOLEAN       "BOOLEAN"  
%token <strval>   T_RECORD        "RECORD"  
%token <strval>   T_CHAR          "CHAR"  
%token <strval>   T_SET           "SET"  
%token <strval>   T_IF            "IF"            
%token <strval>   T_WHILE         "WHILE"  
%token <strval>   T_DO            "DO"  
%token <strval>   T_FOR           "FOR"  
%token <strval>   T_ELSE          "ELSE"  
%token <strval>   T_THEN          "THEN"  
%token <strval>   T_DOWNTO        "DOWNTO"  
%token <strval>   T_TO            "TO" 
%token <strval>   T_OF            "OF" 
%token <strval>   T_WITH          "WITH"  
%token <strval>   T_READ          "READ"  
%token <strval>   T_WRITE         "WRITE"  
%token <strval>   T_RELOP         ">= or | or <= or | or <> or | or > or | or<"
%token <strval>   T_ADDOP         "ADD"
%token <strval>   T_OROP          "OR"
%token <strval>   T_MULDIVANDOP   "* or / or DIV or MOD or AND"
%token <strval>   T_NOTOP         "NOT"
%token <strval>   T_INOP          "IN" 
%token <strval>   T_LPAREN        "("
%token <strval>   T_RPAREN        ")"
%token <strval>   T_DOT           "."
%token <strval>   T_COMMA         ","
%token <strval>   T_EQU           "="
%token <strval>   T_COLON         ":"
%token <strval>   T_LBRACK        "["
%token <strval>   T_RBRACK        "]"
%token <strval>   T_ASSIGN        ":="
%token <strval>   T_DOTDOT        ".." 
%token <strval>   T_SEMI          ";"

// Identifiers
%token <strval>   T_ID            "identifier"
%token <intval>   T_ICONST        "integer const"
%token <floatval> T_RCONST        "unsigned float const"

// Logical Operators
%token <strval>   T_BCONST        "boolean constant"

// Strings
%token <charval>  T_CCONST        "character consant"
%token <strval>   T_SCONST        "string constant"


%token <strval>   T_EOF       0   "end of file"

%type <strval> program header declarations constdefs constant_defs expression variable expressions constant parameter_list
%type <strval> setexpression elexpressions elexpression typedefs type_defs type_def dims limits limit typename
%type <strval> standard_type fields field identifiers vardefs variable_defs subprograms subprogram sub_header formal_parameters
%type <strval> pass comp_statement statements statement assignment if_statement if_tail while_statement for_statement
%type <strval> iter_space with_statement subprogram_call io_statement read_list read_item write_list write_item

// Priority
%left T_ADDOP T_OROP
%left T_MULDIVANDOP
%left T_NOTOP

%nonassoc LOWER_THAN_ELSE
%nonassoc T_ELSE
%nonassoc T_RELOP
%nonassoc T_INOP
%nonassoc T_EQU

%start program

%%

program:                          header declarations subprograms comp_statement T_DOT

header:                           T_PROGRAM T_ID T_SEMI                                           { hashtbl_insert(hashtbl, $2, NULL, scope); }
                                | error T_ID T_SEMI                                               { yyerrok; printf("test");  }
                                | T_PROGRAM error T_SEMI                                          { yyerrok; printf("test"); }
                                | T_PROGRAM T_ID error                                            { yyerrok; printf("test");  }

declarations:                     constdefs typedefs vardefs

constdefs:                        T_CONST constant_defs T_SEMI 
                                | %empty {}

constant_defs:                    constant_defs T_SEMI T_ID T_EQU expression                      { hashtbl_insert(hashtbl, $3, NULL, scope); }
                                | T_ID T_EQU expression                                           { hashtbl_insert(hashtbl, $1, NULL, scope); }

expression:                       expression T_RELOP expression
                                | expression T_EQU expression
                                | expression T_INOP expression
                                | expression T_OROP expression
                                | expression T_ADDOP expression
                                | expression T_MULDIVANDOP expression
                                | T_ADDOP expression
                                | T_NOTOP expression
                                | variable
                                | T_ID T_LPAREN expressions T_RPAREN                              { hashtbl_insert(hashtbl, $1, NULL, scope); }
                                | constant
                                | T_LPAREN expression T_RPAREN
                                | setexpression

variable:                         T_ID                                                            { hashtbl_insert(hashtbl, $1, NULL, scope); }
                                | variable T_DOT T_ID                                             { hashtbl_insert(hashtbl, $3, NULL, scope); }
                                | variable T_LBRACK expressions T_RBRACK
                                
expressions:                      expressions T_COMMA expression
                                | expression

constant:                         T_ICONST
                                | T_RCONST
                                | T_BCONST
                                | T_CCONST

setexpression:                    T_LBRACK elexpressions T_RBRACK
                                | T_LBRACK T_RBRACK

elexpressions:                    elexpressions T_COMMA elexpression
                                | elexpression

elexpression:                     expression T_DOTDOT expression
                                | expression

typedefs:                        T_TYPE type_defs T_SEMI
                                | %empty {}

type_defs:                        type_defs T_SEMI T_ID T_EQU type_def                            { hashtbl_insert(hashtbl, $3, NULL, scope); }
                                | T_ID T_EQU type_def                                             { hashtbl_insert(hashtbl, $1, NULL, scope); }

type_def:                         T_ARRAY T_LBRACK dims T_RBRACK T_OF typename
                                | T_SET T_OF typename
                                | T_RECORD fields T_END
                                | T_LPAREN identifiers T_RPAREN
                                | limit T_DOTDOT limit

dims:                             dims T_COMMA limits
                                | limits

limits:                           limit T_DOTDOT limit
                                | T_ID                                                            { hashtbl_insert(hashtbl, $1, NULL, scope); }

limit:                            T_ADDOP T_ICONST
                                | T_ADDOP T_ID                                                    { hashtbl_insert(hashtbl, $2, NULL, scope); }
                                | T_ICONST
                                | T_CCONST
                                | T_BCONST
                                | T_ID                                                            { hashtbl_insert(hashtbl, $1, NULL, scope); }

typename:                         standard_type
                                | T_ID                                                            { hashtbl_insert(hashtbl, $1, NULL, scope); }

standard_type:                    T_INTEGER
                                | T_REAL
                                | T_BOOLEAN
                                | T_CHAR

fields:                           fields T_SEMI field                                                  
                                | field 

field:                            identifiers T_COLON typename

identifiers:                      identifiers T_COMMA T_ID                                        { hashtbl_insert(hashtbl, $3, NULL, scope); }
                                | T_ID                                                            { hashtbl_insert(hashtbl, $1, NULL, scope); }

vardefs:                          T_VAR variable_defs T_SEMI
                                | %empty {}

variable_defs:                    variable_defs T_SEMI identifiers T_COLON typename
                                | identifiers T_COLON typename

subprograms:                      subprograms subprogram T_SEMI
                                | %empty {}

subprogram:                       sub_header T_SEMI T_FORWARD
                                | sub_header T_SEMI declarations subprograms comp_statement

sub_header:                       T_FUNCTION T_ID formal_parameters T_COLON standard_type         { hashtbl_insert(hashtbl, $2, NULL, scope); }
                                | T_PROCEDURE T_ID formal_parameters                              { hashtbl_insert(hashtbl, $2, NULL, scope); }
                                | T_FUNCTION T_ID                                                 { hashtbl_insert(hashtbl, $2, NULL, scope); }

formal_parameters:                T_LPAREN parameter_list T_RPAREN
                                | %empty {}

parameter_list:                   parameter_list T_SEMI pass identifiers T_COLON typename
                                | pass identifiers T_COLON typename

pass:                             T_VAR
                                | %empty {}

comp_statement:                   T_BEGIN statements T_END

statements:                       statements T_SEMI statement
                                | statement

statement:                        assignment
                                | if_statement
                                | while_statement
                                | for_statement
                                | with_statement
                                | subprogram_call
                                | io_statement
                                | comp_statement
                                | %empty {}

assignment:                       variable T_ASSIGN expression
                                | variable T_ASSIGN T_SCONST

if_statement:                     T_IF expression T_THEN statement if_tail

if_tail:                          T_ELSE statement
                                | %empty {} %prec LOWER_THAN_ELSE
                                
while_statement:                  T_WHILE expression T_DO statement

for_statement:                    T_FOR T_ID T_ASSIGN iter_space T_DO statement                          { hashtbl_insert(hashtbl, $2, NULL, scope); }

iter_space:                       expression T_TO expression
                                | expression T_DOWNTO expression

with_statement:                   T_WITH variable T_DO statement

subprogram_call:                  T_ID                                                                   { hashtbl_insert(hashtbl, $1, NULL, scope); }
                                | T_ID T_LPAREN expressions T_RPAREN                                     { hashtbl_insert(hashtbl, $1, NULL, scope); }

io_statement:                     T_READ T_LPAREN read_list T_RPAREN
                                | T_WRITE T_LPAREN write_list T_RPAREN

read_list:                        read_list T_COMMA read_item
                                | read_item

read_item:                        variable

write_list:                       write_list T_COMMA write_item
                                | write_item

write_item:                       expression
                                | T_SCONST

%%

int main(int argc, char *argv[]){
  if(!(hashtbl = hashtbl_create(10, NULL))) {
      fprintf(stderr, "ERROR: hashtbl_create() failed!\n");
      exit(EXIT_FAILURE);
  }

  if(argc > 1){
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
          perror ("[Error] opening file"); 
          return EXIT_FAILURE;
      }
  }
  
  yyparse();
  hashtbl_destroy(hashtbl);
  fclose(yyin);

  return 0;
}