*****************************************************************************

************************/FUN€AO QUANTIDADE VENDAS CONSULTA PECAS*************
IF ACESSO = 1
        IF ALLTRIM(FUNCIONARIO)="MARCELO";
                .OR. ALLTRIM(FUNCIONARIO)="RODRIGO" .OR. ALLTRIM(FUNCIONARIO)="FABIO"
           ELSE
                RETURN(.T.)
        ENDIF
   ELSE
        RETURN(.T.)
ENDIF

*PECAS()
SAVE SCREEN TO TELAP
RUN COPY D:\KARVAN\PECAS.DBF C:\TEMP
RESTORE SCREEN FROM TELAP
USE C:\TEMP\PECAS.DBF SHARED
COPY TO C:\TEMP\PECATEMP FOR QTD>0 .OR. QTDMIN>0
USE C:\TEMP\PECATEMP.DBF SHARED
SETCOLOR("GR/B+")
CLS
DIA1=DAY(DATE())
DIA2=DAY(DATE()-DIA1)
DIA3=DAY(DATE()-DIA1-DIA2)

PRIVATE V1[05], V2[05], V3[05]
 
V1[01]="LEFT(NOMEPECA,30)"
V1[02]="QTDMAX"
V1[03]="QTDMAX1"
V1[04]="QTDMAX2"
V1[05]="QTDMAX3"

V2[01]="@!"
V2[02]="9999"
V2[03]="9999"
V2[04]="9999"
V2[05]="9999"
            
V3[01]="DESCRI€ŽO"
V3[02]=CMONTH(DATE())
V3[03]=CMONTH(DATE()-DIA1)
V3[04]=CMONTH(DATE()-DIA1-DIA2)
V3[05]=CMONTH(DATE()-DIA1-DIA2-DIA3)

*@ 07,09 SAY CMONTH(DATE())
*@ 07,25 SAY CMONTH(DATE()-DIA1)
*@ 07,41 SAY CMONTH(DATE()-DIA1-DIA2)
*@ 07,57 SAY CMONTH(DATE()-DIA1-DIA2-DIA3)

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE
@ 18,00 TO 21,79 DOUBLE
 
DBEDIT(01,00,17,79,v1,"Rdbedit",v2,v3,chr(205),space(1)+chr(179))
function Rdbedit(MODO,COLUNA)

if modo=1   
    return(1)
  elseif modo=2  
    return(1)
  elseif modo=3   
    return(0)
  elseif modo=4
         
     if lastkey() == 27 && "esc"             
         return(0)

       elseif lastkey()== 50 && "2"
      
                  CLEAR GETS
                  SET CURSOR ON
                  SET SOFTSEEK ON
                  SETCOLOR("W+/BG,N/W")
                  V_DESCR:=SPACE(20)
                  @ 03,20 CLEAR TO 07,54
                  @ 03,20 TO 07,54 DOUBLE
                  @ 04,22 SAY "DESCRICAO.:" GET V_DESCR PICT "@!"
                  READ
                  TAM=LEN(V_DESCR)
                  INDEX ON QTDMAX1 TO TEMP FOR LEFT(NOMEPECA,TAM)=ALLTRIM(V_DESCR) 
                  VALORTOT=0
                  QTDTOTAL=0
                  QTDPROD=0
                  MQTDMAX=0
                  MQTDMAX1=0
                  MQTDMAX2=0
                  MQTDMAX3=0
                  DO WHILE ! EOF()
                        IF CODPECA = "99999" .OR. CODPECA = "22222" .OR. CODPECA = "88888" .OR. CODPECA = "22225"
                                SKIP
                            ELSE
                                VALORTOT=VALORTOT+(PRECO*QTD)
                                MQTDMAX=MQTDMAX+QTDMAX
                                MQTDMAX1=MQTDMAX1+QTDMAX1
                                MQTDMAX2=MQTDMAX2+QTDMAX2
                                MQTDMAX3=MQTDMAX3+QTDMAX3
                                QTDPROD++
                                QTDTOTAL=QTDTOTAL+QTD
                        ENDIF
                        SKIP
                  ENDDO
                  @ 19,50 SAY MQTDMAX  PICT "999999"
                  @ 19,57 SAY MQTDMAX1 PICT "999999"
                  @ 19,64 SAY MQTDMAX2 PICT "999999"
                  @ 19,71 SAY MQTDMAX3 PICT "999999"
                  @ 19,05 SAY "TOTAL CADASTRADO:"
                  @ 19,23 SAY QTDPROD  PICT "9999999"
                  @ 20,05 SAY "QUANTIDADE TOTAL:"
                  @ 20,23 SAY QTDTOTAL PICT "9999999"
                  @ 23,05 SAY "VALOR TOTAL VENDA:"
                  @ 23,24 SAY VALORTOT PICT "9,999,999.99"

                  NTX=2
                  RETURN(2)

        ELSEIF LASTKEY() == 32 && "espaço"

                  SAVE SCREEN TO FTELA
                  SETCOLOR("W+/BG,N/W")
                  @ 00,02 CLEAR TO 23,76
                  @ 00,02 TO 23,76 DOUBLE
                  @ 00,12 SAY "CONSULTA PECAS"
                  PUVARPE()
                  IGUAVARPE()
                  IF ACESSO=1
                        @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
                  ENDIF
                  @ 01,17 SAY "-"
                  @ 01,18 SAY MDIGITO
                  @ 05,21 SAY "Estoque:"  GET MQTD PICT "999"
                  MOSTEXPE()
                  IF ACESSO#1
                        @ 04,25 CLEAR TO 04,30
                        @ 02,25 CLEAR TO 02,45
                  ENDIF
                  INKEY(0)
                  RESTORE SCREEN FROM FTELA
                  CLEAR GETS
                  RETURN(2)

     ENDIF
ENDIF
