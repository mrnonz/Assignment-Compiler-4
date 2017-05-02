#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* getMain();
char* getTail();
char* getAssign(int,char*);
char* getShowCode(int);
char* getShowHead();
char* getShowHexCode(int);
char* getShowHexHead();
char* getShowStringCode();
char* getShowStringHead(char*);
char* getSetTmp(char*, int);
char* getSetNegTmp(char*, int);
char* getSetValue(char*,int);
char* getAdd(int);
char* getSub(int);
char* getMul(int);
char* getDiv(int);
char* getMod(int);
char* asmConcat(char*,char*);
char* getCmpCodeStart();
char* getCmpCodeEnd();
char* getLoopCodeAdd(char*);
char* getLoopCodeSub(char*);
char* getLoopCodeMultiple(char*);
char* getLoopCodeEnd();
char* asmConcatNoFree(char*,char*);
char* getCmpCode1();
char* getCmpCode2();


int HeaderNum = 0;
int JumpNum = 0;
int LoopNum = 0;
int offsetLoop = 76;

char* asmConcat(char* base,char* cc){
  char* tmpStr = malloc(strlen(base) + strlen(cc) + 1);
  strcpy(tmpStr,base);
  strcat(tmpStr,cc);
  free(base);
  free(cc);
  return tmpStr;
}

char* asmConcatNoFree(char* base,char* cc){
  char* tmpStr = malloc(strlen(base) + strlen(cc) + 1);
  strcpy(tmpStr,base);
  strcat(tmpStr,cc);
  free(base);
  return tmpStr;
}

char* getAssign(int offset, char* val){
  char tmp[10];
  char* asmString = "\tmovl ";
  asmString = asmConcat(asmString,val);
  asmString = asmConcat(asmString,", ");
  sprintf(tmp, "%d", 100 + offset * 4);
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"(%esp)\n");
  return asmString;
}

char* getShowCode(int offset){
  char tmp[10];
  sprintf(tmp, "%d", 100 + offset * 4);
  char* asmString = "\tmovl	";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"(%esp), %eax\n");
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

char* getShowHexCode(int offset){
  char tmp[10];
  sprintf(tmp, "%d", 100 + offset * 4);
  char* asmString = "\tmovl	";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"(%esp), %eax\n");
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
  asmString = asmConcat(asmString,"\tsubl	$2804, %esp\n");
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

char* getSetTmp(char* val, int counter){
  char* asmString = "\tmovl ";
  asmString = asmConcatNoFree(asmString, val);
  asmString = asmConcat(asmString, ", %eax\n");
  if(counter == 0){
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 1){
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }else if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl %eax, 60(%esp)\n");
  }
  return asmString;
}

char* getSetNegTmp(char* val, int counter){
  char* asmString = "\tmovl ";
  asmString = asmConcatNoFree(asmString, val);
  asmString = asmConcat(asmString, ", %eax\n");
  asmString = asmConcat(asmString,"\tneg %eax\n");
  if(counter == 0){
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 1){
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }else if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl %eax, 60(%esp)\n");
  }
  return asmString;
}

char* getSetValue(char* val, int i){
  char* asmString = "\tmovl	";
  if(i == 1){
    asmString = asmConcat(asmString,val);
    asmString = asmConcat(asmString,", %edx\n");
  }else{
    asmString = asmConcat(asmString,val);
    asmString = asmConcat(asmString,", %eax\n");
  }
  return asmString;
}

