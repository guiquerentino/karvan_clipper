******************************************************************************

*****************************/FUN€AO CONSULTA PECAS***************************
PECAS()
ORDSETFOCUS("PNOMEPECA")
NTX=1
SAVE SCREEN TO TELAP

SET KEY -41 TO OTARIOS() // F12

SETCOLOR("GR/B+")
CLS

PRIVATE V1[07], V2[07], V3[07]
 
V1[01]="NOMEPECA"
V1[02]="QTD+TEMP"
V1[03]="P_CUSTO"
V1[04]="FABRIC"
V1[05]="FABRIC2"
V1[06]="NFABRIC"
V1[07]="NFABRIC2"

V2[01]="@!"
V2[02]="999"
V2[03]="9999.99"
V2[04]="@!"
V2[05]="@!"
V2[06]="@!"
V2[07]="@!"
            
V3[01]="DESCRI€ŽO"
V3[02]="QTD"
V3[03]="CUSTO"
V3[04]="FABRICANTE"
V3[05]="FABRICANTE2"
V3[06]="NFABRICANTE"
V3[07]="NFABRICANTE2"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE
@ 18,00 TO 21,79 DOUBLE

@ 23,05 SAY "[01] CODIGO [02] NOME [03] FABRICANTE [04] N§ FABRICANTE"
                    
SETCOLOR("R/B+")
@ 23,05 SAY "[01]"
@ 23,17 SAY "[02]"
@ 23,27 SAY "[03]"
@ 23,43 SAY "[04]"
SETCOLOR("GR/B+,N/W")
RECNOATU=1
RECNOANT=0
RECNO2=1 
DBEDIT(01,00,17,79,v1,"KLdbedit",v2,v3,chr(205),space(1)+chr(179))
                                                          
function KLdbedit(MODO,COLUNA)

IF RECNOANT+1#RECNO()
        RECNO2=RECNOANT
        RECNOANT=RECNOATU
        RECNOATU=RECNO()
        IF RECNOANT=RECNOATU
                RECNOANT=RECNO2
        ENDIF
ENDIF

MNOMEPECA2=NOMEPECA2
MNOMEPECA3=NOMEPECA3

    
SETCOLOR("W+/BG,N/W")

IF CONPEC=1
        @23,66 SAY MCODNOT
ENDIF

@ 19,06 SAY MNOMEPECA2 PICT "@!"
@ 20,06 SAY MNOMEPECA3 PICT "@!"

