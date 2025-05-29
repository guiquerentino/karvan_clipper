************************************************************************

*****************************/FUN€AO RELATORIO ENTREGAS******************

SET CENTURY ON
NTX=1
CLEAR GETS
REL_ENTR()
CLOSE INDEXES
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhuma Entrega no momento...')
   REST SCREEN FROM FTELA
   RETURN(0)
ENDIF

SETCOLOR("GR/B+")
PRIVATE V1[14], V2[14], V3[14]

V1[01]="MOTOBOY"
V1[02]="QTDENTR"
V1[03]="HORA_S"
V1[04]="HORA_C"
V1[05]="SEC2TIME(TIME2SEC(HORA_S)+TIME2SEC(SEC2TIME(((4*KM)+(1.5*QTDENTR))*60)))"
V1[06]="TEMPO"
V1[07]="KM"
V1[08]="PONTO"
V1[09]="SACOLA"
V1[10]="MAQUINA"
V1[11]="DATA"
V1[12]="CODENTR"
V1[13]="TERMINAL"
V1[14]="ATRASO"
             
V2[01]="@!"
V2[02]="99"
V2[03]="99:99:99"
V2[04]="99:99:99"
V2[05]="99:99:99"
V2[06]="99:99:99"
V2[07]="99.999"
V2[08]="@!"
V2[09]="@!"
V2[10]="@!"
V2[11]="99/99/99"
V2[12]="999999999"
V2[13]="@!"
V2[14]="@!"

V3[01]="MOTOBOY"
V3[02]="QTD"
V3[03]="SAIDA"
V3[04]="CHEGADA"
V3[05]="ESTIMATIVA"
V3[06]="TEMPO"
V3[07]="KM"
V3[08]="PONTO"
V3[09]="S"
V3[10]="M"
V3[11]="DATA"
V3[12]="N.ENTREGA"
V3[13]="TERMINAL"
V3[14]="ATRASO"
    
@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[B] BUSCA [DELETE] DELETA [R] VERIFICA [CTRL+I] INCLUIR ",78)

DBEDIT(01,00,21,79,v1,"NDBEDIT", v2, v3,chr(205),space(1)+chr(179))

function NDBEDIT(modo,coluna)

