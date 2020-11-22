%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "tokens.h"

    void TOKEN_PRINT(int token_id);
%}

/* ===== OPTIONS ===== */

/* Read only 1 File */
%option noyywrap
/* Case insensitive tokens (e.x ClaSS == class) */
%option case-insensitive
/* Finds the line that we are currently */
%option yylineno

/* Sub-Lectical Analyzer */
%x STRING
%x COMMENT

DIGIT               [0-9]
LETTER              [a-zA-Z]
ALPHARITHM          {LETTER}|{DIGIT}
ALPHARITHM_         [a-zA-Z0-9_]

NUMBER              [1-9][0-9]*|0
HEXA                0Η[A-F1-9][A-F0-9]*
BINARY              0B1[0-1]*

DEC_EX              [1-9][0-9]*(E-?[1-9][0-9]*)+|([1-9][0-9]*|0)\.(0*[1-9][0-9]*|0)
BINARY_EX           0B(0*[1][0-1]*)?\.(0*[1][0-1]*|0)
HEXA_EX             0H(0*[1-9A-F][0-9A-F]*)?*\.(0*[1-9A-F][0-9A-F]*|0)

IDENTIFIER_REG      _?{LETTER}{ALPHARITHM_}*{ALPHARITHM}
ICONST_REG          {BINARY}|{HEXA}|{NUMBER}
RCONST_REG          {DEC_EX}|{BINARY_EX}|{HEXA_EX}
CCONST_REG          '([\x20-\x7E]|\\[nftrbv])'

%%

"PROGRAM"                                       { TOKEN_PRINT(T_PROGRAM); return T_PROGRAM; }
"BEGIN"                                         { TOKEN_PRINT(T_BEGIN); return T_BEGIN; }
"END"                                           { TOKEN_PRINT(T_END); return T_END; }
"PROCEDURE"                                     { TOKEN_PRINT(T_PROCEDURE); return T_PROCEDURE; }
"FUNCTION"                                      { TOKEN_PRINT(T_FUNCTION); return T_FUNCTION; }
"FORWARD"                                       { TOKEN_PRINT(T_FORWARD); return T_FORWARD; }

"CONST"                                         { TOKEN_PRINT(T_CONST); return T_CONST; }
"TYPE"                                          { TOKEN_PRINT(T_TYPE); return T_TYPE; }
"ARRAY"                                         { TOKEN_PRINT(T_ARRAY); return T_ARRAY; }
"VAR"                                           { TOKEN_PRINT(T_VAR); return T_VAR; }
"INTEGER"                                       { TOKEN_PRINT(T_INTEGER); return T_INTEGER; }
"REAL"                                          { TOKEN_PRINT(T_REAL); return T_REAL; }
"BOOLEAN"                                       { TOKEN_PRINT(T_BOOLEAN); return T_BOOLEAN; }
"RECORD"                                        { TOKEN_PRINT(T_RECORD); return T_RECORD; }
"CHAR"                                          { TOKEN_PRINT(T_CHAR); return T_CHAR; }
"SET"                                           { TOKEN_PRINT(T_SET); return T_SET; }

"IF"                                            { TOKEN_PRINT(T_IF); return T_IF; }
"WHILE"                                         { TOKEN_PRINT(T_WHILE); return T_WHILE; }
"DO"                                            { TOKEN_PRINT(T_DO); return T_DO; }
"FOR"                                           { TOKEN_PRINT(T_FOR); return T_FOR; }
"ELSE"                                          { TOKEN_PRINT(T_ELSE); return T_ELSE; }
"THEN"                                          { TOKEN_PRINT(T_THEN); return T_THEN; }
"DOWNTO"                                        { TOKEN_PRINT(T_DOWNTO); return T_DOWNTO; }
"TO"                                            { TOKEN_PRINT(T_TO); return T_TO; }
"OF"                                            { TOKEN_PRINT(T_OF); return T_OF; }

"WITH"                                          { TOKEN_PRINT(T_WITH); return T_WITH; }
"READ"                                          { TOKEN_PRINT(T_READ); return T_READ; }
"WRITE"                                         { TOKEN_PRINT(T_WRITE); return T_WRITE; }

