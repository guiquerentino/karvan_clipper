******************************************************************************

*****************************/FUN€AO CONSULTA PEDIDO**************************
NTX=1
SET CENTURY ON
OP=3
PEDCUP()
CLOSE INDEXES

GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhum Cupom emitido ate o momento...')
   RETURN(0)
ENDIF


SETCOLOR("GR/B+")
      PRIVATE V1[3], V2[3], V3[3]
V1[01]="PEDCOD"
V1[02]="PEDNUM"
V1[03]="DATACUP"

V2[01]="999999999"
V2[03]="99/99/9999"   
V2[02]="999999999"

V3[01]="PECA"
V3[02]="PEDIDO"
V3[03]="DATA"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [1] CODIGO [2] NOME CLIENTE [ENTER] SELECIONA ",78)

DBEDIT(01,00,21,79,v1,"DDBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function DDbedit(modo,coluna)
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
          PEDCUP()

       ELSEIF LASTKEY()= 13 && "ENTER"
          IF ACESSO#1
              RETURN(2)
          ENDIF
          SETCOLOR("W+/BG,N/W")
          PUVARNOT()
          IGUAVANOT()
          @ 03,07 CLEAR TO 19,67
          @ 03,07 TO 19,67 DOUBLE
          @ 03,11 SAY "CONSULTA CUPOM PEDIDO"
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTENOT()
          INKEY(0)
          RETURN(2)

       elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"

          SAVE SCREEN TO FTELA
          NUNREG=RECNO()
      	  PUVARNOT()
          IGUAVANOT()
          REIMCUPO()
          PEDCUP()
          IF NTX=1
		ORDSETFOCUS("CODNOT")
	      ELSE
		ORDSETFOCUS("NOTCLI")
	  ENDIF
          REST SCREEN FROM FTELA
	  GOTO NUNREG
          RETURN(2)

      elseif lastkey()== -5   && "F6 VENDA FISCAL"

               CONTROLE=RECNO()
               PUVARNOT()
               IGUAVANOT()
	       F6=".T."               
               FISCAL()
               MFISCAL=FISCAL
               MFISCALAPK=FISCALAPK
               DO WHILE MFISCAL<-1
                       FISCAL()
                       MFISCAL=FISCAL
                       OL_Yield()
                       ALERT('IMPRESSORA EM USO, AGUARDE')
                       F6=".F."
                       PEDCUP()
                       IF NTX=1
                                ORDSETFOCUS("CODNOT")
                              ELSE
                                ORDSETFOCUS("NOTCLI")
                       ENDIF
                       REST SCREEN FROM FTELA
                       GOTO CONTROLE
                       RETURN(2)
               ENDDO
               MFISCAL=-999
               FISCAL()
               BLOQUEIO()
               REPLACE FISCAL WITH MFISCAL
               UNLOCK     
               IMP_CUPOM()               
	       F6=".F."
               PEDCUP()
               IF NTX=1
                        ORDSETFOCUS("CODNOT")
                      ELSE
                        ORDSETFOCUS("NOTCLI")
               ENDIF
               REST SCREEN FROM FTELA
               GOTO CONTROLE
               RETURN(2)

       elseif lastkey()== 65 .OR. lastkey() == 97  && "A/a"

                MDATA=DATACUP
                @ 01,01 GET MDATA PICT "99/99/9999"
                READ
                BLOQUEIO()
                REPLACE DATACUP WITH MDATA
                UNLOCK
                RETURN(2)

       elseif lastkey()== 49 && "1"

          ORDSETFOCUS("PEDNUM")
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
	  NTX=1 
	  RETURN(2)

    elseif lastkey()== 50 && "2"

          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          ORDSETFOCUS("CODCLI")
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,24
          @ 17,10 TO 19,24 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "999"
          READ
          ORDSETFOCUS("CODCLI")
          SEEK MCODCLI
          IF FOUND()
                 MNOMECLI=NOMECLI
              ELSE
                 OL_Yield()
                 ALERT('CODIGO NAO ENCONTRADO')
          ENDIF
          PEDCUP()
          ORDSETFOCUS("NOTCLI")
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
	  NTX=2
          RETURN(2)

                 
    elseif lastkey()== 51 && "3" 
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
	  NTX=2
          RETURN(2)

    elseif lastkey()== 52 && "4"
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
       elseif lastkey()== 54 && "6"
             CLEAR GETS
             @ 03,20 CLEAR TO 05,65
             @ 03,20 TO 05,65 DOUBLE
             V_BUSCA=0
             @ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "9999.00"
             READ
             INDEX ON NOTTOTG TO NOTTOTG
             SEEK V_BUSCA
             RETURN(2)
     
       elseif lastkey()== 53 && "5"
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

