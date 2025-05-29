*******************************************************************************

**************************FUNCAO CUPOM DE PEDIDO*******************************
    RUNORCA=1
    SAVE SCREEN TO FTELA
    RUN COPY D:\karvan\PECAS.DBF C:\TEMP
    RESTORE SCREEN FROM FTELA
    MPCODPEC=SPACE(05)
    MPNOMPEC=SPACE(45)
    MPPREPEC=0
    MPQTDPEC=1
    MPPRETOT=0
    MPTOTG=0
    MQTDTOT=0
    TOT=0
    USE C:\TEMP\PEDIDO
    ZAP
    MPCODPEC="88888"
    PECAS()
    ORDSETFOCUS("CODPECA")
    SEEK MPCODPEC
    MPPREPEC=PRECO
    MPNOMPEC="TAXA DE ENTREGA"
    MPQTDPEC=1
    MPPREPEC=MPPREPEC*MTAXA_DUPLA
    MPPRETOT=MPQTDPEC*MPPREPEC              
    SEEK "99999"
    MCASCO=PRECO
    USE C:\TEMP\PEDIDO
    IF MTAXA # "N"
            APPEND BLANK
            REPLACE PCODPEC WITH MPCODPEC
            REPLACE PNOMPEC WITH MPNOMPEC
            REPLACE PQTDPEC WITH MPQTDPEC
            REPLACE PPREPEC WITH MPPREPEC
            REPLACE PPRETOT WITH MPPRETOT
            DBCOMMIT()
    ENDIF
    INDEX ON PCODPEC TO PCODPEC
    IF MCNOTCLI=1
            V_DESC=0.90
        ELSE
            V_DESC=0.90
    ENDIF           
    SETCOLOR("W+/R,N/W")
    PRIVATE V1[6], V2[6], V3[6]

     V1[01]="LEFT(PNOMPEC,30)"
     V1[02]="PQTDPEC"
     V1[03]="PPREPEC"
     V1[04]="PPREPEC * V_DESC"
     V1[05]="PPRETOT"
     V1[06]="LOCAL"
        
     V2[01]="@!"
     V2[02]="999"
     V2[03]="9999.99"
     V2[04]="9999.99"
     V2[05]="99999.99"
     V2[06]="@!"
        
     V3[01]="DESCRI€ŽO"
     V3[02]="QTD"
     V3[03]="PRE€O"
     V3[04]="DESC."
     V3[05]="TOTAL"
     V3[06]="LOCAL"

USE C:\TEMP\PEDIDO
SET INDEX TO PCODPEC
SOMATOTAL()
    
DBEDIT(05,02,20,77,v1,"YDBEDIT",v2,v3,chr(205),space(1)+chr(179))


