****************************************************************************

*****************************FUN€AO CONSULTA FECHAMENTO*********************
SET CENT ON
IF ACESSO#1 
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')               
    RETURN(.T.)
ENDIF
IF ALLTRIM(FUNCIONARIO)="MARCELO" .OR. ALLTRIM(FUNCIONARIO)="TIAGO"

      ELSE
        OL_Yield()
        ALERT('ACESSO NAO AUTORIZADO')               
        RETURN(.T.)
ENDIF

SELE 5
CUPOM()
SELE 6
CLIENTES()
SELE 7
PAGAMENTO()
SELE 1
DEVOLU()                 

DIA=DAY(DATE())
DIA=STRZERO(DIA,2)
MES=MONTH(DATE())
MES=STRZERO(MES,2)
DIRET="D:\KARVAN\"
BARRA="\"
EXT=".TXT"
TRACO="-"
CAMINHO="D:\KARVAN\"+DIA+"-"+MES
DIRMAKE(CAMINHO)
SET KEY -04 TO OTARIOS()
IF .NOT. FILE ("D:\KARVAN\CREDITO.DBF")
          ARQ20:={}
          AADD (ARQ20, {"DCNOT","N",09,00})
          AADD (ARQ20, {"DNONPEC","C",35,00})
          AADD (ARQ20, {"DQT",   "N",03,00})
          AADD (ARQ20, {"DPRE", "N",09,02})
          AADD (ARQ20, {"DDATA","D",08,00})
               DBCREATE("D:\KARVAN\CREDITO",ARQ20)
ENDIF
IF .NOT. FILE ("D:\KARVAN\DEVOLVE.DBF")
          ARQ21:={}
          AADD (ARQ21, {"DCNOT","N",09,00})
          AADD (ARQ21, {"DNONPEC","C",35,00})
          AADD (ARQ21, {"DQT",   "N",03,00})
          AADD (ARQ21, {"DPRE", "N",09,02})
          AADD (ARQ21, {"DDATA","D",08,00})
          AADD (ARQ21, {"DNOT","N",15,02})
               DBCREATE("D:\KARVAN\DEVOLVE",ARQ21)
ENDIF
IF .NOT. FILE ("C:\KARVAN\DIVIDA.DBF")
          ARQ22:={}
          AADD (ARQ22, {"CODNOT","N",09,00})
          AADD (ARQ22, {"NOTCLI","C",35,00})
          AADD (ARQ22, {"NOTPAG","C",10,00})
          AADD (ARQ22, {"NOTTOTG","N",15,02})
          AADD (ARQ22, {"P_CUSTO","N",15,02})
               DBCREATE("C:\KARVAN\DIVIDA",ARQ22)
ENDIF


SELE 2
USE D:\KARVAN\CREDITO
SELE 3
USE D:\KARVAN\DEVOLVE
SELE 4
USE C:\KARVAN\DIVIDA
@ 04,15 CLEAR TO 08,64
@ 04,15 TO 08,64 DOUBLE

@ 06,16 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL <=DATE()
READ