if modo=1   
    return(1)
  elseif modo=2  
    return(1)
  elseif modo=3   
    return(0)
  elseif modo=4
         
     if lastkey() == 27
         RESTORE SCREEN FROM TELAP
         return(0)

      elseif lastkey()== 99 .OR. lastkey() == 67 .OR. lastkey() == 43 && "c/C/+"

                NUNREG=RECNO()
                PUVARPE()
                IGUAVARPE()
                LINFABR=0
                IF ! EMPTY(MFABRIC2)
                        LINFABR++
                ENDIF        
                IF ! EMPTY(MFABRIC3)
                        LINFABR++
                ENDIF        
                IF ! EMPTY(MFABRIC4)
                        LINFABR++
                ENDIF        
                IF ! EMPTY(MFABRIC5)
                        LINFABR++
                ENDIF        
                IF MQTDMIN=999
                        SAVE SCREEN TO FTELA
                        OL_Yield()
                        ALERT('QUANTIDA MAXIMA=999, ALTERE O VALOR')
                        @ 02,02 CLEAR TO 06,20
                        @ 02,02 TO 06,20 DOUBLE
                        @ 04,03 SAY "QUANTIDADE:" GET MQTDMIN PICT "999"
                        READ
                        IF LASTKEY()=27
                                RETURN(2)
                        ENDIF
                        BLOQUEIO()
                        REPLACE QTDMIN WITH MQTDMIN
                        UNLOCK
                        RESTORE SCREEN FROM FTELA
                ENDIF
                MQTDMIN_=MQTDMIN
                MQTDMIN=MQTDMIN-(MQTD+MTEMP+MTEMPPED)
                IF MULTIPLO>0
                        MQTDMIN=INT(MQTDMIN/MULTIPLO)*MULTIPLO
                ENDIF
                SAVE SCREEN TO FTELA
                @ 04,06 CLEAR TO 08,72
                @ 04,06 TO 08,72 DOUBLE
                DIA1=DAY(DATE())
                DIA2=DAY(DATE()-DIA1)
                DIA3=DAY(DATE()-DIA1-DIA2)
                @ 05,15 SAY "QUANTIDADE:"
                SETCOLOR("R+/BG,N/W")
                @ 05,27 SAY MQTD PICT "999"
                SETCOLOR("W+/BG,N/W")
                @ 05,40 SAY "QUANT.MAXIMA:"
                SETCOLOR("R+/BG,N/W")
                @ 05,54 SAY MQTDMIN_ PICT "999"
                SETCOLOR("W+/BG,N/W")
                @ 07,09 SAY CMONTH(DATE())
                @ 07,25 SAY CMONTH(DATE()-DIA1)
                @ 07,41 SAY CMONTH(DATE()-DIA1-DIA2)
                @ 07,57 SAY CMONTH(DATE()-DIA1-DIA2-DIA3)
                SETCOLOR("B+/BG,N/W")
                @ 07,19 SAY MQTDMAX PICT "9999"
                @ 07,35 SAY MQTDMAX1 PICT "9999"
                @ 07,51 SAY MQTDMAX2 PICT "9999"
                @ 07,67 SAY MQTDMAX3 PICT "9999"
                SETCOLOR("W+/BG,N/W")
                @ 10,10 CLEAR TO 14,30
                @ 10,10 TO 14,30 DOUBLE
                @ 12,11 SAY "QUANT. A PEDIR:" GET MQTDMIN PICT "999"
                READ
                RESTORE SCREEN FROM FTELA

                IF MQTDMIN>0
                        IF LINFABR>0
                                IF MTEMPPED>0
                                          SAVE SCREEN TO FTELA
                                          @ 10,10 CLEAR TO 15,33
                                          @ 10,10 TO 15,33 DOUBLE
                                          @ 12,12 SAY "PRODUTO JA PEDIDO!!!"
                                          @ 13,12 SAY "QUANT. PEDIDA.:" GET MTEMPPED PICT "999"
                                          @ 14,12 SAY "QUANT. A PEDIR:" GET MQTDMIN PICT "999"
                                          CLEAR GETS
                                          INKEY(0)
                                          RESTORE SCREEN FROM FTELA
                                ENDIF        
                                MCUSTO=P_CUSTO
                                MDISTRIB=DISTRIB
                                IF MCUSTO>P_CUSTO2
                                        MCUSTO=P_CUSTO2
                                        MDISTRIB=DISTRIB2
                                ENDIF
                                IF MCUSTO>P_CUSTO3
                                        MCUSTO=P_CUSTO3
                                        MDISTRIB=DISTRIB3
                                ENDIF
                                IF MCUSTO>P_CUSTO4
                                        MCUSTO=P_CUSTO4
                                        MDISTRIB=DISTRIB4
                                ENDIF
                                SAVE SCREEN TO FTELA
                                @ 14,05 CLEAR TO 17,28
                                @ 14,05 TO 17,28 DOUBLE
                                @ 15,07 SAY "DICA MELHOR PRECO"
                                @ 16,07 SAY MDISTRIB
                                @ 16,20 SAY MCUSTO PICT "9999.99"
                                *RESTORE SCREEN FROM FTELA
                                @ 02,05 clear to 06+LINFABR,28
                                @ 02,05 to 06+LINFABR,28 double
                                @ 04+LINFABR,06 TO 04+LINFABR,27 
                                @ 03,06 SAY "1-"
                                @ 04,06 SAY "2-"
                                @ 03,08 SAY MFABRIC
                                @ 03,20 SAY MCUSTO1 PICT "9,999.99"
                                @ 04,08 SAY MFABRIC2
                                @ 04,20 SAY MCUSTO2 PICT "9,999.99"
                                IF ! EMPTY(MFABRIC3)
                                        @ 05,06 SAY "3-"
                                        @ 05,08 SAY MFABRIC3
                                        @ 05,20 SAY MCUSTO3 PICT "9,999.99"
                                ENDIF        
                                IF ! EMPTY(MFABRIC4)
                                        @ 06,06 SAY "4-"
                                        @ 06,08 SAY MFABRIC4
                                        @ 06,20 SAY MCUSTO4 PICT "9,999.99"
                                ENDIF        
                                IF ! EMPTY(MFABRIC5)
                                        @ 07,06 SAY "5-"
                                        @ 07,08 SAY MFABRIC5
                                        @ 07,20 SAY MCUSTO5 PICT "9,999.99"
                                ENDIF        
                                OPC=0
                                @ 05+LINFABR,06 SAY "OPCAO" GET OPC PICT "9" VALID OPC >0 .AND. OPC <=LINFABR+1
                                READ
                                IF LASTKEY()=27
                                        RETURN(2)
                                ENDIF
                                IF OPC=1
                                        MFABRIC=FABRIC
                                        MNFABRIC=NFABRIC
                                ENDIF        
                                IF OPC=2
                                        MFABRIC=FABRIC2
                                        MNFABRIC=NFABRIC2
                                ENDIF        
                                IF OPC=3
                                        MFABRIC=FABRIC3
                                        MNFABRIC=NFABRIC3
                                ENDIF        
                                IF OPC=4
                                        MFABRIC=FABRIC4
                                        MNFABRIC=NFABRIC4
                                ENDIF        
                                IF OPC=5
                                        MFABRIC=FABRIC5
                                        MNFABRIC=NFABRIC5
                                ENDIF        

                        ENDIF
                        BLOQUEIO()
                        REPLACE TEMPPED WITH TEMPPED+MQTDMIN
                        UNLOCK
                        DBCOMMIT()
                        USE &CAMINHO&MCODNOT SHARED
                        INDEX ON PCODPEC TO PCODPEC
                        SEEK MCODPECA
                        IF FOUND()
                                BLOQUEIO()
                                REPLACE PQTDPEC WITH PQTDPEC+MQTDMIN
                                REPLACE PPRETOT   WITH MP_CUSTO*MQTDMIN
                                UNLOCK
                            ELSE
                                BLOQUEIO()				
                                APPEND BLANK
                                REPLACE PCODPEC   WITH MCODPECA
                                REPLACE PNOMPEC   WITH MNOMEPECA
                                REPLACE PUNI      WITH MUNIDADE
                                REPLACE PPRECO    WITH MP_CUSTO
                                REPLACE PPRETOT   WITH MP_CUSTO*MQTDMIN
                                REPLACE PQTDPEC   WITH MQTDMIN
                                REPLACE PNFABRIC  WITH MNFABRIC
                                REPLACE PNFABRIC2 WITH MNFABRIC2
                                REPLACE PFABRIC   WITH MFABRIC
                                UNLOCK
                        ENDIF
                ENDIF
                PECAS()
                IF NTX=1
                        ORDSETFOCUS("PCODPECA")
                        SEEK MCODPECA
                ENDIF
                IF NTX=2
                        ORDSETFOCUS("PNOMEPECA")
                        SEEK MNOMEPECA
                ENDIF
                IF NTX=3
                        ORDSETFOCUS("PFABRIC")
                        SEEK MFABRIC
                        GOTO RECNOANT
                        IF ! FOUND()
                                SKIP
                        ENDIF
                ENDIF
                IF NTX=4
                        ORDSETFOCUS("PNFABRIC")
                        SEEK MNFABRIC
                ENDIF	
                IF NTX=5
                        SET INDEX TO TEMP
                        SEEK MNOMEPECA
                ENDIF        
                RETURN(2)


        ELSEIF LASTKEY()== 13 && "ENTER"

                  SAVE SCREEN TO FTELA
                  SETCOLOR("W+/BG,N/W")
                  @ 00,02 CLEAR TO 23,76
                  @ 00,02 TO 23,76 DOUBLE
                  @ 00,12 SAY "CONSULTA PECAS"
                  PUVARPE()
                  IGUAVARPE()
                  MLUCRO=PRECO/MP_CUSTO
                  MLUCRO=MLUCRO-1
                  MLUCRO=MLUCRO*100
                  IF ACESSO=1
                        @ 04,33 SAY "Margem" GET MLUCRO PICT "999.99%"
                  ENDIF
                  @ 01,04 SAY "Codigo:"  GET MCODPECA PICT "@!"
                  @ 01,17 SAY "-"
                  @ 01,18 SAY MDIGITO
                  @ 05,21 SAY "Estoque:"  GET MQTD PICT "999"
                  MOSTEXPE()
                  IF ACESSO#1
                        @ 04,25 CLEAR TO 04,30
                  ENDIF
                  INKEY(0)
                  RESTORE SCREEN FROM FTELA
                  CLEAR GETS
                  RETURN(2)


	elseif lastkey()== 49 && "1" 
          NTX=1
          PECAS()
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("PCODPECA")
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

          PECAS()
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
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_APLIC) $ NOMEPECA .AND. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO 
              ELSEIF EMPTY(V_APLIC)
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_DESCR) $ NOMEPECA .AND. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO 
              ELSE
                INDEX ON NOMEPECA TO TEMP FOR RTRIM(V_DESCR) $ NOMEPECA .AND. RTRIM(V_APLIC) $ NOMEPECA;
                .AND. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO
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

          NTX=3
          PECAS()
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("PFABRIC")
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

            NTX=4
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
                ORDSETFOCUS("PNFABRIC")
                SEEK V_BUSCA
                IF FOUND()
                        EXIT
                ENDIF
                ORDSETFOCUS("PNFABRIC2")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('2§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("PNFABRIC3")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('3§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("PNFABRIC4")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('4§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF
                ORDSETFOCUS("PNFABRIC5")
                SEEK V_BUSCA
                IF FOUND()
                OL_Yield()
                        ALERT('5§ CODIGO ENCONTRADO')
                        EXIT
                ENDIF    
                ORDSETFOCUS("PNFABRIC")
                SEEK V_BUSCA
                IF ! FOUND()
                OL_Yield()
                      ALERT('CODIGO NAO ENCONTRADO')
                ENDIF        
                RETURN(1)
            ENDDO
	          RETURN(2)

    	  elseif lastkey()== 53 && "5"

            NTX=5
            PECAS()
            CLEAR GETS
            SET CURSOR ON        
            SET SOFTSEEK ON
            SETCOLOR("W+/BG,N/W")
            V_BUSCA:=SPACE(10)
            @ 03,20 CLEAR TO 05,47
            @ 03,20 TO 05,47 DOUBLE
            @ 04,22 SAY "NOME FABRIC.:" GET V_BUSCA PICT "@!"
            READ
            INDEX ON NOMEPECA TO TEMP FOR QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=FABRIC;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=FABRIC2;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=FABRIC3;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=FABRIC4
            *.OR. QUANTID > MULTIPLO .AND. V_BUSCA=FABRIC5 
            RETURN(2)

        elseif lastkey()== 56 && "8"

            PECAS()
            NTX=5
            CLEAR GETS
            INDEX ON NOMEPECA TO TEMPMAX FOR QTDMAX > QTDMIN .AND. QTDMIN > 0 
            RETURN(2)
         
        elseif lastkey()== 55 && "7"

            PECAS()
            INDEX ON QTD TO QTD FOR (QTD+TEMP+TEMPPED) <= 0 .AND. QTDMIN > 0
            RETURN(2)

        elseif lastkey()== 54 && "6"

            NTX=5
            PECAS()
            CLEAR GETS
	          SET CURSOR ON	       
	          SET SOFTSEEK ON
	          SETCOLOR("W+/BG,N/W")
            V_BUSCA:=SPACE(20)
            @ 03,20 CLEAR TO 05,58
            @ 03,20 TO 05,58 DOUBLE
            @ 04,22 SAY "DISTRIBUIDOR:" GET V_BUSCA PICT "@!"
            READ
            INDEX ON NOMEPECA TO TEMP FOR QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=DISTRIB;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=DISTRIB2;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=DISTRIB3;
            .OR. QTDMIN-(QTD+TEMP+TEMPPED) > MULTIPLO .AND. V_BUSCA=DISTRIB4
            RETURN(2)


     ENDIF
ENDIF
