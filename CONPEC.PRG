******************************************************************************

*****************************/FUN€AO CONSULTA PECAS***************************
MNCMM=SPACE(8)
TNOMEPECA2=SPACE(68)
TNOMEPECA3=SPACE(68)
TNOMEPECA4=SPACE(68)
TNOMEPECA7=SPACE(68)
PECAS()
SAVE SCREEN TO TELAP
IF RUNORCA=0
        RUN COPY D:\karvan\PECAS.DBF C:\TEMP
ENDIF
RESTORE SCREEN FROM TELAP
IF CONPEC=1 .AND. RUNORCA=0
        MNOMEPECA=MPNOMPEC
        MCODPECA=MPCODPEC
        MFABRIC=V_BUSCA
        MNFABRIC=V_BUSCA
        INDEXAR()
     ELSE
        ORDSETFOCUS("CODPECA")
ENDIF

IF RUNORCA=1 .AND. NTX=2
        USE C:\TEMP\PECAS 
        MNOMEPECA=MPNOMPEC
        MCODPECA=MPCODPEC
        MFABRIC=V_BUSCA
        MNFABRIC=V_BUSCA
        INDEXAR()
     ELSE
        ORDSETFOCUS("CODPECA")
ENDIF
IF EOF()
        ORDSETFOCUS("CODPECA")
ENDIF        
SET KEY -41 TO OTARIOS() // F12

SETCOLOR("GR/B+")
CLS

IF ACESSO =0 .OR. ACESSO=4
        PRIVATE V1[06], V2[06], V3[06]
        V1[01]="NOMEPECA"
        V1[02]="QTD+TEMP"
        V1[03]="PRECO"
        V1[04]="UNIDADE"
        V1[06]="FABRIC"
        V1[05]="LOCAL"
               
        V2[01]="@!"
        V2[02]="999"
        V2[03]="9999.99"
        V2[04]="@!"
        V2[06]="@!"
        V2[05]="@!"
                            
        V3[01]="DESCRI€ŽO"
        V3[02]="QTD"
        V3[03]="PRE€O"
        V3[04]="UN"
        V3[06]="FABRICANTE"
        V3[05]="LOCAL"

     ELSEIF ACESSO =1
        PRIVATE V1[07], V2[07], V3[07]
        V1[01]="CODPECA"
        V1[02]="NOMEPECA"
        V1[03]="QTD+TEMP"
        V1[04]="PRECO"
        V1[05]="UNIDADE"
        V1[07]="FABRIC"
        V1[06]="LOCAL"
       
        V2[01]="@!"
        V2[02]="@!"
        V2[03]="999"
        V2[04]="9999.99"
        V2[05]="@!"
        V2[07]="@!"
        V2[06]="@!"
                    
        V3[01]="COD."
        V3[02]="DESCRI€ŽO"
        V3[03]="QTD"
        V3[04]="PRE€O"
        V3[05]="UN"
        V3[07]="FABRICANTE"
        V3[06]="LOCAL"
ENDIF

        
@ 00,00 TO 00,79 DOUBLE
@ 19,00 TO 24,79 DOUBLE

 
DBEDIT(01,00,18,79,v1,"bdbedit",v2,v3,chr(205),space(1)+chr(179))
pecas()                                                          
function Bdbedit(MODO,COLUNA)

MCODPECA=CODPECA
MDIGITO=DIGITO
MNOMEPECA2=NOMEPECA2
MNOMEPECA3=NOMEPECA3
MNOMEPECA4=NOMEPECA4
MNOMEPECA7=NOMEPECA7


IF TEMP<>0
        SETCOLOR("W+/R*,N/W")
        @ 23,75 SAY TEMP PICT "999"
   ELSE
        SETCOLOR("W+/B,N/W")			
        @ 23,75 SAY "   "
ENDIF

SETCOLOR("W+/BG,N/W")

IF ACESSO=1
        @ 23,66 SAY MCODPECA
        @ 23,72 SAY MDIGITO
ENDIF
IF CONPEC=1
        @23,66 SAY MCODNOT
ENDIF
@ 20,06 SAY MNOMEPECA2 PICT "@!"
@ 21,06 SAY MNOMEPECA3 PICT "@!"
@ 22,06 SAY MNOMEPECA4 PICT "@!"
@ 23,06 SAY MNOMEPECA7 PICT "@!"


