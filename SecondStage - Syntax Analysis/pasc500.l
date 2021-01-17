/*
    Team:
      Ioannis Kontopoulos         2118172
      Vasilis Georgoulas          2118147
      Alexandros Eleftheriadis    2118200
    Project Coordinator:
      Alexandros Eleftheriadis 
*/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    #include "pasc500.tab.h"

    /* Function Declaration */
    void TOKEN_PRINT(int token_id);
    void NUMBER_PRINT(int token_id);
    void FLOAT_PRINT(int token_id);
    void yyerror(const char *);

    int BinToInt(char *);
    int HexToInt(char *);
    float BinToFloat(char* str);
    float HexToFloat(char* str);

    int strToInt(char *str);
    char getCharBetweenQuotes(char *yytext);
    float strToFloat(char *str);

    /* Variables */
    char str_buff[256];

    int error_counter = 0;
    const int MAX_ERRORS = -1;

    #define FLEX_DEBUG 0
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

"PROGRAM"                                       { TOKEN_PRINT(T_PROGRAM); return T_PROGRAM; yylval.strval = strdup(yytext); }
"BEGIN"                                         { TOKEN_PRINT(T_BEGIN); return T_BEGIN; yylval.strval = strdup(yytext); }
"END"                                           { TOKEN_PRINT(T_END); return T_END; yylval.strval = strdup(yytext); }
"PROCEDURE"                                     { TOKEN_PRINT(T_PROCEDURE); return T_PROCEDURE; yylval.strval = strdup(yytext); }
"FUNCTION"                                      { TOKEN_PRINT(T_FUNCTION); return T_FUNCTION; yylval.strval = strdup(yytext); }
"FORWARD"                                       { TOKEN_PRINT(T_FORWARD); return T_FORWARD; yylval.strval = strdup(yytext); }

"CONST"                                         { TOKEN_PRINT(T_CONST); return T_CONST; yylval.strval = strdup(yytext);  }
"TYPE"                                          { TOKEN_PRINT(T_TYPE); return T_TYPE; yylval.strval = strdup(yytext);  }
"ARRAY"                                         { TOKEN_PRINT(T_ARRAY); return T_ARRAY; yylval.strval = strdup(yytext);  }
"VAR"                                           { TOKEN_PRINT(T_VAR); return T_VAR; yylval.strval = strdup(yytext);  }
"INTEGER"                                       { TOKEN_PRINT(T_INTEGER); return T_INTEGER; yylval.strval = strdup(yytext);  }
"REAL"                                          { TOKEN_PRINT(T_REAL); return T_REAL; yylval.strval = strdup(yytext);  }
"BOOLEAN"                                       { TOKEN_PRINT(T_BOOLEAN); return T_BOOLEAN; yylval.strval = strdup(yytext);  }
"RECORD"                                        { TOKEN_PRINT(T_RECORD); return T_RECORD; yylval.strval = strdup(yytext);  }
"CHAR"                                          { TOKEN_PRINT(T_CHAR); return T_CHAR; yylval.strval = strdup(yytext);  }
"SET"                                           { TOKEN_PRINT(T_SET); return T_SET; yylval.strval = strdup(yytext);  }

"IF"                                            { TOKEN_PRINT(T_IF); return T_IF; yylval.strval = strdup(yytext);  }
"WHILE"                                         { TOKEN_PRINT(T_WHILE); return T_WHILE; yylval.strval = strdup(yytext);  }
"DO"                                            { TOKEN_PRINT(T_DO); return T_DO; yylval.strval = strdup(yytext);  }
"FOR"                                           { TOKEN_PRINT(T_FOR); return T_FOR; yylval.strval = strdup(yytext);  }
"ELSE"                                          { TOKEN_PRINT(T_ELSE); return T_ELSE; yylval.strval = strdup(yytext);  }
"THEN"                                          { TOKEN_PRINT(T_THEN); return T_THEN; yylval.strval = strdup(yytext);  }
"DOWNTO"                                        { TOKEN_PRINT(T_DOWNTO); return T_DOWNTO; yylval.strval = strdup(yytext);  }
"TO"                                            { TOKEN_PRINT(T_TO); return T_TO; yylval.strval = strdup(yytext);  }
"OF"                                            { TOKEN_PRINT(T_OF); return T_OF; yylval.strval = strdup(yytext);  }