function Ydbedit(modo,coluna)


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
              TELA1=SAVESCREEN(07,02,19,76)
        DO WHILE .T.
              MPQTDPEC=0
              MPCODPEC=SPACE(05)
              ACESSO=0              
              CONPEC() 
              TELA=SAVESCREEN(07,02,19,76)
              USE C:\TEMP\PEDIDO
              SET INDEX TO PCODPEC
              *SOMATOTAL()                                                       
              @ 22,37 SAY TOT PICT "99"
              @ 22,40 SAY "PE€AS"
              @ 22,51 SAY MPTOTG * V_DESC PICT "99999.99"
              @ 22,70 SAY MPTOTG PICT "99999.99"
              SETCOLOR("W+/R,N/W")
              @ 22,00 CLEAR TO 22,24
              PECAS()
              IF LASTKEY()=27

                  *SET KEY -41 TO OTARIOS() // F12

                  USE C:\TEMP\PEDIDO
                  SET INDEX TO PCODPEC
                  RESTSCREEN(07,02,19,76,TELA1)
                  IF ! EOF()
                     KEYBOARD CHR(03)
                  ENDIF
                  RETURN(1)
              ENDIF
              @ 22,00 CLEAR TO 24,23
              @ 22,02 SAY "CODIGO...:"
              ORDSETFOCUS("CODPECA")
              SEEK MPCODPEC
              IF ! FOUND() 
                   TONE(200,26)
                   OL_Yield()
                   ALERT ('CODIGO NÇO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                   LOOP
              ENDIF
              @ 22,25 SAY "QTD...:" GET MPQTDPEC PICT "999" VALID MPQTDPEC > 0
              READ
              MTEMPUNI=TEMPUNI
              IF MTEMPUNI="S"
                        MPQTDPEC=2
              ENDIF
              IF MTEMPUNI="4" .OR. MTEMPUNI="3"
                        MPQTDPEC=VAL(MTEMPUNI)
              ENDIF
              IF LASTKEY()=27
                  LOOP
              ENDIF
              MUNIDADE=UNIDADE
              MPCODPEC=CODPECA
              MPNOMPEC=NOMEPECA
              MPPREPEC=PRECO
              MPFABRIC=FABRIC
              MLOCAL=LOCAL
              MPNFABRIC=NFABRIC
              MPPRETOT=MPPREPEC*MPQTDPEC
              MQTD=QTD+TEMP
              DISTRIBQTD=MPQTDPEC
              MP_CUSTO=0
              IF DISTRIBQTD > 0 .AND. EQTD4 > 0
                          MEQTD4=EQTD4
                          FOR MQTD1 = 1 TO EQTD4
                                MEQTD4--
                                DISTRIBQTD--
                                MP_CUSTO=MP_CUSTO+P_CUSTO4
                                IF DISTRIBQTD=0
                                        EXIT
                                ENDIF
                          NEXT
              ENDIF     
              IF DISTRIBQTD >0 .AND. EQTD3> 0
                          MEQTD3=EQTD3
                          FOR MQTD1 = 1 TO EQTD3
                                MEQTD3--
                                DISTRIBQTD--
                                MP_CUSTO=MP_CUSTO+P_CUSTO3
                                IF DISTRIBQTD=0
                                        EXIT
                                ENDIF
                          NEXT
              ENDIF
              IF DISTRIBQTD >0 .AND. EQTD2> 0
                          MEQTD2=EQTD2
                          FOR MQTD1 = 1 TO EQTD2
                                MEQTD2--
                                DISTRIBQTD--
                                MP_CUSTO=MP_CUSTO+P_CUSTO2
                                IF DISTRIBQTD=0
                                        EXIT
                                ENDIF
                          NEXT
              ENDIF
              IF DISTRIBQTD >0
                          MEQTD1=EQTD1
                          FOR MQTD1 = 1 TO DISTRIBQTD
                                MEQTD1--
                                MP_CUSTO=MP_CUSTO+P_CUSTO
                                IF DISTRIBQTD=0
                                        EXIT
                                ENDIF
                          NEXT
              ENDIF
              MP_CUSTO=MP_CUSTO/MPQTDPEC
              IF MP_CUSTO=0
                        MP_CUSTO=MPPREPEC/1.4
              ENDIF
              USE C:\TEMP\PEDIDO
              SET INDEX TO PCODPEC
              SEEK MPCODPEC
              IF FOUND()
                 MPPREPEC=PPREPEC
                 MPQTDPEC=PQTDPEC+MPQTDPEC
                 MP_CUSTO=(PCUSTO+MP_CUSTO)/2
                 IF (MQTD-MPQTDPEC)<0
                 OL_Yield()
                        ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                 ENDIF
                 REPLACE PQTDPEC WITH MPQTDPEC
                 MPPRETOT=MPPREPEC*MPQTDPEC
                 REPLACE PPRETOT WITH MPPRETOT
                 REPLACE PCUSTO WITH MP_CUSTO
                 TOT--
                ELSE
                 IF (MQTD-MPQTDPEC)<0
                 OL_Yield()
                        ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                 ENDIF
                 APPEND BLANK
                 REPLACE PCODPEC WITH MPCODPEC
                 REPLACE PNOMPEC WITH MPNOMPEC
                 REPLACE PQTDPEC WITH MPQTDPEC
                 REPLACE PPREPEC WITH MPPREPEC
                 REPLACE PPRETOT WITH MPPRETOT
                 REPLACE PFABRIC WITH MPFABRIC
                 REPLACE LOCAL   WITH MLOCAL
                 REPLACE PNFABRIC WITH MPNFABRIC
                 REPLACE PCUSTO WITH MP_CUSTO
                 DBCOMMIT()
              ENDIF
              USE C:\TEMP\PEDIDO
              SET INDEX TO PCODPEC
              SOMATOTAL()
              TOT++
              IF MPPREPEC=0
              OL_Yield()
                 ALERT ('CODIGO DIGITADO ESTA COM VALOR INCORRETO,VERIFIQUE')
                 LOOP
              ENDIF
              IF MTEMPUNI="C"
                        MPCODPEC="99999"
                        MPNOMPEC="CASCO BATERIA"
                        *MPQTDPEC=1
                        MPPREPEC=MCASCO
                        MPPRETOT=MPQTDPEC*MCASCO  
                        USE C:\TEMP\PEDIDO
                        INDEX ON PCODPEC TO PCODPEC
                        SEEK "999999"
                        IF ! FOUND()
                              APPEND BLANK
                        ENDIF   
                        REPLACE PCODPEC WITH MPCODPEC
                        REPLACE PNOMPEC WITH MPNOMPEC
                        REPLACE PQTDPEC WITH MPQTDPEC
                        REPLACE PPREPEC WITH MPPREPEC
                        REPLACE PPRETOT WITH MPPRETOT
                        DBCOMMIT()
                        TOT++

              ENDIF
              RESTSCREEN(08,02,20,76,TELA)
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
               USE C:\TEMP\PEDIDO
               SET INDEX TO PCODPEC
               OL_Yield()
               ALERT('PECA EXCLUIDA COM EXITO')
               SOMATOTAL()
               @ 22,51 SAY MPTOTG * V_DESC PICT "99999.99"
               @ 22,70 SAY MPTOTG PICT "99999.99"


       elseif lastkey()== 65 .OR. lastkey() == 97   && "A"

                       MPCODPEC=PCODPEC
                       TELA=SAVESCREEN(07,02,19,76)
                       SAVE SCREEN TO FTELA
                       SETCOLOR("W+/R,N/W")
                       @07,16 CLEAR TO 09,40
                       @07,16 TO 09,40 DOUBLE
                       MPQTDPEC=PQTDPEC
                       MPPREPEC=PPREPEC
                       MPCODPEC=PCODPEC
                       PECAS()
                       ORDSETFOCUS("CODPECA")
                       SEEK MPCODPEC
                       MQTD=QTD+TEMP
                       USE C:\TEMP\PEDIDO
                       INDEX ON PCODPEC TO PCODPEC 
                       SEEK MPCODPEC
                       @ 08,17 SAY "QTD.:"GET MPQTDPEC  PICT "99" VALID MPQTDPEC >0
                       @ 08,26 SAY "PRE€O:"GET MPPREPEC PICT "9999.99"
                       READ

                       IF (MQTD-MPQTDPEC)<0
                       OL_Yield()
                                ALERT('QUANTIDADE SUPERIOR AO ESTOQUE')
                       ENDIF

                       RESTSCREEN(07,02,19,76,TELA)
                       MPPRETOT=MPQTDPEC*MPPREPEC
                       REPLACE PPRETOT WITH MPPRETOT
                       REPLACE PQTDPEC WITH MPQTDPEC
                       REPLACE PPREPEC WITH MPPREPEC
                       DBCOMMIT()
                       RESTORE SCREEN FROM FTELA
                       USE C:\TEMP\PEDIDO
                       SET INDEX TO PCODPEC
                       SOMATOTAL()
                       @ 22,51 SAY MPTOTG * V_DESC PICT "99999.99"
                       @ 22,70 SAY MPTOTG PICT "99999.99"
                       LOCATE FOR PCODPEC=MPCODPEC
                       KEYBOARD CHR(13)

         elseif lastkey()== -3   && "F4 CANCELA PEDIDO"

               IF CONFIRMA("DESEJA CANCELAR O ORCAMENTO?")=1

                        USE C:\TEMP\PEDIDO
                        ZAP
                        SET KEY -8 TO OTARIOS() // F9
                        RUNORCA=0
                        RETURN(0)
               ENDIF

        elseif lastkey()== -2 .OR. LASTKEY()== -1 .OR. LASTKEY()== 28 && "F2/F3"

                IF MNOTCLI="CONSUMIDOR"
                        TECLA="F2"
                     ELSE
                        TECLA="F3"
                ENDIF
                USE C:\TEMP\PEDIDO
                SET INDEX TO PCODPEC
                IF MPTOTG=0
                OL_Yield()
                    ALERT('NENHUMA PE€A INCLUIDA NO PEDIDO')
                    SET KEY -8 TO OTARIOS() // F9
                    RUNORCA=0
                    RETURN(0)
                ENDIF
                SETCOLOR("W+/R,N/W")
                ORCA()
                MNOTPAG="ORCAMENTO"
                BLOQUEIO()
                *CLOSE INDEXES
                ORDSETFOCUS("CODNOT")
                GOTO BOTTOM
                MCODNOT=CODNOT+1
                DO WHILE .T.
                        SEEK MCODNOT
                        IF ! FOUND()
                                EXIT
                        ENDIF
                        MCODNOT++
                ENDDO
                APPEND BLANK
                REPLACE CODNOT  WITH MCODNOT
                REPLACE NOTTOTG WITH MPTOTG
                REPLACE NOTCLI  WITH MNOTCLI
                REPLACE NOTFUNC WITH MNOTFUNC
                REPLACE NOTPAG  WITH MNOTPAG
                REPLACE D_NOT   WITH MD_NOT
                REPLACE HORANOT WITH TIME()
                REPLACE PCUSTO  WITH VENDACUSTO
                DBCOMMIT()
                UNLOCK    

                USE C:\TEMP\PEDIDO
                NUMREG=1
                GOTO NUMREG
                DO WHILE .NOT. EOF()
                     MPEDCOD=PCODPEC
                     MPEDQTD=PQTDPEC
                     MPPREPEC=PPREPEC
                     ORCAPED()
                     BLOQUEIO()
                     APPEND BLANK
                     REPLACE PEDCOD   WITH MPEDCOD
                     REPLACE PEDNUM   WITH MCODNOT
                     REPLACE PEDQTD   WITH MPEDQTD
                     REPLACE PRECOCUP WITH MPPREPEC
                     REPLACE DATACUP  WITH MD_NOT

                     USE C:\TEMP\PEDIDO
                     NUMREG++
                     GOTO NUMREG
                ENDDO
                UNLOCK                
                IF LASTKEY()== 28
                        RUNORCA=0
                        RETURN(0)
                ENDIF
                IMPRI_ORCA()
                RUNORCA=0
                RETURN(0)
        ENDIF
ENDIF
