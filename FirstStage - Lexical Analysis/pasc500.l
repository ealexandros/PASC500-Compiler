/*
    Authors:
      Ioannis Kontopoulos         2118172
      Vasilis Georgoulas          2118147
      Alexandros Eleftheriadis    2118200
*/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    #include "tokens.h"

    /* Function Declaration */
    void TOKEN_PRINT(int token_id);
    void NUMBER_PRINT(int token_id);
    void FLOAT_PRINT(int token_id);
    void ERROR_PRINT(const char *);

    int BinToInt(char *);
    int HexToInt(char *);
    float BinToFloat(char* str);
    float HexToFloat(char* str);

    /* Variables */
    char str_buff[256];

    int error_counter = 0;
    const int MAX_ERRORS = 1;
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
HEXA                0H[A-F1-9][A-F0-9]*
BINARY              0B1[0-1]*

DEC_EX              [1-9][0-9]*(E-?[1-9][0-9]*)+|([1-9][0-9]*|0)\.(0*[1-9][0-9]*|0)
BINARY_EX           0B(0*[1][0-1]*)?\.(0*[1][0-1]*|0)
HEXA_EX             0H(0*[1-9A-F][0-9A-F]*)?\.(0*[1-9A-F][0-9A-F]*|0)

IDENTIFIER_REG      _?{LETTER}({ALPHARITHM_}*{ALPHARITHM})?
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
<COMMENT>"}"                                    { BEGIN(INITIAL);  printf("[LINE %d] COMMENT FOUND\n", yylineno); return T_COMMENT; }
<COMMENT>(\n|\r\n)                              { }
<COMMENT><<EOF>>                                { ERROR_PRINT("Found comment without closing it. \n"); return T_EOF; }
<COMMENT>.                                      { }                                    

\"                                              { strcpy(str_buff, ""); BEGIN(STRING); }
<STRING>\"                                      { BEGIN(INITIAL); printf("[LINE %d] STRING: %s\n", yylineno, str_buff); return T_SCONST; }
<STRING>(\\\n|\\\r\n)                           { }
<STRING>(\\.|[^"\\])                            {
                                                    if(strlen(yytext) == 2){
                                                        if(strcmp(yytext, "\\n") == 0){
                                                            strcat(str_buff, "\n");
                                                        }else if(strcmp(yytext, "\\t") == 0){
                                                            strcat(str_buff, "\t");
                                                        }else if(strcmp(yytext, "\\f") == 0){
                                                            strcat(str_buff, "\f");
                                                        }else if(strcmp(yytext, "\\r") == 0){
                                                            strcat(str_buff, "\r");
                                                        }else if(strcmp(yytext, "\\v") == 0){
                                                            strcat(str_buff, "\v");
                                                        }else if(strcmp(yytext, "\\b") == 0){
                                                            strcat(str_buff, "\b");
                                                        }else if(strcmp(yytext, "\\\\") == 0){
                                                            strcat(str_buff, "\\");
                                                        }else{
                                                            strcat(str_buff, &yytext[1]);
                                                        }
                                                    }else{
                                                        strcat(str_buff, yytext);
                                                    }
                                                }
<STRING>(\n|\r\n)                               { ERROR_PRINT("Found newline without \\ \n"); }
<STRING><<EOF>>                                 { ERROR_PRINT("End of string without closing it. \n"); return T_EOF; }
<STRING>.                                       { ERROR_PRINT("Unknown Character. \n"); }

">="|"<="|"<>"|">"|"<"                          { TOKEN_PRINT(T_RELOP); return T_RELOP; }
"+"|"-"                                         { TOKEN_PRINT(T_ADDOP); return T_ADDOP; }
"OR"                                            { TOKEN_PRINT(T_OROP); return T_OROP; }

"*"|"/"|"DIV"|"MOD"|"AND"                       { TOKEN_PRINT(T_MULDIVANDOP); return T_MULDIVANDOP; }
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

{IDENTIFIER_REG}                                { TOKEN_PRINT(T_ID); return T_ID; }

{ICONST_REG}                                    { NUMBER_PRINT(T_ICONST); return T_ICONST; }
{RCONST_REG}                                    { FLOAT_PRINT(T_RCONST); return T_RCONST; }
{CCONST_REG}                                    { TOKEN_PRINT(T_CCONST); return T_CCONST; }

"\n"|"\r\n"|"\t"                                { printf("[LINE %d] TOKEN SPECIAL\n", yylineno); } 
" "                                             { } 

<<EOF>>                                         { printf("[LINE %d] TOKEN \"T_EOF\" TOKEN_ID (%d)\n", yylineno, T_EOF); return T_EOF; }

.                                               { ERROR_PRINT("This character can not be recognised."); }

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
    
    fclose(yyin);
    yyterminate();
}

void TOKEN_PRINT(int token_id){
    printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void NUMBER_PRINT(int token_id) {
    int decimal_number, base=10;
    if(strncmp(yytext, "0B", 2) == 0){ decimal_number = BinToInt(yytext); base=2; }
    else if(strncmp(yytext, "0H", 2) == 0){ decimal_number = HexToInt(yytext); base=16; }
    else decimal_number = atoi(yytext);

    if(base != 10) printf("[LINE %d] TOKEN \"%s\"(BASE %d)->\"%d\"(BASE 10) TOKEN_ID (%d)\n", yylineno, yytext, base, decimal_number, token_id);
    else printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void FLOAT_PRINT(int token_id){
    float decimal_number;
    int base=10;
    if(strncmp(yytext, "0B", 2) == 0){ decimal_number = BinToFloat(yytext); base=2; }
    else if(strncmp(yytext, "0H", 2) == 0){ decimal_number = HexToFloat(yytext); base=16; }
    else decimal_number = atoi(yytext);

    if(base != 10) printf("[LINE %d] TOKEN \"%s\"(BASE %d)->\"%f\"(BASE 10) TOKEN_ID (%d)\n", yylineno, yytext, base, decimal_number, token_id);
    else printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void ERROR_PRINT(const char *err) {
    error_counter++;
    printf("[ERROR] LINE %d [ERROR MESSAGE] %s\n", yylineno, err);

    if(error_counter == MAX_ERRORS) {
        printf("TOO MANY ERRORS FOUND.\n");
        exit(0);
    }

    yyless(1);
}

int HexToInt(char *str){
    return (int) strtol(&str[2], NULL, 16);
}

int BinToInt(char *str){
    return (int) strtol(&str[2], NULL, 2);
}

float BinToFloat(char* str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,2);
    for(i=1;i<length_real;i++){
        number += (character[i] - '0') * (1/pow(2,i));
    }
    return number;
}

float HexToFloat(char*str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,16);
    for(i=1;i<=length_real;i++){
        if(character[i] <= '9')
			number += (character[i] - '0') * (1/pow(16,i));
		else
			number += (character[i] + 10 - 'A') * (1/pow(16,i));
	}
    return number;
}

