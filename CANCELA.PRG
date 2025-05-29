IF ACESSO#1
OL_Yield() 
     ALERT('ACESSO NAO AUTORIZADO')
     RETURN(.T.)
ENDIF
SELE 1
PECAS()
SELE 4
CLIENTES()
SELE 6
DEVOLCRE()

MCODPECA=SPACE(05)
MCODBARRA=SPACE(20)
MDESCONTO=0
CENTO=1
MQTD=0         
MDIGITO=SPACE(2)
MCODCLI=0
CLEAR GETS
SETCOLOR("W+/R,GR/W")
SELE 1
@ 10,20 CLEAR TO 18,65
@ 10,20 TO 18,65 DOUBLE
@ 11,21 SAY "DIGITE O COD.BARRA....:" GET MCODBARRA PICT "@!"
READ
IF LASTKEY()=27
      RETURN
ENDIF      
TESTACOD(MCODBARRA)
MCODPECA=SPACE(05)
IF TECLA="S"
          MCODBARRA=SPACE(20)
          MCODPECA=ALLTRIM(VARIA)
          MDIGITO=ALLTRIM(VARDIG)
ENDIF
ORDSETFOCUS("CODBARRA")
SEEK MCODBARRA
BARRA=1
IF ! FOUND() .AND. MCODBARRA # SPACE(20)
                    ORDSETFOCUS("CODBARRA1")
                    SEEK MCODBARRA
                    MDIGITO=DIGITO
                    BARRA=2
                    IF ! FOUND() 
                         ORDSETFOCUS("CODBARRA2")
                         SEEK MCODBARRA
                         MDIGITO=DIGITO
                         BARRA=3
                         IF ! FOUND()
                             ORDSETFOCUS("CODBARRA3")
                             SEEK MCODBARRA
                             MDIGITO=DIGITO
                             BARRA=4
                             IF ! FOUND()
                                 ORDSETFOCUS("CODBARRA4")
                                 SEEK MCODBARRA
                                 MDIGITO=DIGITO
                                 BARRA=5
                                 IF ! FOUND()
                                      TONE(200,26)
                                      OL_Yield()    
                                      ALERT ('CODIGO NÇO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                                      NFABRQTD=1
                                  ENDIF
                             ENDIF     
                          ENDIF    
                    ENDIF
ENDIF

IF FOUND() .AND. TECLA="N" .AND. ! EMPTY(MCODBARRA)
          MCODPECA=CODPECA
ENDIF

IF EMPTY(MCODBARRA) .OR. EMPTY(MCODPECA)
        @ 11,21 CLEAR TO 11,64
        @ 11,21 SAY "DIGITE O N§ DA PE€AS..:" GET MCODPECA PICT "@!"
        *@ 11,50 SAY "-"
        *@ 11,51 GET MDIGITO PICT "99"        
        IF TECLA="S"
              CLEAR GETS
        ENDIF
        @ 13,21 SAY "DIGITE A QUANTIDADE...:" GET MQTD PICT "999" VALID MQTD > 0
        @ 15,21 SAY "DIGITE O N§ DO CLIENTE:" GET MCODCLI PICT "9999" 
        READ
        IF ! EMPTY(MDIGITO)
                  BARRA=VAL(SUBSTR(MDIGITO,2,1))  
        ENDIF
     ELSE
        @ 13,21 SAY "DIGITE A QUANTIDADE...:" GET MQTD PICT "999" VALID MQTD > 0
        @ 15,21 SAY "DIGITE O N§ DO CLIENTE:" GET MCODCLI PICT "9999" 
        READ
ENDIF
SELE 1
ORDSETFOCUS("CODPECA")
SEEK MCODPECA
IF ! FOUND()
OL_Yield()
          ALERT('CODIGO NAO CADASTRADO !!!')
          DO CANCELA
ENDIF               
MTEMPUNI=TEMPUNI
IF TRAVA="A"
OL_Yield()
        ALERT('PRODUTO SENDO ALTERADO EM OUTRO TERMINAL; IMPOSSIVEL CANCELAR, AGUARDE!!!')
        DO CANCELA
ENDIF      
IF ! EMPTY(MTEMPUNI) .AND. MTEMPUNI# "N"
OL_Yield()
           ALERT('ATENÇÃO NA QUANTIDADE DIGITADA!!!')
ENDIF         
IF LASTKEY()=27
           RETURN
ENDIF
IF MCODCLI#0
        SELE 4
        ORDSETFOCUS("CODCLI")
        SEEK MCODCLI
        IF FOUND()
                MNOMECLI=NOMECLI
             ELSE
                ALERT('CLIENTE NAO CADASTRADO')
                MCODCLI=0
        ENDIF
ENDIF
SELE 2
CUPOM()
SELE 3
PEDCUP()
*IF MCODCLI=0
                SAVE SCREEN TO FTELA
                SELE 2                
                ORDSETFOCUS("CODNOT")
                SELE 3
                ORDSETFOCUS("PEDCOD")
                @ 02,01 CLEAR TO 22,78
                @ 02,01 TO 22,78
                LIN1=05
                @ 03,03 SAY "PECA"
                @ 03,17 SAY "COD.NOTA"
                @ 03,30 SAY "CLIENTE"
                @ 03,68 SAY "DATA"
                NUMREG=LASTREC()
                DO WHILE ! BOF()
                            MDATACUP=DATACUP
                            @ LIN1,68 SAY MDATACUP
                            IF LASTKEY()=27
                                  RETURN(.T.)
                            ENDIF
                            SELE 3
                            GOTO NUMREG
                            MPEDNUM=PEDNUM                          
                            IF PEDCOD = MCODPECA 
                               IF ! DELETED()
                                   * IF EMPTY(MDIGITO)
                                   *        BARRA=VERIFIC
                                   * ENDIF
                                    MPEDCOD=PEDCOD
                                    MPEDNUM=PEDNUM
                                    MPEDQTD=PEDQTD
                                    MVERIFIC=VERIFIC
                                    SELE 1
                                    ORDSETFOCUS("CODPECA")
                                    SEEK MPEDCOD                         
                                    IF MVERIFIC=0
                                          MVERIFIC=1
                                    ENDIF           
                                    IF MVERIFIC<=1
                                           MPFABRIC=FABRIC
                                           MPNFABRIC=NFABRIC
                                    ENDIF
                                    IF MVERIFIC=2
                                            MPFABRIC=FABRIC2
                                            MPNFABRIC=NFABRIC2
                                    ENDIF
                                    IF MVERIFIC=3
                                            MPFABRIC=FABRIC3
                                            MPNFABRIC=NFABRIC3
                                    ENDIF
                                    IF MVERIFIC=4
                                            MPFABRIC=FABRIC4
                                            MPNFABRIC=NFABRIC4
                                    ENDIF
                                    IF MVERIFIC=5
                                            MPFABRIC=FABRIC5
                                            MPNFABRIC=NFABRIC5
                                    ENDIF
                                    SELE 2
                                    ORDSETFOCUS("CODNOT")
                                    SEEK MPEDNUM
                                    @ LIN1,03 SAY MPEDCOD
                                    @ LIN1,08 SAY "-"
                                    @ LIN1,09 SAY MVERIFIC
                                    @ LIN1,12 SAY MPEDQTD
                                    @ LIN1,15 SAY MPEDNUM

                                    @ LIN1,30 SAY NOTCLI
                                    VNOMECLI=NOTCLI
                                    @ LIN1,68 SAY D_NOT
                                    LIN1++
                                    @ LIN1,03 SAY MPFABRIC
                                    @ LIN1,15 SAY MPNFABRIC
                                    LIN1++
                                    SELE 6
                                    ORDSETFOCUS("CODNOT")
                                    SEEK MPEDNUM
                                    DO WHILE ! EOF()
                                        IF CODPECA=MPEDCOD
                                                SETCOLOR("W*/R,GR/W")
                                                @ LIN1-2,30 SAY VNOMECLI
                                                @ LIN1-2,26 SAY QTD PICT "999"
                                                SETCOLOR("W+/R,GR/W")
                                                EXIT
                                        ENDIF
                                        SKIP
                                    ENDDO
                                    IF MCODCLI=0
                                        INKEY(0)
                                    ENDIF
                                    IF MCODCLI#0
                                        IF MNOMECLI=VNOMECLI
                                                INKEY(0)
                                        ENDIF
                                    ENDIF
                                    CLOSE ALL
                                    SELE 6
                                    DEVOLCRE()
                                    SELE 1
                                    PECAS()
                                    SELE 4
                                    CLIENTES()
                                    SELE 2
                                    CUPOM()
                                    ORDSETFOCUS("CODNOT")                                   
                                    SELE 3
                                    PEDCUP()                                                 
                                    ORDSETFOCUS("PEDCOD")
                                    IF LASTKEY()=27
                                        EXIT
                                    ENDIF
                               ENDIF
                            ENDIF
                            NUMREG--
                            IF LIN1>=20
                                SETCOLOR("W+/R,GR/W")
                                @ 21,15 SAY "FIM DE PAGINA PRESIONE ENTER PARA CONTINUAR ..."
                                CLOSE ALL
                                *INKEY(0)
                                SELE 6
                                DEVOLCRE()
                                SELE 1
                                PECAS()
                                SELE 4
                                CLIENTES()
                                SELE 2
                                CUPOM()
                                ORDSETFOCUS("CODNOT")                                       
                                SELE 3
                                PEDCUP()                                                     
                                ORDSETFOCUS("PEDCOD")
                                IF LASTKEY()=27
                                        EXIT
                                ENDIF
                                SETCOLOR("W+/R,GR/W")
                                LIN1=5
                                @ 05,03 CLEAR TO 21,77
                            ENDIF
                            IF NUMREG=-1
                            OL_Yield()
                                  ALERT('CLIENTE NAO ENCONTRADO')
                                  RETURN
                            ENDIF
                ENDDO
                RESTORE SCREEN FROM FTELA
                @ 15,21 SAY "DIGITE O N§ DO PEDIDO.:" GET MPEDNUM PICT "999999999"
                SELE 2
                ORDSETFOCUS("CODNOT")
                SEEK MPEDNUM
                IF FOUND()
                        MNOTFUNC=NOTFUNC
                        MNOMECLI=NOTCLI
                        MD_NOT=D_NOT
                        CONFVALOR=NOTTOTG
                        MNOTTOTG=NOTTOTG
                        MNOTPAG=NOTPAG
                        MDESCONTO=DESCONTO
                        CENTO=(MNOTTOTG-MDESCONTO)/MNOTTOTG
                     ELSE
                     OL_Yield()
                        ALERT('CUPOM NAO ENCONTRADO')
                        RETURN(.T.)
                ENDIF
                SELE 3
                ORDSETFOCUS("PEDNUM")
                SEEK MPEDNUM
                DO WHILE ! EOF()
                        IF PEDNUM=MPEDNUM .AND. PEDCOD=MCODPECA
                                MPRECOCUP=PRECOCUP
                                EXIT
                            ELSE
                                SKIP
                        ENDIF
                ENDDO
*ENDIF


@ 10,20 CLEAR TO 18,65
@ 10,20 TO 18,65 DOUBLE
@ 11,21 SAY "N§ DO CUPOM.:"
@ 11,36 SAY MPEDNUM
@ 13,21 SAY "CLIENTE:"
@ 13,30 SAY MNOMECLI
@ 15,21 SAY "FABRIC.:"
@ 15,30 SAY MPFABRIC
@ 15,41 SAY "N.FABRIC:"
@ 15,52 SAY MPNFABRIC
@ 17,21 SAY "DATA :"
@ 17,28 SAY MD_NOT
@ 17,44 SAY "TOTAL :"
@ 17,50 SAY MNOTTOTG
IF CONFIRMA("DADOS CORRETOS...?") = 1

        ELSE
                RETURN
ENDIF
SELE 5
TRAVAPED()
MTRAVA=TRAVAPED
DO WHILE ! EMPTY(MTRAVA)
        OL_Yield()
        ALERT('AGUARDE A LIBERACAO E PRESSIONE ENTER')
        SELE 5
        TRAVAPED()
        MTRAVA=TRAVAPED
ENDDO
BLOQUEIO()
REPLACE TRAVAPED WITH "S"
DBCOMMIT()
UNLOCK

SELE 3
ORDSETFOCUS("PEDNUM")
SEEK MPEDNUM
DO WHILE PEDNUM=MPEDNUM
        IF PEDNUM=MPEDNUM .AND. PEDCOD=MCODPECA .AND. ! DELETED()
               IF PEDQTD < MQTD
               OL_Yield()
                       ALERT('QUANTIDADE PEDIDO INFERIOR AO CANCELAMENTO')
                       RETURN
               ENDIF
               IF PEDQTD=MQTD
                       MPRECO=PRECOCUP*MQTD
                       BLOQUEIO()
                       DELETE
                       DISTRIBQTD=MQTD
                       UNLOCK
                       DBCOMMIT()

                ENDIF
                IF PEDQTD>MQTD
                        MPRECO=PRECOCUP*MQTD
                        BLOQUEIO()
                        REPLACE PEDQTD WITH PEDQTD-MQTD
                        DISTRIBQTD=MQTD
                        DBCOMMIT()
                        UNLOCK
                ENDIF
                EXIT
        ENDIF
        SKIP
         
ENDDO
DBCOMMIT()

DO WHILE .T.
        ORDSETFOCUS("PEDNUM")
        SEEK MPEDNUM
        XQTD=0
        MNOTTOTG=0
        DO WHILE MPEDNUM=PEDNUM
              IF MPEDNUM=PEDNUM
                    XQTD++
                    MNOTTOTG=(PRECOCUP*PEDQTD)+MNOTTOTG
              ENDIF
              SKIP
        ENDDO
        IF XQTD=1
               SEEK MPEDNUM
               IF PEDCOD="88888"
                        BLOQUEIO()
                        DELETE
                        UNLOCK
                        XQTD--
                        DBCOMMIT()
               ENDIF
        ENDIF
        IF CONFVALOR#MNOTTOTG
                EXIT
             ELSE
                ALERT('VALOR INCORRETO FAVOR VERIFICAR')
                IF LASTKEY()=27
                        EXIT
                ENDIF
        ENDIF
ENDDO

SELE 2
ORDSETFOCUS("CODNOT")
SEEK MPEDNUM
IF FOUND()
        IF XQTD=0
                BLOQUEIO()
                DELETE
                UNLOCK
                DBCOMMIT()
           ELSE
                BLOQUEIO()
                MDESCONTO=MNOTTOTG-(MNOTTOTG/CENTO)
                MNOTTOTG=MNOTTOTG/CENTO
                REPLACE NOTTOTG  WITH MNOTTOTG
                REPLACE DESCONTO WITH MDESCONTO-(MDESCONTO*2)
                UNLOCK
                DBCOMMIT()
        ENDIF
ENDIF
SELE 8
ENVIADOS()
ORDSETFOCUS("CODNOT")
SEEK MPEDNUM
IF FOUND()
        IF XQTD=0
                BLOQUEIO()
                DELETE
                UNLOCK
                DBCOMMIT()
           ELSE
                BLOQUEIO()
                REPLACE NOTDESC  WITH MNOTTOTG
                REPLACE NOTTOTG  WITH MNOTTOTG+MDESCONTO
                IF TROCO>0
                        ALERT('REFAZER O TROCO NO CANHOTO')
                ENDIF
                UNLOCK
                DBCOMMIT()
        ENDIF
ENDIF
SELE 1
ORDSETFOCUS("CODPECA")
SEEK MPEDCOD
MNOMEPECA=NOMEPECA
BLOQUEIO()
DQTDPED=MQTD+QTD
REPLACE QTD WITH DQTDPED
IF QTD_C>0
        XMQTD=MQTD
        DO WHILE QTD_P<QTD_C .AND. XMQTD>0
                REPLACE QTD_P WITH QTD_P+1
                XMQTD--
        ENDDO                
        IF XMQTD>0
                REPLACE QTD_E WITH QTD_E+XMQTD
        ENDIF        
ENDIF
REPLACE ATUALIZADO WITH "S"
DBCOMMIT()
                     IF MVERIFIC<=1
                                REPLACE QTD2 WITH QTD2+MQTD
                                DBCOMMIT()
                     ENDIF     
                     IF MVERIFIC=2
                                      REPLACE QTD3 WITH QTD3+MQTD
                                      DBCOMMIT()
                     ENDIF     
                     IF MVERIFIC=3
                                      REPLACE QTD4 WITH QTD4+MQTD
                                      DBCOMMIT()
                     ENDIF     
                     IF MVERIFIC=4
                                      REPLACE QTD5 WITH QTD5+MQTD
                                      DBCOMMIT()
                     ENDIF     
                     IF MVERIFIC=5
                                      REPLACE QTD6 WITH QTD6+MQTD
                                      DBCOMMIT()
                     ENDIF                                          
REPLACE DATAENTR WITH DATE()
DBCOMMIT()
DIA1=DAY(DATE())
DIA2=DAY(DATE()-DIA1)
DIA3=DAY(DATE()-DIA1-DIA2)
IF CMONTH(MD_NOT)=CMONTH(DATE())
        REPLACE QTDMAX WITH QTDMAX-MQTD
        DBCOMMIT()
    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1)
        REPLACE QTDMAX1 WITH QTDMAX1-MQTD
        DBCOMMIT()
    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1-DIA2)
        REPLACE QTDMAX2 WITH QTDMAX2-MQTD
        DBCOMMIT()
    ELSEIF CMONTH(MD_NOT)=CMONTH(DATE()-DIA1-DIA2-DIA3)
        REPLACE QTDMAX3 WITH QTDMAX3-MQTD
        DBCOMMIT()
