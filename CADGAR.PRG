******************************************************************************

*****************************/FUN€AO CADASTRO GARANTIA\***********************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF
CONPEC=0
GARANTIA()

DO WHILE .T.
   @ 04,12 CLEAR TO 22,76
   @ 04,12 TO 22,76 DOUBLE
   NFABRQTD=0
   MCODBARRA=SPACE(20)
   MCODCLI=0
   MCODPECA=SPACE(05)
   MDIGITO=SPACE(02)
   PUVARGA()
   INIVARGA()
   CLEAR GETS
   SETCOLOR("W+/BG,N/W")
   @ 03,27 SAY "³    CADASTRO DE GARANTIA   ³"
   SET KEY -40 TO CONCLI1() // F11
   @ 05,13 SAY "Cliente.......:"  GET MCODCLI PICT "9999"
   READ
   IF MCODCLI=0
        CONCLI1()
   ENDIF
   CLIENTES()
   ORDSETFOCUS("CODCLI")
   SEEK MCODCLI
   IF LASTKEY()=27
           SET KEY -40 TO OTARIOS() // F11
           RETURN
   ENDIF
   IF FOUND()
        MGARCLI=NOMECLI
        MPONTO=P1
        MT_MOTO=T_MOTO
        MENDCLI=ENDCLI
        MCODNOT=99999990
        MKM=KM
        @ 05,29 SAY MGARCLI
     ELSE
     OL_Yield()
       ALERT('CLIENTE NAO CADASTRADO')
   ENDIF
   MGARVEN=FUNCIONARIO
   SET KEY -41 TO CONPEC() // F12
   @ 07,13 SAY "Vendedor......:" GET MGARVEN PICT "@!"
   CLEAR GETS
   @ 09,13 SAY "Codigo Barra..:" GET MCODBARRA PICT "@!"
   READ
   TESTACOD(MCODBARRA)
   IF TECLA="S"
             MCODBARRA=SPACE(20)
             MCODPECA=ALLTRIM(VARIA)
             MDIGITO=ALLTRIM(VARDIG)
   ENDIF 
   IF LASTKEY()=27
           SET KEY -40 TO OTARIOS() // F11
           RETURN
   ENDIF
   PECAS()
   ORDSETFOCUS("CODBARRA")
   SEEK MCODBARRA
   BARRA=1
   IF ! FOUND() .AND. MCODBARRA # SPACE(20)
                    ORDSETFOCUS("CODBARRA1")
                    SEEK MCODBARRA
                    BARRA=2
                    IF ! FOUND() 
                         ORDSETFOCUS("CODBARRA2")
                         SEEK MCODBARRA
                         BARRA=3
                         IF ! FOUND()
                             ORDSETFOCUS("CODBARRA3")
                             SEEK MCODBARRA
                             BARRA=4
                             IF ! FOUND()
                                 ORDSETFOCUS("CODBARRA4")
                                 SEEK MCODBARRA
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
             @ 09,13 CLEAR TO 09,60
             @ 09,13 SAY "Aplica‡„o.....:" GET MCODPECA PICT "@!"
             @ 09,34 SAY "-"
             @ 09,35 GET MDIGITO PICT "99"
             IF TECLA="N"
                       READ
                   ELSE
                       CLEAR GETS
             ENDIF
             ORDSETFOCUS("CODPECA")
             SEEK MCODPECA
             BARRA=VAL(SUBSTR(MDIGITO,2,1))
             IF ! FOUND()
                        TONE(200,26)
                        OL_Yield()
                        ALERT ('CODIGO NÇO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                        LOOP
             ENDIF
             IF MDIGITO#DIGITO .OR. BARRA > 5
             OL_Yield()
                         ALERT('DIGITO VERIFICADOR INCORRETO')
                         LOOP
             ENDIF
   ENDIF
   IF LASTKEY()=27
           SET KEY -40 TO OTARIOS() // F11
           RETURN
   ENDIF
   SET KEY -41 TO OTARIOS()
   ORDSETFOCUS("CODPECA")
   SEEK MCODPECA
   MTRAVA=TRAVA
   MTEMPUNI=TEMPUNI
   IF TRAVA="A"
   OL_Yield()
            ALERT('PRODUTO SENDO ALTERADO EM OUTRO TERMINAL; IMPOSSIVEL FAZER GARANTIA, AGUARDE!!!')
            LOOP
   ENDIF      
   IF ! EMPTY(MTEMPUNI) .AND. MTEMPUNI # "N"
   OL_Yield()
            ALERT('ATENÇÃO NA QUANTIDADE DIGITADA!!!')
   ENDIF         
   IF BARRA<=1
           MGARNFAB=NFABRIC
           MGARFABR=FABRIC
   ENDIF
   IF BARRA=2
           MGARNFAB=NFABRIC2
           MGARFABR=FABRIC2
   ENDIF
   IF BARRA=3
           MGARNFAB=NFABRIC3
           MGARFABR=FABRIC3
   ENDIF
   IF BARRA=4
           MGARNFAB=NFABRIC4
           MGARFABR=FABRIC4
   ENDIF
   IF BARRA=5
           MGARNFAB=NFABRIC5
           MGARFABR=FABRIC5
   ENDIF
   IF FOUND()
        MGARPECA=NOMEPECA
        MGARCOD=CODPECA
        MDISTRIB=DISTRIB
        MDISTRIB2=DISTRIB2
        MDISTRIB3=DISTRIB3
        MDISTRIB4=DISTRIB4
     ELSE
     OL_Yield()
        ALERT('PECA NAO CADASTRADA...')
        LOOP
   ENDIF
   @ 09,29 SAY MGARPECA
   @ 11,13 SAY "Fabricante....:"
   @ 11,29 SAY MGARFABR
   @ 13,13 SAY "N§ Fabricante.:"
   @ 13,29 SAY MGARNFAB
   @ 15,13 SAY "Quantidade....:" GET MGARQTD PICT  "999" VALID MGARQTD >0
   @ 17,13 SAY "Data Entrega..:" GET MGARDATA PICT "@D"      
   @ 19,13 SAY "Defeito.......:" GET MGARDEF1 PICT  "@!"
   @ 20,29 GET MGARDEF2 PICT  "@!"
   READ
   MTEMPUNI=TEMPUNI
   DO WHILE MTEMPUNI="S"
                  SETCOLOR("W+/R,N/W")
                   @ 10,20 CLEAR TO 15,60
                   @ 10,20 TO 15,60 DOUBLE
                   @ 12,22 SAY "VERIFIQUE SE A QUANTIDADE DIGITADA"
                   @ 13,22 SAY "ESTA CORRETA E PRESSIONE A LETRA 'S'"
                   INKEY(0)
                   IF lastkey()== 83 .OR. lastkey() == 115 && "s/S"
                         SETCOLOR("W+/BG,N/W")
                         EXIT
                   ENDIF
   ENDDO     
   IF LASTKEY()=27
           SET KEY -40 TO OTARIOS() // F11
           RETURN
   ENDIF
   GARANTIA()
   IF UPDATED()
      IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
            APPEND BLANK
            MDATAENVIO=DATE()
            MHORAGAR=TIME()
            REPLGAR()
            PECAS()
            ORDSETFOCUS("CODPECA")
            SEEK MCODPECA
            BLOQUEIO()
            MQTD=QTD-MGARQTD
            DISTRIBQTD=MGARQTD
            IF BARRA<=1
                      REPLACE QTD2 WITH QTD2-MGARQTD
            ENDIF     
            IF BARRA=2
                      IF QTD3>=MGARQTD
                            REPLACE QTD3 WITH QTD3-MGARQTD

                         ELSE
                            REPLACE QTD3 WITH 0
                            REPLACE QTD2 WITH QTD2-MGARQTD   
                      ENDIF      
            ENDIF     
            IF BARRA=3
                      IF QTD4>=MGARQTD
                            REPLACE QTD4 WITH QTD4-MGARQTD
                         ELSE
                            MGARQTD=MGARQTD-QTD4
                            REPLACE QTD4 WITH 0
                            REPLACE QTD2 WITH QTD2-MGARQTD   
                      ENDIF      
            ENDIF     
            IF BARRA=4
                      IF QTD5>=MGARQTD
                            REPLACE QTD5 WITH QTD5-MGARQTD
                         ELSE
                            MGARQTD=MGARQTD-QTD5
                            REPLACE QTD5 WITH 0
                            REPLACE QTD2 WITH QTD2-MGARQTD   
                      ENDIF      
            ENDIF     
            IF BARRA=5
                      IF QTD6>=MGARQTD
                            REPLACE QTD6 WITH QTD6-MGARQTD
                         ELSE
                            MGARQTD=MGARQTD-QTD6
                            REPLACE QTD6 WITH 0
                            REPLACE QTD2 WITH QTD2-MGARQTD   
                      ENDIF      
            ENDIF
            REPLACE QTD WITH MQTD
            REPLACE ATUALIZADO WITH "S"
            IF QTD_C>0
               XMQTD=DISTRIBQTD
               DO WHILE QTD_P>0 .AND. XMQTD>0
                       REPLACE QTD_P WITH QTD_P-1
                       XMQTD--
               ENDDO                
               IF XMQTD>0
                       REPLACE QTD_E WITH QTD_E-XMQTD
               ENDIF        
            ENDIF
            SAIDISTRIB()
            MQTD=MQTD+TEMP
            COMMIT
            UNLOCK
            GARANTIA()
            IMPRI_GAR()
            IF CONFIRMA('DESEJA CADASTRA ENTREGA ?')=1
                    ENTREGA()
                    BLOQUEIO()
                    APPEND BLANK
                    REPLACE ENTREGAS WITH "GARANTIA "+LEFT(MGARCLI,36)
                    REPLACE PONTO    WITH MPONTO
                    REPLACE ENDERECO WITH MENDCLI
                    REPLACE CODIGO   WITH MCODNOT
                    REPLACE HORA     WITH TIME()
                    REPLACE KM       WITH MKM
                    REPLACE T_MOTO   WITH MT_MOTO
                    UNLOCK
                    TESTAPONTO()
            ENDIF
            RETURN
      ENDIF
   ENDIF
  EXIT
ENDDO
