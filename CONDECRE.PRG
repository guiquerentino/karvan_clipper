****************************************************************************

*******************/FUN€AO CONSULTA DEVOLUCOES E CREDITOS******************

SET CENT ON
DEVOLCRE()
ORDSETFOCUS("DATAB")
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT ('Nenhuma devolucao feita...')
ENDIF
*INDEX ON DATA TO DATA FOR DATA=DATE() .OR. EMPTY(BAIXA)
DO WHILE ! EOF()
        SKIP
ENDDO
SETCOLOR("GR/B+")
CLS
PRIVATE V1[10], V2[10], V3[10]

V1[01]="LEFT(NOMECLI,30)"
V1[02]="LEFT(NOMEPECA,30)"
V1[03]="QTD"
V1[04]="PRECO"
V1[05]="BAIXA"
V1[06]="CODNOT"
V1[07]="CODPECA"
V1[08]="DATA"
V1[09]="NOMEFUNC"
V1[10]="CREDITO"

V2[01]="@!"
V2[02]="@!"
V2[03]="999"
V2[04]="9999.99"
V2[05]="@!"
V2[06]="@!"
V2[07]="@!"
V2[08]="99/99/99"
V2[09]="@!"
V2[10]="9999999999"

V3[01]="CLIENTE"
V3[02]="PRODUTO"
V3[03]="QTD"
V3[04]="PRECO"
V3[05]="BAIXA"
V3[06]="PEDIDO"
V3[07]="COD.PECA"
V3[08]="DATA"
V3[09]="FUNC."
V3[10]="CREDITO"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[01] CLIENTE [02] PEDIDO [03] DATA ",78)

DBEDIT(01,00,21,79,v1,"GXDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function GXdbedit(modo,coluna)
if modo=1
    return(1)
  elseif modo=2
    return(1)
  elseif modo=3
    return(1)
  elseif modo=4
     if lastkey() == 27
	 set softseek off
          ACESSO=0
          DEVOLCEX()
          PACK
	  return(0)
     elseif lastkey()== 07 && "DELETE"
          SET CURSOR ON
          IF ACESSO#1
                RETURN(2)
          ENDIF
          MCREDITO=CREDITO
          MQTD=QTD
          MPRECO=PRECO
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF                
          PAGAMENTO()
          ORDSETFOCUS("CODIGO")
          SEEK MCREDITO
          IF FOUND()
                BLOQUEIO()
                REPLACE VALOR WITH VALOR-MPRECO*MQTD
                IF VALOR<=0
                        DELETE
                ENDIF
                UNLOCK
          ENDIF
          DEVOLCRE()
          RETURN(2)

        elseif lastkey()== 49 && "1"

          CLEAR GETS
          SET CURSOR ON
          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          ORDSETFOCUS("CODCLI")
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,26
          @ 17,10 TO 19,26 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
          READ
          SEEK MCODCLI
          IF FOUND()
                 MNOMECLI=NOMECLI
              ELSE
                 OL_Yield()
                 ALERT('CODIGO NAO ENCONTRADO')
          ENDIF
          CLEAR GETS
          SET CURSOR ON
          DEVOLCRE()
          ORDSETFOCUS("NOMECLI")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)          

        elseif lastkey()== 50 && "2"

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

        elseif lastkey()== 51 && "3"
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=DATE()
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "DATA:" GET V_BUSCA PICT "@d"
          READ
          ORDSETFOCUS("DATA")
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 52 && "4"
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA=0
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "CREDITO:" GET V_BUSCA PICT "9999999999"
          READ
          ORDSETFOCUS("CREDITO")
          SEEK V_BUSCA
          MVALOR=0
          DO WHILE CREDITO=V_BUSCA
                 MVALOR=PRECO+MVALOR
                 SKIP
          ENDDO
          TELA1=SAVESCREEN(10,10,12,76)
          @ 11,11 SAY "VALOR DO CREDITO:"
          @ 11,29 SAY  MVALOR PICT "9,999.99"
          INKEY(0)
          RESTSCREEN(10,10,12,76,TELA1)
          RETURN(2)
        elseif lastkey()== 66 .OR. lastkey() == 98 && "b/B"

          IF ACESSO=1
                RETURN(2)
          ENDIF
          CLEAR GETS
          BLOQUEIO()
          REPLACE BAIXA WITH "S"
          UNLOCK
          RETURN(2)
     ENDIF
ENDIF
RETURN(1)       