"TRUE" | "FALSE"                                { TOKEN_PRINT(T_ΒCONST); return T_ΒCONST; }

"{"                                             { BEGIN(COMMENT); }
<COMMENT>"}"                                    { BEGIN(INITIAL);  return T_COMMENT; }
<COMMENT>.                                      { printf("Found comment: %s\n", yytext); }                                    
<COMMENT><<EOF>>                                { printf("Found comment without closing it. \n"); return T_EOF; }

\"                                              { BEGIN(STRING); }
<STRING>\"                                      { BEGIN(INITIAL); return T_SCONST; }
<STRING>(\\\n|\\\r\n)                           { }
<STRING>(\\.|[^"\\])                            { printf("Found word: %s\n", yytext); }
<STRING>(\n|\r\n)                               { printf("Found newline without \\ \n"); }
<STRING><<EOF>>                                 { printf("End of string without closing it \n"); return T_EOF; }
<STRING>.                                       { printf("Unknown Character. \n"); }

">" | "<" |  ">=" | "<=" | "<>"                 { TOKEN_PRINT(T_RELOP); return T_RELOP; }
"+" | "-"                                       { TOKEN_PRINT(T_ADDOP); return T_ADDOP; }
"OR"                                            { TOKEN_PRINT(T_OROP); return T_OROP; }

"*" | "/" | "DIV" | "MOD" | "AND"               { TOKEN_PRINT(T_MULDIVANDOP); return T_MULDIVANDOP; }
"NOT"                                           { TOKEN_PRINT(T_NOTOP); return T_NOTOP; }
"IN"                                            { TOKEN_PRINT(T_INOP); return T_INOP; }

"("                                             { TOKEN_PRINT(T_LPAREN); return T_LPAREN; }
")"                                             { TOKEN_PRINT(T_RPAREN); return T_RPAREN; }
";"                                             { TOKEN_PRINT(T_SEMI); return T_SEMI; }
"."                                             { TOKEN_PRINT(T_DOT); return T_DOT; }
","                                             { TOKEN_PRINT(T_COMMA); return T_COMMA; }
"="                                             { TOKEN_PRINT(T_EQU); return T_EQU; }                               
":"                                             { TOKEN_PRINT(T_COLON); return T_COLON; }
"["                                             { TOKEN_PRINT(T_LBRACK); return T_LBRACK; }
"]"                                             { TOKEN_PRINT(T_RBRACK); return T_RBRACK; }
":="                                            { TOKEN_PRINT(T_ASSIGN); return T_ASSIGN; }
".."                                            { TOKEN_PRINT(T_DOTDOT); return T_DOTDOT; }

{IDENTIFIER_REG}                                { TOKEN_PRINT(T_IDENTIFIER); return T_IDENTIFIER; }
{ICONST_REG}                                    { TOKEN_PRINT(T_ICONST); return T_ICONST; }
{RCONST_REG}                                    { TOKEN_PRINT(T_RCONST); return T_RCONST; }
{CCONST_REG}                                    { TOKEN_PRINT(T_CCONST); return T_CCONST; }

"\n"|"\r\n"|"\t"                                { printf("[LINE %d] TOKEN SPECIAL\n", yylineno); } 

<<EOF>>                                         { printf("[LINE %d] TOKEN \"T_EOF\" TOKEN_ID (%d)\n", yylineno, T_EOF); return T_EOF; }

.                                               { printf("This character can not be recognised at line, %d\n", yylineno); }

%%

int main(int argc, char *argv[]){
    int token;
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("Error opening file"); 
            return -1;
        }
    }
    
    do{
		token = yylex();
    }while(token != T_EOF);
    
    /* if(error_count > 0){
         printf("Failed to analyze the program due to %d errors\n", error_count);
     }else{
         printf("Program analyzed successfully\n");
     } */
    
    fclose(yyin);
    yyterminate();
}

void TOKEN_PRINT(int token_id){
    printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