if modo=1   
    return(1)
  elseif modo=2  
    return(1)
  elseif modo=3   
    return(0)
  elseif modo=4
         
     if lastkey() == 27 && "esc"             
         RESTORE SCREEN FROM TELAP
         return(0)

        ELSEIF LASTKEY() == 32 && "espaço"  

                  SAVE SCREEN TO FTELA
                  SETCOLOR("W+/BG,N/W")
                  @ 00,02 CLEAR TO 23,76
                  @ 00,02 TO 23,76 DOUBLE
                  @ 00,12 SAY "CONSULTA PECAS"
                  PUVARPE()
                  IGUAVARPE()
                  IF ACESSO=1
                        @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
                  ENDIF
                  @ 01,17 SAY "-"
                  @ 01,18 SAY MDIGITO
                  @ 05,21 SAY "Estoque:"  GET MQTD PICT "999"
                  MOSTEXPE()
                  IF ACESSO#1
                        @ 04,25 CLEAR TO 04,30
                        @ 02,25 CLEAR TO 02,45
                  ENDIF
                  INKEY(0)
                  RESTORE SCREEN FROM FTELA
                  CLEAR GETS
                  RETURN(2)

        ELSEIF LASTKEY() == 69 .OR. lastkey() == 101 && "E/e"

                  IF ACESSO=1
                          ENTR_PEC()
                          PECAS()
                          ORDSETFOCUS("CODPECA")
                          SEEK MCODPECA
                          RETURN(2)
                  ENDIF

        ELSEIF LASTKEY()== 13 && "ENTER"

           IF CONPEC=1
                MPCODPEC=CODPECA
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MPCODPEC
                KEYBOARD CHR(13)
                RESTORE SCREEN FROM TELAP
                RETURN(0)
           ENDIF

           IF CONPEC=0
                  SAVE SCREEN TO FTELA
                  SETCOLOR("W+/BG,N/W")
                  @ 00,02 CLEAR TO 23,76
                  @ 00,02 TO 23,76 DOUBLE
                  @ 00,12 SAY "CONSULTA PECAS"
                  PUVARPE()
                  IGUAVARPE()
                  IF ACESSO=1
                        @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
                  ENDIF
                  @ 01,17 SAY "-"
                  @ 01,18 SAY MDIGITO
                  @ 05,21 SAY "Estoque:"  GET MQTD PICT "999"
                  MOSTEXPE()
                  IF ACESSO#1
                        @ 04,25 CLEAR TO 04,30
                        @ 02,25 CLEAR TO 02,45
                  ENDIF
                  INKEY(0)
                  RESTORE SCREEN FROM FTELA
                  RETURN(2)
           ENDIF

       elseif lastkey()== 17 && "CTRL+Q"
      
          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF           
          PUVARPE()
          IGUAVARPE()
                OPC=0
                MQTD=QTD
                CLEAR GETS  
                @ 16,04 CLEAR TO 16,28
                @ 16,04 TO 16,28 DOUBLE
                @ 16,05 SAY "DIGITE O FABRICANTE:" GET OPC PICT "9" VALID OPC <=5
                READ
                BARRA=OPC
                MCODBARRA=CODBARRA
                MPFABRIC=FABRIC
                MPNFABRIC=NFABRIC
                IF BARRA=2
                     MCODBARRA1=CODBARRA1
                     MPFABRIC2=FABRIC2
                     MPNFABRIC2=NFABRIC2

                     BLOQUEIO()
                     REPLACE CODBARRA  WITH MCODBARRA1
                     REPLACE FABRIC    WITH MPFABRIC2
                     REPLACE NFABRIC   WITH MPNFABRIC2
                     REPLACE CODBARRA1 WITH MCODBARRA
                     REPLACE FABRIC2   WITH MPFABRIC
                     REPLACE NFABRIC2  WITH MPNFABRIC
                     REPLACE QTD2       WITH MQTD
                     REPLACE QTD3       WITH 0
                     REPLACE QTD4       WITH 0
                     REPLACE QTD5       WITH 0
                     DBCOMMIT()
                     UNLOCK
                ENDIF
                IF BARRA=3
                     MCODBARRA2=CODBARRA2
                     MPFABRIC3=FABRIC3
                     MPNFABRIC3=NFABRIC3

                     BLOQUEIO()
                     REPLACE CODBARRA  WITH MCODBARRA2
                     REPLACE FABRIC    WITH MPFABRIC3
                     REPLACE NFABRIC   WITH MPNFABRIC3
                     REPLACE CODBARRA2 WITH MCODBARRA
                     REPLACE FABRIC3   WITH MPFABRIC
                     REPLACE NFABRIC3  WITH MPNFABRIC
                     REPLACE QTD2       WITH MQTD
                     REPLACE QTD3       WITH 0
                     REPLACE QTD4       WITH 0
                     REPLACE QTD5       WITH 0
                     DBCOMMIT()
                     UNLOCK 
                ENDIF
                IF BARRA=4
                     MCODBARRA3=CODBARRA3
                     MPFABRIC4=FABRIC4
                     MPNFABRIC4=NFABRIC4

                     BLOQUEIO()
                     REPLACE CODBARRA  WITH MCODBARRA3
                     REPLACE FABRIC    WITH MPFABRIC4
                     REPLACE NFABRIC   WITH MPNFABRIC4
                     REPLACE CODBARRA3 WITH MCODBARRA
                     REPLACE FABRIC4   WITH MPFABRIC
                     REPLACE NFABRIC4  WITH MPNFABRIC
                     REPLACE QTD2       WITH MQTD
                     REPLACE QTD3       WITH 0
                     REPLACE QTD4       WITH 0
                     REPLACE QTD5       WITH 0
                     DBCOMMIT()
                     UNLOCK

                ENDIF
                IF BARRA=5
                     MCODBARRA4=CODBARRA4
                     MPFABRIC5=FABRIC5
                     MPNFABRIC5=NFABRIC5

                     BLOQUEIO()
                     REPLACE CODBARRA  WITH MCODBARRA4
                     REPLACE FABRIC    WITH MPFABRIC5
                     REPLACE NFABRIC   WITH MPNFABRIC5
                     REPLACE CODBARRA4 WITH MCODBARRA
                     REPLACE FABRIC5   WITH MPFABRIC
                     REPLACE NFABRIC5  WITH MPNFABRIC
                     REPLACE QTD2       WITH MQTD
                     REPLACE QTD3       WITH 0
                     REPLACE QTD4       WITH 0
                     REPLACE QTD5       WITH 0
                     DBCOMMIT()
                     UNLOCK

                ENDIF
                IF CONFIRMA ("ZERA O RESTANTE ?")=1
                        BLOQUEIO()
                        REPLACE CODBARRA1  WITH SPACE(20)
                        REPLACE FABRIC2    WITH SPACE(10)
                        REPLACE NFABRIC2   WITH SPACE(12)
                        REPLACE CODBARRA2  WITH SPACE(20)
                        REPLACE FABRIC3    WITH SPACE(10)
                        REPLACE NFABRIC3   WITH SPACE(12)
                        REPLACE CODBARRA3  WITH SPACE(20)
                        REPLACE FABRIC4    WITH SPACE(10)
                        REPLACE NFABRIC4   WITH SPACE(12)
                        REPLACE CODBARRA4  WITH SPACE(20)
                        REPLACE FABRIC5    WITH SPACE(10)
                        REPLACE NFABRIC5   WITH SPACE(12)
                        DBCOMMIT()
                        UNLOCK
              ENDIF
          RESTORE SCREEN FROM FTELA
          V_BUSCA=MNOMEPECA
          ORDSETFOCUS("NOMEPECA")
          SEEK V_BUSCA
          RETURN(2)
                                                                                                          
       elseif lastkey()== 20 && "CTRL+T"

          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF
          PUVARPE()
          IGUAVARPE()
          TNOMEPECA2=MNOMEPECA2
          TNOMEPECA3=MNOMEPECA3
          TNOMEPECA4=MNOMEPECA4
          TNOMEPECA7=MNOMEPECA7
          MNOMEPECA=NOMEPECA
          IF NTX=2
                PECAS()
                ORDSETFOCUS("NOMEPECA")
                SEEK MNOMEPECA
          ENDIF          
          RETURN(2)  

    elseif lastkey()== 22 && "CTRL+V"

          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF          
          IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                BLOQUEIO()
                REPLACE NOMEPECA2 WITH TNOMEPECA2
                REPLACE NOMEPECA3 WITH TNOMEPECA3
                REPLACE NOMEPECA4 WITH TNOMEPECA4
                REPLACE NOMEPECA7 WITH TNOMEPECA7
                DBCOMMIT()
                UNLOCK
          ENDIF
          MNOMEPECA=NOMEPECA
          IF NTX=2
                PECAS()
                ORDSETFOCUS("NOMEPECA")
                SEEK MNOMEPECA
          ENDIF          
          RETURN(2)

    elseif lastkey()== 09 && "TAB"

          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF           
          PUVARPE()
          IGUAVARPE()
          @ 10,00 CLEAR TO 15,79 
          @ 10,00 TO 15,79 DOUBLE
          @ 11,06 GET MNOMEPECA2 PICT "@!"
          @ 12,06 GET MNOMEPECA3 PICT "@!"
          @ 13,06 GET MNOMEPECA4 PICT "@!"
          @ 14,06 GET MNOMEPECA7 PICT "@!"
          READ
          IF UPDATED()
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                    BLOQUEIO()
                    REPLACE NOMEPECA2 WITH MNOMEPECA2
                    REPLACE NOMEPECA3 WITH MNOMEPECA3
                    REPLACE NOMEPECA4 WITH MNOMEPECA4
                    REPLACE NOMEPECA7 WITH MNOMEPECA7
                    DBCOMMIT()
                    UNLOCK
              ENDIF
          ENDIF             
          IF NTX=2
                PECAS()
                ORDSETFOCUS("NOMEPECA")
                SEEK MNOMEPECA
          ENDIF
          RETURN(2)

                                      
       elseif lastkey()== 83 .OR. lastkey() == 115 && "s/S"
          
          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF
          MCAD=1           
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 00,02 CLEAR TO 23,76
          @ 00,02 TO 23,76 DOUBLE
          @ 00,12 SAY "SELECIONA PECAS"
          PUVARPE()
          IGUAVARPE()           
          INIVARPE() 
          MNOMEPECA=NOMEPECA
          MUNIDADE=UNIDADE         
          CLEAR GETS
          ORDSETFOCUS("CODPECA")
          BUSCANUMERO()
          MCODPECA=STRZERO(N1,5)
          @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
          READ
          @ 01,17 SAY "-" + MDIGITO
          SEEK MCODPECA
          IF LASTKEY()=27
                MCAD=0
                RETURN(2)
          ENDIF
          IF MCODPECA=" "
                   TONE(500,5)
                   OL_Yield()
                   ALERT ('CODIGO NAO PODE SER IGUAL A ZERO !!!')
                   MCAD=0
                   RETURN(2)
          ENDIF
          IF FOUND()
          OL_Yield()
                ALERT('CODIGO JA CADASTRADO , REPITA A OPERA€AO')
                RESTORE SCREEN FROM FTELA
                MCAD=0
                RETURN(2)
          ENDIF    
          DO WHILE .T.
                  MOSTEXPE()
                  READ
                  IF EMPTY(MFABRIC)
                  OL_Yield()
                        ALERT('VALOR FABRICANTE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MTEMPUNI)
                  OL_Yield()
                        ALERT('VALOR UNIDADE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MNFABRIC)
                  OL_Yield()
                        ALERT('VALOR N§ FABRICANTE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MNOMEPECA)
                  OL_Yield()
                        ALERT('VALOR DESCRI€AO INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MUNIDADE)
                  OL_Yield()
                        ALERT('VALOR UNIDADE INVALIDO')
                        LOOP
                  ENDIF
                  IF ! EMPTY(MCODBARRA)
                          ORDSETFOCUS('CODBARRA')
                          SEEK MCODBARRA
                          IF FOUND() 
                          OL_Yield()
                                ALERT('CODIGO BARRA JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA1')
                          SEEK MCODBARRA
                          IF FOUND() 
                          OL_Yield()
                                ALERT('CODIGO BARRA2 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA2')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA3 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA3')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA4 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA4')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA5 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  EXIT
          ENDDO
          MDATAENTR=DATE()
          IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1       
                   ORDSETFOCUS("CODPECA")
                   SEEK MCODPECA
                   IF FOUND()
                   OL_Yield()
                           ALERT ('CODIGO JA EXISTE, E TROCADO POR OUTO !!!')
                           BUSCANUMERO()
                           MCODPECA=STRZERO(N1,5)
                   ENDIF
                   BLOQUEIO() 
                   MQTD=0
                   MPRECO=9999.99
                   MQTDMIN=999
                   MQTD2=0
                   MCQTD2=0
                   MCODBARRA1=SPACE(20)
                   MFABRIC2=SPACE(10)
                   MNFABRIC2=SPACE(12)
                   MQTD3=0
                   MCQTD3=0
                   MCODBARRA2=SPACE(20)
                   MFABRIC3=SPACE(10)
                   MNFABRIC3=SPACE(12)
                   MQTD4=0
                   MCQTD4=0
                   MCODBARRA3=SPACE(20)
                   MFABRIC4=SPACE(10)
                   MNFABRIC4=SPACE(12)
                   MQTD5=0
                   MCQTD5=0
                   MCODBARRA4=SPACE(20)
                   MFABRIC5=SPACE(10)
                   MNFABRIC5=SPACE(12)
                   MQTD6=0
                   MCQTD6=0
                   APPEND BLANK
                   REPLPEC()
                   UNLOCK
          ENDIF

          RESTORE SCREEN FROM FTELA
          IF NTX=2
                PECAS()
                ORDSETFOCUS("NOMEPECA")
                SEEK MNOMEPECA
          ENDIF 
          MCAD=0         
          RETURN(2)

    elseif lastkey() == 65 .OR. lastkey()== 97 && "a/A"

          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()      
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          PECAS()
          ORDSETFOCUS("CODPECA")
          SEEK MCODPECA                                    
          IF EMPTY(TRAVA)
                  BLOQUEIO()
                  REPLACE TRAVA WITH "A"
                  DBCOMMIT()
                  UNLOCK
              ELSE
              OL_Yield()
                  ALERT('PECA NAO AUTORIZADA PARA ALTERACAO NO MOMENTO')
                  RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF           
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 00,02 CLEAR TO 23,76
          @ 00,02 TO 23,76 DOUBLE
          @ 00,12 SAY "ALTERA PECAS"
          PUVARPE()
          IGUAVARPE()           
          @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
          @ 01,18 SAY MDIGITO
          @ 05,21 SAY "Estoque:"  GET MQTD PICT "999"
          CLEAR GETS
          DO WHILE .T.
                  ORDSETFOCUS("CODPECA")
                  SEEK MCODPECA                                    
                  MOSTEXPE()
                  READ
                  IF EMPTY(MFABRIC)
                  OL_Yield()
                        ALERT('VALOR FABRICANTE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MTEMPUNI)
                  OL_Yield()
                        ALERT('VALOR UNIDADE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MNFABRIC)
                  OL_Yield()
                        ALERT('VALOR N§ FABRICANTE INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MNOMEPECA)
                  OL_Yield()
                        ALERT('VALOR DESCRI€AO INVALIDO')
                        LOOP
                  ENDIF
                  IF EMPTY(MUNIDADE)
                  OL_Yield()
                        ALERT('VALOR UNIDADE INVALIDO')
                        LOOP
                  ENDIF
                  IF ! EMPTY(MCODBARRA)
                          IF MCODBARRA#CODBARRA    
                              ORDSETFOCUS('CODBARRA')
                              SEEK MCODBARRA
                              IF FOUND() .OR. MCODBARRA=MCODBARRA1 .OR. MCODBARRA=MCODBARRA2 .OR. MCODBARRA=MCODBARRA3 .OR. MCODBARRA=MCODBARRA4
                              OL_Yield()
                                    ALERT('CODIGO BARRA JA EXISTE')
                                    LOOP
                              ENDIF
                          ENDIF
                          ORDSETFOCUS('CODBARRA1')
                          SEEK MCODBARRA
                          IF FOUND() 
                          OL_Yield()
                                ALERT('CODIGO BARRA2 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA2')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA3 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA3')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA4 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA4')
                          SEEK MCODBARRA
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA5 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  ORDSETFOCUS("CODPECA")
                  SEEK MCODPECA
                  IF ! EMPTY(MCODBARRA1)
                          IF MCODBARRA1#CODBARRA1    
                              ORDSETFOCUS('CODBARRA1')
                              SEEK MCODBARRA1
                              IF FOUND() .OR. MCODBARRA1=MCODBARRA2 .OR. MCODBARRA1=MCODBARRA3 .OR. MCODBARRA1=MCODBARRA4
                              OL_Yield()
                                    ALERT('CODIGO BARRA2 JA EXISTE')
                                    LOOP
                              ENDIF
                          ENDIF    
                          ORDSETFOCUS('CODBARRA')
                          SEEK MCODBARRA1
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA2')
                          SEEK MCODBARRA1
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA3 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA3')
                          SEEK MCODBARRA1
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA4 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA4')
                          SEEK MCODBARRA1
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA5 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  ORDSETFOCUS("CODPECA")
                  SEEK MCODPECA
                  IF ! EMPTY(MCODBARRA2)
                          IF MCODBARRA2#CODBARRA2    
                              ORDSETFOCUS('CODBARRA2')
                              SEEK MCODBARRA2
                              IF FOUND() .OR. MCODBARRA2=MCODBARRA3 .OR. MCODBARRA2=MCODBARRA4
                              OL_Yield()
                                    ALERT('CODIGO BARRA3 JA EXISTE')
                                    LOOP
                              ENDIF
                          ENDIF    
                          ORDSETFOCUS('CODBARRA')
                          SEEK MCODBARRA2
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA1')
                          SEEK MCODBARRA2
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA2 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA3')
                          SEEK MCODBARRA2
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA4 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA4')
                          SEEK MCODBARRA2
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA5 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  ORDSETFOCUS("CODPECA")
                  SEEK MCODPECA
                  IF ! EMPTY(MCODBARRA3)
                          IF MCODBARRA3#CODBARRA3                     
                              ORDSETFOCUS('CODBARRA3')
                              SEEK MCODBARRA3
                              IF FOUND() .OR. MCODBARRA3=MCODBARRA4
                              OL_Yield() 
                                    ALERT('CODIGO BARRA4 JA EXISTE')
                                    LOOP
                              ENDIF
                          ENDIF
                          ORDSETFOCUS('CODBARRA')
                          SEEK MCODBARRA3
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA1')
                          SEEK MCODBARRA3
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA2 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA2')
                          SEEK MCODBARRA3
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA3 JA EXISTE')
                                LOOP
                          ENDIF
                            ORDSETFOCUS('CODBARRA4')
                          SEEK MCODBARRA3
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA5 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  ORDSETFOCUS("CODPECA")
                  SEEK MCODPECA
                  IF ! EMPTY(MCODBARRA4)
                          IF MCODBARRA4#CODBARRA4    
                              ORDSETFOCUS('CODBARRA4')
                              SEEK MCODBARRA4
                              IF FOUND()
                              OL_Yield()
                                    ALERT('CODIGO BARRA5 JA EXISTE')
                                    LOOP
                              ENDIF 
                          ENDIF
                          ORDSETFOCUS('CODBARRA')
                          SEEK MCODBARRA4
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA1')
                          SEEK MCODBARRA4
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA2 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA2')
                          SEEK MCODBARRA4
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA3 JA EXISTE')
                                LOOP
                          ENDIF
                          ORDSETFOCUS('CODBARRA3')
                          SEEK MCODBARRA4
                          IF FOUND()
                          OL_Yield()
                                ALERT('CODIGO BARRA4 JA EXISTE')
                                LOOP
                          ENDIF                                               
                  ENDIF
                  EXIT
          ENDDO
          ORDSETFOCUS("CODPECA")
          SEEK MCODPECA            
          IF UPDATED()
              MDATAENTR=DATE()
              MHORA=TIME()
              MBALCONISTA=FUNCIONARIO
              MQTD=MQTD2+MQTD3+MQTD4+MQTD5+MQTD6
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                 DO WHILE .T.
                     HANDLE := FOPEN("D:\KARVAN\ALTERA.TXT", 2)
                         IF FERROR() # 0
                               SETCOLOR("W+/R,N/W")
                               @ 10,18 CLEAR TO 12,48
                               @ 10,18 TO 12,48 DOUBLE
                               SETCOLOR("W+*/R,N/W")
                               @ 11,19 SAY "TENTANDO ACESSO, AGUARDE !!!"
                               INKEY(0.1)
                               SETCOLOR("W+/BG,N/W")
                               @ 10,18 CLEAR TO 12,48
                               LOOP
                           ELSE
                               EXIT
                         ENDIF
                 ENDDO
                 BUFFER=SPACE(1024)
                 BLOCO=1024
                 DO WHILE FREAD(HANDLE,@BUFFER,BLOCO) # 0
                      FREAD(HANDLE,@BUFFER,BLOCO)
                 ENDDO
                 FWRITE(HANDLE,+CHR(13)+CHR(10))
                 FWRITE(HANDLE,ALLTRIM(MCODPECA))
                 FWRITE(HANDLE,SPACE(4))
                 FWRITE(HANDLE,MBALCONISTA)
                 FWRITE(HANDLE,SPACE(1))
                 FWRITE(HANDLE,DTOC(DATE()))
                 FWRITE(HANDLE,SPACE(1))
                 FWRITE(HANDLE,TIME())            
                 FWRITE(HANDLE,+CHR(13)+CHR(10))
                 IF MMULTIPLO # MULTIPLO
                      FWRITE(HANDLE,"MULTIPLO....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(MULTIPLO)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MMULTIPLO)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MCODBARRA3 # CODBARRA3
                      FWRITE(HANDLE,"COBARRA3......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA3))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCODBARRA3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MCODBARRA4 # CODBARRA4
                      FWRITE(HANDLE,"COBARRA4......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA4))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCODBARRA4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF

                 IF MCODBARRA # CODBARRA
                      FWRITE(HANDLE,"COBARRA.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCODBARRA))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MCODBARRA2 # CODBARRA2
                      FWRITE(HANDLE,"COBARRA2......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA2))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCODBARRA2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF   
                 IF MCODBARRA1 # CODBARRA1
                      FWRITE(HANDLE,"COBARRA1......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA1))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCODBARRA1))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNOMEPECA # NOMEPECA
                      FWRITE(HANDLE,"NOMEPECA......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NOMEPECA))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNOMEPECA))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MPRECO # PRECO
                      FWRITE(HANDLE,"PRECO.........:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(PRECO)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MPRECO)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MUNIDADE # UNIDADE
                      FWRITE(HANDLE,"UNIDADE.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(UNIDADE))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MUNIDADE))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MLACRE # LACRE
                      FWRITE(HANDLE,"LACRE.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(LACRE))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MLACRE))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MQTD # QTD
                      FWRITE(HANDLE,"QTD.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MQTD2 # QTD2
                      FWRITE(HANDLE,"QTD2....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD2)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD2)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                                                
                 IF MQTD3 # QTD3
                      FWRITE(HANDLE,"QTD3....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD3)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD3)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                                                
                 IF MQTD4 # QTD4
                      FWRITE(HANDLE,"QTD4....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD4)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD4)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                                                
                 IF MQTD5 # QTD5
                      FWRITE(HANDLE,"QTD5....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD5)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD5)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                                                

                 IF MQTD6 # QTD6
                      FWRITE(HANDLE,"QTD6....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD6)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTD6)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                               
                 IF MTEMPUNI # TEMPUNI
                      FWRITE(HANDLE,"TEMPUNIDADE...:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(TEMPUNI))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MTEMPUNI))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB # DISTRIB
                      FWRITE(HANDLE,"DISTRIBUIDOR1.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB2 # DISTRIB2
                      FWRITE(HANDLE,"DISTRIBUIDOR2.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB2))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB3 # DISTRIB3
                      FWRITE(HANDLE,"DISTRIBUIDOR3.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB3))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB4 # DISTRIB4
                      FWRITE(HANDLE,"DISTRIBUIDOR4.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB4))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MQTDMAX # QTDMAX
                      FWRITE(HANDLE,"QUANTIDADE MAX:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTDMAX)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTDMAX)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MQTDMIN # QTDMIN
                      FWRITE(HANDLE,"QUANTIDADE MIN:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTDMIN)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MQTDMIN)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MFABRIC # FABRIC
                      FWRITE(HANDLE,"FABRICANTE....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MFABRIC))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MFABRIC2 # FABRIC2
                      FWRITE(HANDLE,"FABRICANTE 2..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC2))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MFABRIC2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MFABRIC3 # FABRIC3
                      FWRITE(HANDLE,"FABRICANTE 3..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC3))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MFABRIC3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MFABRIC4 # FABRIC4
                      FWRITE(HANDLE,"FABRICANTE4...:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC4))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MFABRIC4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MFABRIC5 # FABRIC5
                      FWRITE(HANDLE,"FABRICANTE5...:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC5))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MFABRIC5))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNFABRIC4 # NFABRIC4
                      FWRITE(HANDLE,"N.FABRICANTE4.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC4))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNFABRIC4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNFABRIC5 # NFABRIC5
                      FWRITE(HANDLE,"N.FABRICANTE5.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC5))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNFABRIC5))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNFABRIC # NFABRIC
                      FWRITE(HANDLE,"N.FABRICANTE..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNFABRIC))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNFABRIC2 # NFABRIC2
                      FWRITE(HANDLE,"N.FABRICANTE 2:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC2))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNFABRIC2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNFABRIC3 # NFABRIC3
                      FWRITE(HANDLE,"N.FABRICANTE 3:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC3))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNFABRIC3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MP_CUSTO # P_CUSTO
                      FWRITE(HANDLE,"P_CUSTO.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MP_CUSTO)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MP_CUSTO2 # P_CUSTO2
                      FWRITE(HANDLE,"P_CUSTO 2.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO2)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MP_CUSTO2)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MP_CUSTO3 # P_CUSTO3
                      FWRITE(HANDLE,"P_CUSTO 3.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO3)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MP_CUSTO3)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MP_CUSTO4 # P_CUSTO4
                      FWRITE(HANDLE,"P_CUSTO 4.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO4)))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(STR(MP_CUSTO4)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB # DISTRIB
                      FWRITE(HANDLE,"DISTRIB.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB2 # DISTRIB2
                      FWRITE(HANDLE,"DISTRIB2....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB2))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB3 # DISTRIB3
                      FWRITE(HANDLE,"DISTRIB3....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB3))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MDISTRIB4 # DISTRIB4
                      FWRITE(HANDLE,"DISTRIB4....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB4))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MDISTRIB4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MNCM # NCM
                      FWRITE(HANDLE,"NCM.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NCM))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MNCM))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF
                 IF MCFOP # CFOP
                      FWRITE(HANDLE,"CFOP.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CFOP))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MCFOP))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF                               
                 IF MLOCAL # LOCAL
                      FWRITE(HANDLE,"LOCAL.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(LOCAL))
                      FWRITE(HANDLE,SPACE(4))
                      FWRITE(HANDLE,ALLTRIM(MLOCAL))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                 ENDIF

                 FWRITE(HANDLE,"*********************************************")
                 FWRITE(HANDLE,+CHR(13)+CHR(10))
                 FCLOSE(HANDLE)        
                 BLOQUEIO()
                 REPLPEC()
              ENDIF
          ENDIF
          BLOQUEIO()
          REPLACE TRAVA WITH SPACE(01)
          UNLOCK
          DBCOMMIT()
          RESTORE SCREEN FROM FTELA
          V_BUSCA=MNOMEPECA
          ORDSETFOCUS("NOMEPECA")
          SEEK V_BUSCA
          RETURN(2)

           ELSEIF lastkey() == 80 .or. lastkey() == 112 && "P/p"
                
                IF ACESSO#1
                OL_Yield()
                    ALERT('ACESSO NAO AUTORIZADO')
                    RETURN(2)
                ENDIF
                RUN DEL C:\KARVAN\*.TXT
                RUN DEL C:\KARVAN\*.TMP
                OPC=0
                PUVARPE()
                IGUAVARPE()
                MNOTFUNC=FUNCIONARIO
                @ 08,03 CLEAR TO 17,75
                @ 08,03 to 08,75
                SETCOLOR("W+/R,N/W")
                @ 08,04 say "Cod. Barra"
                @ 08,29 say "Fabricante"
                @ 08,48 say "N§ Fabricante"
                SETCOLOR("W+/BG,N/W")
                @ 10,04 GET MCODBARRA PICT "@!"
                @ 10,29 GET MFABRIC PICT "@!"
                @ 10,48 GET MNFABRIC PICT "@!"
                @ 10,61 SAY "= 1"
                @ 17,03 to 17,75
                @ 11,04 GET MCODBARRA1 PICT "@!"
                @ 11,29 GET MFABRIC2 PICT "@!"
                @ 11,48 GET MNFABRIC2 PICT "@!"
                @ 11,61 SAY "= 2"
                @ 12,04 GET MCODBARRA2 PICT "@!"
                @ 12,29 GET MFABRIC3 PICT "@!"
                @ 12,48 GET MNFABRIC3 PICT "@!"
                @ 12,61 SAY "= 3"
                @ 13,04 GET MCODBARRA3 PICT "@!"
                @ 13,29 GET MFABRIC4 PICT "@!"
                @ 13,48 GET MNFABRIC4 PICT "@!"
                @ 13,61 SAY "= 4"
                @ 14,04 GET MCODBARRA4 PICT "@!"
                @ 14,29 GET MFABRIC5 PICT "@!"
                @ 14,48 GET MNFABRIC5 PICT "@!"
                @ 14,61 SAY "= 5"
                CLEAR GETS  
                @ 16,05 SAY "DIGITE O FABRICANTE:" GET OPC PICT "9" VALID OPC <=5 
                *.AND. VALID OPC >= 1                
                READ
                BARRA=OPC
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
                IF EMPTY(MPFABRIC)
                OL_Yield()
                        ALERT('CODIGO VERIFICADOR INCORRETO')
                        RETURN(2)
                ENDIF        
                MPCODPEC=CODPECA
                MPNOMPEC=NOMEPECA
                RUN NET USE LPT1 /DELETE
                IF ALLTRIM(NETNAME())="CPU14"
                        RUN NET USE LPT1 \\CPU14\GENERICO
                     ELSE
                        RUN NET USE LPT1 \\CPU12\GENERICO
                ENDIF
                CONTZEBRA=0
                LINZEBRA=-255
                NOMEZEBRA=1
                ZEBRA()
                NOMEZEBRA=1
                ZEBRA()
                NOMEZEBRA=1
                ZEBRA()
                RUN NET USE LPT1 /DELETE
                TESTAIMP()
                RETURN(0)
                         
    elseif lastkey()== 07 && "DELETE"
                    
          SAVE SCREEN TO FTELA
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          IF NTX=2
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
          ENDIF
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 00,02 CLEAR TO 23,76
          @ 00,02 TO 23,76 DOUBLE
          @ 00,12 SAY "DELETA PECAS"
          PUVARPE()
          IGUAVARPE()
          @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
          MOSTEXPE()
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
                 DO WHILE .T.
                     MBALCONISTA=FUNCIONARIO
                     HANDLE := FOPEN("D:\KARVAN\DELETA.TXT", 2)
                         IF FERROR() # 0
                               SETCOLOR("W+/R,N/W")
                               @ 10,18 CLEAR TO 12,48
                               @ 10,18 TO 12,48 DOUBLE
                               SETCOLOR("W+*/R,N/W")
                               @ 11,19 SAY "TENTANDO ACESSO, AGUARDE !!!"
                               INKEY(0.1)
                               SETCOLOR("W+/BG,N/W")
                               @ 10,18 CLEAR TO 12,48
                               LOOP
                           ELSE
                               EXIT
                         ENDIF
                 ENDDO
                 BUFFER=SPACE(1024)
                 BLOCO=1024
                 DO WHILE FREAD(HANDLE,@BUFFER,BLOCO) # 0
                      FREAD(HANDLE,@BUFFER,BLOCO)
                 ENDDO
                 FWRITE(HANDLE,+CHR(13)+CHR(10))
                 FWRITE(HANDLE,ALLTRIM(MCODPECA))
                 FWRITE(HANDLE,SPACE(4))
                 FWRITE(HANDLE,MBALCONISTA)
                 FWRITE(HANDLE,SPACE(1))
                 FWRITE(HANDLE,DTOC(DATE()))
                 FWRITE(HANDLE,SPACE(1))
                 FWRITE(HANDLE,TIME())
                 FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"COBARRA.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"COBARRA2......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"COBARRA1......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(CODBARRA1))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"NOMEPECA......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NOMEPECA))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"PRECO.........:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(PRECO)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"UNIDADE.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(UNIDADE))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"TEMPUNIDADE...:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(TEMPUNI))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"DISTRIBUIDOR1.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"DISTRIBUIDOR2.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"DISTRIBUIDOR3.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"DISTRIBUIDOR4.:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(DISTRIB4))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"QUANTIDADE....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTD)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"QUANTIDADE MAX:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTDMAX)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"QUANTIDADE MIN:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(QTDMIN)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"FABRICANTE....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"FABRICANTE 2..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"FABRICANTE 3..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"N.FABRICANTE..:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"N.FABRICANTE 2:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(NFABRIC2))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"N.FABRICANTE 3:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(FABRIC3))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"P_CUSTO.......:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"P_CUSTO 2.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO2)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"P_CUSTO 3.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO3)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"P_CUSTO 4.....:")
                      FWRITE(HANDLE,SPACE(1))
                      FWRITE(HANDLE,ALLTRIM(STR(P_CUSTO4)))
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FWRITE(HANDLE,"**************************************************")
                      FWRITE(HANDLE,+CHR(13)+CHR(10))
                      FCLOSE(HANDLE)        
              BLOQUEIO()
              DELETE           
              DBCOMMIT()
              UNLOCK
          ENDIF
          RESTORE SCREEN FROM FTELA
          V_BUSCA=MNOMEPECA
          ORDSETFOCUS("NOMEPECA")
          SEEK V_BUSCA
          
          RETURN(2)

	elseif lastkey()== 49 && "1" 

          PECAS()
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("CODPECA")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(05)
          @ 03,20 CLEAR TO 05,36
          @ 03,20 TO 05,36 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF ! FOUND()
          OL_Yield()
              ALERT('CODIGO NAO ENCONTRADO')
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 50 && "2"

          SAVE SCREEN TO FTELA
          REST SCREEN FROM FTELA
          USE C:\TEMP\PECAS.DBF SHARED
          *pecas()
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_APLIC:=SPACE(20)
          V_DESCR:=SPACE(20)
          @ 03,20 CLEAR TO 07,54
          @ 03,20 TO 07,54 DOUBLE
          @ 04,22 SAY "DESCRICAO:" GET V_DESCR PICT "@!"
          @ 06,22 SAY "APLICACAO:" GET V_APLIC PICT "@!"
          READ
          IF EMPTY(V_DESCR) .AND. EMPTY(V_APLIC)                        

              ELSEIF EMPTY(V_DESCR)
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_APLIC) $ NOMEPECA .OR. RTRIM(V_APLIC) $ NOMEPECA2;
                .OR. RTRIM(V_APLIC) $ NOMEPECA3 .OR. RTRIM(V_DESCR) $ NOMEPECA4 .OR. RTRIM(V_DESCR) $ NOMEPECA7
              ELSEIF EMPTY(V_APLIC)
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_DESCR) $ NOMEPECA .OR. RTRIM(V_DESCR) $ NOMEPECA2;
                .OR. RTRIM(V_DESCR) $ NOMEPECA3 .OR. RTRIM(V_DESCR) $ NOMEPECA4 .OR. RTRIM(V_DESCR) $ NOMEPECA7
              ELSE
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA;
                .OR. RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA2;
                .OR. RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA3;
                .OR. RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA4;
                .OR. RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA7
          ENDIF          
          IF EOF() .OR. EMPTY(V_DESCR) .AND. EMPTY(V_APLIC)
          OL_Yield()
              ALERT('CONSULTA NAO ENCONTRADA')
              PECAS()
              ORDSETFOCUS("NOMEPECA")
              GOTO TOP
              RETURN(2)
          ENDIF
          NTX=2
          RETURN(2)

        elseif lastkey()== 51 && "3"

          PECAS()
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("FABRIC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          @ 03,20 CLEAR TO 05,47
          @ 03,20 TO 05,47 DOUBLE
          @ 04,22 SAY "NOME FABRIC.:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF ! FOUND()
          OL_Yield()
              ALERT('CODIGO NAO ENCONTRADO')
              SKIP-1
              RETURN(1)
          ENDIF
          NTX=3
          RETURN(2)

	elseif lastkey()== 52 && "4"

          PECAS()
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(12)
          @ 03,20 CLEAR TO 05,47
          @ 03,20 TO 05,47 DOUBLE
          @ 04,22 SAY "N§ FABRIC.:" GET V_BUSCA PICT "@!"
          READ
          DO WHILE .T.
                ORDSETFOCUS("NFABRIC")
                SEEK V_BUSCA
                IF FOUND()
                        EXIT
                ENDIF
                ORDSETFOCUS("NFABRIC2")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('2§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("NFABRIC3")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('3§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("NFABRIC4")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('4§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("NFABRIC5")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('5§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("NFABRIC")
                SEEK V_BUSCA
                IF ! FOUND()
                OL_Yield()
                      ALERT('CODIGO NAO ENCONTRADO')
                ENDIF        
                RETURN(1)
          ENDDO
          NTX=4
          RETURN(2)

        elseif lastkey()== 53 && "5"

          PECAS()
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,55
          @ 03,20 TO 05,55 DOUBLE
          @ 04,22 SAY "COD.BARRA.:" GET V_BUSCA PICT "@!"
          READ
          DO WHILE .T.
                ORDSETFOCUS("CODBARRA")
                SEEK V_BUSCA
                IF FOUND()
                        EXIT
                ENDIF
                ORDSETFOCUS("CODBARRA1")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('2§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("CODBARRA2")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('3§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("CODBARRA3")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('4§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("CODBARRA4")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('5§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("CODBARRA")
                SEEK V_BUSCA
                IF ! FOUND()
                OL_Yield()
                        ALERT('CODIGO NAO ENCONTRADO')
                ENDIF
                RETURN(1)
          ENDDO
          NTX=5
          RETURN(2)
        elseif lastkey()== 54 && "6"

            IF CONPEC=0
        
                  SAVE SCREEN TO FTELA
                  REST SCREEN FROM FTELA
                  USE C:\TEMP\PECAS.DBF SHARED
                  CLEAR GETS
                  SET CURSOR ON
                  SET SOFTSEEK ON
                  SETCOLOR("W+/BG,N/W")
                  V_APLIC:=SPACE(20)
                  V_DESCR:=SPACE(20)
                  @ 03,20 CLEAR TO 07,54
                  @ 03,20 TO 07,54 DOUBLE
                  @ 04,22 SAY "DESCRICAO.:" GET V_DESCR PICT "@!"
                  @ 06,22 SAY "FABRICANTE:" GET V_APLIC PICT "@!"
                  READ
                  IF LASTKEY() == 27
                        NTX=2
                        RETURN(2)
                  ENDIF
                  COPY TO C:\TEMP\PECATEMP FOR V_APLIC=FABRIC .OR. V_APLIC=FABRIC2 .OR. V_APLIC=FABRIC3;
                  .OR. V_APLIC=FABRIC4 .OR. V_APLIC=FABRIC5
                  USE C:\TEMP\PECATEMP
                  COPY TO C:\TEMP\PECAS FOR RTRIM(V_DESCR) $ NOMEPECA 
                  USE C:\TEMP\PECAS
                  NTX=2
                  RETURN(2)
            ENDIF

        elseif lastkey()== 55 && "7"

          PECAS()
          ORDSETFOCUS("LOCAL")
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          @ 03,20 CLEAR TO 05,41
          @ 03,20 TO 05,41 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          NTX=1
          RETURN(2)


        elseif lastkey()== 56 && "8"

          PECAS()
          index on LOCAL to c:\temp\LOCAL for qtdmin < 0 .and. qtd <=0
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          @ 03,20 CLEAR TO 05,41
          @ 03,20 TO 05,41 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          NTX=1
          RETURN(2)

        elseif lastkey()== 400 && "ctrl +"

          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RESTORE SCREEN FROM FTELA
              RETURN(2)
          ENDIF
          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          MQTDMIN=0
          PUVARPE()
          IGUAVARPE()
          MQTDANTIGO=QTDMIN
          @ 03,20 CLEAR TO 07,54
          @ 03,20 TO 07,54 DOUBLE
          @ 04,22 SAY "QTD_MAX:" GET MQTDMIN PICT "999"
          READ
          BLOQUEIO()
          REPLACE QTDMIN WITH MQTDMIN
          DBCOMMIT()
          UNLOCK           
          OL_Yield()
          NTX=1
          RETURN(2)

       elseif lastkey()== 18  && "ctrl+R/r"

            IF CONFIRMA ("IMPRIMIR O ESTOQUE?")=1
                    CLEAR GETS
                    SET CURSOR ON
                    SET SOFTSEEK ON
                    MCORREDOR=SPACE(02)
                    PUVARPE()
                    IGUAVARPE()
                    @ 03,20 CLEAR TO 07,54
                    @ 03,20 TO 07,54 DOUBLE
                    @ 04,22 SAY "CORREDOR:" GET MCORREDOR PICT "@!"
                    READ
                    ORDSETFOCUS("LOCAL_E")
                    SEEK MCORREDOR
                    LIN=01
                    LIN++
                    LIN++
                    SET DEVICE TO PRINT
                    @ LIN,05 SAY "RELATORIO REPOSICAO"
                    LIN++
                    DO WHILE .T.
                        IF LEFT(LOCAL_E,02)#MCORREDOR
                                EXIT
                        ENDIF
                        IF QTD_C>QTD_P
                             LIN++
                             MQTD=QTD_C-QTD_P
                             @ LIN,01 SAY LOCAL_E
                             @ LIN,15 SAY LOCAL
                             IF MQTD>QTD_E
                                    MQTD=QTD_E
                             ENDIF
                             @ LIN,25 SAY MQTD PICT "9999"
                             BLOQUEIO()
                             REPLACE QTD_P WITH QTD_P+MQTD
                             REPLACE QTD_E WITH QTD_E-MQTD
                             DBCOMMIT()
                             UNLOCK
                        ENDIF
                        SKIP
                    ENDDO
                    LIN=LIN+8
                    @LIN,01 SAY "  "
                    GUILHOTINA()
                    SET DEVICE TO SCREEN
            ENDIF
            RETURN(2)

        elseif lastkey()== 398 && "ctrl -"

          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          BLOQUEIO()
          REPLACE QTDMIN WITH MQTDANTIGO
          DBCOMMIT()
          UNLOCK           
          OL_Yield()
          NTX=1
          RETURN(2)

        elseif lastkey()== 79 .OR. lastkey() == 111  && "o/O"

          PECAS()
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("original")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(12)
          @ 03,20 CLEAR TO 05,47
          @ 03,20 TO 05,47 DOUBLE
          @ 04,22 SAY "N. ORIGINAL:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF ! FOUND()
          OL_Yield()
              ALERT('CODIGO NAO ENCONTRADO')
              SKIP-1
              RETURN(1)
          ENDIF
          NTX=3
          RETURN(2)

       elseif lastkey()== -1 && "F2"
             CLEAR GETS
             SAVE SCREEN TO FTELA             
             @ 02,04 CLEAR TO 23,47
             @ 02,04 TO 23,47 DOUBLE
             @ 03,05 SAY "E/E.....= VERIFICA DADOS DA ENTRADA"
             @ 04,05 SAY "CTRL+Q..= TROCA FABRICANTE E ZERA RESTANTE"
             @ 05,05 SAY "CTRL+T..= COPIA DADOS DE OBSERVACAO"
             @ 06,05 SAY "CTRL+V..= COLA DADOS DE OBSERVACAO"
             @ 07,05 SAY "TAB.....= GRAVA DADOS EM OBSERVACAO"
             @ 08,05 SAY "S/s.....= SELECIONA DADOS PECAS"
             @ 09,05 SAY "A/a.....= ALTERA DADOS PECAS"
             @ 10,05 SAY "P/p.....= IMPRIME ETIQUETA"
             @ 11,05 SAY "1.......= CONSULTA POR CODIGO PECA"
             @ 12,05 SAY "2.......= CONSULTA POR NOME PECA"
             @ 13,05 SAY "3.......= CONSULTA POR FABRICANTE"
             @ 14,05 SAY "4.......= CONSULTA POR NOME FABRICANTE"
             @ 15,05 SAY "5.......= ENCONTRA CODIGO DE BARRAS"
             @ 16,05 SAY "6.......= CONSULTA POR NOME/FABRICANTE"
             @ 17,05 SAY "7.......= CONSULTA POR LOCAL"
             @ 18,05 SAY "8.......= CONSULTA LOCAL COM ESTOQUE ZERO"
             @ 19,05 SAY "CTRL+...= ALTERA ESTOQUE MAXIMO"
             @ 20,05 SAY "CTRL-...= RETORNA ESTOQUE MAXIMO ANTIGO"
             @ 21,05 SAY "CTRL+R/r= IMPRIME RELATORIO DO ESTOQUE"
             @ 22,05 SAY "O/o.....= CONSULTA POR NUMERO ORIGINAL"
             INKEY(0)
             RESTORE SCREEN FROM FTELA
             RETURN(2)

     ENDIF
ENDIF
