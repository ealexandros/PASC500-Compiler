%{
  #include <stdio.h>
  #include <stdlib.h>

  extern FILE *yyin;
%}
%union {
  int intval;
  float floatval;
  char *strval;

}



%token <strval> T_PROGRAM     "PROGRAM"       
%token <strval> T_BEGIN       "BEGIN"         
%token <strval> T_END         "END"           
%token <strval> T_PROCEDURE   "PROCEDURE"     
%token <strval> T_FUNCTION    "FUNCTION"      
%token <strval> T_FORWARD     "FORWARD"       
%token <strval> T_CONST       "CONST"         
%token <strval> T_TYPE        "TYPE"          
%token <strval> T_ARRAY       "ARRAY"  
%token <strval> T_VAR         "VAR"  
%token <strval> T_INTEGER     "INTEGER"  
%token <strval> T_REAL        "REAL"  
%token <strval> T_BOOLEAN     "BOOLEAN"  
%token <strval> T_RECORD      "RECORD"  
%token <strval> T_CHAR        "CHAR"  
%token <strval> T_SET         "SET"  
%token <strval> T_IF          "IF"            
%token <strval> T_WHILE       "WHILE"  
%token <strval> T_DO          "DO"  
%token <strval> T_FOR         "FOR"  
%token <strval> T_ELSE        "ELSE"  
%token <strval> T_THEN        "THEN"  
%token <strval> T_DOWNTO      "DOWNTO"  
%token <strval> T_TO          "TO" 
%token <strval> T_OF          "OF" 
%token <strval> T_WITH        "WITH"  
%token <strval> T_READ        "READ"  
%token <strval> T_WRITE       "WRITE"  
%token <strval> T_RELOP       "">="|"<="|"<>"|">"|"<"   " 
%token <strval> T_ADDOP       "ADDOP"  
%token <strval> T_OROP        "OR"  
%token <strval> T_MULDIVANDOP  "*"|"/"|"DIV"|"MOD"|"AND" 
%token <strval> T_NOTOP        "NOT"
%token <strval> T_INOP         "IN" 
%token <strval> T_LPAREN        "("
%token <strval> T_RPAREN        ")"
%token <strval> T_DOT           "."
%token <strval> T_COMMA         ","
%token <strval> T_EQU           "="
%token <strval> T_COLON         ":"
%token <strval> T_LBRACK        "["
%token <strval> T_RBRACK        "]"
%token <strval> T_ASSIGN        ":="
%token <strval> T_DOTDOT        ".." 
%token <strval> T_SEMI          ";"

// Identifiers
%token T_IDENTIFIER    46
%token T_ICONST        47
%token T_RCONST        49

// Logical Operators
%token T_BCONST        48

// Strings
%token T_CCONST        50
%token T_SCONST        51

%token T_COMMENT       52


%token T_EOF           0


%%


program:                          header declarations subprograms comp_statement DOT

header:                           PROGRAM ID SEMI

declarations:                     constdefs typedefs vardefs

constdefs:                        CONST constant_defs SEMI 
                                | %emtpy

constant_defs:                    constant_defs SEMI ID EQU expression
                                | ID EQU expression

expression:                       expression RELOP expression
                                | expression EQU expression
                                | expression INOP expression
                                | expression OROP expression
                                | expression ADDOP expression
                                | expression MULDIVANDOP expression
                                | ADDOP expression
                                | NOTOP expression
                                | variable
                                | ID LPAREN expressions RPAREN
                                | constant
                                | LPAREN expression RPAREN
                                | setexpression

variable:                         ID
                                | variable DOT ID
                                | variable LBRACK expressions RBRACK
                                
expressions:                      expressions COMMA expression
                                | expression

constant:                         ICONST
                                | RCONST
                                | BCONST
                                | CCONST

setexpression:                    LBRACK elexpressions RBRACK
                                | LBRACK RBRACK

elexpressions:                    elexpressions COMMA elexpression
                                | elexpression

elexpression:                     expression DOTDOT expression
                                | expression

typedefs:                         TYPE type_defs SEMI
                                | %empty

type_defs:                        type_defs SEMI ID EQU type_def
                                | ID EQU type_def

type_def:                         ARRAY LBRACK dims RBRACK OF typename
                                | SET OF typename
                                | RECORD fields END
                                | LPAREN identifiers RPAREN
                                | limit DOTDOT limit

dims:                             dims COMMA limits
                                | limits

limits:                           limit DOTDOT limit
                                | ID

limit:                            ADDOPICONST
                                | ADDOP ID
                                | ICONST
                                | CCONST
                                | BCONST
                                | ID

typename:                         standard_type
                                | ID

standard_type:                    INTEGER
                                | REAL
                                | BOOLEAN
                                | CHAR

fields:                           fields SEMI field
                                | field

field:                            identifiers COLON typename

identifiers:                      identifiers COMMA ID
                                | ID

vardefs:                          VAR variable_defs SEMI
                                | %empty

variable_defs:                    variable_defs SEMI identifiers COLON typename
                                | identifiers COLON typename

subprograms:                      subprograms subprogram SEMI
                                | %empty

subprogram:                       sub_header SEMI FORWARD
                                | sub_header SEMI declarations subprograms comp_statement

sub_header:                       FUNCTION ID formal_parameters COLON standard_type
                                | PROCEDURE ID formal_parameters
                                | FUNCTION ID

formal_parameters:                LPAREN parameter_list RPAREN
                                | %empty

parameter_list:                   parameter_list SEMI pass identifiers COLON typename
                                | pass identifiers COLON typename

pass:                             VAR
                                | %empty

comp_statement:                   BEGIN statements END

statements:                       statements SEMI statement
                                | statement

statement:                        assignment
                                | if_statement
                                | while_statement
                                | for_statement
                                | with_statement
                                | subprogram_call
                                | io_statement
                                | comp_statement
                                | %empty

assignment:                       variable ASSIGN expression
                                | variable ASSIGN STRING

if_statement:                     IF expression THEN statement if_tail

if_tail:                          ELSE statement
                                | %empty

while_statement:                  WHILE expression DO statement

for_statement:                    FORID ASSIGN iter_space DO statement

iter_space:                       expression TO expression
                                | expression DOWNTO expression

with_statement:                   WITH variable DO statement

subprogram_call:                  ID
                                | ID LPAREN expressions RPAREN

io_statement:                     READ LPAREN read_list RPAREN
                                | WRITE LPAREN write_list RPAREN

read_list:                        read_list COMMA read_item
                                | read_item

read_item:                        variable

write_list:                       write_list COMMA write_item
                                | write_item

write_item:                       expression
                                | STRING


%%

int main(int argc, char *argv[]){
  int token;
  if(argc > 1){
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
          perror ("[Error] opening file"); 
          return EXIT_FAILURE;
      }
  }
  
  yyparse();
  fclose(yyin);

  return 0;
}