"WITH"                                          { TOKEN_PRINT(T_WITH); return T_WITH; yylval.strval = strdup(yytext); }
"READ"                                          { TOKEN_PRINT(T_READ); return T_READ; yylval.strval = strdup(yytext); }
"WRITE"                                         { TOKEN_PRINT(T_WRITE); return T_WRITE; yylval.strval = strdup(yytext); }

"TRUE" | "FALSE"                                { TOKEN_PRINT(T_ΒCONST); return T_ΒCONST; yylval.strval = strdup(yytext); }

"{"                                             { BEGIN(COMMENT); }
<COMMENT>"}"                                    { BEGIN(INITIAL); }
<COMMENT>(\n|\r\n)                              { }
<COMMENT><<EOF>>                                { yyerror("Found comment without closing it. \n"); return T_EOF; }
<COMMENT>.                                      { }                                    

\"                                              { strcpy(str_buff, ""); BEGIN(STRING); }
<STRING>\"                                      { BEGIN(INITIAL); yylval.strval = strdup(str_buff); return T_SCONST; }
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
<STRING>(\n|\r\n)                               { yyerror("Found newline without \\ \n"); }
<STRING><<EOF>>                                 { yyerror("End of string without closing it. \n"); return T_EOF; }
<STRING>.                                       { yyerror("Unknown Character. \n"); }

">="|"<="|"<>"|">"|"<"                          { TOKEN_PRINT(T_RELOP); return T_RELOP; yylval.strval = strdup(yytext); }
"+"|"-"                                         { TOKEN_PRINT(T_ADDOP); return T_ADDOP; yylval.strval = strdup(yytext); }
"OR"                                            { TOKEN_PRINT(T_OROP); return T_OROP; yylval.strval = strdup(yytext); }

"*"|"/"|"DIV"|"MOD"|"AND"                       { TOKEN_PRINT(T_MULDIVANDOP); return T_MULDIVANDOP; yylval.strval = strdup(yytext);}
"NOT"                                           { TOKEN_PRINT(T_NOTOP); return T_NOTOP; yylval.strval = strdup(yytext);}
"IN"                                            { TOKEN_PRINT(T_INOP); return T_INOP; yylval.strval = strdup(yytext);}

"("                                             { TOKEN_PRINT(T_LPAREN); return T_LPAREN; yylval.strval = strdup(yytext); }
")"                                             { TOKEN_PRINT(T_RPAREN); return T_RPAREN; yylval.strval = strdup(yytext); }
";"                                             { TOKEN_PRINT(T_SEMI); return T_SEMI; yylval.strval = strdup(yytext); }
"."                                             { TOKEN_PRINT(T_DOT); return T_DOT; yylval.strval = strdup(yytext); }
","                                             { TOKEN_PRINT(T_COMMA); return T_COMMA; yylval.strval = strdup(yytext); }
"="                                             { TOKEN_PRINT(T_EQU); return T_EQU; yylval.strval = strdup(yytext); }                               
":"                                             { TOKEN_PRINT(T_COLON); return T_COLON; yylval.strval = strdup(yytext); }
"["                                             { TOKEN_PRINT(T_LBRACK); return T_LBRACK; yylval.strval = strdup(yytext); }
"]"                                             { TOKEN_PRINT(T_RBRACK); return T_RBRACK; yylval.strval = strdup(yytext); }
":="                                            { TOKEN_PRINT(T_ASSIGN); return T_ASSIGN; yylval.strval = strdup(yytext); }
".."                                            { TOKEN_PRINT(T_DOTDOT); return T_DOTDOT; yylval.strval = strdup(yytext); }

