%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "tokens.h"

    void print_token(int token_id);
%}

/* ===== OPTIONS ===== */

// Read only 1 File
%option noyywrap
// Case insensitive tokens (e.x ClaSS == class)
%option case-insensitive
// Finds the line that we are currently
%option yylineno

%%

<<EOF>>                 { print_token(T_EOF); return T_EOF; }

.                       { printf("This character can not be recognised at line, %d\n", yylineno); }

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
    
    // if(error_count > 0){
    //     printf("Failed to analyze the program due to %d errors\n", error_count);
    // }else{
    //     printf("Program analyzed successfully\n");
    // }
    
    fclose(yyin);
    yyterminate();
}

void token_print(int token_id){
    printf("Found token %s (%d) at line, %d\n", yytext, token_id, yylineno);
}

