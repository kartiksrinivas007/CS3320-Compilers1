%option caseless

BINARY (0|1)
RELATIONAL ("=="|"!="|"<="|">=")
DIGIT [0-9]
SPACE (" ")


%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#define STDIO "#include<stdio.h>"
#define SEVSEG "#include<seven_segment.h>"
#define STDLIB "#include<stdlib.h>"
#define MAIN "int main()"
#define ENDMAIN "return 0;"
#define INIT "init();"
#define READINT "readInt();"
#define WHILE "while(1)"
#define OPENCURLY "{"
#define WRITE "write(strtol(\""
#define ENDWRITE "\"));"
#define DELAY "delay("
#define ENDBRACKET ");"
#define SELECT "select("
#define ENDCURLY "}"
#define INPUT "input ;"
#define INT "int"
#define EQQ "=="
#define EQ "="
#define IF "if("
#define CLOSENORM ")"
char stored_val[9] = "       ";
int numb = 0;
char *trimString(char *str);
void initialize_while();
void extract_integer(char *str,char*extracted_int);
void select(const char *);
void delay(const char *);
void init();
void readint();
void else_stat();
void if_stat(const char*);
void input();
void default_ans();
char* substring(const char *,int,int);
bool if_flag = false;
%}


%%
#.*                {;}
"Select: "{DIGIT}+ {select(yytext);} 
"Delay: "{DIGIT}+  {delay(yytext);}
"input: int"       {input();}
"input = readInt"  {readint();}
"INIT"             {init();}
{BINARY} 		   {if(numb <=7)  
						{ 
							stored_val[numb] = yytext[0]; 
  							numb ++;
						}
					if(numb>7)
						{
						stored_val[8] = '\0';
						fprintf(yyout,"%s%s%s\n",WRITE,stored_val,ENDWRITE);
						numb =0;
						if(if_flag){
                            fprintf(yyout,"\n%s\n",ENDCURLY);
							if_flag = false;
									}
						}
					}
[ \t\n]				{;}
"if input "{RELATIONAL}" "{DIGIT}+: {if_stat(yytext);}
"else:" 		   {else_stat();}

%%

int yywrap(void){
	return 1;
}

int main()
{
	printf("This program uses TestCase1.txt\n");
	fclose(fopen("OutputFile.c", "w"));
	yyout = fopen("OutputFile.c","a");
	yyin = fopen("Test Cases/Testcase1.txt","r");
	fprintf(yyout,"%s\n%s\n%s\n%s\n%s\n",STDIO,STDLIB,SEVSEG,MAIN,OPENCURLY);
	yylex();
	fprintf(yyout,"%s\n%s\n%s\n",ENDCURLY,ENDMAIN,ENDCURLY);
	printf("Please see the output file named - OutputFile.c\n");
	return 0;

}

char *trimString(char *str)
{
	int len = strlen(str);
    for(int i = 0; i < len; i++)
	{
		if(str[i] == '\t')
		{
			for(int j = i; j < len; j++)
			{
				str[j] = str[j + 1];
			}
			len--;
			i--;	
		} 
	}
	return str;	
}
void initialize_while(){
	static int k =0;
	if(k==0){
		fprintf(yyout,"%s\n%s\n",WHILE,OPENCURLY);
		k++;
	}
}
void else_stat(){
	fprintf(yyout,"else{\n");
	if_flag = true;
}
void input(){
	fprintf(yyout, "%s %s\n",INT,INPUT);
}
void readint(){
	initialize_while();
	fprintf(yyout,"input = readInt();");
}
void init()
{
fprintf(yyout,"%s\n",INIT);
}
void default_ans(){
	ECHO;fprintf(yyout,"\n Invalid My dear Kartik\n %s \n",ENDCURLY);
}
void if_stat(const char* text){
     char* relation = substring(text,9,12);
	 fprintf(yyout,"%sinput %s%s\n%s\n",IF,relation,CLOSENORM,OPENCURLY);
	 if_flag = true;
}
char *substring(const char* input , int start , int end){
	char* ans = (char*)malloc(sizeof(char)*(end - start + 2));
	for (int i = start; i<=end; i++){
		ans[i - start] = input[i];
	}
	ans[end - start + 1] = '\0';
	return ans;
}
void select(const char *text){
	char *number = substring(text,8,strlen(text) - 1);
	initialize_while();
	fprintf(yyout,"%s%s%s \n", SELECT,number,ENDBRACKET);

}
void delay(const char* text){
	char *number = substring(text,7,strlen(text) - 1);
	fprintf(yyout,"%s%s%s \n", DELAY,number,ENDBRACKET);
}
