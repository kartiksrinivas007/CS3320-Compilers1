PIECE (R|K|B|N|Q)
LETTER [a-h]
DIGIT [1-8]
NORMAL {PIECE}{LETTER}{DIGIT}[-x]{LETTER}{DIGIT}
PAWNPROM {LETTER}{DIGIT}[-]{LETTER}{DIGIT}[=]{PIECE}
PAWN {LETTER}{DIGIT}[-x]{LETTER}{DIGIT} 
SPACE ([ ])
%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
char chessboard[9][9];
void initialize_chessboard();
void print_chessboard();
void print_piece(const char c );
void modify_piece_position(const char c,const char x_start, const char y_start ,const char x_end, const char y_end );
void pawn_promotion(const char c,const char x_start, const char y_start ,const char x_end, const char y_end);
void MPP_normal(const char*,int);
void MPP_pawn(const char *,int);
void PP(const char*,int a);
%}

%%
{NORMAL}{SPACE}{NORMAL}     {printf("NN \n");MPP_normal(yytext,0);MPP_normal(yytext,7);}
{NORMAL}{SPACE}{PAWN}		{printf("NP \n");MPP_normal(yytext,0);MPP_pawn(yytext,7);} 
{NORMAL}{SPACE}{PAWNPROM}	{printf("NPP \n");MPP_normal(yytext,0);PP(yytext,7);}
{PAWN}{SPACE}{PAWN}			{printf("PP \n");MPP_pawn(yytext,0);MPP_pawn(yytext,6);}     
{PAWN}{SPACE}{NORMAL}		{printf("PN \n");MPP_pawn(yytext,0);MPP_normal(yytext,6);}
{PAWN}{SPACE}{PAWNPROM}    	{printf("PPP");MPP_pawn(yytext,0);PP(yytext,6);}
{PAWNPROM}{SPACE}{PAWNPROM} {printf("PPPP\n");PP(yytext,0);PP(yytext,8);}
{PAWNPROM}{SPACE}{PAWN}		{printf("PP - P \n");PP(yytext,0); MPP_pawn(yytext,8);}
{PAWNPROM}{SPACE}{NORMAL}	{printf("PPN \n");PP(yytext,0);MPP_normal(yytext,8);}
.* 							{printf("Invalid input");}
%%

int yywrap(void){ return 1;}

int main()
{
	printf("This program uses TestCase1.txt\n");
	initialize_chessboard();
	fclose(fopen("OuptutFile.txt","w"));
	yyin = fopen("Test Cases/TestCase1.txt","r");
	yyout = fopen("OuptutFile.txt","a+");
	yylex();
    print_chessboard();
	printf("Above are the type of moves that have been made\n");
	printf("Please see the Output File named \"OutputFile.txt\" \n");
	return 0;
}

void initialize_chessboard()
{
	
	static int k = 0;
	if(k==0){
	char c = 'a';
	char d = '1';
	for(int i = 0; i <9; i++){
		for (int j = 0; j<9; j++){
			if(i==0 && j !=0){
				chessboard[i][j] = c;
				c++;
			}
			else if(j == 0 && i !=0){
				chessboard[i][j] = d;
				d++;
			}
			else if(i==2 || i==7){
				chessboard[i][j] = 'P';
			}
			else{
				chessboard[i][j] = ' ';
			}
		}
	}
	chessboard[1][1] = 'R';
	chessboard[1][2] = 'N';
	chessboard[1][3] = 'B';
	chessboard[1][4] = 'Q';
	chessboard[1][5] = 'K';
	chessboard[1][6] = 'B';
	chessboard[1][7] = 'N';
	chessboard[1][8] = 'R';

	chessboard[8][1] = 'R';
	chessboard[8][2] = 'N';
	chessboard[8][3] = 'B';
	chessboard[8][4] = 'Q';
	chessboard[8][5] = 'K';
	chessboard[8][6] = 'B';
	chessboard[8][7] = 'N';
	chessboard[8][8] = 'R';
	k++;
	}

}
void print_piece(const char c){
	printf("the %c moves", c);
}
void modify_piece_position(const char c,const char j_start, const char i_start ,const char j_end, const char i_end){
	int j_s = j_start - 'a' + 1;
	int i_s = i_start - '0';
	int j_e = j_end - 'a' + 1;
	int i_e = i_end - '0';
	char temp = chessboard[i_s][j_s];
	chessboard[i_s][j_s] = ' ';
	chessboard[i_e][j_e] = temp;
}
void print_chessboard()
{
	for (int i = 0; i<9; i++){
		for(int j = 0; j<9 ; j++){
			fprintf(yyout,"%c \t ",chessboard[i][j]);
		}
		fprintf(yyout,"\n \n");
	}

}
void pawn_promotion(const char c,const char j_start, const char i_start ,const char j_end, const char i_end){
	int j_s = j_start - 'a' + 1;
	int i_s = i_start - '0';
	int j_e = j_end - 'a' + 1;
	int i_e = i_end - '0';
	char temp = chessboard[i_s][j_s];
	chessboard[i_s][j_s] = ' ';
	chessboard[i_e][j_e] = c;
}
void MPP_normal(const char*text,int a){
	
	modify_piece_position(text[a],text[a+1],text[a+2],text[a+4],text[a+5]);
}
void MPP_pawn(const char*text,int a){
	
	modify_piece_position('P',text[a],text[a+1],text[a+3],text[a+4]);
}
void PP(const char *text, int a){
	pawn_promotion(text[a+6],text[a],text[a+1],text[a+3],text[a+4]);
}