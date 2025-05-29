******************************************************************************

*****************************/FUN€AO CONSULTA OR€AMENTO***********************

CAMINHO="D:\KARVAN\ORCA\ORCA"
USE &CAMINHO&MORCA SHARED

IF EOF()
    TONE(500,5)
    PECAS()
    OL_Yield()
    ALERT ('Nenhuma Pe‡a Cadastrada...')
    RETURN(0)
ENDIF

SETCOLOR("GR/B+")
PRIVATE V1[5], V2[5], V3[5]

V1[01]="ONOMEPECA"
V1[02]="OPRECO"
V1[03]="OQTD"
V1[04]="OPRECO*OQTD"
V1[05]="OFABRIC"

V2[01]=" "
V2[02]="9999.99"
V2[03]="999"
V2[04]="9999.99"
V2[05]="@!"

V3[01]="APLICA€ŽO"
V3[02]="PRECO"
V3[03]="QUANT"
V3[04]="TOTAL..:"
V3[05]="FABRICANTE"

@ 00,00 TO 24,79 DOUBLE
@ 01,01 SAY PADC("TELA DE OR€AMENTO",78)
@ 02,01 TO 02,78 DOUBLE
@ 22,00 SAY "Ì"
@ 02,00 SAY "Ì"
@ 22,79 SAY "¹ "
@ 02,79 SAY "¹ "
@ 22,01 TO 22,78 DOUBLE
@ 23,02 CLEAR TO 23,78

@ 23,50 SAY "TOTAL GERAL..:"
INDEX ON OCODPECA TO OCODPECA
MOTOTALG=0
DO WHILE .NOT. EOF()
     SEEK OCODPECA
     MOTOTALG=OTOTAL+MOTOTALG
     SKIP
ENDDO
@ 23,65 SAY MOTOTALG PICT "999999.99"

 
DBEDIT(03,01,21,78,v1,"KDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Kdbedit(modo,coluna)

if modo=1
    return(1)
  elseif modo=2
    return(1)
  elseif modo=3
    return(0)
  elseif modo=4
     if lastkey() == 27
	 set softseek off
         PECAS()
         RESTSCREEN(00,00,24,79,FTELA)
         return(0)

       elseif lastkey()== 65 .OR. lastkey() == 97  && "A/a"
               SET CURSOR ON
               SETCOLOR("W+/BG,N/W")
               @07,16 CLEAR TO 09,41
               @07,16 TO 09,41 DOUBLE
               MOQTD=OQTD
               MOPRECO=OPRECO
               @ 08,17 SAY "QTD.:"GET MOQTD  PICT "99"
               @ 08,26 SAY "PRE€O:"GET MOPRECO PICT "9999.99"
               READ
               SETCOLOR("GR/B+")
               @ 07,16 CLEAR TO 09,40
               MOTOTAL=MOQTD*MOPRECO
               BLOQUEIO()
               REPLACE OTOTAL WITH MOTOTAL
               REPLACE OQTD WITH MOQTD
               REPLACE OPRECO WITH MOPRECO
               COMMIT
               UNLOCK
               INDEX ON OCODPECA TO OCODPECA
               MOTOTALG=0
               DO WHILE .NOT. EOF()
                   SEEK OCODPECA
                   MOTOTALG=OTOTAL+MOTOTALG
                   SKIP
               ENDDO
              @ 23,65 SAY MOTOTALG PICT "999999.99"

    elseif lastkey()== 07 && "DELETE"
          SET CURSOR ON
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
          USE &CAMINHO&MORCA SHARED
          IF EOF()
               PECAS()
               RESTSCREEN(00,00,23,79,FTELA)
               return(0)
          ENDIF    
          RETURN(2)

     ENDIF
ENDIF
RETURN(1) 

