******************************************************************************

*****************************/FUN€AO CONSULTA CONFEREN€A\**********************

CONFERE()
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('NŽO FOI FEITO CONFEREN€A AINDA')
   RETURN(0)
ENDIF
RDISTRIB=SPACE(20)
SETCOLOR("GR/B+")
PRIVATE V1[8], V2[8], V3[8]

V1[01]="((CPRECO/CPCUSTO)-1)*100"
V1[02]="CNOMEPECA"
V1[03]="CQTD"
V1[04]="CPCUSTO"
V1[05]="CPCUSTO*CQTD"
V1[06]="CPRECO"
V1[07]="CNFABRIC"
V1[08]="BARRA"

V2[01]="999.99%"
V2[02]="@!"
V2[03]="999"
V2[04]="999.99"
V2[05]="999.99"
V2[06]="999.99"
V2[07]="@!"
V2[08]="@!"

V3[01]="LUCRO"
V3[02]="APLICACAO"
V3[03]="QTD"
V3[04]="P_CUSTO"
V3[05]="TOTAL"
V3[06]="PRE€O"
V3[07]="N§FABRICA"
V3[08]="BARRA"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

INDEX ON CCODPECA TO CCODPECA
CTOTALG=0
TOT=0
DO WHILE .NOT. EOF()
     MCTOTALG=0
     SEEK CCODPECA
     MCTOTALG=CPCUSTO*CQTD
     CTOTALG=CTOTALG+MCTOTALG
     TOT++
     SKIP
ENDDO

INDEX ON CCODPECA TO CCODPECA
CTOTALG1=0
DO WHILE .NOT. EOF()
     MCTOTALG1=0
     SEEK CCODPECA
     MCTOTALG1=CPRECO*CQTD
     CTOTALG1=CTOTALG1+MCTOTALG1
     SKIP
ENDDO
INDEX ON CNOMEPECA TO CNOMEPECA

@ 23,05 CLEAR TO 23,76
@ 23,65 SAY CTOTALG PICT "999999.99"
@ 23,45 SAY CTOTALG1 PICT "999999.99"
@ 23,35 SAY TOT 

CONFERE()

DBEDIT(01,00,21,79,v1,"UDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Udbedit(modo,coluna)
if modo=1
   return(1)
elseif modo=2
   return(1)
elseif modo=3
   return(0)
elseif modo=4
     if lastkey() == 27
          set softseek off
          return(0)

    elseif lastkey() == 65 .OR. lastkey()== 97 && "A/a"

          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 03,06 CLEAR TO 20,73
          @ 03,06 TO 20,73 DOUBLE
          MCPCUSTO=CPCUSTO
          MCPRECO=CPRECO
          MQTD=CQTD
          MBARRA=BARRA
          @ 03,12 SAY "ALTERA CONFEREN€A"
          @ 05,13 SAY "Codigo........:"  GET CCODPECA PICT "@!"
          @ 07,13 SAY "Aplica‡„o.....:"  GET CNOMEPECA
          @ 09,13 SAY "N§ original...:"  GET CNFABRIC PICT "@!"
          CLEAR GETS
          @ 11,13 SAY "Preco.........:"  GET MCPRECO PICT "999.99"
          @ 13,13 SAY "P_custo ......:"  GET MCPCUSTO PICT "999.99"
          @ 15,13 SAY "QTD ..........:"  GET MQTD
          @ 17,13 SAY "BARRA.........:"  GET MBARRA
          READ
          IF UPDATED()
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                 BLOQUEIO()
                 REPLACE CPRECO  WITH MCPRECO
                 REPLACE CPCUSTO WITH MCPCUSTO
                 REPLACE CQTD    WITH MQTD
                 REPLACE BARRA   WITH MBARRA
                 UNLOCK
              ENDIF
          ENDIF
          RETURN(2)
     ENDIF
ENDIF
RETURN(1)
