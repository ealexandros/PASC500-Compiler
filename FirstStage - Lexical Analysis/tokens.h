/* In this file we will have all of the Lexical Tokens */

// Lex Keywords
#define T_EOF           0

// Program Keywords
#define T_PROGRAM       1
#define T_BEGIN         16
#define T_END           17
#define T_PROCEDURE     11
#define T_FUNCTION      10
#define T_FORWARD       9

// Variables
#define T_CONST         2
#define T_TYPE          3
#define T_ARRAY         4
#define T_VAR           5
#define T_INTEGER       12
#define T_REAL          13
#define T_BOOLEAN       14
#define T_RECORD        8
#define T_CHAR          15
#define T_SET           6

// Conditions
#define T_IF            18
#define T_WHILE         21
#define T_DO            22
#define T_FOR           23

#define T_ELSE          20
#define T_THEN          19
#define T_DOWNTO        24
#define T_TO            25
#define T_OF            7

// Input-Output
#define T_WITH          26
#define T_READ          27
#define T_WRITE         28