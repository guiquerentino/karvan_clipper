******************************************************************************

*****************************/FUN€AO CONSULTA CLIENTES************************

OP=3
SET CENT ON
CLIENTES()
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhum Cliente Cadastrado...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
IF ACESSO=0 .OR. ACESSO=4
      PRIVATE V1[4], V2[4], V3[4]
ENDIF

IF  ACESSO=1 
      PRIVATE V1[10], V2[10], V3[10]
      V1[05]="VALSEMANA"
      V2[05]="999,999.99"
      V3[05]="VALOR"
      V1[06]="LUCRO"
      V2[06]="999.99%"
      V3[06]="LUCRO"
      V1[07]="GASTO"
      V2[07]="999,999.99"
      V3[07]="GASTO"
      V1[08]="PAGO"
      V2[08]="999,999.99"
      V3[08]="PAGO"
      V1[09]="DEVOLUCAO"
      V2[09]="999"
      V3[09]="DEVOL"
      V1[10]="ULTCOMPRA"
      V2[10]="@D"
      V3[10]="ULT_COMPRA"
ENDIF      
V1[01]="CODCLI"
V1[02]="NOMECLI"
V1[03]="TEL"
V1[04]="CEL"

V2[01]="9999"
V2[02]="@!"
V2[03]="9999-9999"
V2[04]="99999-9999"

V3[01]="CODIGO"
V3[02]="CLIENTE"
V3[03]="TELEFONE"
V3[04]="CELULAR"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [1] CODIGO [2] CLIENTE ",78)

IF ACESSO=1
      VALOR=0
      DO WHILE ! EOF()
             VALOR+=VALSEMANA
             SKIP
      ENDDO
      @ 23,59 SAY "GERAL:" GET VALOR PICT "999,999.99" 