{IDENTIFIER_REG}                                { TOKEN_PRINT(T_ID); yylval.strval = strdup(yytext); return T_ID; }

{ICONST_REG}                                    { NUMBER_PRINT(T_ICONST); yylval.intval = strToInt(yytext); return T_ICONST; }
{RCONST_REG}                                    { FLOAT_PRINT(T_RCONST); yylval.floatval = strToFloat(yytext); return T_RCONST; }
{CCONST_REG}                                    { TOKEN_PRINT(T_CCONST); yylval.charval = getCharBetweenQuotes(yytext); return T_CCONST; }

"\n"|"\r\n"|"\t"                                { } 
" "                                             { } 

<<EOF>>                                         { printf("|--> EVERYTHING COMPILED CORRECTLY.\n"); return T_EOF; }

.                                               { yyerror("This character can not be recognised."); }

%%

void TOKEN_PRINT(int token_id){
    if(!FLEX_DEBUG) return;

    printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void NUMBER_PRINT(int token_id) {
    if(!FLEX_DEBUG) return;

    int decimal_number, base=10;
    if(strncmp(yytext, "0B", 2) == 0){ decimal_number = BinToInt(yytext); base=2; }
    else if(strncmp(yytext, "0H", 2) == 0){ decimal_number = HexToInt(yytext); base=16; }
    else decimal_number = atoi(yytext);

    if(base != 10) printf("[LINE %d] TOKEN \"%s\"(BASE %d)->\"%d\"(BASE 10) TOKEN_ID (%d)\n", yylineno, yytext, base, decimal_number, token_id);
    else printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void FLOAT_PRINT(int token_id){
    if(!FLEX_DEBUG) return;

    float decimal_number;
    int base=10;
    if(strncmp(yytext, "0B", 2) == 0){ decimal_number = BinToFloat(yytext); base=2; }
    else if(strncmp(yytext, "0H", 2) == 0){ decimal_number = HexToFloat(yytext); base=16; }
    else decimal_number = atoi(yytext);

    if(base != 10) printf("[LINE %d] TOKEN \"%s\"(BASE %d)->\"%f\"(BASE 10) TOKEN_ID (%d)\n", yylineno, yytext, base, decimal_number, token_id);
    else printf("[LINE %d] TOKEN \"%s\" TOKEN_ID (%d)\n", yylineno, yytext, token_id);
}

void yyerror(const char *err) {
    error_counter++;
    printf("[ERROR] LINE %d [ERROR MESSAGE] %s\n", yylineno, err);

    if(MAX_ERRORS < 0) return;
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

int strToInt(char *str) {
    // hexa number
    if (strncmp(str, "0x", 2) == 0) return HexToInt(str);
    
    // binary number
    if (strncmp(str, "0b", 2) == 0) return BinToInt(str);

    // dec number
    return strtoll(str, NULL, 10);
}


float BinToFloat(char *str){
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

float HexToFloat(char *str){
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

float strToFloat(char *str) {
    // hex number
    if (strncmp(str, "0x", 2) == 0) return HexToFloat(str); 

    // binary number
    if (strncmp(str, "0b", 2) == 0) return BinToFloat(str);

    // dec number
    return strtoll(str, NULL, 10);
}

char getCharBetweenQuotes(char *yytext) {
    if(yytext[1] == '\\'){
        if(yytext[2] == 'n'){
            return '\n';
        }else if(yytext[2] == 't'){
            return '\t';
        }else if(yytext[2] == 'v'){
            return '\v';
        }else if(yytext[2] == 'b'){
            return '\b';
        }else if(yytext[2] == 'f'){
            return '\f';
        }else if(yytext[2] == 'r'){
            return '\r';
        }
    }
    return yytext[1];
}
