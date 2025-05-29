
******************************************************************************
SET DELETED ON
SELE 1
DEVOLU()
SELE 2
PEDCUP()
SELE 3
CUPOM()
SELE 4
PECAS()
SELE 5
CLIENTES()

SELE 1
CLOSE INDEXES

GOTO BOTTOM
SETCOLOR("GR/B+")
PRIVATE V1[13], V2[13], V3[13]

V1[01]="DCODNOT"
V1[02]="DNOMECLI"
V1[03]="LEFT(DNOMEPECA,30)"
V1[04]="DCODPECA"
V1[05]="DQTD"
V1[06]="DDATA"
V1[07]="DDTNOT"
V1[08]="DPRECO"
V1[09]="DNOTTOTAL"
V1[10]="DHORA"
V1[11]="BAIXA"
V1[12]="DFUNC"
V1[13]="NOTFUNC"

V2[01]="999999999"
V2[02]="@!"
V2[03]="@!"
V2[04]="@!"
V2[05]="999"
V2[06]="99/99/99"
V2[07]="99/99/99"
V2[08]="9,999.99"
V2[09]="9,999.99"
V2[10]="99:99"
V2[11]="@!"
V2[12]="@!"
V2[13]="@!"

V3[01]="CUPOM"
V3[02]="CLIENTE"
V3[03]="PE€A"
V3[04]="CODIGO"
V3[05]="QTD"
V3[06]="DATA"
V3[07]="D.NOTA"
V3[08]="PRECO"
V3[09]="VALOR"
V3[10]="HORA"
V3[11]="B"
V3[12]="DEV_FUNC"
V3[13]="NOT_FUNC"

@ 03,00 TO 21,79 DOUBLE


