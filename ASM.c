#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* getMain();
char* getTail();
char* getShowCode(int);
char* getShowHead();
char* getShowHexCode(int);
char* getShowHexHead();
char* getShowStringCode();
char* getShowStringHead(char*);
char* asmConcat(char*,char*);

int HeaderNum = 0;

void main(){
  char* asmHeader;
  char* asmCode;

  asmCode = getShowStringCode();
  asmHeader = getShowStringHead("Hello World");

  asmHeader = asmConcat(asmHeader,getMain());
  asmCode = asmConcat(asmCode,getTail());
  printf("%s\n%s",asmHeader,asmCode);
}

char* asmConcat(char* base,char* cc){
  char* tmpStr = malloc(strlen(base) + strlen(cc) + 1);
  strcpy(tmpStr,base);
  strcat(tmpStr,cc);
  free(base);
  free(cc);
  return tmpStr;
}

char* getShowCode(int val){
  char tmp[10];
  sprintf(tmp, "%d", val);
  char* asmString = "\tmovl	$";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,", 28(%esp)\n");
  asmString = asmConcat(asmString,"\tmovl	28(%esp), %eax\n");
  asmString = asmConcat(asmString,"\tmovl	%eax, 4(%esp)\n");
  asmString = asmConcat(asmString,"\tmovl	$LC");
  sprintf(tmp, "%d", HeaderNum);
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,", (%esp)\n");
  asmString = asmConcat(asmString,"\tcall	_printf\n");
  return asmString;
}

char* getShowHead(){
  char tmp[10];
  sprintf(tmp, "%d", HeaderNum);
  char* asmString = "LC";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n");
  asmString = asmConcat(asmString,"\t.ascii \"%d\\12\\0\"\n");
  HeaderNum++;
  return asmString;
}

char* getShowHexCode(int val){
  char tmp[10];
  sprintf(tmp, "%d", val);
  char* asmString = "\tmovl	$";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,", 28(%esp)\n");
  asmString = asmConcat(asmString,"\tmovl	28(%esp), %eax\n");
  asmString = asmConcat(asmString,"\tmovl	%eax, 4(%esp)\n");
  asmString = asmConcat(asmString,"\tmovl	$LC");
  sprintf(tmp, "%d", HeaderNum);
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,", (%esp)\n");
  asmString = asmConcat(asmString,"\tcall	_printf\n");
  return asmString;
}

char* getShowHexHead(){
  char tmp[10];
  sprintf(tmp, "%d", HeaderNum);
  char* asmString = "LC";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n");
  asmString = asmConcat(asmString,"\t.ascii \"0x%02x\\12\\0\"\n");
  HeaderNum++;
  return asmString;
}

char* getShowStringCode(){
  char tmp[10];
  sprintf(tmp, "%d", HeaderNum);
  char* asmString = "\tmovl	$LC";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,", (%esp)\n");
  asmString = asmConcat(asmString,"\tcall	_puts\n");
  return asmString;
}

char* getShowStringHead(char* str){
  char tmp[10];
  sprintf(tmp, "%d", HeaderNum);
  char* asmString = "LC";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n");
  asmString = asmConcat(asmString,"\t.ascii \"");
  asmString = asmConcat(asmString,str);
  asmString = asmConcat(asmString,"\\0\"\n");
  HeaderNum++;
  return asmString;
}

char* getMain(){
  char* asmString = "\t.text\n";
  asmString = asmConcat(asmString,"\t.globl	_main\n");
  asmString = asmConcat(asmString,"\t.def	_main;	.scl	2;	.type	32;	.endef\n");
  asmString = asmConcat(asmString,"_main:\n");
  asmString = asmConcat(asmString,"LFB10:\n");
  asmString = asmConcat(asmString,"\t.cfi_startproc\n");
  asmString = asmConcat(asmString,"\tpushl	%ebp\n");
  asmString = asmConcat(asmString,"\t.cfi_def_cfa_offset 8\n");
  asmString = asmConcat(asmString,"\t.cfi_offset 5, -8\n");
  asmString = asmConcat(asmString,"\tmovl	%esp, %ebp\n");
  asmString = asmConcat(asmString,"\t.cfi_def_cfa_register 5\n");
  asmString = asmConcat(asmString,"\tandl	$-16, %esp\n");
  asmString = asmConcat(asmString,"\tsubl	$32, %esp\n");
  asmString = asmConcat(asmString,"\tcall	___main\n");
  return asmString;
}

char* getTail(){
  char* asmString = "\tnop\n";
  asmString = asmConcat(asmString,"\tleave\n");
  asmString = asmConcat(asmString,"\t.cfi_restore 5\n");
  asmString = asmConcat(asmString,"\t.cfi_def_cfa 4, 4\n");
  asmString = asmConcat(asmString,"\tret\n");
  asmString = asmConcat(asmString,"\t.cfi_endproc\n");
  return asmString;
}