char* getAdd(int counter){
  char* asmString = "";
  if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl 52(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %edx\n");
    asmString = asmConcat(asmString,"\taddl	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 3){
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 60(%esp), %edx\n");
    asmString = asmConcat(asmString,"\taddl	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }
  return asmString;
}

char* getSub(int counter){
  char* asmString = "";
  if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl 52(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %edx\n");
    asmString = asmConcat(asmString,"\tsubl	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 3){
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 60(%esp), %edx\n");
    asmString = asmConcat(asmString,"\tsubl	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }
  return asmString;
}

char* getMul(int counter){
  char* asmString = "";
  if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl 52(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %edx\n");
    asmString = asmConcat(asmString,"\timul	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 3){
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tmovl 60(%esp), %edx\n");
    asmString = asmConcat(asmString,"\timul	%edx, %eax\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }
  return asmString;
}

char* getDiv(int counter){
  char* asmString = "";
  if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl 52(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tcltd\n");
    asmString = asmConcat(asmString,"\tidivl	56(%esp)\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 52(%esp)\n");
  }else if(counter == 3){
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tcltd\n");
    asmString = asmConcat(asmString,"\tidivl	60(%esp)\n");
    asmString = asmConcat(asmString,"\tmovl %eax, 56(%esp)\n");
  }
  return asmString;
}

char* getMod(int counter){
  char* asmString = "";
  if(counter == 2){
    asmString = asmConcat(asmString,"\tmovl 52(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tcltd\n");
    asmString = asmConcat(asmString,"\tidivl	56(%esp)\n");
    asmString = asmConcat(asmString,"\tmovl %edx, 52(%esp)\n");
  }else if(counter == 3){
    asmString = asmConcat(asmString,"\tmovl 56(%esp), %eax\n");
    asmString = asmConcat(asmString,"\tcltd\n");
    asmString = asmConcat(asmString,"\tidivl	60(%esp)\n");
    asmString = asmConcat(asmString,"\tmovl %edx, 56(%esp)\n");
  }
  asmString = asmConcat(asmString,"\tmovl %edx, %eax\n");
  return asmString;
}

char* getCmpCodeStart(){
  char tmp[10];
  sprintf(tmp, "%d", JumpNum);
  char* asmString = "\tcmp	";
  asmString = asmConcat(asmString,"\t%eax, %edx\n");
  asmString = asmConcat(asmString,"\tjne\t\tnxt");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"\n");
  return asmString;
}

char* getCmpCodeEnd(){
  char tmp[10];
  sprintf(tmp, "%d", JumpNum);
  char* asmString = "\tnxt";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n");
  JumpNum++;
  return asmString;
}

char* getLoopCodeAdd(char* inc){
  char tmp[10], tmp2[10], tmp3[10];
  sprintf(tmp, "%d", LoopNum);
  sprintf(tmp2, "%d", offsetLoop);
  sprintf(tmp3, "%d", offsetLoop+4);
  char* asmString = "\tmovl\t%edx,";
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\nLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n\tmovl ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp), %edx\n\tmovl ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp), %eax\n\tcmp\t%eax, %edx\n\tjg outLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"\n\taddl\t");
  asmString = asmConcat(asmString,inc);
  asmString = asmConcat(asmString,", %edx\n\tmovl\t%edx, ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\n");
  offsetLoop += 8;
  LoopNum++;
  return asmString;
}

char* getLoopCodeMultiple(char* inc){
  char tmp[10], tmp2[10], tmp3[10];
  sprintf(tmp, "%d", LoopNum);
  sprintf(tmp2, "%d", offsetLoop);
  sprintf(tmp3, "%d", offsetLoop+4);
  char* asmString = "\tmovl\t%edx,";
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\nLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n\tmovl ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp), %edx\n\tmovl ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp), %eax\n\tcmp\t%eax, %edx\n\tjg outLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"\n\timul\t");
  asmString = asmConcat(asmString,inc);
  asmString = asmConcat(asmString,", %edx\n\tmovl\t%edx, ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\n");
  offsetLoop += 8;
  LoopNum++;
  return asmString;
}

char* getLoopCodeSub(char* inc){
  char tmp[10], tmp2[10], tmp3[10];
  sprintf(tmp, "%d", LoopNum);
  sprintf(tmp2, "%d", offsetLoop);
  sprintf(tmp3, "%d", offsetLoop+4);
  char* asmString = "\tmovl\t%edx,";
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\nLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n\tmovl ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp), %edx\n\tmovl ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp), %eax\n\tcmp\t%eax, %edx\n\tjl outLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"\n\tsubl\t");
  asmString = asmConcat(asmString,inc);
  asmString = asmConcat(asmString,", %edx\n\tmovl\t%edx, ");
  asmString = asmConcat(asmString,tmp2);
  asmString = asmConcat(asmString,"(%esp)\n\tmovl\t%eax, ");
  asmString = asmConcat(asmString,tmp3);
  asmString = asmConcat(asmString,"(%esp)\n");
  offsetLoop += 8;
  LoopNum++;
  return asmString;
}

char* getLoopCodeEnd(){
  char tmp[10];
  offsetLoop -= 8;
  LoopNum--;
  sprintf(tmp, "%d", LoopNum);
  char* asmString = "\tjmp\tLoop";
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,"\n");
  asmString = asmConcat(asmString,"outLoop");
  asmString = asmConcat(asmString,tmp);
  asmString = asmConcat(asmString,":\n");
  return asmString;
}
