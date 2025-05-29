******************************************************************************

*****************************/FUN€AO CONSULTA PEDIDO**************************
NTX=1
SET CENTURY ON
OP=3
CUPOM()
CLOSE INDEXES
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhum Cupom emitido ate o momento...')
   RETURN(0)
ENDIF


SETCOLOR("GR/B+")
IF ACESSO =0 .OR. ACESSO=4
      PRIVATE V1[10], V2[10], V3[10]
   ELSEIF ACESSO =1   
      PRIVATE V1[15], V2[15], V3[15]
      V1[10]="P_CUSTO"
      V2[10]="9,999.99"
      V3[10]="CUSTO"
      V1[11]="(NOTTOTG/P_CUSTO-1)*100"
      V2[11]="999.99%"
      V3[11]="LUCRO"
      V1[12]="NOTFUNC"
      V2[12]="@!"
      V3[12]="FUNC."
      V1[13]="ALTFUNC"
      V2[13]="@!"
      V3[13]="FUNC.ALT."
      V1[14]="DATAULT"
      V2[14]="@D"
      V3[14]="D_ALT"
      V1[15]="HORAULT"
      V2[15]="@!"
      V3[15]="HORAALT"
ENDIF      
V1[01]="CODNOT"
V1[02]="NOTCLI"
V1[03]="NOTTOTG+(DESCONTO*-1)"
V1[04]="NOTTOTG"
V1[05]="D_NOT"
V1[06]="NOTPAG"
V1[07]="HORANOT"
V1[08]="CNPJCLI"
V1[09]="CODIGO"
V1[10]="ABATIMENTO"

V2[01]="999999999"
V2[02]="@!"   
V2[03]="99,999.99"
V2[04]="99,999.99"
V2[05]="99/99/99"
V2[06]="@!"   
V2[07]="99:99"
V2[08]="@!"
V2[09]="9999999999"
V2[10]="9,999.99"

V3[01]="N§ CUPOM"
V3[02]="NOME CLIENTE"
V3[03]="TOTAL"
V3[04]="C/DESC."
V3[05]="DATA"
V3[06]="PAGAMENTO"
V3[07]="HORA"
V3[08]="DOC.CLIENTE"
V3[09]="CREDITO"
V3[10]="ABATIMENTO"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [1] CODIGO [2] NOME CLIENTE [8] CREDITO ",78)

