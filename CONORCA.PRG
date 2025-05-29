******************************************************************************

*****************************/FUN€AO CONSULTA ORCAMENTO***********************

SET CENTURY ON
SET DELETE ON
OP=3
ORCA()
CLOSE INDEXES
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhum orcamento emitido ate o momento...')
   RETURN(0)
ENDIF


SETCOLOR("GR/B+")
IF ACESSO =0
      PRIVATE V1[6], V2[6], V3[6]
   ELSE   
      PRIVATE V1[8], V2[8], V3[8]
      V1[07]="PCUSTO"
      V2[07]="999,999.99"
      V3[07]="PCUSTO"
      V1[08]="(NOTTOTG/PCUSTO-1)*100"
      V2[08]="999.99%"
      V3[08]="LUCRO"
ENDIF      

V1[01]="CODNOT"
V1[02]="NOTCLI"
V1[03]="NOTTOTG"
V1[04]="NOTFUNC"
V1[05]="D_NOT"
V1[06]="HORANOT"

V2[01]="999999999"
V2[02]="@!"
V2[03]="999,999.99"
V2[04]="@!"
V2[05]="99/99/9999"
V2[06]="99:99"

V3[01]="ORCAMENTO"
V3[02]="NOME CLIENTE"
V3[03]="TOTAL GERAL"
V3[04]="FUNCIONARIO"
V3[05]="DATA PEDIDO"
V3[06]="HORA NOTA"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [1] CODIGO [2] NOME CLIENTE [ENTER] SELECIONA ",78)

DBEDIT(01,00,21,79,v1,"HDBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function HDbedit(modo,coluna)
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
         ORCA()

       ELSEIF LASTKEY()= 13 && "ENTER"
          IF ACESSO#1
              RETURN(2)
          ENDIF
          SETCOLOR("W+/BG,N/W")
          PUVARNOT()
          IGUAVANOT()
          @ 03,07 CLEAR TO 19,67
          @ 03,07 TO 19,67 DOUBLE
          @ 03,11 SAY "CONSULTA ORCAMENTO"
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTENOT()
          INKEY(0)
          RETURN(2)

       elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"

          SAVE SCREEN TO FTELA
          PUVARNOT()
          IGUAVANOT()
          REIMORCA()
          ORCA()
          REST SCREEN FROM FTELA
          RETURN(2)

       elseif lastkey()== 65 .OR. lastkey() == 97  && "A/a"
          SETCOLOR("W+/BG,N/W")
          SET CURSOR ON
          PUVARNOT()
          IGUAVANOT()
          @ 03,07 CLEAR TO 19,67
          @ 03,07 TO 19,67 DOUBLE
          @ 03,11 SAY "ALTERA ORCAMENTO"
          VTOTG=NOTTOTG
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTENOT()
          READ
          IF UPDATED()
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                 REPLNOT()
              ENDIF
          ENDIF
          RETURN(2)

       elseif lastkey()== 49 && "1"
          ORCA()
          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=0
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,40
          @ 03,20 TO 05,40 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
	      READ
	      SEEK V_BUSCA
	      IF EOF()
             SKIP-1
             RETURN(1)
	      ENDIF
	      RETURN(2)

                 
    elseif lastkey()== 50 && "2" 
          ORCA()
          ORDSETFOCUS("NOTCLI")
          *SET INDEX TO NOTCLI
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,65
          @ 03,20 TO 05,65 DOUBLE
          @ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

    elseif lastkey()== 51 && "3"
          ORCA()
          ORDSETFOCUS("NOTFUNC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,55
          @ 03,20 TO 05,55 DOUBLE
          @ 04,22 SAY "FUNCIONARIO:" GET V_BUSCA PICT "@!"
	      READ
	      SEEK V_BUSCA
	      IF EOF()
             SKIP-1
             RETURN(1)
	     ENDIF
	     RETURN(2)
     
       elseif lastkey()== 52 && "4"

          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,65
          @ 03,20 TO 05,65 DOUBLE
          @ 04,22 SAY "Cliente:" GET V_BUSCA PICT "@!"
          READ
          IF EMPTY(V_BUSCA)
                ORDSETFOCUS("NOTCLI")
              ELSE
                INDEX ON NOTCLI TO TEMP FOR RTRIM(V_BUSCA) $ NOTCLI
          ENDIF
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

      ENDIF
     ENDIF
RETURN(1)
****
