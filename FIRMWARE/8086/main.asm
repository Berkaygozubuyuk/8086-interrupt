;====================================================================
;
; Processor: 8086
; Compiler:  MASM32
;
;====================================================================

STAK SEGMENT PARA STACK 'STACK' 
DW 20 DUP(?) 
STAK ENDS 
DATA SEGMENT PARA 'DATA' 
MYDAT DB 5 DUP(0) 
DATASAY  DW 0 
DATASENDSAY DW 0 
ALLSENT  DB 1 
DATA ENDS 
CODE SEGMENT PARA 'CODE' 
ASSUME CS:CODE, DS:DATA, SS:STAK 
; ----------------------------------------------------------------------- 
; 8251 seri veri alma KSP 
; ----------------------------------------------------------------------- 
NEWINT PROC FAR 
  IN AL, 7CH ; gelen karakteri oku 
  shr al,1
  INC AL ; ASCII bir fazlasini sakla 
  MOV SI, DATASAY 
  MOV MYDAT[SI], AL 
  INC SI 
  CMP SI, 5 
  JNE DEVAM ; 5 karakter biriktirilmis mi 
  XOR SI, SI ; alma indisini sifirla 
  MOV ALLSENT, 0 
  MOV AL, MYDAT[0] 
  OUT 7CH, AL ; 5 karakterden ilkini g�nder 
  INC DATASENDSAY 
DEVAM: MOV DATASAY, SI 
  IRET 
NEWINT ENDP 
; ----------------------------------------------------------------------- 
;  seri veri g�nderme KSP 
; ----------------------------------------------------------------------- 
NEWINT2 PROC FAR 
  CMP ALLSENT, 1 ; 5 karakterin g�nderimi bitti mi 
  JE DEVAM2 
  MOV DI, DATASENDSAY 
  MOV AL, MYDAT[DI] 
  OUT 7CH, AL ; siradaki karakteri g�nder 
  INC DI ; bir sonraki karakter indisi 
  CMP DI, 5 
  JNE DEVAM2 
  MOV ALLSENT, 1 ; 5 karakterin g�nderimi bitti 
  XOR DI, DI ; g�nderme indisini sifirla 
DEVAM2: MOV DATASENDSAY, DI 
  IRET 
NEWINT2 ENDP 
START PROC FAR 
;------------------------------------------------------------------------ 
; DATA ismiyle tanimli kesim alanina erisebilmek i�in gerekli tanimlar 
;------------------------------------------------------------------------ 
  MOV AX, DATA 
  MOV DS, AX 
;------------------------------------------------------------------------ 
; 50H kesme vekt�r numarasinin NEWINT�e baglanmasi 
;------------------------------------------------------------------------
XOR AX, AX 
  MOV ES, AX 
  MOV AL, 50H 
  MOV AH, 4 
  MUL AH 
  MOV BX, AX 
  LEA AX, NEWINT 
  MOV WORD PTR ES:[BX], AX 
  MOV AX, CS 
  MOV WORD PTR ES:[BX+2], AX  
;------------------------------------------------------------------------ 
; 51H kesme vekt�r numarasinin NEWINT2�ye baglanmasi 
;------------------------------------------------------------------------ 
  MOV AL, 51H 
  MOV AH, 4 
  MUL AH 
  MOV BX, AX 
  LEA AX, NEWINT2 
  MOV WORD PTR ES:[BX], AX 
  MOV AX, CS 
  MOV WORD PTR ES:[BX+2], AX  
;------------------------------------------------------------------------ 
; 8251�in kosullandirilmasi 
;------------------------------------------------------------------------ 
  MOV AL, 01001101B 
  OUT 7EH, AL 
  MOV AL, 40H 
  OUT 7EH, AL 
  MOV AL, 01001101B 
  OUT 7EH, AL 
  MOV AL, 15H 
  OUT 7EH, AL 
;------------------------------------------------------------------------ 
; 8259�un kosullandirilmasi 
;------------------------------------------------------------------------ 
  MOV AL, 13H 
  OUT 60H, AL 
  MOV AL, 50H ; IR0 50H tipinde kesme saglar 
  OUT 62H, AL 
  MOV AL, 03H 
  OUT 62H, AL 
  STI ; IF<-1, INTR kesmeleri aktif 
ENDLESS: JMP ENDLESS ; sonsuz d�ng� 
START  ENDP 
CODE ENDS 
END START 