ENDIF
ENTRADISTRIB()
DQTDPED=DQTDPED+TEMP
UNLOCK
SELE 2 
ORDSETFOCUS("CODNOT")
SEEK MPEDNUM
IF FOUND()
		BLOQUEIO()
		REPLACE P_CUSTO WITH P_CUSTO-MP_CUSTO
                DBCOMMIT()
		UNLOCK                
ENDIF				
IF XQTD=0
        ENTREGA()
        ORDSETFOCUS("CODIGO")
        SEEK MPEDNUM
        IF FOUND()
                BLOQUEIO()
                DELETE
                UNLOCK
                DBCOMMIT()
        ENDIF
ENDIF
SELE 7
DEVOLU()
IF XQTD=0
      MNOTTOTG=0
ENDIF
APPEND BLANK
REPLACE DCODNOT   WITH MPEDNUM
REPLACE DNOMECLI  WITH MNOMECLI
REPLACE DFUNC     WITH FUNCIONARIO
REPLACE DCODPECA  WITH MPEDCOD
REPLACE DNOMEPECA WITH LEFT(MNOMEPECA,35)
REPLACE DDTNOT    WITH MD_NOT
REPLACE DDATA     WITH DATE()
REPLACE DHORA     WITH TIME()
REPLACE DQTD      WITH MQTD
REPLACE DPRECO    WITH MPRECOCUP
REPLACE DNOTTOTAL WITH MNOTTOTG
REPLACE NOTFUNC   WITH MNOTFUNC
DBCOMMIT()
SELE 5
BLOQUEIO()
REPLACE TRAVAPED WITH " "
DBCOMMIT()
UNLOCK
SELE 6
ORDSETFOCUS("CODNOT")
SEEK MPEDNUM
DO WHILE ! EOF()
        IF CODPECA=MPEDCOD
                BLOQUEIO()
                REPLACE BAIXA WITH "S"
                DBCOMMIT()
                UNLOCK
        ENDIF
        SKIP
ENDDO
CLOSE ALL
DO CANCELA