ENDIF            
DBEDIT(01,00,21,79,v1,"CDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Cdbedit(modo,coluna)
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

       ELSEIF LASTKEY() == 13   && "ENTER"
          SET CURSOR OFF  
	      SETCOLOR("W+/BG,N/W")
          PUVARCLI()
          IGUAVACLI()
          @ 03,11 CLEAR TO 19,66
          @ 03,11 TO 19,66 DOUBLE
          @ 03,15 SAY "CONSULTA CLIENTES"
          @ 04,14 SAY "CODIGO......:" GET MCODCLI PICT "9999"
          MOSTECLI()
          INKEY(0)
          RETURN(2)

       elseif lastkey()== 65 .OR. lastkey() == 97 && "A/a"

          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RETURN(1)
          ENDIF
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          PUVARCLI()
          IGUAVACLI()
          ALTNOMECLI=MNOMECLI
          @ 03,11 CLEAR TO 19,66
          @ 03,11 TO 19,66 DOUBLE
          @ 03,15 SAY "CONSULTA CLIENTES"
          @ 04,14 SAY "CODIGO......:" GET MCODCLI PICT "9999"
          CLEAR GETS
          MOSTECLI()
          READ
          IF UPDATED()
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                 ORDSETFOCUS("NOMECLI")
                 SEEK MNOMECLI
                 IF FOUND() .AND. ALTNOMECLI#MNOMECLI 
                        ALERT('NOME CLIENTE DUPLICADO, ALTERACAO NAO REALIZADA')
                        RETURN(2)
                 ENDIF
                 ORDSETFOCUS("CODCLI")
                 SEEK MCODCLI
                 REPLCLI()
                 IF ALTNOMECLI#MNOMECLI
                          CUPOM()
                          ORDSETFOCUS("NOTCLI")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE NOTCLI WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          GARANTIA()
                          ORDSETFOCUS("GARCLI")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE GARCLI WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          DEVOLCRE()
                          ORDSETFOCUS("NOMECLI")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE NOMECLI WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          PAGAMENTO()
                          ORDSETFOCUS("CLIENTE")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE CLIENTE WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          DEVOLU()
                          ORDSETFOCUS("DNOMECLI")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE DNOMECLI WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          CHEQUE()
                          ORDSETFOCUS("CLIENTE")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE CLIENTE WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          ENTR_CLI()
                          ORDSETFOCUS("CLIENTE")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE CLIENTE WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO
                          ORCA()
                          ORDSETFOCUS("NOTCLI")
                          DO WHILE .T.
                                SEEK ALTNOMECLI
                                IF FOUND()
                                        BLOQUEIO()
                                        REPLACE NOTCLI WITH MNOMECLI
                                        UNLOCK
                                     ELSE
                                        EXIT
                                ENDIF
                          ENDDO        
                  ENDIF
              ENDIF
          ENDIF
          CLIENTES()
          ORDSETFOCUS("NOMECLI")
          SEEK MNOMECLI
          V_BUSCA=MNOMECLI
          RETURN(2)
       
    elseif lastkey()== 66 && "BLOQUEIO"
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RETURN(1)
          ENDIF
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          PUVARCLI()
          IGUAVACLI()
          @ 03,11 CLEAR TO 19,66
          @ 03,11 TO 19,66 DOUBLE
          @ 03,15 SAY "BLOQUEIA CLIENTES"
          @ 04,14 SAY "CODIGO......:" GET MCODCLI PICT "9999"
          MOSTECLI()
          IF CONFIRMA ("BLOQUEIA ESSE REGISTRO ?")=1
                BLOQUEIO()
                MBLOQUEIO="S"
             ELSE
                BLOQUEIO()
                MBLOQUEIO="N"
          ENDIF
          REPLACE BLOQUEIO WITH MBLOQUEIO
          UNLOCK
          RETURN(2)

    elseif lastkey()== 07 && "DELETE"
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RETURN(1)
          ENDIF
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          PUVARCLI()
          IGUAVACLI()
          @ 03,11 CLEAR TO 19,66
          @ 03,11 TO 19,66 DOUBLE
          @ 03,15 SAY "DELETA CLIENTES"
          @ 04,14 SAY "CODIGO......:" GET MCODCLI PICT "9999"
          MOSTECLI()
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
          RETURN(2)

	elseif lastkey()== 49 && "1" 
          SET CURSOR ON
          CLEAR GETS
          ORDSETFOCUS("CODCLI")
          *INDEX ON CODCLI TO CODCLI
          SET SOFTSEEK ON
	      SETCOLOR("W+/BG,N/W")
          V_BUSCA:=0
	      SET CURSOR ON
          @ 03,20 CLEAR TO 05,35
          @ 03,20 TO 05,35 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "9999"
          READ
              SEEK V_BUSCA
	      IF EOF()
               SKIP-1
               RETURN(1)
	     ENDIF
	     RETURN(2)

    elseif lastkey()== 50 && "2"
          SET CURSOR ON
          CLEAR GETS
          ORDSETFOCUS("NOMECLI")
          *INDEX ON NOMECLI TO NOMECLI
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "NOME CLIENTE:" GET V_BUSCA PICT "@!"
          READ          
          IF EMPTY(V_BUSCA)
                ORDSETFOCUS("NOMECLI")
              ELSE
                INDEX ON NOMECLI TO TEMP FOR RTRIM(V_BUSCA) $ NOMECLI
          ENDIF
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

    elseif lastkey()== 51 && "3"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,52
          @ 03,20 TO 05,52 DOUBLE
          @ 04,22 SAY "ENDERECO:" GET V_BUSCA PICT "@!"
          READ          
          IF ! EMPTY(V_BUSCA)          
                INDEX ON ENDCLI TO ENDCLI FOR RTRIM(V_BUSCA) $ ENDCLI
          ENDIF
          IF EOF()
             SKIP-1
             ORDSETFOCUS("CODCLI")
             RETURN(1)
          ENDIF
          RETURN(2)
    elseif lastkey()== -20 && "CTRL+F1"

          CLEAR GETS
          @ 04,15 CLEAR TO 10,64
          @ 04,15 TO 10,64 DOUBLE
          @ 07,16 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
          @ 08,16 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
          READ
          SAVE SCREEN TO TELA
          RUN DEL C:\KARVAN\CUPOM.DBF
          RUN DEL C:\KARVAN\PAGAMENT.DBF
          RUN DEL C:\KARVAN\DEVOLUCA.DBF 
          RUN DEL C:\KARVAN\CUPOTEMP.DBF    
          RUN DEL C:\KARVAN\PAGATEMP.DBF 
          RUN DEL C:\KARVAN\DEVOTEMP.DBF 
          RUN COPY D:\KARVAN\CUPOM.DBF C:\KARVAN
          RUN COPY D:\KARVAN\PAGAMENT.DBF C:\KARVAN
          RUN COPY D:\KARVAN\DEVOLUCA.DBF C:\KARVAN          
          REST SCREEN FROM TELA
          USE C:\KARVAN\CUPOM
          COPY TO C:\KARVAN\CUPOTEMP FOR D_NOT>=DINICIO .AND. D_NOT<=DFINAL
          USE C:\KARVAN\PAGAMENT
          COPY TO C:\KARVAN\PAGATEMP FOR DATA>=DINICIO .AND. DATA<=DFINAL
          USE C:\KARVAN\DEVOLUCA
          COPY TO C:\KARVAN\DEVOTEMP FOR DDATA>=DINICIO .AND. DDATA<=DFINAL
          SELE 1
          USE C:\KARVAN\CUPOTEMP                
          SELE 2
          USE C:\KARVAN\PAGATEMP                
          SELE 3
          USE C:\KARVAN\DEVOTEMP
          SELE 4
          CLIENTES()            			 
          CONT=1
          NUMREG=1
          GOTO NUMREG                                
          DO WHILE ! EOF()
                GOTO NUMREG
                MNOMECLI=NOMECLI
                MPAGO=0
                MDEVOLUCA=0
                MCUSTO=0
                MTOTAL=0
                SELE 1
                GOTO TOP
                DO WHILE ! EOF()
                        IF MNOMECLI=NOTCLI
                                MCUSTO=MCUSTO+P_CUSTO
                                MTOTAL=MTOTAL+NOTTOTG
                        ENDIF        
                        SKIP                                                                                                                                          
                ENDDO       
                SELE 2
                GOTO TOP
                DO WHILE ! EOF()
                           IF MNOMECLI=CLIENTE
                                   MPAGO=MPAGO+VALOR
                           ENDIF
                           SKIP
                ENDDO
                SELE 3
                GOTO TOP
                DO WHILE ! EOF()
                         IF MNOMECLI=DNOMECLI
                              MDEVOLUCA++
                         ENDIF
                         SKIP
                ENDDO
                SELE 4
                GOTO NUMREG
                BLOQUEIO()
                IF BLOQUEIO="N"
                        MTOTAL=MTOTAL * 0.90
                ENDIF
                REPLACE GASTO     WITH MTOTAL
                REPLACE LUCRO     WITH ((MTOTAL/MCUSTO)-1)*100
                REPLACE PAGO      WITH MPAGO
                REPLACE DEVOLUCAO WITH MDEVOLUCA
                NUMREG++
          ENDDO

      elseif lastkey()== 52 && "4"

          SET CURSOR ON
          INDEX ON VALSEMANA TO VALOR
          RETURN(2)
    
      elseif lastkey()== 53 && "5"

          SET CURSOR ON
          INDEX ON LUCRO TO LUCRO
          RETURN(2)

      elseif lastkey()== 54 && "6"

          SET CURSOR ON
          INDEX ON GASTO TO GASTO
          RETURN(2)

      elseif lastkey()== 55 && "7"

          SET CURSOR ON
          INDEX ON PAGO TO PAGO
          RETURN(2)

       elseif lastkey()== 68 .OR. lastkey() == 100 && "D/d"

          SET CURSOR ON
          INDEX ON ULTCOMPRA TO TEMP
          RETURN(2)


      elseif lastkey()== 56 && "8"
          SET CURSOR ON
          INDEX ON DEVOLUCAO TO DEVOLUCAO
          RETURN(2)

      elseif lastkey()== 57 && "9"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          V_BUSCA=SPACE(02)
          SETCOLOR("W+/BG,N/W")
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,30
          @ 03,20 TO 05,35 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          INDEX ON P1 TO PONTO FOR P1=V_BUSCA
          SEEK V_BUSCA
          IF EOF()
               SKIP-1
               RETURN(1)
          ENDIF
          RETURN(2)

      ENDIF
ENDIF
RETURN(1)
