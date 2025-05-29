******************************************************************************

*****************************/FUN€AO CONSULTA GARANTIA***************************

SET CENT ON
GARANTIA()
PUBLIC MGPROTOCOLO
MGPROTOCOLO=SPACE(20)
MGARDISTR=SPACE(15)
ORDSETFOCUS("GARDATA")
IF ACESSO=1
        ORDSETFOCUS("GARDATA_B")
ENDIF
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT ('Nenhuma Garantia Pendente...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
CLS

PRIVATE V1[13], V2[13], V3[13]

V1[06]="GARCOD"
V1[07]="GARPECA"
V1[02]="GARQTD"
V1[08]="GARCLI"
V1[10]="GARDATA"
V1[01]="GARPROTO"
V1[09]="GARFABR"
V1[04]="GARNFAB"
V1[05]="GARDISTR"
V1[03]="GARBAIXA"
V1[11]="DATAENVIO"
V1[12]="GCUSTO"
V1[13]="GNUMNOTA"

V2[06]="@!"
V2[07]="@!"
V2[02]="999"
V2[08]="@!"
V2[10]="99/99/99"
V2[01]="@!"
V2[09]="@!"
V2[04]="@!"
V2[05]="@!"
V2[03]="@!"
V2[11]="99/99/99"
V2[12]="99999.99"
V2[13]="@!"

V3[06]="CODIGO"
V3[07]="PRODUTO"
V3[02]="QTD"
V3[08]="CLIENTE"
V3[10]="DATA"
V3[01]="PROTOCOLO"
V3[09]="FABRICANTE"
V3[04]="N.FABRIC"
V3[05]="DISTRIBUIDOR"
V3[03]="BAIXA"
V3[11]="ENVIO"
V3[12]="CUSTO"
V3[13]="NOTA FORNEC"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[01] CODIGO [02] PRODUTO [04] PROTOCOLO ",78)

DBEDIT(01,00,21,79,v1,"GDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Gdbedit(modo,coluna)
if modo=1
    return(1)
  elseif modo=2
    return(1)
  elseif modo=3
    return(0)
  elseif modo=4
     if lastkey() == 27
	 set softseek off
          ACESSO=0
	  return(0)
     elseif lastkey()== 07 && "DELETE"
          SET CURSOR ON
          IF ACESSO#1
                RETURN(2)
          ENDIF     
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              PUVARGA()
              IGUAVARGA()
              MBARRA=VERIFIC
              BLOQUEIO()
              DELETE
              UNLOCK
              PECAS()
              ORDSETFOCUS("CODPECA")
              SEEK MGARCOD
              IF ! FOUND()
              OL_Yield()
                    ALERT('CODIGO NAO ENCONTRADO... QTD NAO ATUALIZADA')
                 ELSE
                    DISTRIBQTD=MGARQTD
                    MQTD=QTD+MGARQTD
                    BLOQUEIO()
                    IF MBARRA<=1
                          REPLACE QTD2 WITH QTD2+MGARQTD
                    ENDIF      
                    IF MBARRA=2
                          REPLACE QTD3 WITH QTD3+MGARQTD
                    ENDIF      
                    IF MBARRA=3
                          REPLACE QTD4 WITH QTD4+MGARQTD
                    ENDIF      
                    IF MBARRA=4
                          REPLACE QTD5 WITH QTD5+MGARQTD
                    ENDIF      
                    IF MBARRA=5
                          REPLACE QTD6 WITH QTD6+MGARQTD
                    ENDIF      
                    REPLACE QTD WITH MQTD
                    REPLACE ATUALIZADO WITH "S"
                    IF QTD_C>0
                        XMQTD=DISTRIBQTD
                        DO WHILE QTD_P<QTD_C .AND. XMQTD>0
                                REPLACE QTD_P WITH QTD_P+1
                                XMQTD--
                        ENDDO                
                        IF XMQTD>0
                                REPLACE QTD_E WITH QTD_E+XMQTD
                        ENDIF        
                    ENDIF
                    ENTRADISTRIB()
                    DBCOMMIT()
                    UNLOCK
              ENDIF
          ENDIF
          GARANTIA()

          RETURN(2)

    elseif lastkey()== 65 .OR. lastkey() == 97 .OR. LASTKEY()= -1 && "A"

          @ 02,15 SAY "ALTERA GARANTIA"
          MOSTEXGAR()
          READ
          IF LASTKEY()=27
                   RESTORE SCREEN FROM FTELA
                   RETURN(2)
          ENDIF
          IF UPDATED()
                IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                     REPLGAR()
                ENDIF
          ENDIF
          RESTORE SCREEN FROM FTELA
          RETURN(2)

        ELSEIF LASTKEY()== 13 && "ENTER"

          @ 02,15 SAY "MOSTRA GARANTIA"
          MOSTEXGAR()
          INKEY(0)
          CLEAR GETS
          RESTORE SCREEN FROM FTELA
          RETURN(2)

	elseif lastkey()== 49 && "1" 
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("GARCOD_B")
             ELSE
                ORDSETFOCUS("GARCOD")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(05)
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          DBSEEK (V_BUSCA,.T.,.T.)
          IF EOF()
               SKIP-1
               RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 50 && "2"

          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          ORDSETFOCUS("CODCLI")
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,25
          @ 17,10 TO 19,25 DOUBLE
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
          GARANTIA()
          IF ACESSO=1
                ORDSETFOCUS("GARCLI_B")
             ELSE
                ORDSETFOCUS("GARCLI")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(25)
          *@ 03,20 CLEAR TO 05,56
          *@ 03,20 TO 05,56 DOUBLE
          *@ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "@!"
          *READ
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
          
        elseif lastkey()== 51 && "3"
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("GARDISTR_B")
             ELSE
                ORDSETFOCUS("GARDISTR")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "DISTRIB:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 52 && "4"
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("GARPROTO_B")
             ELSE
                ORDSETFOCUS("GARPROTO")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "PROTOCOLO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 53 && "5"
          CLEAR GETS
          SET SOFTSEEK ON
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "PROTOCOLO:" GET V_BUSCA PICT "@!"
          READ
          MGARPROTO=SPACE(20)
          MGARDISTR=SPACE(07)
          INDEX ON GARDISTR TO c:\karvan\RELAT FOR GARPROTO=V_BUSCA
          RUN DEL C:\TEMP\*.TXT
          CAM="C:\TEMP\"
          EXT=".TXT"
          NUNREG=1
          DO WHILE ! EOF()
                IF MGARDISTR#GARDISTR
                      NUMREG=1
                ENDIF
                IF NUMREG=1
                     HANDLE:=fcreate(CAM+GARDISTR+EXT)
                     HANDLE := FOPEN(CAM+GARDISTR+EXT, 2)
                     BUFFER=SPACE(1024)
                     BLOCO=1024
                     DO WHILE FREAD(HANDLE,@BUFFER,BLOCO) # 0
                              FREAD(HANDLE,@BUFFER,BLOCO)
                     ENDDO
                     FWRITE(HANDLE,GARDISTR)
                     FWRITE(HANDLE,+CHR(13)+CHR(10))
                     FWRITE(HANDLE,+CHR(13)+CHR(10))
                ENDIF
                FWRITE(HANDLE,GARNFAB)
                FWRITE(HANDLE,SPACE(1))
                FWRITE(HANDLE,ALLTRIM(STR(GARQTD)))
                FWRITE(HANDLE,SPACE(1))
                FWRITE(HANDLE,GARDEF1)
                FWRITE(HANDLE,SPACE(1))
                FWRITE(HANDLE,GARDEF2)
                FWRITE(HANDLE,SPACE(1))
                FWRITE(HANDLE,GNUMNOTA)
                FWRITE(HANDLE,SPACE(1))
                FWRITE(HANDLE,ALLTRIM(STR(GCUSTO)))
                FWRITE(HANDLE,+CHR(13)+CHR(10))
                MGARDISTR=GARDISTR
                NUMREG++                
                SKIP
          ENDDO
          FCLOSE(HANDLE)
          ALERT('RELATORIO CRIADO EM C:\TEMP')
          RETURN(2)

        elseif lastkey()== 54 && "6"
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("GARNFAB_B")
             ELSE
                ORDSETFOCUS("GARNFAB")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "N.FABRICANTE:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 55 && "7"
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("DATAENVIO_B")
             ELSE
                ORDSETFOCUS("DATAENVIO")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=DATE()
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "DATA ENVIO:" GET V_BUSCA PICT "@D"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 56 && "8"
          CLEAR GETS
          SET CURSOR ON
          IF ACESSO=1
                ORDSETFOCUS("GARDATA_B")
             ELSE
                ORDSETFOCUS("GARDATA")
          ENDIF
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=DATE()
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "DATA GARANTIA:" GET V_BUSCA PICT "@D"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        ELSEIF LASTKEY() == 69 .OR. lastkey() == 101 && "E/e"

                  MCODPECA=GARCOD
                  MGARDISTR=GARDISTR
                  NUMREG=RECNO()
                  ENTR_PEC()
                  GARANTIA()
                  IF ACESSO=1
                        ORDSETFOCUS("GARCOD_B")
                     ELSE
                        ORDSETFOCUS("GARCOD")
                  ENDIF
                  SEEK MCODPECA
                  GOTO NUMREG
                  IF GRAVA="S"
                          BLOQUEIO()
                          REPLACE GCUSTO WITH MCUSTO
                          REPLACE GNUMNOTA WITH MNOTA
                          REPLACE GARDISTR WITH MDISTRIB
                          REPLACE GARPROTO WITH MGPROTOCOLO
                          REPLACE DATAENVIO WITH DATE()
                          UNLOCK
                  ENDIF
                  RETURN(2)

        elseif lastkey()== 66 .OR. lastkey() == 98 && "b/B"

          IF ACESSO=1
                RETURN(2)
          ENDIF
          CLEAR GETS
          BLOQUEIO()
          REPLACE GARBAIXA WITH "S"
          UNLOCK
          RETURN(2)

       elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"          

          IF CONFIRMA ("REIMPRIME A GARANTIA?")=1
                PUVARGA()
                IGUAVARGA()
                IMPRI_GAR()
          ENDIF
          RETURN(2)                         

        elseif lastkey()== 80 .OR. lastkey() == 112 && "P/p"

          SAVE SCREEN TO FTELA
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
          IF EMPTY(MGPROTOCOLO)             
                  @ 03,20 CLEAR TO 05,56
                  @ 03,20 TO 05,56 DOUBLE
                  @ 04,22 SAY "N.PROTOCOLO:" GET MGPROTOCOLO PICT "@!"
                  READ
          ENDIF
          RESTORE SCREEN FROM FTELA
          BLOQUEIO()
          REPLACE DATAENVIO WITH DATE()
          REPLACE GARPROTO WITH MGPROTOCOLO
          UNLOCK
          RETURN(2)
     ENDIF
ENDIF
RETURN(1)       