if modo=1
        return(1) 
      elseif modo=2
        return(1)
      elseif modo=3
        REST SCREEN FROM FTELA
        return(0)
      elseif modo=4
        if lastkey() == 27
               set softseek off
               REST SCREEN FROM FTELA
               return(0)
           elseif lastkey()== 84 .OR. lastkey() == 116  && "T/t"

                  IF ACESSO#1
                  OL_Yield()
                      ALERT('ACESSO NAO AUTORIZADO')
                      RESTORE SCREEN FROM FTELA
                      RETURN(0)
                  ENDIF
                  MMOTOBOY=SPACE(10)
                  MMOTOCA=MOTOBOY
                  MHORA=HORA_S
                  MCODENTR=CODENTR
                  @ 18,10 CLEAR TO 20,56
                  @ 18,10 TO 20,56 DOUBLE
                  @ 19,12 SAY "FUNCIONARIO:" GET MMOTOBOY PICT "@!" 
                  READ
                  BLOQUEIO()
                  REPLACE MOTOBOY WITH MMOTOBOY
                  REPLACE HORA_S  WITH TIME()
                  MOTOBOY()
                  ORDSETFOCUS("MOTOCA")
                  SEEK MMOTOBOY
                  IF ! FOUND() .OR. EMPTY(CHEGADA)
                  OL_Yield()                         
                        ALERT('NOME INVALIDO OU, MOTOBOY ESTA FORA')
                        REL_ENTR()
                        ORDSETFOCUS("CODENTR")
                        SEEK MCODENTR
                        BLOQUEIO()
                        REPLACE MOTOBOY WITH MMOTOCA
                        REPLACE HORA_S  WITH MHORA
                        RETURN(1)
                  ENDIF
                  BLOQUEIO()
                  REPLACE CHEGADA WITH SPACE(08)
                  REPLACE SAIDA   WITH TIME()
                  UNLOCK
                  SEEK MMOTOCA
                  BLOQUEIO()
                  REPLACE CHEGADA WITH "08:00:00"
                  REPLACE SAIDA   WITH SPACE(08)
                  REL_ENTR()
                  CLOSE INDEXES
                  GOTO BOTTOM
                  RETURN(1)

           elseif lastkey()== 66 .OR. lastkey() == 98  && "B/b"

                SAVE SCREEN TO TELA
                MCODCLI=0
                MNOMECLI=SPACE(35)
                CLIENTES()
                ORDSETFOCUS("CODCLI")
                SET KEY -40 TO CONCLI1() // F11
                @ 17,10 CLEAR TO 19,24
                @ 17,10 TO 19,24 DOUBLE
                @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "999"
                READ
                IF MCODCLI=0
                        @ 17,10 CLEAR TO 19,55
                        @ 17,10 TO 19,55 DOUBLE
                        @ 18,12 SAY "NOME:" GET MNOMECLI PICT "@!"
                        READ
                    ELSE
                        SEEK MCODCLI
                        IF FOUND()
                                MNOMECLI=NOMECLI
                             ELSE
                             OL_Yield()
                                ALERT('CODIGO NAO ENCONTRADO')
                        ENDIF
                ENDIF
                ENTR_CLI()
                NUMREG=LASTREC()
                LINHA=05
                @ LINHA,04 CLEAR TO LINHA+1,35
                @ LINHA,04 TO LINHA+1,35 DOUBLE
                DO WHILE ! BOF()
                        GOTO NUMREG
                        IF RTRIM(MNOMECLI) $ CLIENTE
                                IF ! DELETED()
                                        @ LINHA+1,04 CLEAR TO LINHA+1,35
                                        MCODENTR=ENTREGA
                                        REL_ENTR()
                                        ORDSETFOCUS("CODENTR")
                                        SEEK MCODENTR
                                        MMOTOBOY=MOTOBOY
                                        MDATA=DATA
                                        @ LINHA+1,05 SAY MMOTOBOY
                                        @ LINHA+1,16 SAY MDATA 
                                        @ LINHA+1,26 SAY MCODENTR
                                        LINHA++
                                        @ 05,04 TO LINHA+1,35 DOUBLE
                                        IF LINHA=20
                                                INKEY(0)
                                                REST SCREEN FROM TELA
                                                LINHA=05
                                                @ LINHA,04 CLEAR TO LINHA+1,35
                                                @ LINHA,04 TO LINHA+1,35 DOUBLE
                                        ENDIF
                                ENDIF
                        ENDIF
                        IF LASTKEY()==27
                                REST SCREEN FROM TELA
                                REL_ENTR()
                                ORDSETFOCUS("CODENTR")
                                GOTO BOTTOM
                                RETURN(1)
                        ENDIF
                        NUMREG--
                        ENTR_CLI()
                        GOTO NUMREG
                ENDDO
                INKEY(0)
                REST SCREEN FROM TELA
                REL_ENTR()
                ORDSETFOCUS("CODENTR")
                GOTO BOTTOM
                RETURN(1)

           elseif lastkey() == 65 .OR. lastkey()== 97 && "a/A"

                  SAVE SCREEN TO FTELA
                  IF ACESSO#1 
                  OL_Yield()     
                      ALERT('ACESSO NAO AUTORIZADO')
                      RESTORE SCREEN FROM FTELA
                      RETURN(0)
                  ENDIF
                  MCODENTR=CODENTR
                  MHORA_S=HORA_S
                  MHORA_C=HORA_C
                  MTEMPO=TEMPO
                  *MMAQUINA=MAQUINA
                  MSACOLA=SACOLA
                  MMOTOBOY=MOTOBOY
                  MDATA=DATA
                  MQTDENTR=QTDENTR
                  @ 08,04 CLEAR TO 20,35
                  @ 08,04 TO 20,35 DOUBLE
                  @ 09,05 SAY "CHEGADA:" GET MHORA_C 
                  @ 11,05 SAY "TEMPO..:" GET MTEMPO
                  *@ 13,05 SAY "MAQUINA:" GET MMAQUINA PICT "99"
                  *@ 15,05 SAY "SACOLA.:" GET MSACOLA PICT "99"
                  @ 17,05 SAY "DATA...:" GET MDATA PICT "@D"
                  @ 19,05 SAY "QTD....:" GET MQTDENTR PICT "99"
                  READ
                  BLOQUEIO()
                  REPLACE HORA_C  WITH MHORA_C
                  REPLACE TEMPO   WITH MTEMPO
                  REPLACE DATA    WITH MDATA
                  REPLACE QTDENTR WITH MQTDENTR
                  UNLOCK
                  REST SCREEN FROM FTELA
                  RETURN(1)

           elseif lastkey() == 122 .OR. lastkey()== 90 && "z/Z"

                  SAVE SCREEN TO FTELA
                  MCODENTR=CODENTR
                  MMOTOBOY=MOTOBOY
                  MOTOBOY()
                  ORDSETFOCUS("MOTOCA")
                  SEEK MMOTOBOY
                  BLOQUEIO()
                  REPLACE CHEGADA WITH SPACE(08)
                  REPLACE SAIDA   WITH SPACE(08)
                  UNLOCK
                  REL_ENTR()
                  ORDSETFOCUS("CODENTR")
                  SEEK MCODENTR
                  REST SCREEN FROM FTELA
                  RETURN(1)


           elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"

                SAVE SCREEN TO TELA
                MMOTOBOY=MOTOBOY
                MCODENTR=CODENTR
                MHORA_S=HORA_S
                MHORA_C=HORA_C
                ENTR_CLI()
                ORDSETFOCUS("ENTREGA")
                LINHA=05
                @ 05,22 CLEAR TO LINHA+4,75
                @ 05,22 TO LINHA+4,75 DOUBLE
                SEEK MCODENTR
                DO WHILE ! EOF()
                      IF ENTREGA=MCODENTR
                              IF ! DELETED()
                                    MCLIENTE=CLIENTE
                                    MCODIGO=CODIGO
                                    MT_MOTO=T_MOTO
                                    @ LINHA+3,22 CLEAR TO LINHA+3,75
                                    @ 06,28 SAY MMOTOBOY
                                    @ 06,40 SAY MHORA_S PICT "99:99"
                                    @ 06,46 SAY "\"
                                    @ 06,47 SAY MHORA_C PICT "99:99"
                                    @ 07,28 SAY REPL("-",47)
                                    @ LINHA+3,24 SAY MT_MOTO                                     
                                    @ LINHA+3,28 SAY MCLIENTE                                     
                                    @ LINHA+3,64 SAY MCODIGO                                     
                                    LINHA++                                    
                                    @ 05,22 TO LINHA+3,75 DOUBLE
                                                    
                              ENDIF
                         ELSE
                              EXIT  
                      ENDIF
                      SKIP
                ENDDO
                IF CONFIRMA("IMPRIME O RELATORIO?")=1
                        PRINTER()
                        REL_ENTR()
                        ORDSETFOCUS("CODENTR")
                        SEEK MCODENTR
                        MCODENTR=CODENTR
                        ENTR_CLI()
                        ORDSETFOCUS("ENTREGA")
                        LINHA=05
                        SEEK MCODENTR
                        @ LINHA,05 SAY MMOTOBOY
                        LINHA=LINHA+2          
                        DO WHILE ! EOF()
                              IF ENTREGA=MCODENTR
                                      IF ! DELETED()
                                            MCLIENTE=CLIENTE
                                            MCODIGO=CODIGO
                                            @ LINHA,02 SAY MCLIENTE
                                            LINHA++                                                            
                                      ENDIF
                                 ELSE
                                      EXIT  
                              ENDIF
                              SKIP
                        ENDDO
                        LINHA=LINHA+8
                        @ LINHA,01 SAY " "
                        GUILHOTINA()
                        NORMAL()        
                 ENDIF                 
                 REST SCREEN FROM TELA
                 SET DEVICE TO SCREEN
                 REL_ENTR()
                 ORDSETFOCUS("CODENTR")
                 SEEK MCODENTR 
                 RETURN(1) 
                                                                  
           elseif lastkey()== 49 && "1" 
                  CLEAR GETS
                  SETCOLOR("W+/BG,N/W")
                  SET CURSOR ON
                  ORDSETFOCUS("CODENTR")
                  SET SOFTSEEK ON
                  V_BUSCA:=0
                  @ 03,20 CLEAR TO 05,41
                  @ 03,20 TO 05,41 DOUBLE
                  @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
                  READ
                  SEEK V_BUSCA
                  IF EOF()
                      SKIP-1
                      RETURN(1)
                  ENDIF
                RETURN(1)

           elseif lastkey()== 50 && "2"
                  CLEAR GETS
                  SETCOLOR("W+/BG,N/W")
                  SET CURSOR ON
                  ORDSETFOCUS("SACOLA")
                  SET SOFTSEEK ON
                  V_BUSCA:=0
                  @ 03,20 CLEAR TO 05,35
                  @ 03,20 TO 05,35 DOUBLE
                  @ 04,22 SAY "SACOLA:" GET V_BUSCA PICT "99"
                  READ
                  SEEK V_BUSCA
                  IF EOF()
                      SKIP-1
                      RETURN(1)
                  ENDIF
                RETURN(1)

           elseif lastkey()== 51 && "3" 
                  CLEAR GETS
                  SETCOLOR("W+/BG,N/W")
                  SET CURSOR ON
                  ORDSETFOCUS("MOTOBOY")
                  SET SOFTSEEK ON
                  V_BUSCA:=SPACE(12)
                  @ 03,20 CLEAR TO 05,44
                  @ 03,20 TO 05,44 DOUBLE
                  @ 04,22 SAY "MOTOBOY:" GET V_BUSCA PICT "@!"
                  READ
                  DBSEEK(V_BUSCA,.T.,.T.)
                  IF EOF()
                      SKIP-1
                      RETURN(1)
                  ENDIF

                RETURN(1)

           elseif lastkey()== 52 && "4" 

                INDEX ON QTDENTR TO QTDENTR
                RETURN(1)

           elseif lastkey()== 53 && "5" 

                  CLEAR GETS
                  MENTREGA=CODENTR
                  SETCOLOR("W+/BG,N/W")
                  SET CURSOR ON
                  SET SOFTSEEK ON
                  V_BUSCA:=0
                  @ 03,20 CLEAR TO 05,43
                  @ 03,20 TO 05,43 DOUBLE
                  @ 04,22 SAY "ORCAMENTO:" GET V_BUSCA PICT "999999999"
                  READ
                  ENTR_CLI()
                  ORDSETFOCUS("CODIGO")
                  SEEK V_BUSCA
                  IF FOUND()
                        MENTREGA=ENTREGA
                     ELSE
                        ALERT('ENTREGA NAO ENCONTRADA !!!')
                  ENDIF
                  REL_ENTR()
                  ORDSETFOCUS("CODENTR")
                  SEEK MENTREGA
                  RETURN(1)

           elseif lastkey()== 54 && "6" 

                SAVE SCREEN TO TELA
                XP1=0
                XP2=0
                XP3=0
                XP4=0
                XP5=0
                DINICIO=DATE()
                DFINAL=DATE()
                @ 04,10 CLEAR TO 20,45
                @ 04,10 TO 20,45 DOUBLE
                @ 06,12 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
                @ 07,12 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
                READ                
                INDEX ON DATA TO DATA FOR DATA>=DINICIO .AND. DATA<=DFINAL
                NUMREG=1
                @ 09,11 SAY "=PONTO=====QTD===================="
                LINHA=10
                REL_ENTR()
                SET INDEX TO DATA
                DO WHILE ! EOF()
                        IF PONTO="P1"
                                        XP1=XP1+QTDENTR
                        ENDIF
                        IF PONTO="P2"
                                        XP2=XP2+QTDENTR
                        ENDIF
                        IF PONTO="P3"
                                        XP3=XP3+QTDENTR
                        ENDIF
                        IF PONTO="P4"
                                        XP4=XP4+QTDENTR
                        ENDIF
                        IF PONTO="P5"
                                        XP5=XP5+QTDENTR
                        ENDIF
                        SKIP
                ENDDO
                @ 11,12 SAY "P1 =" GET XP1 PICT "99999"
                @ 13,12 SAY "P2 =" GET XP2 PICT "99999"
                @ 15,12 SAY "P3 =" GET XP3 PICT "99999"
                @ 17,12 SAY "P4 =" GET XP4 PICT "99999"
                @ 19,12 SAY "P5 =" GET XP5 PICT "99999"
                INKEY(0)
                CLEAR GETS
                REST SCREEN FROM TELA
                REL_ENTR()
                RETURN(1)
           
           elseif lastkey()== 09 && "CTRL+I"

                SAVE SCREEN TO TELA
                SET KEY -40 TO CONCLI1() // F11                                
                MHORA_S=HORA_S
                MCODCLI=0
                MMOTOBOY=MOTOBOY
                MQTDENTR=QTDENTR
                MCODENTR=CODENTR
                ENTR_CLI()
                INDEX ON ENDERECO TO TEMP FOR ENTREGA=MCODENTR
                GOTO TOP
                CONTCLI=0
                MENDERECO=SPACE(20)
                DO WHILE ! EOF()
                        IF MENDERECO#ENDERECO
                                CONTCLI++
                        ENDIF
                        MENDERECO=ENDERECO
                        SKIP
                ENDDO
                @ 18,10 CLEAR TO 20,56
                @ 18,10 TO 20,56 DOUBLE
                @ 19,12 SAY "CLIENTE:" GET MCODCLI PICT "9999" 
                READ
                CTEMPO="00:05:00"
                SomaH:=SEC2TIME( TIME2SEC(TIME())-TIME2SEC(MHORA_S))
                IF SOMAH > CTEMPO  .OR. CONTCLI>=6
                        ALERT('TEMPO OU QUANTIDADE EXCEDIDO')
                        REL_ENTR()
                        ORDSETFOCUS("CODENTR")
                        SEEK MCODENTR
                        RETURN(1)
                ENDIF
                CLIENTES()
                SET KEY -40 TO OTARIOS() // F11                                
                ORDSETFOCUS("CODCLI")
                SEEK MCODCLI
                IF FOUND()
                        MNOMECLI=NOMECLI
                        MT_MOTO=T_MOTO
                        MENDCLI=ENDCLI
                        MKM=KM
                        IF ! EMPTY(CEL)
                                MTEL=CEL
                             ELSE
                                MTEL=TEL
                        ENDIF
                        ENTREGA()
                        ORDSETFOCUS("ENDERECO")
                        SEEK MENDCLI
                        IF FOUND()
                                MCODIGO=CODIGO
                                MNOMECLI=ENTREGAS
                            ELSE
                                IF ACESSO#1 
                                       ALERT('ACESSO NAO AUTORIZADO')
                                       REL_ENTR()
                                       ORDSETFOCUS("CODENTR")
                                       SEEK MCODENTR 
                                       RETURN(1)
                                ENDIF                
                                MCODIGO=0
                        ENDIF
                        CUPOM()
                        ORDSETFOCUS("CODNOT")
                        SEEK MCODIGO
                        IF FOUND()
                                IF ALLTRIM(NOTPAG)="CREDITO" 
                                     CARTAO=1
                                ENDIF
                                IF ALLTRIM(NOTPAG)="DEBITO" 
                                     CARTAO=1
                                ENDIF
                        ENDIF
                    ELSE
                        *REL_ENTR()
                        *ORDSETFOCUS("CODENTR")
                        *SEEK MCODENTR
                        *OL_Yield()
                        *ALERT('CLIENTE NAO CADASTRADO')
                        *RETURN(1)
                        ENTREGA()
                        ORDSETFOCUS("CODIGO")
                        @ 18,10 CLEAR TO 20,56
                        @ 18,10 TO 20,56 DOUBLE
                        MCODIGO=0
                        @ 19,12 SAY "PEDIDO:" GET MCODIGO PICT "999999999"
                        READ
                        SEEK MCODIGO
                        IF FOUND()
                                MCODIGO=CODIGO
                                MNOMECLI=ENTREGAS
                                MENDCLI=ENDERECO
                                MPONTO=PONTO
                                MKM=KM
                                MT_MOTO=T_MOTO
                                MHORA=HORA
                                MTEL=TELEFONE
                                IF ALLTRIM(FORMA)="CREDITO" .OR. ALLTRIM(FORMA)="DEBITO" 
                                             CARTAO=1
                                ENDIF
                            ELSE
                                ALERT('PEDIDO NAO ENCONTRADO!!!')
                                REL_ENTR()
                                ORDSETFOCUS("CODENTR")
                                SEEK MCODENTR
                                RETURN(1)
                        ENDIF
                ENDIF
                IF LASTKEY() == 27
                        REST SCREEN FROM FTELA
                        return(0)
                ENDIF
                ENTR_CLI()
                INDEX ON ENDERECO TO TEMP FOR ENTREGA=MCODENTR
                SEEK MENDCLI
                MQTDENTR=1
                IF FOUND()
                        MQTDENTR--
                    ELSE
                        MQTDENTR=MT_MOTO
                ENDIF
                REL_ENTR()
                ORDSETFOCUS("CODENTR")
                SEEK MCODENTR
                BLOQUEIO()
                REPLACE QTDENTR WITH QTDENTR+MQTDENTR
                *REPLACE HORA_S  WITH TIME()
                IF (2*MKM) > KM
                        REPLACE KM WITH 2 * (MKM*(1+(QTDENTR/50)))
                     ELSE
                        REPLACE KM WITH KM*(1+(QTDENTR/50))
                ENDIF
                MQTD=QTDENTR
                MKM=KM
                ENTREGA()
                ORDSETFOCUS("ENDERECO")
                SEEK MENDCLI
                IF FOUND()
                        BLOQUEIO()
                        DELETE
                        UNLOCK
                        OL_Yield()
                        ALERT('ENTREGA EXCLUIDA COM EXITO')
                ENDIF
                ENVIADOS()
                ORDSETFOCUS("CODNOT")
                SEEK MCODIGO
                IF FOUND()
                        BLOQUEIO()
                        REPLACE MOTOCA WITH MMOTOBOY
                        UNLOCK
                ENDIF
                ENTR_CLI()
                BLOQUEIO()
                APPEND BLANK
                REPLACE ENTREGA  WITH MCODENTR
                REPLACE CLIENTE  WITH MNOMECLI
                REPLACE ENDERECO WITH MENDCLI
                REPLACE CODIGO   WITH MCODIGO
                REPLACE T_MOTO   WITH MT_MOTO
                REPLACE TELEFONE WITH MTEL
                UNLOCK
                NUMREG=LASTREC()
                LIN=1
                Printer()
                DO WHILE ! BOF()
                        IF NUMREG=LASTREC()-150
                                EXIT
                        ENDIF
                        GOTO NUMREG
                        IF ENTREGA=MCODENTR .AND. ! DELETED()
                                @ LIN,02 SAY CLIENTE
                                LIN++
                        ENDIF
                        NUMREG--
                ENDDO
                LIN++
                @ LIN,00 SAY MQTD PICT "999"
                LIN++
                LIN++
                @ LIN,00 SAY MMOTOBOY
                @ LIN,10 SAY TIME() PICT "99:99"
                @ LIN,16 SAY DATE()
                @ LIN,30 SAY "KM:"
                @ LIN,33 SAY MKM PICT "99.999"
                TCHEGADA=((4*MKM)+(1.5*MQTD))*60
                TCHEGADA=SEC2TIME(TCHEGADA)
                *@ LIN+1,00 SAY "ESTIMATIVA CHEGADA:"
                *@ LIN+1,22 SAY SEC2TIME(TIME2SEC(TIME())+TIME2SEC(TCHEGADA))
                LIN++
                REL_ENTR()
                SOMA=0
                DINICIO=DATE()
                DFINAL=DATE()
                INDEX ON DATA TO DATA FOR DATA>=DINICIO .AND. DATA<=DFINAL
                *NUMREG=1
                SET INDEX TO DATA
                DO WHILE ! EOF()
                       IF MMOTOBOY=MOTOBOY
                              SOMA=SOMA+QTDENTR
                       ENDIF
                       SKIP
                ENDDO
                LIN++
                @ LIN,00 SAY SOMA PICT "999"
                @ LIN+5,01 SAY " "
                @ PROW(),00 SAY CHR(27)+chr(109)
                LIN=0
                SET DEVICE TO SCREEN
                REST SCREEN FROM TELA
                ORDSETFOCUS("CODENTR")
                SEEK MCODENTR
                RETURN(1)

           elseif lastkey()== -20 && "CTRL+F1"

                IF ACESSO#1
                        RETURN(1)
                ENDIF
                SAVE SCREEN TO TELA
                SOMA=0
                DINICIO=DATE()
                DFINAL=DATE()
                @ 04,08 CLEAR TO 22,76
                @ 04,08 TO 22,76 DOUBLE
                @ 06,10 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
                @ 07,10 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
                READ                
                INDEX ON DATA TO DATA FOR DATA>=DINICIO .AND. DATA<=DFINAL
                NUMREG=1
                @ 08,10 SAY "MOTO=======QTD==KM========A==P1==P2==P3==P4==P5==P1==P2==P3==P4==P5"
                LINHA=10
                DO WHILE ! EOF()
                        MOTOBOY()
                        GOTO NUMREG
                        MMOTOBOY=MOTOCA
                        @ LINHA,12 SAY MMOTOBOY
                        REL_ENTR()
                        SET INDEX TO DATA
                        MQTD=0
                        DIST=0
                        MATRASO=0
                        XP1=0
                        XP2=0
                        XP3=0
                        XP4=0
                        XP5=0
                        MP1=0
                        MP2=0
                        MP3=0
                        MP4=0
                        MP5=0
                        DO WHILE ! EOF()
                                IF MMOTOBOY=MOTOBOY
                                        IF PONTO="P1"
                                                        XP1=XP1+QTDENTR
                                                        MP1++
                                        ENDIF
                                        IF PONTO="P2"
                                                        XP2=XP2+QTDENTR
                                                        MP2++
                                        ENDIF           
                                        IF PONTO="P3"
                                                        XP3=XP3+QTDENTR
                                                        MP3++
                                        ENDIF
                                        IF PONTO="P4"
                                                        XP4=XP4+QTDENTR
                                                        MP4++
                                        ENDIF
                                        IF PONTO="P5"
                                                        XP5=XP5+QTDENTR
                                                        MP5++
                                        ENDIF
                                        MQTD=MQTD+QTDENTR                                        
                                        DIST=DIST+KM
                                        IF ATRASO="S"
                                        		MATRASO++
                                        ENDIF		
                                ENDIF
                                SKIP
                        ENDDO
                        MOTOBOY()
                        NUMREG++
                        GOTO NUMREG
                        @ LINHA,21 SAY MQTD PICT "9999"
                        SOMA=SOMA+MQTD
                       *@ LINHA,26 SAY "KM"
                        @ LINHA,26 SAY DIST * 1.1 PICT "9999.999"
                        @ LINHA,35 SAY MATRASO PICT "99"
                        @ LINHA,38 SAY MP1 PICT "999"
                        @ LINHA,42 SAY MP2 PICT "999"
                        @ LINHA,46 SAY MP3 PICT "999"
                        @ LINHA,50 SAY MP4 PICT "999"
                        @ LINHA,54 SAY MP5 PICT "999"
                        @ LINHA,58 SAY XP1 PICT "999"
                        @ LINHA,61 SAY XP2 PICT "999"
                        @ LINHA,65 SAY XP3 PICT "999"
                        @ LINHA,69 SAY XP4 PICT "999"
                        @ LINHA,73 SAY XP5 PICT "999"
                        LINHA++
                ENDDO
                @ LINHA,21 SAY SOMA PICT "9999"
                INKEY(0)
                REST SCREEN FROM TELA
                REL_ENTR()
                RETURN(1)

        ENDIF
ENDIF
RETURN(1)