DBEDIT(01,00,21,79,v1,"DDBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function DDbedit(modo,coluna)
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
          CUPOM()

       ELSEIF LASTKEY()= 13 && "ENTER"

          IF ACESSO#1
              RETURN(2)
          ENDIF
          SETCOLOR("W+/BG,N/W")
          PUVARNOT()
          IGUAVANOT()
          @ 03,07 CLEAR TO 19,67
          @ 03,07 TO 19,67 DOUBLE
          @ 03,11 SAY "CONSULTA CUPOM PEDIDO"
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTENOT()
          INKEY(0)
          RETURN(2)

       elseif lastkey()== 281  && "ALT+P"

          CLEAR GETS
          IF ACESSO#1
              RETURN(2)
          ENDIF
          SAVE SCREEN TO FTELA
          NUNREG=RECNO()
      	  PUVARNOT()
          IGUAVANOT()
          BLOQUEIO()
          REPLACE NOTPAG  WITH "PAGO"
          REPLACE ALTFUNC WITH FUNCIONARIO
          REPLACE DATAULT WITH DATE()
          REPLACE HORAULT WITH TIME()
          UNLOCK
          KEYBOARD CHR(13)
          REIMCUPO()
          CUPOM()
          IF NTX=1
		ORDSETFOCUS("CODNOT")
	      ELSE
		ORDSETFOCUS("NOTCLI")
	  ENDIF
          REST SCREEN FROM FTELA
	  GOTO NUNREG
          RETURN(2)

       elseif lastkey()== 275  && "ALT+R"

          CLEAR GETS
          IF ACESSO#1
              RETURN(2)
          ENDIF
          SAVE SCREEN TO FTELA
          XENTREGAS="RECEBER "
          NUNREG=RECNO()
      	  PUVARNOT()
          IGUAVANOT()
          BLOQUEIO()
          REPLACE NOTPAG  WITH "PAGO"
          REPLACE ALTFUNC WITH FUNCIONARIO
          REPLACE DATAULT WITH DATE()
          REPLACE HORAULT WITH TIME()
          UNLOCK
          KEYBOARD CHR(13)
          REIMCUPO()
          CLIENTES()
          ORDSETFOCUS("NOMECLI")
          SEEK MNOTCLI
          IF FOUND()
                MNOMECLI=NOMECLI
                MPONTO=P1
                MT_MOTO=T_MOTO
                MENDCLI=ENDCLI
                MKM=KM
          ENDIF
          ENTREGA()
          ORDSETFOCUS("ENTREGAS")
          BLOQUEIO()
          APPEND BLANK
          REPLACE ENTREGAS WITH XENTREGAS+LEFT(MNOMECLI,38)
          REPLACE PONTO    WITH MPONTO
          REPLACE CODIGO   WITH MCODNOT
          REPLACE ENDERECO WITH MENDCLI
          REPLACE T_MOTO   WITH MT_MOTO
          REPLACE HORA     WITH TIME()
          REPLACE KM       WITH MKM
          DBCOMMIT()
          UNLOCK
          IF CONFIRMA ("DESEJA COLOCAR CANHOTO ?")=1          
                  ENVIADOS()
                  BLOQUEIO()
                  APPEND BLANK
                  CANHOTO()
          ENDIF
          REST SCREEN FROM FTELA
          CUPOM()
          IF NTX=1
		ORDSETFOCUS("CODNOT")
	      ELSE
		ORDSETFOCUS("NOTCLI")
	  ENDIF
          GOTO NUNREG
          RETURN(2)


       elseif lastkey()== 286  && "ALT+A"

          CLEAR GETS
          NUNREG=RECNO()
          ACESSO()
          IF EMPTY(FUNCIONARIO)
                RETURN(2)
          ENDIF
         * SAVE SCREEN TO FTELA
          CUPOM()
          GOTO NUNREG
          PUVARNOT()
          IGUAVANOT()
          BLOQUEIO()
          REPLACE NOTPAG  WITH "ASSINAR"
          REPLACE ALTFUNC WITH FUNCIONARIO
          REPLACE DATAULT WITH DATE()
          REPLACE HORAULT WITH TIME()
          UNLOCK
         * KEYBOARD CHR(13)
         * REIMCUPO()
         * CUPOM()
         * IF NTX=1
         *       ORDSETFOCUS("CODNOT")
         *     ELSE
         *       ORDSETFOCUS("NOTCLI")
         * ENDIF
         * REST SCREEN FROM FTELA
          GOTO NUNREG
          RETURN(2)

       elseif lastkey()== 84 .OR. lastkey() == 116  && "T/t"

          CLEAR GETS
          NUNREG=RECNO()
          ACESSO()
          IF EMPTY(FUNCIONARIO)
                CUPOM()
                GOTO NUNREG
                RETURN(2)
          ENDIF
         * SAVE SCREEN TO FTELA
          CUPOM()
          GOTO NUNREG
          PUVARNOT()
          IGUAVANOT()
          BLOQUEIO()
          REPLACE NOTPAG   WITH "CONVENIO"
          REPLACE ALTFUNC  WITH FUNCIONARIO
          REPLACE DATAULT  WITH DATE()
          REPLACE HORAULT  WITH TIME()
          REPLACE NOTTOTG  WITH NOTTOTG+(DESCONTO*-1)
          REPLACE DESCONTO WITH 0
          UNLOCK
         * KEYBOARD CHR(13)
         * REIMCUPO()
         * CUPOM()
         * IF NTX=1
         *       ORDSETFOCUS("CODNOT")
         *     ELSE
         *       ORDSETFOCUS("NOTCLI")
         * ENDIF
         * REST SCREEN FROM FTELA
          GOTO NUNREG
          RETURN(2)

       elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"
          
          CLEAR GETS
          SAVE SCREEN TO FTELA
          NUNREG=RECNO()
      	  PUVARNOT()
          IGUAVANOT()
          REIMCUPO()
          CUPOM()
          IF NTX=1
		ORDSETFOCUS("CODNOT")
	      ELSE
		ORDSETFOCUS("NOTCLI")
	  ENDIF
          REST SCREEN FROM FTELA
	  GOTO NUNREG
          RETURN(2)

       elseif lastkey()== 67 .OR. lastkey() == 99  && "C/c"

                        CLEAR GETS
                        CNPJ=SPACE(18)
                        OP=1
                        OK=.f.
                        @ 23,02 CLEAR TO 23,70
                        @ 10,10 CLEAR TO 16,36
                        @ 10,10 TO 16,36 DOUBLE
                        @ 11,12 PROMPT "1-NULO." MESS "SEM DADOS "
                        @ 12,12 PROMPT "2-CPF.." MESS "DIGITE O CPF DO CONSUMIDOR" 
                        @ 13,12 PROMPT "3-CNPJ." MESS "DIGITE O CNPJ DA EMPRESA" 
                        MENU TO OP
                        DO CASE
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
                           CASE OP == 1                              

                        ENDCASE
                        BLOQUEIO()
                        REPLACE CNPJCLI WITH CNPJ
                        UNLOCK
           RETURN(2)

       elseif lastkey()== 65 .OR. lastkey() == 97  && "A/a"

          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RETURN(2)
          ENDIF
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
          SET CURSOR ON
          PUVARNOT()
          IGUAVANOT()
          SET CENT ON
          @ 03,07 CLEAR TO 19,67
          @ 03,07 TO 19,67 DOUBLE
          @ 03,11 SAY "ALTERA CUPOM PEDIDO"
          VTOTG=NOTTOTG
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTENOT()
          READ
          IF UPDATED()
              IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                 IF ALLTRIM(FUNCIONARIO)#"MARCELO"
                        MNOTFUNC=NOTFUNC
                 ENDIF
                 REPLNOT()
              ENDIF
          ENDIF
          BLOQUEIO()
          REPLACE ALTFUNC WITH FUNCIONARIO
          REPLACE DATAULT WITH DATE()
          REPLACE HORAULT WITH TIME()
          UNLOCK
          RETURN(2)

       elseif lastkey()== 49 && "1"
          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=0
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,40
          @ 03,20 TO 05,40 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
	  READ
	  SEEK V_BUSCA
	  IF EOF()
             SKIP-1
             RETURN(1)
	  ENDIF
	  NTX=1 
	  RETURN(2)

    elseif lastkey()== 50 && "2"

          CLEAR GETS
          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,25
          @ 17,10 TO 19,25 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
          READ
          IF MCODCLI=0
                CONCLI1()
          ENDIF
          ORDSETFOCUS("CODCLI")
          SEEK MCODCLI
          IF FOUND()
                 MNOMECLI=NOMECLI
              ELSE
                 OL_Yield()
                 ALERT('CODIGO NAO ENCONTRADO')
          ENDIF
          CUPOM()
          ORDSETFOCUS("NOTCLI")
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
	  NTX=2
          RETURN(2)
                 
    elseif lastkey()== 51 && "3"

          ORDSETFOCUS("NOTCLI")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,65
          @ 03,20 TO 05,65 DOUBLE
          @ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
	  NTX=2
          RETURN(2)

    elseif lastkey()== 52 && "4"

          ORDSETFOCUS("NOTFUNC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,55
          @ 03,20 TO 05,55 DOUBLE
          @ 04,22 SAY "FUNCIONARIO:" GET V_BUSCA PICT "@!"
          READ
          DBSEEK(V_BUSCA,.T.,.T.)
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

       elseif lastkey()== 54 && "6"

             CLEAR GETS
             @ 03,20 CLEAR TO 05,65
             @ 03,20 TO 05,65 DOUBLE
             V_BUSCA=0
             @ 04,22 SAY "VALOR:" GET V_BUSCA PICT "9999.99"
             READ
             INDEX ON NOTTOTG TO NOTTOTG
             SEEK V_BUSCA
             RETURN(2)
     
       elseif lastkey()== 53 && "5"

          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,65
          @ 03,20 TO 05,65 DOUBLE
          @ 04,22 SAY "Cliente:" GET V_BUSCA PICT "@!"
          READ
          IF EMPTY(V_BUSCA)
                ORDSETFOCUS("NOTCLI")
              ELSE
                INDEX ON NOTCLI TO TEMP FOR RTRIM(V_BUSCA) $ NOTCLI
          ENDIF
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

    elseif lastkey()== 55 && "7"

          CLEAR GETS
          ORDSETFOCUS("CNPJCLI")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          CLEAR GETS
          MOP=1
          OK=.f.
          CNPJ=SPACE(18)
          @ 23,02 CLEAR TO 23,70
          @ 10,10 CLEAR TO 14,36
          @ 10,10 TO 14,36 DOUBLE
          @ 11,12 PROMPT "1-CPF.." MESS "DIGITE O CPF DO CONSUMIDOR" 
          @ 12,12 PROMPT "2-CNPJ." MESS "DIGITE O CNPJ DA EMPRESA" 
          MENU TO MOP
          DO CASE
                CASE MOP == 1
                       DO WHILE OK=.f.
                               @ 13,12 SAY "CPF.:" GET CNPJ PICT "999.999.999-99" 
                               READ
                               IF LASTKEY()=27
                                       CNPJ=SPACE(18)
                                       EXIT
                               ENDIF
                               TESTA_CPF()
                       ENDDO
                CASE MOP == 2
                       DO WHILE OK=.f.
                               @ 13,12 SAY "CNPJ:" GET CNPJ PICT "99.999.999/9999-99"
                               READ 
                               IF LASTKEY()=27
                                       CNPJ=SPACE(18)
                                       EXIT
                               ENDIF
                               TESTA_CNPJ()
                       ENDDO
          ENDCASE
          READ
          SEEK CNPJ
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)
       elseif lastkey()== 56 && "8"
             CLEAR GETS
             @ 03,20 CLEAR TO 05,65
             @ 03,20 TO 05,65 DOUBLE
             V_BUSCA=0
             @ 04,22 SAY "CREDITO:" GET V_BUSCA PICT "9999999999"
             READ
             ORDSETFOCUS("ABERTOS")
             DBSEEK(V_BUSCA,.T.,.T.)
             RETURN(2)

       elseif lastkey()== 9 && "TAB"

             CLEAR GETS
             V_BUSCA="ASSINAR"
             CLEAR GETS
             MCODCLI=0
             MNOMECLI=SPACE(35)
             CLIENTES()
             SET KEY -40 TO CONCLI1() // F11
             @ 17,10 CLEAR TO 19,25
             @ 17,10 TO 19,25 DOUBLE
             @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
             READ
             ORDSETFOCUS("CODCLI")
             IF MCODCLI=0
                   CUPOM()
                   INDEX ON DTOS(D_NOT) + NOTCLI TO C:\KARVAN\TEMP FOR NOTPAG="ASSINAR";
                   .OR. NOTPAG="CONVENIO"
                   DBSEEK(V_BUSCA,.T.,.T.)
                   RETURN(2)
             ENDIF
             SEEK MCODCLI
             IF FOUND()
                    MNOMECLI=NOMECLI
                    CUPOM()
                    INDEX ON DTOS(D_NOT) + NOTCLI TO C:\KARVAN\TEMP FOR NOTPAG="ASSINAR" .AND. NOTCLI=MNOMECLI;
                    .OR. NOTPAG="CONVENIO" .AND. NOTCLI=MNOMECLI
                    TOTAL=0
                    TOTALDESC=0
                    DO WHILE ! EOF()
                                TOTALDESC=TOTALDESC+NOTTOTG
                                TOTAL=TOTAL+(NOTTOTG-DESCONTO)
                                SKIP
                    ENDDO
                    @ 23,02 CLEAR TO 23,77
                    @ 23,05 SAY "TOTAL.....:"
                    @ 23,17 SAY TOTAL PICT "99,999.99"
                    @ 23,35 SAY "TOTAL DESC:"
                    @ 23,47 SAY TOTALDESC PICT "99,999.99"
                            ELSE
                    OL_Yield()
                    ALERT('CODIGO NAO ENCONTRADO')
             ENDIF
             *CUPOM()
             *ORDSETFOCUS("NOTCLI")
             DBSEEK(MNOMECLI,.T.,.T.)
             IF EOF()
                ALERT('NENHUMA NOTA ASSINADA')
                SKIP-1
                RETURN(1)
             ENDIF
             NTX=2
             RETURN(2)

       elseif lastkey()== -1 && "F2"
             CLEAR GETS
             SAVE SCREEN TO FTELA             
             @ 03,04 CLEAR TO 21,42
             @ 03,04 TO 21,42 DOUBLE
             @ 04,05 SAY "TAB.. = ORGANIZA POR ASSINADAS"
             @ 05,05 SAY "ENTER.= SELECIONA"
             @ 06,05 SAY "ALT+A.= TROCA PARA ASSINAR"
             @ 07,05 SAY "ALT+P.= TROCA PARA PAGO"
             @ 08,05 SAY "ALT+R.= CADASTRA ENTREGA RECEBER"
             @ 09,05 SAY "T/t...= TROCA PARA CONVENIO"
             @ 10,05 SAY "R/r...= REIMPRIME PEDIDO"
             @ 11,05 SAY "C/c...= COLOCAR CNPJ/CPF"
             @ 12,05 SAY "A/a...= ALTERA PEDIDO"
             @ 13,05 SAY "1.....= CONSULTA POR CODIGO PEDIDO"
             @ 14,05 SAY "2.....= CONSULTA POR CODIGO CLIENTE"
             @ 15,05 SAY "3.....= CONSULTA POR NOME CLIENTE"
             @ 16,05 SAY "4.....= CONSULTA POR NOME FUNCIONARIO"
             @ 17,05 SAY "5.....= ENCONTRA NO NOME CLIENTE"
             @ 18,05 SAY "6.....= CONSULTA POR VALOR PEDIDO"
             @ 19,05 SAY "7.....= CONSULTA POR CNPJ/CPF"
             @ 20,05 SAY "8.....= CONSULTA POR CREDITO"
             INKEY(0)
             REST SCREEN FROM FTELA
             RETURN(2)
      ENDIF
     ENDIF
RETURN(1)
****

