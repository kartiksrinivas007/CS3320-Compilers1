#include<stdio.h>
#include<stdlib.h>
#include<seven_segment.h>
int main()
{
init();
int input ;
while(1)
{
input = readInt();select(1); 
if(input == 0)
{
write(strtol("11111100"));

}
else{
write(strtol("01100000"));

}
delay(40); 
select(30); 
write(strtol("01011101"));
delay(50); 
if(input == 1)
{
write(strtol("01100000"));

}
delay(50); 
}
return 0;
}