DO WHILE .T.
        RESTORE SCREEN FROM FTELA
        SETCOLOR("W+/R,N/W")
        MCODCLI=0
        MNOMECLI=SPACE(35)
        MTOTALDESC=0
        V_PAGO=0
        ANTERIOR=0
        DEVOLV=0
        CHEQUE=0
        CARTAO=0
        MVALOR=0
        OUTROS=0
        MP_CUSTO=0
        MDINHEIRO=0
        MDEBITO=0
        MCHEQUE=0
        MCREDITO=0
        MCONVENIO=0
        OUTRO=SPACE(15)
        CLEAR GETS
        *SET KEY -40 TO CONCLI1() // F11
        
        @ 04,15 CLEAR TO 10,64
        @ 04,15 TO 10,64 DOUBLE
        @ 05,16 SAY "CLIENTE:" GET MCODCLI PICT "9999"
        READ
        IF LASTKEY()=27
            RETURN(1)
        ENDIF
        
        SET KEY -40 TO OTARIOS() // F11
        
        SELE 6
        ORDSETFOCUS("CODCLI")
        SEEK MCODCLI
        IF MCODCLI=0 .AND. ALLTRIM(FUNCIONARIO)="MARCELO"
           ELSEIF ! FOUND()
             RESTORE SCREEN FROM FTELA
             OL_Yield()
             ALERT ('CLIENTE NAO CADASTRADO !!!')
             RETURN(1)
           ELSEIF FOUND()
             MNOMECLI=NOMECLI
             @ 05,25 SAY MNOMECLI
        ENDIF
        IF LASTKEY()=27
             RETURN(1)
        ENDIF
        IF MCODCLI>0
                SELE 6                  
                ORDSETFOCUS("CODCLI") 
                SEEK MCODCLI
                ANTERIOR=VALSEMANA
                IF ! EMPTY(DT_FECHA)
                        DINICIO=DT_FECHA+1
                      ELSE
                        ALERT('DIGITE A DATA DO ULTIMO FECHAMENTO')
                        SAVE SCREEN TO FTELA   
                        @ 04,15 CLEAR TO 08,64
                        @ 04,15 TO 08,64 DOUBLE
                        @ 07,16 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DFINAL
                        READ
                        REST SCREEN FROM FTELA
                        SELE 5
                        INDEX ON NOTCLI TO NOTCLI;
                        FOR NOTCLI=MNOMECLI .AND. D_NOT<DINICIO
                        DO WHILE ! EOF()
                                IF NOTPAG="ASSINAR" .OR. NOTPAG="CONVENIO"
                                        BLOQUEIO()
                                        REPLACE NOTPAG WITH "FECHAMENTO"
                                        UNLOCK
                                ENDIF
                                SKIP
                        ENDDO
                ENDIF
                SELE 4
                ZAP
                SELE 5
                ORDSETFOCUS("ABERTOS")
                GOTO TOP
                DO WHILE ! EOF()
                        MCODNOT=CODNOT
                        MNOTCLI=NOTCLI
                        MNOTTOTG=NOTTOTG
                        MNOTPAG=NOTPAG
                        MP_CUSTO=P_CUSTO
                        IF D_NOT<=DFINAL
                                SELE 4
                                BLOQUEIO()
                                APPEND BLANK
                                REPLACE CODNOT WITH MCODNOT
                                REPLACE NOTCLI WITH MNOTCLI
                                REPLACE NOTTOTG WITH MNOTTOTG
                                REPLACE NOTPAG  WITH MNOTPAG
                                REPLACE P_CUSTO WITH MP_CUSTO
                                UNLOCK
                        ENDIF
                        SELE 5
                        ORDSETFOCUS("ABERTOS")
                        SKIP 
                ENDDO
                SELE 4
                INDEX ON NOTTOTG TO NOTTOTG FOR NOTCLI=MNOMECLI
            ELSE
                ANTERIOR=0
                SELE 4                
                ZAP
                SELE 5
                INDEX ON D_NOT TO D_NOT FOR D_NOT>=DINICIO .AND. D_NOT<=DFINAL
                GOTO TOP
                DO WHILE ! EOF()
                        MCODNOT=CODNOT
                        MNOTCLI=NOTCLI
                        MNOTTOTG=NOTTOTG
                        MNOTPAG=NOTPAG
                        MP_CUSTO=P_CUSTO
                        SELE 4
                        BLOQUEIO()
                        APPEND BLANK
                        REPLACE CODNOT WITH MCODNOT
                        REPLACE NOTCLI WITH MNOTCLI
                        REPLACE NOTTOTG WITH MNOTTOTG
                        REPLACE NOTPAG  WITH MNOTPAG
                        REPLACE P_CUSTO WITH MP_CUSTO
                        UNLOCK
                        SELE 5
                        SKIP 
                ENDDO
                SELE 4
                INDEX ON NOTTOTG TO NOTTOTG
        ENDIF
        *IF MCODCLI=1
        *        SELE 4
        *        USE C:\KARVAN\DIVIDA                
        *        INDEX ON NOTTOTG TO NOTTOTG FOR NOTCLI=MNOMECLI
        *ENDIF        
        MTOTAL=0
        CONT=0
        SELE 4
        SET INDEX TO NOTTOTG
        GOTO TOP
        DO WHILE ! EOF()
              CONT++
              MTOTAL=MTOTAL+NOTTOTG
              MP_CUSTO=MP_CUSTO+P_CUSTO
              IF ALLTRIM(NOTPAG)="CONVENIO" .OR. NOTPAG="ASSINAR"
                        MCONVENIO=MCONVENIO+NOTTOTG
              ENDIF
              IF ALLTRIM(NOTPAG)="DINHEIRO" .OR. NOTPAG="TROCA"
                        MDINHEIRO=MDINHEIRO+NOTTOTG
              ENDIF
              IF ALLTRIM(NOTPAG)="DEBITO"
                        MDEBITO=MDEBITO+NOTTOTG
              ENDIF
              IF ALLTRIM(NOTPAG)="CREDITO"
                        MCREDITO=MCREDITO+NOTTOTG
              ENDIF
              IF ALLTRIM(NOTPAG)="CHEQUE"
                        MCHEQUE=MCHEQUE+NOTTOTG
              ENDIF
              SKIP
        ENDDO
        @ 05,52 SAY CONT 
        IF MTOTAL>250
                MTOTALDESC=MTOTAL * 0.90
           ELSE
                MTOTALDESC=MTOTAL
        ENDIF
        @ 09,15 CLEAR TO 23,64
        @ 04,15 TO 23,64 DOUBLE
        @ 10,16 SAY "TOTAL SEMANA:"
        @ 10,29 SAY MTOTAL PICT "9,999,999.99"
        @ 10,50 SAY MP_CUSTO PICT "9,999,999.99"
        @ 08,55 SAY ((MTOTALDESC/MP_CUSTO)-1)*100 PICT "999.999%" 
        @ 12,16 SAY "COM DESCONTO:"
        @ 12,30 SAY MTOTALDESC PICT "9,999,999.99"
        @ 14,41 SAY "ANTERIOR:"
        @ 14,50 SAY ANTERIOR PICT "9,999,999.99"
        TOTAL=0
        @ 05,65 CLEAR TO 23,77 
        @ 05,65 TO 23,77 DOUBLE
        @ 06,67 SAY "VALOR:"
        @ 22,67 SAY "TOTAL:"

        IF CONFIRMA('DESEJA IMPRIMIR RELATORIO DE DEVOLUCOES?')=1
                
                SELE 2                
                ZAP
                SELE 3                
                ZAP
                SELE 1
                NUMREG=LASTREC()
                GOTO NUMREG
                CLI=0
                CRE=0
                DO WHILE ! EOF()
                          IF DDATA<DINICIO
                                EXIT
                          ENDIF                          
                          IF EMPTY(BAIXA) .OR. BAIXA="C" .AND. ! DELETED()
                                  IF MNOMECLI=DNOMECLI
                                          IF DFINAL >= DDTNOT
                                                  IF BAIXA#"C"
                                                          BLOQUEIO()
                                                          REPLACE BAIXA WITH "S"
                                                          UNLOCK
                                                  ENDIF
                                                  CLI++
                                                  MDCNOT=DCODNOT
                                                  MDNONPEC=DNOMEPECA
                                                  MDNOT=DNOTTOTAL
                                                  MDCOD=DCODPECA
                                                  MDQT=DQTD
                                                  MDPRE=DPRECO
                                                  MDDATA=DDTNOT
                                                  IF DINICIO > DDTNOT .OR. BAIXA="C"
                                                          BLOQUEIO()
                                                          REPLACE BAIXA WITH "G"
                                                          UNLOCK
                                                          CRE++
                                                          SELE 2
                                                          APPEND BLANK
                                                          REPLACE DCNOT   WITH MDCNOT
                                                          REPLACE DNONPEC WITH MDNONPEC
                                                          REPLACE DQT     WITH MDQT
                                                          REPLACE DPRE    WITH MDPRE
                                                          REPLACE DDATA   WITH MDDATA
                                                      ELSE
                                                          SELE 3
                                                          APPEND BLANK
                                                          REPLACE DCNOT   WITH MDCNOT
                                                          REPLACE DNONPEC WITH MDNONPEC
                                                          REPLACE DQT     WITH MDQT
                                                          REPLACE DPRE    WITH MDPRE
                                                          REPLACE DDATA   WITH MDDATA
                                                          REPLACE DNOT    WITH MDNOT
                                                  ENDIF
                                        ENDIF
                                  ENDIF
                          ENDIF
                          SELE 1
                          NUMREG--
                          GOTO NUMREG
                ENDDO
                IF CLI > 0
                        SELE 2
                        INDEX ON DCNOT TO DCNOT
                        set device to print
                        *Printer()
                        IF CRE > 0                        
                                @ LIN,00 SAY PADC("DEVOLUCOES PARA CREDITO",40)
                                LIN++
                                LIN++
                                LIN++
                        ENDIF
                        MCODNOT=0
                        CREDI=0
                        DO WHILE ! EOF()
                                IF MCODNOT#DCNOT
                                        LIN++
                                        @ LIN,00 SAY DCNOT
                                        @ LIN,15 SAY DDATA
                                        MCODNOT=DCNOT
                                 ENDIF       
                                 LIN++                                 
                                 CREDI=CREDI+((DPRE*DQT) * 0.9)
                                 @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                                 @ LIN,00 SAY LEFT(DNONPEC,38)
                                 @ LIN,37 SAY DQT PICT "999"
                                 @ LIN,41 SAY (DPRE*DQT) * 0.90 PICT "9999.99"
                                 SKIP
                        ENDDO
                        IF CRE > 0
                                LIN++
                                @ LIN,38 SAY "----------"
                                LIN++
                                @ LIN,38 SAY CREDI PICT "9999.99"
                                LIN++
                                LIN=LIN+7
                                @ LIN,01 SAY " "
                                @ PROW(),00 SAY CHR(27)+chr(109)
                                IF CREDI>0
                                        DEVOLV=CREDI
                                ENDIF
                                CRE=0
                                OL_Yield()
                        ENDIF
                        SELE 3
                        INDEX ON STR(DCNOT)+STR(DNOT) TO DCNOT
                        MCODNOT=0
                        IF CLI > 0                        
                                @ LIN,00 SAY PADC("DEVOLUCOES DO PERIODO",40)
                                LIN++
                                LIN++
                                LIN++
                        ENDIF
                        @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                        DO WHILE ! EOF()
                                IF MCODNOT#DCNOT
                                        @ LIN,00 SAY DCNOT
                                        @ LIN,15 SAY DNOT PICT "99999.99"
                                        @ LIN,28 SAY DDATA
                                        LIN++
                                        MCODNOT=DCNOT
                                 ENDIF       
                                 @ LIN,00 SAY DNONPEC
                                 @ LIN,37 SAY DQT PICT "999"
                                 @ LIN,41 SAY DPRE*DQT PICT "9999.99"
                                 LIN++
                                 SKIP
                        ENDDO
                        LIN++
                        IF CLI>0
                                LIN=lin+7
                                @ LIN,01 SAY " "                       
                                @ PROW(),00 SAY CHR(27)+chr(109)
                        ENDIF
                        SET DEVICE TO SCREEN
                ENDIF
        ENDIF
        DO WHILE .T.
                SOMA=0
                SELE 4
                SET INDEX TO NOTTOTG
                GOTO TOP
                IF EOF()
                        EXIT
                ENDIF
                @ 07,67 GET SOMA PICT "99999.99"
                READ
                IF LASTKEY()=27
                        SAVE SCREEN TO TELA
                        PRIVATE V1[2], V2[2]
        
                        V1[01]="NOTTOTG"
                        V1[02]="CODNOT"

                        V2[01]="9,999.99"
                        V2[02]="999999999"

                        @ 04,01 TO 14,14 DOUBLE

                        DBEDIT(05,02,13,13,V1, ,V2)
                        IF LASTKEY()== 13 && "ENTER"
                             SOMA=NOTTOTG
                        ENDIF
                        IF LASTKEY()=27
                                EXIT
                        ENDIF
                        REST SCREEN FROM TELA
                ENDIF
                SEEK SOMA
                IF FOUND()
                        CONT--
                        DELETE
                        TOTAL=TOTAL+NOTTOTG
                    ELSE
                        TONE(100,11)
                        OL_Yield()
                        ALERT('VALOR NAO ENCONTRADO')
                        LOOP
                ENDIF
                @ 05,52 SAY CONT 
                @ 08,67 SAY SOMA PICT  "999,999.99"
                @ 22,67 SAY TOTAL PICT "999,999.99"
                TELA1=SAVESCREEN(08,67,20,76)
                @ 08,67 CLEAR TO 09,76
                RESTSCREEN(09,67,20,76,TELA1)
        ENDDO
        IF TOTAL=MTOTAL
                TONE(180,7)
              else 
                alert('VALORES DIFERENTES !!!!')   
        ENDIF
        IF CONFIRMA('DESEJA DAR BAIXA NOS PAGAMENTOS?')=1

                SELE 7
                *ORDSETFOCUS("BAIXAN")
                *GOTO TOP
                NUMREG=LASTREC()
                GOTO NUMREG
                set device to print
                *PRINTER()
                LIN=LIN+2
                IF ! EMPTY(MMSG1)
                @ lin,05 say MMSG1
                LIN++
                ENDIF
                IF ! EMPTY(MMSG2)
                @ lin,05 say MMSG2
                LIN++
                ENDIF
                IF ! EMPTY(MMSG3)
                @ lin,05 say MMSG3
                LIN++
                ENDIF
                IF ! EMPTY(MMSG4)
                @ lin,05 say MMSG4
                LIN++
                ENDIF
                IF ! EMPTY(MMSG5)
                @ lin,05 say MMSG5
                LIN++
                ENDIF
                IF ! EMPTY(MMSG6)
                @ lin,05 say MMSG6
                LIN++
                ENDIF
                IF ! EMPTY(MMSG1)
                @ lin,05 say " "
                LIN++
                ENDIF
                DO WHILE ! EOF()
                        IF DATA<DINICIO
                                EXIT
                        ENDIF
                        IF EMPTY(BAIXA) .AND. CLIENTE=MNOMECLI
                              IF TIPO="PAGAMENTO"                    
                                      V_PAGO=V_PAGO+VALOR
                              ENDIF
                              IF TIPO="CHEQUE S/F"
                                      CHEQUE=CHEQUE+VALOR
                              ENDIF
                              IF TIPO="PAGAMENTO"
                                      @ LIN,01 SAY FORMA + ":"
                                      @ LIN,12 SAY VALOR PICT "999,999.99"
                                      @ LIN,25 SAY DATA
                              ENDIF
                              IF TIPO="CHEQUE S/F"        
                                      @ LIN,01 SAY TIPO+":"
                                      @ LIN,00 SAY VALOR PICT "9,999.99"
                                      @ LIN,12 SAY DATA
                              ENDIF
                              LIN++                      
                              BLOQUEIO()
                              REPLACE BAIXA WITH "S"
                              UNLOCK
                        ENDIF
                        NUMREG--
                        GOTO NUMREG
                ENDDO               
                @ LIN,01 SAY " "
        ENDIF
        SET DEVICE TO SCREEN
        @ 14,16 SAY "VALOR PAGO..:" GET V_PAGO PICT  "999,999.99"
        @ 16,16 SAY "DEVOLUCAO...:" GET DEVOLV  PICT "999,999.99"
        @ 18,16 SAY "CHEQUE DEVOL:" GET CHEQUE PICT  "999,999.99"
        @ 20,16 SAY "CARTAO......:" GET CARTAO PICT  "999,999.99"
        @ 22,16 SAY "OUTROS......:" GET OUTROS PICT  "999,999.99"
        IF MCODCLI#0
                READ
        ENDIF
        IF ! EMPTY(OUTROS)
                @ 22,40 GET OUTRO PICT "@!"
                READ
        ENDIF
        @ 16,40 SAY "PAGAMENTO:"
        @ 16,50 SAY V_PAGO PICT "999,999.99"
        
        MVALOR=MTOTALDESC+ANTERIOR+CHEQUE-V_PAGO-CARTAO-DEVOLV+OUTROS 
        @ 18,40 SAY "VALOR DIVIDA:"
        @ 18,53 SAY MVALOR PICT "999,999.99"
        IF MCODCLI=0
                MCONVENIO=MCONVENIO*0.90
                @ 14,16 SAY "DINHEIRO....:" GET MDINHEIRO PICT  "999,999.99"
                @ 16,16 SAY "CONVENIO....:" GET MCONVENIO PICT "999,999.99"
                @ 18,16 SAY "DEBITO......:" GET MDEBITO   PICT "999,999.99"
                @ 20,16 SAY "CHEQUE......:" GET MCHEQUE   PICT  "999,999.99"
                @ 22,16 SAY "CREDITO.....:" GET MCREDITO  PICT  "999,999.99"
                MVALOR=MCONVENIO+MDEBITO+MCHEQUE+MCREDITO+MDINHEIRO
                @ 18,40 SAY "VALOR TOTAL.:"
                @ 18,53 SAY MVALOR PICT "9,999,999.99"
                INKEY(0)
        ENDIF
        IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                SELE 6
                ORDSETFOCUS("CODCLI")
                SEEK MCODCLI
                IF MCODCLI>1
                        BLOQUEIO()
                        REPLACE VALSEMANA WITH MVALOR
                        UNLOCK
                ENDIF
                IF CONFIRMA ("IMPRIME FOLHA?")=1
                        IMP=0
                        COD=ALLTRIM(STRZERO(MCODCLI,5))                 
                        IF MCODCLI>1
                                BLOQUEIO()
                                MMANDANOTA="S"
                                REPLACE MANDANOTA WITH MMANDANOTA
                                REPLACE DT_FECHA  WITH DFINAL
                                UNLOCK
                        ENDIF
                        DO WHILE IMP<=1
                             LIN=0 
                             IF IMP=0
                                SET DEVICE TO PRINT                     
                                SET PRINTER TO &DIRET&DIA&TRACO&MES&BARRA&COD&EXT
                              ELSE
                                set printer TO LPT1
                                *LIN=LIN-20
                                set device to print
                                *Printer()
                             ENDIF 
                                LIN=LIN+1
                                LIN=LIN+1

                                @ LIN,05 SAY DINICIO
                                @ LIN,17 SAY "\"
                                @ LIN,19 SAY DFINAL
                                @ LIN,32 SAY TIME()
        
                                LIN=LIN+1
                                LIN=LIN+1
                                @ LIN,05 SAY MNOMECLI
                                LIN=LIN+1
                                LIN=LIN+1
                                @ LIN,05 SAY MTOTAL PICT  "999,999.99"
                                LIN=LIN+1
                                @ LIN,04 SAY "_____________"
                                LIN=LIN+1
                                @ LIN,05 SAY MTOTALDESC PICT  "999,999.99"
                                IF MTOTAL>250
                                        @ LIN,17 SAY "  VALOR COM DESCONTO"
                                    ELSE
                                        @ LIN,17 SAY "  VALOR TOTAL"
                                ENDIF
                                LIN=LIN+1
                                IF ANTERIOR # V_PAGO
                                   IF ANTERIOR#0
                                        @ LIN,05 SAY ANTERIOR PICT  "999,999.99"
                                        @ LIN,17 SAY "+ SEMANA ANTERIOR"
                                        LIN=LIN+1
                                   ENDIF
                                ENDIF
                                IF OUTROS#0
                                        @ LIN,05 SAY OUTROS PICT  "999,999.99"
                                        @ LIN,17 SAY OUTRO
                                        LIN=LIN+1
                                ENDIF
                                IF CHEQUE>0
                                        @ LIN,05 SAY CHEQUE PICT  "999,999.99"
                                        @ LIN,17 SAY "+ CHEQUE DEVOLVIDO"
                                        LIN=LIN+1
                                ENDIF
                                IF ANTERIOR # V_PAGO
                                   IF V_PAGO#0
                                        @ LIN,05 SAY V_PAGO PICT  "999,999.99"
                                        @ LIN,17 SAY "- VALOR PAGO"
                                        LIN=LIN+1
                                   ENDIF
                                ENDIF
                                IF CARTAO>0
                                        @ LIN,05 SAY CARTAO PICT  "999,999.99"
                                        @ LIN,17 SAY "- CARTAO"
                                        LIN=LIN+1
                                ENDIF
                                IF DEVOLV>0
                                        @ LIN,05 SAY DEVOLV PICT  "999,999.99"
                                        @ LIN,17 SAY "- DEVOLUCAO"
                                        LIN=LIN+1
                                ENDIF
                                @ LIN,04 SAY "_____________"
                                LIN=LIN+1
                                L_DUPLA()
                                @ LIN,05 SAY MVALOR PICT  "999,999.99"
                                NORMAL()
                                @ LIN,07 SAY "VALOR TOTAL DA DIVIDA"
                                LIN=LIN+9
                                @ LIN,01 SAY " "
                                @ PROW(),00 SAY CHR(27)+CHR(109)
                              IMP++
                        ENDDO
                        SELE 4
                        SET INDEX TO NOTTOTG
                        SET DELE OFF
                        GOTO TOP
                        DO WHILE ! EOF()
                                 MCODNOT=CODNOT
                                 SELE 5
                                 ORDSETFOCUS("CODNOT")
                                 SEEK MCODNOT
                                 IF FOUND()
                                        IF MCODCLI>1
                                                IF NOTPAG="CONVENIO" .OR. NOTPAG="ASSINAR"
                                                        BLOQUEIO()
                                                        REPLACE NOTPAG WITH "FECHAMENTO"
                                                        UNLOCK
                                                ENDIF
                                        ENDIF
                                 ENDIF
                                 SELE 4
                                 SKIP
                        ENDDO
                        SET DELE ON
                    ELSE
                                set device to print
                                LIN=LIN+9
                                @ LIN,01 SAY " "
                                @ PROW(),00 SAY CHR(27)+CHR(109)
                                SET DEVICE TO SCREEN
                ENDIF
                SET DEVICE TO SCREEN       
        ENDIF
ENDDO
