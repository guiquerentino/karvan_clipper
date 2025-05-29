  ******************************************************************************

*****************************/FUN€AO CONSULTA FECHAMENTO**********************
SET CENT ON
@ 04,15 CLEAR TO 10,50
@ 04,15 TO 10,50 DOUBLE

@ 07,16 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
@ 08,16 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
READ
SAVE SCREEN TO TELA
RUN DEL C:\KARVAN\CUPOM.DBF
RUN DEL C:\KARVAN\CUPTEMP.DBF
RUN COPY D:\KARVAN\CUPOM.DBF C:\KARVAN
RUN RENAME C:\KARVAN\CUPOM.DBF CUPTEMP.DBF
REST SCREEN FROM TELA
USE C:\KARVAN\CUPTEMP                
COPY TO C:\KARVAN\DIVIDA FOR D_NOT>=DINICIO .AND. D_NOT<=DFINAL
SELE 4
USE C:\KARVAN\DIVIDA                
INDEX ON D_NOT TO D_NOT
MTOTAL=0
CONT=0      
lin=02
@ 01,15 CLEAR TO 24,65
@ 01,15 TO 24,65 DOUBLE
mes=cmonth(dinicio)
DO WHILE ! EOF()
        CONT++
        MTOTAL=MTOTAL+NOTTOTG
        SKIP
        if cmonth(d_not) # mes
                @ lin,16 say mes
                @ lin,30 say "VALOR.:" GET MTOTAL PICT "9,999,999.99" 
                @ LIN,50 SAY "VENDAS:" GET CONT   PICT "999999"
                LIN++      
                mes=cmonth(d_not)
                cont=0
                MTOTAL=0
        endif
ENDDO
INKEY(0)
