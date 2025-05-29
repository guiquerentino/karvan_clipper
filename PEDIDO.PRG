*******************************************************************************

**************************FUNCAO CUPOM DE PEDIDO*******************************
   
    SET KEY -7 TO FORMAPAG() // F8
    SET KEY -6 TO FORMACRE() // F7

    MPCODPEC=SPACE(05)
    MDIGITO=SPACE(02)
    MPNOMPEC=SPACE(45)
    MPPREPEC=0
    MABATIMENTO=0
    TOTDESC=0
    CASCO="N"
    DESC=0
    DESC1="N"
    CRED1="N"
    VIA=1
    MTROCO=0
    MPQTDPEC=1
    MPPRETOT=0
    MVALENTREG=0
    MTAXA_DUPLA=1
    MPTOTG=0
    NFABRQTD=0
    CONFTAXA=SPACE(01)
    TOT=0
    QTDTOT=0
    MTOTPROD=0
    TOTPROD=0
    MQTDTOT=0
    PECAS()
    ORDSETFOCUS("CODPECA")
    SEEK "88888"
    VTAXA=PRECO

    PEDIDOEX()
    IF LASTREC()<=0
        ZAP
      ELSE
        ALERT("EXISTE ARQUIVO ABERTO, VERIFIQUE")
        RETURN
    ENDIF
    SETCOLOR("W+/BG,N/W")
    PRIVATE V1[5], V2[5], V3[5]

     V1[01]="PNOMPEC"
     V1[02]="PQTDPEC"
     V1[03]="PUNIDAD"
     V1[04]="PPREPEC"
     V1[05]="PPRETOT"
        
     V2[01]="@!"
     V2[02]="123"
     V2[03]="@!"
     V2[04]="99999.99"
     V2[05]="99999.99"
        
     V3[01]="DESCRI€ŽO"
     V3[02]="QTD"
     V3[03]="UN"
     V3[04]="PRE€O"
     V3[05]="TOTAL"

PEDIDOEX()
SOMATOTAL()
    
DBEDIT(06,02,20,77,v1,"ADBEDIT",v2,v3,chr(205),space(1)+chr(179))


function Adbedit(modo,coluna)