DBEDIT(04,01,20,78,v1,"LDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Ldbedit(modo,coluna)
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
        elseif lastkey()== 07 && "DELETE"

                IF ACESSO#1
                OL_Yield() 
                     ALERT('ACESSO NAO AUTORIZADO')
                     RETURN(0)
                ENDIF
                MVERIFIC=0
                MCODNOT=DCODNOT
                MD_NOT=DDTNOT
                MQTD=DQTD
                MCODPECA=DCODPECA
                BLOQUEIO()
                REPLACE BAIXA WITH "S"
                DELETE
                UNLOCK
                SET DELETED OFF
                SELE 2
                SET DELETED OFF
                ORDSETFOCUS("PEDNUM")
                SEEK MCODNOT
                VALOR=0
                DO WHILE PEDNUM=MCODNOT
                        IF DELETED() .AND. PEDCOD="88888"
                                BLOQUEIO()
                                VALOR=VALOR+(PRECOCUP*PEDQTD)
                                RECALL
                                UNLOCK
                        ENDIF
                        IF PEDCOD=MCODPECA 
                                IF ! DELETED()
                                        BLOQUEIO()      
                                        MVERIFIC=VERIFIC
                                        REPLACE PEDQTD WITH PEDQTD+MQTD
                                        VALOR=VALOR+(PRECOCUP*MQTD)
                                        UNLOCK
                                    ELSE
                                        BLOQUEIO()
                                        MVERIFIC=VERIFIC
                                        VALOR=VALOR+(PRECOCUP*MQTD)
                                        RECALL
                                        UNLOCK
                                ENDIF
                        ENDIF
                        SKIP
                ENDDO   
                IF MVERIFIC=0
                        ALERT("IMPOSSIVEL RETORNAR ESTOQUE")
                        RETURN(0)
                ENDIF
                SELE 3
                ORDSETFOCUS("CODNOT")
                SEEK MCODNOT
                IF MCODNOT=CODNOT
                        IF DELETED()
                                BLOQUEIO()
                                RECALL
                                REPLACE NOTTOTG WITH VALOR
                                UNLOCK
                             ELSE
                                BLOQUEIO()
                                REPLACE NOTTOTG WITH NOTTOTG+VALOR
                                UNLOCK
                        ENDIF
                ENDIF
                SELE 4 
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
                BLOQUEIO()
                REPLACE QTD WITH QTD-MQTD
                IF MVERIFIC<=1
                                REPLACE QTD2 WITH QTD2-MQTD
                ENDIF     
                IF MVERIFIC=2
                                 REPLACE QTD3 WITH QTD3-MQTD
                ENDIF     
                IF MVERIFIC=3
                                 REPLACE QTD4 WITH QTD4-MQTD
                ENDIF     
                IF MVERIFIC=4
                                 REPLACE QTD5 WITH QTD5-MQTD
                ENDIF     
                IF MVERIFIC=5
                                 REPLACE QTD6 WITH QTD6-MQTD
                ENDIF                                         
                DIA1=DAY(DATE())
                DIA2=DAY(DATE()-DIA1)
                DIA3=DAY(DATE()-DIA1-DIA2)
                IF CMONTH(MD_NOT)=CMONTH(DATE())
                        REPLACE QTDMAX WITH QTDMAX+MQTD
                    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1)
                        REPLACE QTDMAX1 WITH QTDMAX1+MQTD
                    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1-DIA2)
                        REPLACE QTDMAX2 WITH QTDMAX2+MQTD
                    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1-DIA2-DIA3)
                        REPLACE QTDMAX3 WITH QTDMAX3+MQTD
                ENDIF
                UNLOCK
                DISTRIBQTD=MQTD
                SAIDISTRIB()
                OL_Yield()
                *SELE 1
                *ORDSETFOCUS("DCODNOT")
                *SEEK MCODNOT
                *BLOQUEIO()
                *DELETE
                *UNLOCK
                SET DELETED ON
                ALERT('CANCELADO O CANCELAMENTO !!!')
                RETURN(0)

        elseif lastkey() == 65 .OR. lastkey()== 97 && "a/A"

                IF ACESSO#1
                OL_Yield()
                     ALERT('ACESSO NAO AUTORIZADO')
                     RETURN(0)
                ENDIF
                @ 03,07 CLEAR TO 10,67
                @ 03,07 TO 10,67 DOUBLE
                SET CENT ON
                MDNOMECLI=DNOMECLI
                MBAIXA=BAIXA
                MDDATA=DDATA
                @ 05,08 SAY "CLIENTE:" GET MDNOMECLI PICT "@!"
                @ 07,08 SAY "BAIXA..:" GET MBAIXA PICT "@!"
                @ 09,08 SAY "DATA...:" GET MDDATA PICT "99/99/9999"
                READ
                BLOQUEIO()
                REPLACE BAIXA    WITH MBAIXA
                REPLACE DNOMECLI WITH MDNOMECLI
                REPLACE DDATA    WITH MDDATA
                UNLOCK
                RETURN(2)

	elseif lastkey()== 49 && "1" 
           SET CURSOR ON
           CLEAR GETS
           ORDSETFOCUS("DCODNOT")
           SET SOFTSEEK ON
           SETCOLOR("W+/BG,N/W")
           V_BUSCA:=0
           SET CURSOR ON
           @ 03,20 CLEAR TO 05,39
           @ 03,20 TO 05,39 DOUBLE
           @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
           READ
           SEEK V_BUSCA
           IF EOF()
               SKIP-1
               RETURN(1)
           ENDIF
           RETURN(2)

        elseif lastkey()== 50 && "2"

          MCODCLI=0
          MNOMECLI=SPACE(35)
          SELE 5
          ORDSETFOCUS("CODCLI")
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,25
          @ 17,10 TO 19,25 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
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
          SELE 1
          ORDSETFOCUS("DNOMECLI")
          DBSEEK(MNOMECLI,.T.,.T.)
           IF EOF()
               SKIP-1
               RETURN(1)
           ENDIF
           RETURN(2)

        elseif lastkey()== 51 && "3" 
           SET CURSOR ON
           CLEAR GETS
           ORDSETFOCUS("DCODPECA")
           SET SOFTSEEK ON
           SETCOLOR("W+/BG,N/W")
           V_BUSCA:=SPACE(05)
           SET CURSOR ON
           @ 03,20 CLEAR TO 05,34
           @ 03,20 TO 05,34 DOUBLE
           @ 04,22 SAY "PECA.:" GET V_BUSCA PICT "99999"
           READ
           DBSEEK (V_BUSCA,.T.,.T.)
           IF EOF()
               SKIP-1
               RETURN(1)
           ENDIF
           RETURN(2)

        elseif lastkey()== 16 && "CTRL+P"

           NUMREG=LASTREC()
           GOTO NUMREG
           LIN=3
           SET DEVICE TO PRINT
           *Printer()
           @ LIN,01 SAY "DEVOLUCOES"
           LIN++
           LIN++
           DO WHILE ! BOF()
                  MCODPECA=DCODPECA
                  IF EMPTY(IMPRIME)
                          BLOQUEIO()
                          REPLACE IMPRIME WITH "S"
                          UNLOCK
                          SELE 4
                          ORDSETFOCUS("CODPECA")
                          SEEK MCODPECA
                          IF FOUND()
                                MNOMEPECA=NOMEPECA
                                MQTD=QTD+TEMP
                                MNFABRIC=NFABRIC
                                MNFABRIC2=NFABRIC2
                                MNFABRIC3=NFABRIC3
                                MLOCAL=LOCAL
                          ENDIF
                      ELSE
                      OL_Yield()
                          ALERT('DEVOLUCOES IMPRESSAS')
                          LIN++
                          LIN++
                          LIN++
                          @ LIN,01 SAY " "                       
                          @ PROW(),00 SAY CHR(27)+chr(109)
                          LIN=0
                          SET DEVICE TO SCREEN
                          RETURN(0)
                  ENDIF
                  @ LIN,00 SAY MQTD PICT "999"
                  @ LIN,04 SAY LEFT(MNOMEPECA,35)
                  LIN++
                  @ LIN,00 SAY MNFABRIC
                  @ LIN,14 SAY MNFABRIC2
                  @ LIN,27 SAY MNFABRIC3
                  IF ! EMPTY(MLOCAL)
                        LIN++
                        @ LIN,00 SAY MLOCAL
                  ENDIF
                  LIN++
                  @ LIN,00 SAY PADC ("-------------------------------",40)
                  LIN++
                  NUMREG--
                  SELE 1
                  GOTO NUMREG
           ENDDO
           SELE 1
           LIN++
           LIN++
           LIN++
           @ LIN,01 SAY " "                       
           @ PROW(),00 SAY CHR(27)+chr(109)
           LIN=0
           SET DEVICE TO SCREEN
           RETURN(2)

        ENDIF
ENDIF
RETURN(1)
