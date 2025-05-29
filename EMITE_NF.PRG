************************************************************************

*****************************/FUN€AO EMITE NFE**************************

NTX=1
USE PEDIDO
ZAP
SET CENTURY ON
OP=3
CUPOM()
CLOSE INDEXES

GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhum Cupom emitido ate o momento...')
   RETURN(0)
ENDIF

SETCOLOR("GR/B+")

PRIVATE V1[7], V2[7], V3[7]

V1[01]="CODNOT"
V1[02]="NOTCLI"
V1[03]="NOTTOTG"
V1[04]="D_NOT"
V1[05]="NOTPAG"
V1[06]="HORANOT"
V1[07]="CNPJCLI"

V2[01]="999999999"
V2[02]="@!"   
V2[03]="9,999.99"
V2[04]="99/99/99"
V2[05]="@!"   
V2[06]="99:99"
V2[07]="@!"

V3[01]="N§ CUPOM"
V3[02]="NOME CLIENTE"
V3[03]="TOTAL"
V3[04]="DATA"
V3[05]="PAGAMENTO"
V3[06]="HORA"
V3[07]="DOC.CLIENTE"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [1] CODIGO [2] NOME CLIENTE [ENTER] SELECIONA ",78)

DBEDIT(01,00,21,79,v1,"xxBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function xxbedit(modo,coluna)
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
          CUPOM()

        ELSEIF LASTKEY()== 13 && "ENTER"

           NUNREG=RECNO()
           PUVARNOT()
           IGUAVANOT()
           PEDCUP()
           ORDSETFOCUS("PEDNUM")
           SEEK MCODNOT
           IF FOUND()
                   NUMREG=RECNO()
                ELSE
                   OL_Yield() 
                   ALERT('DELETE A NOTA, NAO TEM PECA CADASTRADA')
                   RETURN(.T.)
           ENDIF
           TOT=0
           DO WHILE .T.
                GOTO NUMREG
                IF PEDNUM=MCODNOT 
                        IF DELETED()
                                NUMREG++
                                LOOP
                        ENDIF
                        TOT++
                        MPEDCOD=PEDCOD
                        MPEDQTD=PEDQTD
                        MPRECO=PRECOCUP
                        MVERIFIC=VERIFIC
                        PECAS()
                        ORDSETFOCUS("CODPECA")
                        SEEK MPEDCOD
                        IF FOUND()
                                MNOMEPECA=NOMEPECA
                                MPUNIDAD=UNIDADE                                
                                MPRETOT=MPRECO*MPEDQTD
                                IF MVERIFIC <=1
                                        MFABRIC=FABRIC
                                        MNFABRIC=NFABRIC
                                        MCODBARRA=CODBARRA
                                ENDIF
                                IF MVERIFIC=2
                                        MFABRIC=FABRIC2
                                        MNFABRIC=NFABRIC2
                                        MCODBARRA=CODBARRA1
                                ENDIF
                                IF MVERIFIC=3
                                        MFABRIC=FABRIC3
                                        MNFABRIC=NFABRIC3
                                        MCODBARRA=CODBARRA2
                                ENDIF
                                IF MVERIFIC=4
                                        MFABRIC=FABRIC4
                                        MNFABRIC=NFABRIC4
                                        MCODBARRA=CODBARRA3
                                ENDIF
                                IF MVERIFIC=5
                                        MFABRIC=FABRIC5
                                        MNFABRIC=NFABRIC5
                                        MCODBARRA=CODBARRA4
                                ENDIF
                             ELSE
                                @ 10,10 CLEAR TO 12,18
                                @ 10,10 TO 12,28 DOUBLE
                                @ 11,11 SAY MPEDCOD
                                OL_Yield()
                                ALERT('CODIGO NAO EXISTE, VERIFIQUE O ERRO')
                                RETURN
                        ENDIF
                        USE PEDIDO
                        APPEND BLANK
                        REPLACE PCODPEC   WITH MPEDCOD
                        REPLACE PQTDPEC   WITH MPEDQTD
                        REPLACE PNOMPEC   WITH MNOMEPECA
                        REPLACE PPREPEC   WITH MPRECO
                        REPLACE PFABRIC   WITH MFABRIC
                        REPLACE PNFABRIC  WITH MNFABRIC
                        REPLACE PPRETOT   WITH MPRETOT
                        REPLACE PUNIDAD   WITH MPUNIDAD
                        REPLACE MCODBARRA WITH BARRAS
                        PEDCUP()
                        NUMREG++
                    ELSE
                       EXIT
                ENDIF
          ENDDO
          CUPOM()
          IF NTX=1
		ORDSETFOCUS("CODNOT")
	      ELSE
		ORDSETFOCUS("NOTCLI")
	  ENDIF
          REST SCREEN FROM FTELA
	  GOTO NUNREG
          RETURN(2)


       elseif lastkey()== 49 && "1"
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
	  NTX=1 
	  RETURN(2)

    elseif lastkey()== 50 && "2"

          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,24
          @ 17,10 TO 19,24 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "999"
          READ
          IF MCODCLI=0
                CONCLI1()
          ENDIF
          ORDSETFOCUS("CODCLI")
          SEEK MCODCLI
          IF FOUND()
                 MNOMECLI=NOMECLI
              ELSE
                 OL_Yield()
                 ALERT('CODIGO NAO ENCONTRADO')
          ENDIF
          CUPOM()
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

    elseif lastkey()== 53 && "7"

          ORDSETFOCUS("CNPJCLI")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          CLEAR GETS
          MOP=1
          OK=.f.
          CNPJ=SPACE(18)
          @ 23,02 CLEAR TO 23,70
          @ 10,10 CLEAR TO 14,36
          @ 10,10 TO 14,36 DOUBLE
          @ 11,12 PROMPT "1-CPF.." MESS "DIGITE O CPF DO CONSUMIDOR" 
          @ 12,12 PROMPT "2-CNPJ." MESS "DIGITE O CNPJ DA EMPRESA" 
          MENU TO MOP
          DO CASE
                CASE MOP == 1
                       DO WHILE OK=.f.
                               @ 13,12 SAY "CPF.:" GET CNPJ PICT "999.999.999-99" 
                               READ
                               IF LASTKEY()=27
                                       CNPJ=SPACE(18)
                                       EXIT
                               ENDIF
                               TESTA_CPF()
                       ENDDO
                CASE MOP == 2
                       DO WHILE OK=.f.
                               @ 13,12 SAY "CNPJ:" GET CNPJ PICT "99.999.999/9999-99"
                               READ 
                               IF LASTKEY()=27
                                       CNPJ=SPACE(18)
                                       EXIT
                               ENDIF
                               TESTA_CNPJ()
                       ENDDO
          ENDCASE
          READ
          SEEK CNPJ
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

      ENDIF
     ENDIF
RETURN(1)
****