SETCURSOR (1)
if modo=1
    return(1)
  elseif modo=2
    return(1)
  elseif modo=3
     KEYBOARD CHR(13)
  elseif modo=4
     if lastkey() == 27
         set softseek off
          return(1)

       ELSEIF LASTKEY()== 13 && "ENTER"
              TELA1=SAVESCREEN(08,02,19,76)
        DO WHILE .T.
              NFABRQTD=0
              TELA=SAVESCREEN(08,02,19,76)
              PEDIDOEX()
              SOMATOTAL()
              SETCOLOR("R/BG,N/W")
              *@ 22,37 SAY TOT PICT "99"
              *@ 22,40 SAY "PE€AS"                   
              @ 22,65 SAY MPTOTG PICT "99999.99"
              SETCOLOR("W+/BG,N/W")
              MPCODBAR=SPACE(20)
              MPCODPEC=SPACE(05)
              MDIGITO=SPACE(02)
              MPQTDPEC=1
              @ 22,00 CLEAR TO 22,24
              @ 22,01 GET MPCODBAR PICT "@!"
              SET KEY -8 TO DESC1() // F9

              *SET KEY -41 TO CONPEC() // F12

              READ
              TESTACOD(MPCODBAR)
              IF TECLA="S"
                        MPCODBAR=SPACE(20)
                        MPCODPEC=ALLTRIM(VARIA)
                        MDIGITO=ALLTRIM(VARDIG)
              ENDIF
              PECAS()
              IF LASTKEY()=27
                  SET KEY -8 TO DESC1() ///// F9
                  PEDIDOEX()
                  RESTSCREEN(08,02,19,76,TELA1)
                  IF ! EOF()
                     KEYBOARD CHR(03)
                  ENDIF
                  RETURN(1)
              ENDIF
              ORDSETFOCUS("CODBARRA")
              SEEK MPCODBAR
              BARRA=1
              IF ! FOUND() .AND. MPCODBAR # SPACE(20)
                            ORDSETFOCUS("CODBARRA1")
                            SEEK MPCODBAR
                            BARRA=2
                            IF ! FOUND() 
                                 ORDSETFOCUS("CODBARRA2")
                                 SEEK MPCODBAR
                                 BARRA=3
                                 IF ! FOUND()
                                     ORDSETFOCUS("CODBARRA3")
                                     SEEK MPCODBAR
                                     BARRA=4
                                     IF ! FOUND()
                                               ORDSETFOCUS("CODBARRA4")
                                               SEEK MPCODBAR
                                               BARRA=5
                                               IF ! FOUND()
                                                       TONE(200,26)
                                                       OL_Yield()
                                                        ALERT ('CODIGO NAO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                                                        NFABRQTD=1
                                               ENDIF         
                                     ENDIF
                                 ENDIF    
                            ENDIF
              ENDIF
              IF FOUND() .AND. TECLA="N" .AND. ! EMPTY(MPCODBAR)
                        MCODPECA=CODPECA
              ENDIF
              MPQTDPEC=1
              IF NFABRQTD=1 .OR. MPCODBAR = SPACE(20)
                   @ 22,00 CLEAR TO 24,23
                   @ 22,02 SAY "CODIGO...:"
                   @ 22,13 GET MPCODPEC PICT "@!"
                   @ 22,19 GET MDIGITO PICT "99"
                   IF TECLA="N"
                           READ
                       ELSE
                           CLEAR GETS
                   ENDIF
                   PECAS()
                   ORDSETFOCUS("CODPECA")
                   SEEK MPCODPEC
                   BARRA=VAL(SUBSTR(MDIGITO,2,1))
                   IF ! FOUND() 
                        TONE(200,26)
                        OL_Yield()
                        ALERT ('CODIGO NAO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                        LOOP
                   ENDIF
                   IF MDIGITO#DIGITO .OR. BARRA > 5
                   OL_Yield()
                         ALERT('DIGITO VERIFICADOR INCORRETO')
                         LOOP
                   ENDIF
                   @ 22,25 SAY "QTD...:" GET MPQTDPEC PICT "999" VALID MPQTDPEC > 0
                   IF TECLA="N"
                           READ
                       ELSE
                           CLEAR GETS
                   ENDIF
              ENDIF
              IF LASTKEY()=27
                  LOOP
              ENDIF
              MTEMPUNI=TEMPUNI
              IF MTEMPUNI="C"
                       CASCO="S"
              ENDIF
              IF MTEMPUNI="S"
                        MPQTDPEC=2
              ENDIF
              IF MTEMPUNI="4" .OR. MTEMPUNI="3"
                        MPQTDPEC=VAL(MTEMPUNI)
              ENDIF
              IF BARRA=0
                    BARRA=1
              ENDIF           
              IF BARRA<=1
                     MPFABRIC=FABRIC
                     MPNFABRIC=NFABRIC
              ENDIF
              IF BARRA=2
                    MPFABRIC=FABRIC2
                    MPNFABRIC=NFABRIC2
              ENDIF
              IF BARRA=3
                    MPFABRIC=FABRIC3
                    MPNFABRIC=NFABRIC3
              ENDIF
              IF BARRA=4
                    MPFABRIC=FABRIC4
                    MPNFABRIC=NFABRIC4
              ENDIF
              IF BARRA=5
                    MPFABRIC=FABRIC5
                    MPNFABRIC=NFABRIC5
              ENDIF
              MBARRAS=CODBARRA
              IF EMPTY(MBARRAS)
                  MBARRAS=CODPECA
              ENDIF
              IF EMPTY(MPFABRIC) .OR. EMPTY(MPNFABRIC)
              OL_Yield()
                      ALERT('DIGITO VERIFICADOR INCORRETO')
                      LOOP
              ENDIF
              MUNIDADE=UNIDADE
              MPCODPEC=CODPECA
              MPNOMPEC=NOMEPECA
              MPPREPEC=PRECO
              MPPRETOT=MPPREPEC*MPQTDPEC
              MQTD=QTD+TEMP
              PEDIDOEX()
              INDEX ON PCODPEC TO PCODPEC
              SEEK MPCODPEC
              IF FOUND()
                  IF MTEMPUNI="L" 
                        ACESSO=0
                        ACESSO()     
                        IF ACESSO#1
                                LOOP
                        ENDIF
                        SET KEY -8 TO OTARIOS() // F9
                        SET KEY -7 TO OTARIOS() // F8
                        SET KEY -6 TO OTARIOS() // F7
                        PEDIDOEX()
                        INDEX ON PCODPEC TO PCODPEC 
                        SEEK MPCODPEC
                  ENDIF
              ENDIF    
              INDEX ON PCODPEC TO PCODPEC FOR VERIFIC=BARRA
              SEEK MPCODPEC
              QTDTOT=QTDTOT+MPQTDPEC
              IF FOUND()
                  MPPREPEC=PPREPEC
                  MPQTDPEC=PQTDPEC+MPQTDPEC
                  IF (MQTD-MPQTDPEC)<0
                  OL_Yield()
                        ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                        QTDTOT=(QTDTOT-MPQTDPEC)+PQTDPEC
                        LOOP
                  ENDIF
                  REPLACE PQTDPEC WITH MPQTDPEC
                  MPPRETOT=MPPREPEC*MPQTDPEC
                  REPLACE PPRETOT WITH MPPRETOT
                  TOT--
                ELSE
                 IF (MQTD-MPQTDPEC)<0
                 OL_Yield()
                        ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                        QTDTOT=QTDTOT-MPQTDPEC
                        LOOP
                 ENDIF
                 APPEND BLANK
                 REPLACE BARRAS  WITH MBARRAS
                 REPLACE PCODPEC WITH MPCODPEC
                 REPLACE PNOMPEC WITH MPNOMPEC
                 IF MPCODPEC="88888"
                        MPQTDPEC=1
                        MPPREPEC=MPPRETOT
                 ENDIF
                 REPLACE PQTDPEC WITH MPQTDPEC
                 REPLACE PPREPEC WITH MPPREPEC
                 REPLACE PPRETOT WITH MPPRETOT
                 REPLACE PFABRIC WITH MPFABRIC
                 REPLACE VERIFIC WITH BARRA
                 REPLACE PNFABRIC WITH MPNFABRIC
                 UNLOCK
                 DBCOMMIT()
              ENDIF
              PEDIDOEX()
              SOMATOTAL()
              @ 08,03 SAY MPNOMPEC
              @ 08,51 SAY MPQTDPEC PICT "99"
              @ 08,56 SAY MUNIDADE PICT "@!"
              @ 08,59 SAY MPPREPEC PICT "99999.99"
              @ 08,69 SAY MPPRETOT PICT "99999.99"
              TOT++
              IF CASCO="S"
                        PECAS()
                        ORDSETFOCUS("CODPECA")
                        SEEK "99999"
                        MNOMEPECA=NOMEPECA
                        MPQTDPEC=1
                        MPPRETOT=PRECO
                        PEDIDOEX()
                        BLOQUEIO()
                        APPEND BLANK
                        REPLACE PCODPEC WITH "99999"
                        REPLACE PNOMPEC WITH MNOMEPECA
                        REPLACE PQTDPEC WITH 1
                        REPLACE PPREPEC WITH MPPRETOT
                        REPLACE PPRETOT WITH MPPRETOT
                        DBCOMMIT()                        
                        UNLOCK
                        QTDTOT++
                        TOT++
                        CASCO="N"
              ENDIF
              IF MPPREPEC=0
              OL_Yield()
              OL_Yield()
                 ALERT ('CODIGO DIGITADO ESTA COM VALOR INCORRETO,VERIFIQUE')
              ENDIF
              IF DESC1="S"
                  DESC1()
              ENDIF
              RESTSCREEN(09,02,20,76,TELA)

        ENDDO


       ELSEIF LASTKEY()== 07 && "DELETE"

               MPPRETOT=PPRETOT
               MPCODPEC=PCODPEC
               MPQTDPEC=PQTDPEC
               DELETE
               PACK
               MPTOTG=MPTOTG-MPPRETOT
               KEYBOARD+CHR(13)
               TOT--
               QTDTOT=QTDTOT-MPQTDPEC
               OL_Yield()
               ALERT('PECA EXCLUIDA COM EXITO')
               PEDIDOEX()
               SOMATOTAL()
               IF DESC1="S"
                   DESC1()
               ENDIF
               @ 22,65 SAY MPTOTG PICT "99999.99"
               KEYBOARD CHR(13)


       elseif lastkey()== 65 .OR. lastkey() == 97   && "A"

                       TELA1=SAVESCREEN(08,02,19,76)
                       MPCODPEC=PCODPEC
                       SETCOLOR("W+/BG,N/W")
                       MPQTDPEC=PQTDPEC
                       XPQTDPEC=PQTDPEC
                       MPPREPEC=PPREPEC
                       MPCODPEC=PCODPEC
                       MVERIFIC=VERIFIC
                       QTDTOT=QTDTOT-MPQTDPEC
                       PECAS()
                       ORDSETFOCUS("CODPECA")
                       SEEK MPCODPEC
                       MQTD=QTD+TEMP
                       ALTPRECO=MPPREPEC 
                       ACESSO()
                       @10,10 CLEAR TO 12,34
                       @10,10 TO 12,34 DOUBLE
                       @ 11,11 SAY "QTD.:"GET MPQTDPEC  PICT "99" VALID MPQTDPEC >0
                       @ 11,20 SAY "PRE€O:"GET MPPREPEC PICT "99999.99"
                       READ
                       IF ACESSO#1   
                            MPQTDPEC=XPQTDPEC
                       ENDIF 
                       DO WHILE (MQTD-MPQTDPEC)<0
                                OL_Yield()
                                ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                                PEDIDOEX()
                                INDEX ON PCODPEC TO PCODPEC FOR PCODPEC=MPCODPEC .AND. VERIFIC=MVERIFIC                                                                
                                QTDTOT=QTDTOT+PQTDPEC
                                RETURN(1)
                       ENDDO
                       IF MPPREPEC<ALTPRECO 
                           ACESSO()
                           IF ACESSO # 1 .OR. LASTKEY()=27
                           OL_Yield()
                                ALERT('ALTERACAO NAO PERMITIDO')
                                MPPREPEC=ALTPRECO
                           ENDIF
                       ENDIF                       
                       PEDIDOEX()
                       INDEX ON PCODPEC TO PCODPEC FOR PCODPEC=MPCODPEC
                       DO WHILE ! EOF()
                            IF VERIFIC=MVERIFIC
                                 REPLACE PQTDPEC WITH MPQTDPEC
                            ENDIF 
                            MPPRETOT=PQTDPEC*MPPREPEC                       
                            REPLACE PPRETOT WITH MPPRETOT
                            REPLACE PPREPEC WITH MPPREPEC
                            SKIP
                       ENDDO          
                       QTDTOT=QTDTOT+MPQTDPEC
                       DBCOMMIT()
                       PEDIDOEX()
                       SOMATOTAL()
                       @ 22,65 SAY MPTOTG PICT "99999.99"
                       IF DESC1="S"
                           DESC1()
                       ENDIF
                       LOCATE FOR PCODPEC=MPCODPEC
                       KEYBOARD CHR(13)
                       RESTSCREEN(08,02,19,76,TELA1)
                       ACESSO=0

         elseif lastkey()== -3   && "F4 CANCELA PEDIDO"

               PEDIDOEX()
               ZAP
               SET KEY -8 TO OTARIOS() // F9
               SET KEY -7 TO OTARIOS() // F8
               SET KEY -6 TO OTARIOS() // F7
               CRED1="N"
               DESC1="N"
               RETURN(0)

        elseif lastkey()== -2   && "F3 VENDA CONVENIO"
            
                     IF MPTOTG=0 .AND. CRED1="N"
                          OL_Yield()
                          ALERT('NENHUMA PE€A INCLUIDA NO PEDIDO')
                          SET KEY -8 TO OTARIOS() //// F9
                          SET KEY -7 TO OTARIOS() // F8
                          SET KEY -6 TO OTARIOS() // F7
                          PEDIDOEX()
                          ZAP
                          RETURN(0)
                     ENDIF
                     MPCODPEC=SPACE(5)
                     PEDIDOEX()
                     INDEX ON PCODPEC TO PCODPEC
                     DO WHILE .NOT. EOF()
                        IF MPCODPEC#PCODPEC .AND. PCODPEC# "11111"
                                TOTPROD++
                                MPCODPEC=PCODPEC
                        ENDIF
                        SKIP
                     ENDDO
                     DO WHILE .T.
                        SETCOLOR("R/BG,N/W")
                        @ 07,51 CLEAR TO 20,53 
                        @ 07,16 CLEAR TO 10,49
                        @ 07,16 TO 10,49 DOUBLE
                        @ 08,17 SAY "DIGITE A QUANTIDADE DE PECAS:"
                        @ 09,17 SAY "DIGITE A QUANTIDADE PRODUTOS:"
                        @ 08,46 GET MQTDTOT PICT "999"
                        @ 09,46 GET MTOTPROD PICT "999"
                        READ
                        IF LASTKEY()=27
                                SET KEY -8 TO OTARIOS() // F9
                                SET KEY -7 TO OTARIOS() // F8
                                SET KEY -6 TO OTARIOS() // F7
                                PEDIDOEX()
                                ZAP
                                RETURN(0)
                        ENDIF                        
                        IF MQTDTOT=QTDTOT .AND. MTOTPROD=TOTPROD
                                EXIT
                              ELSE
                              OL_Yield()
                                ALERT('ERRO NA QTD. PEDIDO CANCELADO')
                                ACESSO()
                                IF LASTKEY()=27
                                        SET KEY -8 TO OTARIOS() // F9
                                        SET KEY -7 TO OTARIOS() // F8
                                        SET KEY -6 TO OTARIOS() // F7
                                        PEDIDOEX()
                                        ZAP
                                        RETURN(0)
                                ENDIF
                                IF ACESSO = 1
                                        LOOP
                                ENDIF
                                SET KEY -8 TO OTARIOS() // F9
                                SET KEY -7 TO OTARIOS() // F8
                                SET KEY -6 TO OTARIOS() // F7
                                PEDIDOEX()
                                ZAP
                                RETURN(0)
                        ENDIF
                     ENDDO
                     CONFTAXA="S"
                     ENTREGA()
                     ORDSETFOCUS("ENTREGAS")
                     SEEK MNOTCLI
                     IF FOUND()
                            CONFTAXA="N"
                     ENDIF       
                     CLIENTES()
                     ORDSETFOCUS("NOMECLI")
                     SEEK MNOTCLI
                     MTAXA="S"
                     IF FOUND()
                             MT_MOTO=T_MOTO
                             MTAXA=TAXA
                             MTAXA_DUPLA=TAXA_DUPLA
                             MBLOQUEIO=BLOQUEIO
                             MPONTO1=P1
                             MPONTO2=P2
                             MPONTO3=P3
                             MPONTO4=P4
                             MKM=KM
                          ELSE
                             MTAXA_DUPLA=MTAXA_DUPLA*1
                             MKM=0
                             KM=0
                             MT_MOTO=1
                             MBLOQUEIO="S"
                     ENDIF
                ENTREGA=SPACE(1)
                IF MNOTCLI#"CONSUMIDOR"
                             SETCOLOR("R+/BG,N/W")
                             @18,18 CLEAR TO 20,48
                             @18,18 TO 20,48 DOUBLE
                             SETCOLOR("W+/BG,N/W")
                             @ 19,19 SAY "CONFIRMA ENTREGA POR MOTO?" GET ENTREGA PICT "@!" VALID ENTREGA $ ("S/N")
                             READ
                             IF EMPTY(MENDCLI)
                                     ENTREGA="N"
                             ENDIF
                             IF ENTREGA="S"
                                     CLIENTES()
                                     ORDSETFOCUS("NOMECLI")
                                     SEEK MNOTCLI
                                     IF ! FOUND()
                                              PEDIDOEX()
                                              INDEX ON PCODPEC TO PCODPEC
                                              SEEK "88888"
                                              IF FOUND()
                                                   MT_MOTO=PPRETOT/VTAXA
                                              ENDIF
                                              MPONTO1=SPACE(2)
                                              MPONTO2=SPACE(2)
                                              MPONTO3=SPACE(2)
                                              MPONTO4=SPACE(2)
                                              SETCOLOR("R+/BG,N/W")
                                              @18,18 CLEAR TO 20,50
                                              @18,18 TO 20,50 DOUBLE
                                              SETCOLOR("W+/BG,N/W")
                                              @ 19,21 SAY "DIGITE O DESTINO........:" GET MPONTO1 PICT "@!" VALID MPONTO1 $ ("P1/P2/P3/P4/P5")
                                              READ
                                      ENDIF
                                      ENTREGA()
                                      ORDSETFOCUS("PONTO")
                                      DO WHILE .T.
                                                SEEK MPONTO1
                                                IF FOUND()
                                                        MPONTO=MPONTO1
                                                        EXIT
                                                ENDIF
                                                SEEK MPONTO2
                                                IF FOUND() .AND. ! EMPTY(MPONTO2) 
                                                        MPONTO=MPONTO2
                                                        ORDSETFOCUS("P_EXC")
                                                        SEEK MPONTO2
                                                        IF FOUND()
                                                            MPONTO=MPONTO1
                                                        ENDIF                                                      
                                                        EXIT
                                                ENDIF
                                                SEEK MPONTO3
                                                IF FOUND() .AND. ! EMPTY(MPONTO3) 
                                                        MPONTO=MPONTO3
                                                        ORDSETFOCUS("P_EXC")
                                                        SEEK MPONTO2
                                                        IF FOUND()
                                                            MPONTO=PONTO1
                                                        ENDIF    
                                                        EXIT
                                                ENDIF
                                                MPONTO=MPONTO1
                                                EXIT
                                      ENDDO
                                      IF MTAXA="S" .AND. MPTOTG <= MTAXAS .OR. MTAXA="T" .AND. MPTOTG <= MTAXAT .OR. MTAXA="Q"
                                          IF CONFTAXA="S"
                                                  MPCODPEC="88888"
                                                  MPNOMPEC="TAXA DE ENTREGA"
                                                  MPQTDPEC=1
                                                  MPPREPEC=VTAXA*MTAXA_DUPLA
                                                  MPPRETOT=MPQTDPEC*MPPREPEC  
                                                  PEDIDOEX()
                                                  INDEX ON PCODPEC TO PCODPEC
                                                  SEEK "88888"
                                                  IF ! FOUND()
                                                        APPEND BLANK
                                                          REPLACE PCODPEC WITH MPCODPEC
                                                          REPLACE PNOMPEC WITH MPNOMPEC
                                                          REPLACE PQTDPEC WITH MPQTDPEC
                                                          REPLACE PPREPEC WITH MPPREPEC
                                                          REPLACE PPRETOT WITH MPPRETOT
                                                          DBCOMMIT()
                                                  ENDIF
                                                  PEDIDOEX()
                                                  SOMATOTAL()
                                                  IF DESC1="S"
                                                         DESC1()
                                                  ENDIF
                                          ENDIF    
                                      ENDIF
                             ENDIF
                        ELSE
                                FORMAPAG()
                ENDIF
                CLIENTES()
                ORDSETFOCUS("NOMECLI")
                SEEK MNOTCLI
                IF FOUND()
                        IF MANDANOTA="S"
                            SAVE SCREEN TO FTELA
                            DO WHILE .T.
                               @ 07,16 CLEAR TO 10,49
                               @ 07,16 TO 10,49 DOUBLE
                               @ 08,18 SAY "ENTREGUE AS NOTAS PARA LIBERAR"
                               @ 09,18 SAY "VALOR DA SEMANA:" GET MVALENTREG PICT "999999.99"
                               READ
                               IF MVALENTREG#VALSEMANA
                               OL_Yield()
                                    ALERT ('DIGITE O VALOR CORRETO !!!')
                                    LOOP
                                 ELSE
                                  MMANDANOTA="N"
                                  BLOQUEIO()
                                  REPLACE MANDANOTA WITH MMANDANOTA
                                  DBCOMMIT()
                                  UNLOCK
                                  EXIT
                               ENDIF
                            ENDDO
                        ENDIF
                       ELSE
                        PEDIDOEX()
                ENDIF
                IF DESC1="N"
                     CLIENTES()
                     ORDSETFOCUS("NOMECLI")
                     SEEK MNOTCLI
                     IF FOUND() .AND. BLOQUEIO="S"
                           KEYBOARD CHR(13)
                           KEYBOARD CHR(13)
                           KEYBOARD CHR(13)
                           KEYBOARD CHR(13)
                     ENDIF
                ENDIF   
                SETCOLOR("W+/BG,N/W")
                TRAVAPED()
                MTRAVA=TRAVAPED
                DO WHILE ! EMPTY(MTRAVA)
                      OL_Yield()
                      ALERT('AGUARDE A LIBERACAO E PRESSIONE ENTER')
                      TRAVAPED()
                      MTRAVA=TRAVAPED
                ENDDO        
                BLOQUEIO()
                REPLACE TRAVAPED WITH "S"
                UNLOCK
                DBCOMMIT()
                MCUSTO=0
                IF CRED1="S"
                        IF MV_CREDITO<MPTOTG
                               MABATIMENTO=MV_CREDITO-(MV_CREDITO*2)
                              ELSE
                               MABATIMENTO=MPTOTG-(MPTOTG*2)
                        ENDIF
                        DESC1()
                     ELSE
                        IF MNOTPAG#"CONVENIO"
                                DESC1()
                        ENDIF
                ENDIF
                
                REPLVANOT()
                PEDIDOEX()
                NUMREG=1
                GOTO NUMREG
                DO WHILE .NOT. EOF()
                     MPEDCOD=PCODPEC
                     MPEDQTD=PQTDPEC
                     MPPREPEC=PPREPEC
                     MVERIFIC=VERIFIC
                     MP_CUSTO=PCUSTO
                     PEDCUP()
                     *PEDCUPEX()
                     BLOQUEIO()
                     APPEND BLANK
                     REPLACE PEDCOD   WITH MPEDCOD
                     REPLACE PEDNUM   WITH MCODNOT
                     REPLACE PEDQTD   WITH MPEDQTD
                     REPLACE PRECOCUP WITH MPPREPEC
                     REPLACE DATACUP  WITH MD_NOT
                     REPLACE VERIFIC  WITH MVERIFIC
                     REPLACE P_CUSTO  WITH MP_CUSTO
                     PEDIDOEX()
                     NUMREG++
                     GOTO NUMREG
                ENDDO
                UNLOCK
                PEDIDOEX()
                INDEX ON PCODPEC TO PCODPEC
                NUMREG=1
                GOTO NUMREG
                DO WHILE .NOT. EOF()
                     MPEDCOD=PCODPEC
                     MPEDQTD=PQTDPEC
                     MPPREPEC=PPREPEC
                     MVERIFIC=VERIFIC
                     PECAS()
                     ORDSETFOCUS("CODPECA")
                     SEEK MPEDCOD
                     MTRAVA=TRAVA
                     DO WHILE MTRAVA="A"
                            OL_Yield()
                            ALERT('PRODUTO SENDO ALTERADO EM OUTRO TERMINAL...') 
                            SEEK MPEDCOD
                            MTRAVA=TRAVA
                            INKEY(0)
                     ENDDO
                     TESTAQTD=QTD
                     MQTD= QTD - MPEDQTD
                     BLOQUEIO()
                     REPLACE QTD    WITH MQTD
                     REPLACE ATUALIZADO WITH "S"
                     MQTD_P=MPEDQTD
                     DO WHILE QTD_P>0 
                        IF MQTD_P=0
                                EXIT
                        ENDIF
                        REPLACE QTD_P WITH QTD_P-1
                        MQTD_P--
                     ENDDO
                     IF MQTD_P>0
                        REPLACE QTD_E WITH QTD_E-MQTD_P
                     ENDIF
                     DBCOMMIT()
                     IF MVERIFIC<=1
                                REPLACE QTD2 WITH QTD2-MPEDQTD
                     ENDIF     
                     IF MVERIFIC=2
                                IF QTD3>=MPEDQTD
                                      REPLACE QTD3 WITH QTD3-MPEDQTD
                                   ELSE
                                      MPEDQTD=MPEDQTD-QTD3
                                      REPLACE QTD3 WITH 0
                                      REPLACE QTD2 WITH QTD2-MPEDQTD   
                                ENDIF      
                     ENDIF     
                     IF MVERIFIC=3
                                IF QTD4>=MPEDQTD
                                      REPLACE QTD4 WITH QTD4-MPEDQTD
                                   ELSE
                                      MPEDQTD=MPEDQTD-QTD4
                                      REPLACE QTD4 WITH 0
                                      REPLACE QTD2 WITH QTD2-MPEDQTD   
                                ENDIF      
                     ENDIF     
                     IF MVERIFIC=4
                              IF QTD5>=MPEDQTD
                                      REPLACE QTD5 WITH QTD5-MPEDQTD
                                   ELSE
                                      MPEDQTD=MPEDQTD-QTD5
                                      REPLACE QTD5 WITH 0
                                      REPLACE QTD2 WITH QTD2-MPEDQTD   
                                ENDIF      
                     ENDIF     
                     IF MVERIFIC=5
                                IF QTD6>=MPEDQTD
                                      REPLACE QTD6 WITH QTD6-MPEDQTD
                                   ELSE
                                      MPEDQTD=MPEDQTD-QTD6
                                      REPLACE QTD6 WITH 0
                                      REPLACE QTD2 WITH QTD2-MPEDQTD   
                                ENDIF      
                     ENDIF
                     REPLACE QTDMAX WITH QTDMAX+MPEDQTD
                     DISTRIBQTD=MPEDQTD
                     UNLOCK
                     SAIDISTRIB()
                     DO WHILE .T.
                        IF TESTAQTD=QTD
                                ALERT('ERRO NA BAIXA DO ESTOQUE!!! CONFIRA.')
                                IF LASTKEY()=27
                                        EXIT
                                ENDIF
                            ELSE
                                EXIT
                        ENDIF
                     ENDDO
                     PEDIDOEX()
                     INDEX ON PCODPEC TO PCODPEC
                     SEEK MPEDCOD
                     REPLACE PCUSTO WITH MP_CUSTO
                     MCUSTO=MCUSTO+MP_CUSTO
                     NUMREG++
                     GOTO NUMREG
                ENDDO
                UNLOCK
                CUPOM()
                ORDSETFOCUS("CODNOT")
                SEEK MCODNOT
                BLOQUEIO()
                REPLACE P_CUSTO WITH MCUSTO
                UNLOCK
                DBCOMMIT()
                TRAVAPED()
                BLOQUEIO()
                REPLACE TRAVAPED WITH " "
                DBCOMMIT()
                UNLOCK
                IF ENTREGA="S"
                     ENTREGA()
                     BLOQUEIO()
                     APPEND BLANK
                     REPLACE T_MOTO   WITH MT_MOTO
                     REPLACE ENTREGAS WITH MNOTCLI
                     REPLACE PONTO    WITH MPONTO
                     REPLACE ENDERECO WITH MENDCLI
                     REPLACE P_EXC    WITH MPONTO4 
                     REPLACE CODIGO   WITH MCODNOT
                     REPLACE HORA     WITH TIME()
                     REPLACE KM       WITH MKM
                     REPLACE FORMA    WITH MNOTPAG
                     REPLACE TELEFONE WITH MTEL
                     UNLOCK
                     IF MPTOTG+MABATIMENTO>0
                        IF ALLTRIM(MNOTPAG) <> "CONVENIO"
                             ENVIADOS()
                             APPEND BLANK
                             CANHOTO()
                        ENDIF
                     ENDIF
                ENDIF
                IF ENTREGA="N" .AND. MNOTPAG # "CONVENIO"
                        SETCOLOR("R*/BG*,N*/W*")
                        MCANHOTO=" "
                        @ 07,20 CLEAR TO 17,56
                        @ 07,20 TO 17,56 DOUBLE
                        @ 12,24 SAY "DESEJA COLOCAR O CANHOTO??" GET MCANHOTO PICT "@!"  VALID MCANHOTO $ ("S/N")
                        READ
                        SETCOLOR("W+/BG,N/W")
                        IF MCANHOTO="S"
                             IF MPTOTG+MABATIMENTO>0
                                     ENVIADOS()
                                     APPEND BLANK
                                     CANHOTO()
                             ENDIF
                        ENDIF
                ENDIF        
                CNPJ=SPACE(18)
                OK=.f.
                PAGAMENTO="CARTAO"
                KEYBOARD CHR(0)
                IF MNOTCLI="CONSUMIDOR" 
                        OP=1
                        @ 23,02 CLEAR TO 23,70
                        @ 10,10 CLEAR TO 16,36
                        @ 10,10 TO 16,36 DOUBLE
                        @ 11,12 PROMPT "1-NULO." MESS "SEM DADOS "
                        @ 12,12 PROMPT "2-CPF.." MESS "DIGITE O CPF DO CONSUMIDOR" 
                        @ 13,12 PROMPT "3-CNPJ." MESS "DIGITE O CNPJ DA EMPRESA" 
                        MENU TO OP
                        DO CASE
                           CASE OP == 1                              

                           CASE OP == 2
                                DO WHILE OK=.f.
                                        @ 15,12 SAY "CPF.:" GET CNPJ PICT "999.999.999-99" 
                                        READ
                                        IF LASTKEY()=27
                                                 CNPJ=SPACE(18)
                                                 EXIT
                                        ENDIF
                                        TESTA_CPF()
                                ENDDO
                           CASE OP == 3
                                DO WHILE OK=.f.
                                        @ 15,12 SAY "CNPJ:" GET CNPJ PICT "99.999.999/9999-99"
                                        READ 
                                        IF LASTKEY()=27
                                                 CNPJ=SPACE(18)
                                                 EXIT
                                        ENDIF
                                        TESTA_CNPJ()
                                ENDDO
                        ENDCASE
                        MOP=01
                        IF MNOTTOTG>=40
                                @ 23,02 CLEAR TO 23,70
                                @ 13,37 CLEAR TO 17,49
                                @ 13,37 TO 17,49 DOUBLE
                                @ 14,38 PROMPT "1-CARTÇO.." MESS "PAGAMENTO COM CARTAå"
                                @ 15,38 PROMPT "2-DINHEIRO" MESS "PAGAMENTO COM DINHEIRO"
                                MENU TO MOP
                                DO CASE
                                   CASE MOP == 1
                                        PAGAMENTO="CARTAO"
                                   CASE MOP == 2
                                        PAGAMENTO="DINHEIRO"
                                ENDCASE
                            ELSE
                                PAGAMENTO="DINHEIRO"
                        ENDIF
                        CUPOM()
                        ORDSETFOCUS("CODNOT")
                        SEEK MCODNOT
                        BLOQUEIO()
                        REPLACE CNPJCLI WITH CNPJ
                        UNLOCK
                        DBCOMMIT()
                ENDIF
                CLIENTES()
                ORDSETFOCUS("NOMECLI")
                SEEK MNOTCLI
                IF ! FOUND()
                        ENDERECO()
                        BLOQUEIO()
                        APPEND BLANK
                        REPLACE CODIGO   WITH MCODNOT
                        REPLACE ENDERECO WITH MENDCLI
                        REPLACE TELEFONE WITH MTEL 
                        UNLOCK
                        DBCOMMIT()
                ENDIF
                printer()
                LIN=0
                *IF MNOTCLI#"CONSUMIDOR" .OR. CRED1="S"
                        *IF MNOTPAG#"CONVENIO"
                        *        L_DUPLA()
                        *        @ LIN,00 SAY MCODNOT PICT "999999999"
                        *        NORMAL()
                        *        @ LIN,09 SAY "VALOR:"
                        *        @ LIN,15 SAY MPTOTG PICT "999999.99"
                        *        IF DESC1="S"
                        *                @ LIN,25 SAY "="
                        *                @ LIN,27 SAY TOTDESC PICT "99999.99"
                        *                LIN++
                        *                IF MTROCO > 0
                        *                        LIN++
                        *                        @ LIN,00 SAY MTROCO-TOTDESC PICT "999.99"
                        *                        @ LIN,10 SAY "DE TROCO / TROCO PARA:"
                        *                        @ LIN,33 SAY MTROCO PICT "99,999.99"
                        *                ENDIF
                        *             ELSE
                        *        ENDIF
                        *        LIN=LIN+5
                        *        @ LIN,00 SAY " "
                        *        IF ENTREGA="S"
                        *                GUILHOTINA()
                        *        ENDIF
                        *ENDIF
                        IMPCABEC()
                        PEDIDOEX()
                        IMPARQPED()
                        @ LIN,33 SAY "----------"
                        LIN++
                        @ LIN,10 SAY "TOTAL PECAS ========>"
                        @ LIN,32 SAY  MPTOTG PICT "99,999.99"
                        LIN++
                        IF CRED1="S"
                                @ LIN,10 SAY "CREDITO...: ========>"
                                IF MV_CREDITO<MPTOTG
                                        @ LIN,32 SAY  MABATIMENTO PICT "99,999.99"
                                     ELSE
                                        @ LIN,32 SAY  MABATIMENTO PICT "99,999.99"
                                ENDIF
                                LIN++
                                @ LIN,10 SAY "TOTAL .....:========>"
                                @ LIN,32 SAY  MPTOTG+MABATIMENTO PICT "99,999.99"
                        ENDIF
                        IF DESC1="S"
                                IF (MPTOTG-TOTDESC)>0
                                        @ LIN,33 SAY  "----------"
                                        LIN++
                                        *@ PROW(),00 SAY CHR(27)+CHR(33)
                                        *@ PROW(),00 SAY CHR(27)+"!"+CHR(8)
                                        @ LIN,10 SAY "TOTAL COM DESC======>"
                                        @ LIN,32 SAY  TOTDESC PICT "99,999.99"
                                        LIN++
                                        *@ LIN,54 SAY " "
                                        *@ PROW(),00 SAY CHR(27)+CHR(64)
                                        *@ PROW(),00 SAY CHR(27)+"!"+CHR(0)
                                ENDIF
                                IF MTROCO > 0
                                        @ LIN,10 SAY "TROCO DE   =========>"
                                        @ LIN,32 SAY MTROCO-TOTDESC PICT "99,999.99"
                                        LIN++
                                        @ LIN,10 SAY "TROCO PARA =========>"
                                        @ LIN,32 SAY MTROCO PICT "99,999.99"
                                        LIN++
                                ENDIF
                        ENDIF              
                        @ LIN,03 SAY TOT PICT "99"
                        @ LIN,07 SAY "PRODUTO(S)"
                        LIN++
                        LIN++
                        IF CRED1="S"
                                DEVOLCRE()
                                ORDSETFOCUS("CREDITO")
                                SEEK MCODCRE
                                IF FOUND()
                                        NUMREG=RECNO()
                                        IF EMPTY(BAIXA)
                                                SET DEVICE TO SCREEN        
                                                IF CONFIRMA("CONFIRMA TRAZER AS TROCAS!!!")=1
                                                        printer()
                                                        @ LIN,00 SAY "TRAZER AS TROCAS ABAIXO"
                                                        *LIN++
                                                        *@ LIN,5 SAY " "
                                                        @ LIN,41 SAY " "
                                                        *@ PROW(),00 SAY CHR(27)+CHR(51)
                                                        *@ PROW(),00 SAY CHR(27)+CHR(83)
                                                        *@ PROW(),00 SAY CHR(27)+CHR(33)
                                                        *@ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                                                        @ LIN,02 SAY PADC ("-------------------------------------",40)
                                                        DO WHILE CREDITO=MCODCRE
                                                                IF EMPTY(BAIXA)                                                                        
                                                                        @ lin,00 SAY QTD
                                                                        @ LIN,04 SAY CODPECA
                                                                        @ LIN,10 SAY LEFT(NOMEPECA,30)
                                                                        LIN++
                                                                ENDIF
                                                                GO RECNO()+1
                                                        ENDDO
                                                        @ LIN,76 SAY " "                                                        
                                               ENDIF
                                        ENDIF
                               ENDIF
                        ENDIF
                        printer()
                        MOSTEXCUPOM()
                        LIN++
                        LIN++
                        LIN++
                        LIN++
                        @ LIN,01 SAY " "                                              
                        GUILHOTINA()
                        NORMAL()
                        *@ PROW(),00 SAY CHR(27)+chr(109)
                        LIN=0
                        SET DEVICE TO SCREEN
                        printer()
                        IF LASTKEY()#27 .AND. MNOTCLI#"CONSUMIDOR"
                                VIA++
                                IMPCABEC()
                                PEDIDOEX()
                                IMPARQPED()
                                @ LIN,33 SAY "----------"
                                LIN++
                                @ LIN,10 SAY "TOTAL PECAS =========>"
                                @ LIN,32 SAY  MPTOTG PICT "99,999.99"
                                LIN++
                                IF CRED1="S"
                                        @ LIN,10 SAY "CREDITO...: ========>"
                                        IF MV_CREDITO<MPTOTG
                                                @ LIN,32 SAY  MABATIMENTO PICT "99,999.99"
                                             ELSE
                                                @ LIN,32 SAY  MABATIMENTO PICT "99,999.99"
                                        ENDIF
                                        LIN++
                                        @ LIN,10 SAY "TOTAL .....:========>"
                                        @ LIN,32 SAY  MPTOTG+MABATIMENTO PICT "99,999.99"
                                ENDIF
                                LIN++
                                *IF MNOTCLI="CONSUMIDOR"
                                    IF DESC1="S"
                                            IF (MPTOTG-TOTDESC)>0
                                                    @ LIN,33 SAY  "----------"
                                                    LIN++
                                                    *@ PROW(),00 SAY CHR(27)+CHR(33)
                                                    *@ PROW(),00 SAY CHR(27)+"!"+CHR(8)
                                                    @ LIN,10 SAY "TOTAL COM DESC======>"
                                                    @ LIN,32 SAY  TOTDESC PICT "99,999.99"
                                                    LIN++
                                                    *@ PROW(),00 SAY CHR(27)+CHR(64)
                                                    *@ PROW(),00 SAY CHR(27)+"!"+CHR(0)
                                            ENDIF
                                    ENDIF
                                *ENDIF
                                @ LIN,03 SAY TOT PICT "99"
                                @ LIN,07 SAY "PRODUTO(S)"
                                LIN++
                                MOSTEXCUPOM()
                                LIN++
                                LIN++
                                LIN++
                                @ LIN,01 SAY " "
                                @ PROW(),00 SAY CHR(27)+chr(109)
                                LIN=0
                        ENDIF
                *ENDIF
                PEDIDOEX()                
                IF CRED1="S"
                        PAGAMENTO()
                        ORDSETFOCUS("CODIGO")
                        SEEK MCODCRE
                        IF FOUND()
                                BLOQUEIO()
                                MVALOR=VALOR+MABATIMENTO
                                REPLACE VALOR WITH MVALOR
                                UNLOCK
                             ELSE
                                ALERT ('ERRO NA BAIXA DO CREDITO !!!!; SOLICITAR CONFERENCIA.')
                        ENDIF
                        IF MVALOR>0
                                DADOS2()
                                @ LIN,00 SAY RSOCIAL
                                LIN++
                                @ LIN,00 SAY ENDEMPR
                                LIN++
                                @ LIN,00 SAY "DATA:"
                                @ LIN,06 SAY DATE()
                                @ LIN,20 SAY "HORA:"
                                @ LIN,26 SAY TIME()
                                L_DUPLA()
                                @ PROW()+1,COL() SAY MCODCRE
                                NORMAL()
                                @ PROW()+1,COL() SAY "CREDITO EM PECAS"
                                @ PROW()+1,00 SAY MNOTFUNC
                                PEQUENO()
                                @ PROW()+2,32 SAY "---------------"
                                @ PROW()+1,32 SAY "|R$"
                                @ PROW(),36 SAY MVALOR PICT "99,999.99"
                                @ PROW(),46 SAY "|"
                                @ PROW()+1,32 SAY "---------------"                
                                @ PROW()+1,00  SAY " "
                                @ PROW(),00 SAY CHR(27)+CHR(64)
                                @ PROW()+1,00 SAY "Autorizamos credito para:"
                                @ PROW(),00 SAY CHR(27)+CHR(33)
                                @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                                @ PROW(),00 SAY MNOTCLI
                                @ PROW(),54 SAY " "
                                @ PROW(),00 SAY CHR(27)+CHR(64)
                                @ PROW()+1,00 SAY "A importancia de:"
                                @ PROW(),00 SAY CHR(27)+CHR(33)
                                EXTE=EXT(MVALOR)
                                FOR I=1 TO 48
                                        IF SUBSTR(EXTE,I,1)=" "
                                                SP=I              
                                        ENDIF     
                                NEXT 
                                @ PROW()+1,00 SAY LEFT(EXTE,SP)
                                @ PROW()+1,00 SAY SUBSTR(EXTE, SP+1, 48)
                                @ PROW()+1,00 SAY PADC("VALIDADE 3 MESES",48)
                                LIN=0
                                LIN++
                                @ LIN,54 SAY " "
                                MOSTEXCUPOM()
                                @ PROW()+4,01 SAY " "                       
                                @ PROW(),00 SAY CHR(27)+chr(109)
                        ENDIF
                ENDIF
                CRED1="N"
                DESC1="N"
                MTROCO=0
                TOTDESC=0
                CLIENTES()
                ORDSETFOCUS("NOMECLI")
                SEEK MNOTCLI
                IF FOUND()
                        BLOQUEIO()
                        REPLACE ULTCOMPRA WITH DATE()
                        UNLOCK
                ENDIF
                SET DEVICE TO SCREEN
                SET KEY -8 TO OTARIOS() // F9
                SET KEY -7 TO OTARIOS() // F8
                SET KEY -6 TO OTARIOS() // F7
                PEDIDOEX()
                ZAP
                RETURN(0)
        ENDIF
ENDIF
