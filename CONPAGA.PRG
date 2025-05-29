******************************************************************************

*****************************/FUN€AO CONSULTA PAGAMENTOS***********************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF
PAGAMENTO()
ORDSETFOCUS("DATA")
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT ('Nenhum Pagamento Cadastrado...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
CLS

PRIVATE V1[9], V2[9], V3[9]

V1[01]="CLIENTE"
V1[02]="VALOR"
V1[03]="TIPO"
V1[04]="FORMA"
V1[05]="DATA"
V1[06]="HORA"
V1[07]="NOMEFUNC"
V1[08]="BAIXA"
V1[09]="CODIGO"

V2[01]="@!"
V2[02]="99,999.99"
V2[03]="@!"
V2[04]="@!"
V2[05]="99/99/99"
V2[06]="99:99"
V2[07]="@!"
V2[08]="@!"
V2[09]="9999999999"

V3[01]="CLIENTE"
V3[02]="VALOR"
V3[03]="TIPO"
V3[04]="FORMA"
V3[05]="DATA"
V3[06]="HORA"
V3[07]="FUNCIONARIO"
V3[08]="B"
V3[09]="CREDITO"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[01] FUNC. [02] CLIENTE [03] TIPO [04] FORMA  [05] DATA",78)

DBEDIT(01,00,21,79,v1,"SDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Sdbedit(modo,coluna)
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
     elseif lastkey()== 07 && "DELETE"
          SET CURSOR ON
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
          RETURN(2)
    elseif lastkey()== 65 .OR. lastkey() == 97 .OR. LASTKEY()= -1 && "A"

          SET CURSOR ON
          TELA=SAVESCREEN(02,05,08,60)
          SETCOLOR("W+/BG,N/W")
          @ 03,06 CLEAR TO 07,60
          @ 03,06 TO 07,60 DOUBLE
          MNOMECLI=CLIENTE
          MBAIXA=BAIXA
          MVALOR=VALOR
          MTIPO=TIPO
          MNOMEFUNC=NOMEFUNC
          MFORMA=FORMA
          MCODIGO=CODIGO
          @ 03,27 SAY "³  ALTERACAO DE PAGAMENTO ³"
          @ 04,07 SAY "Cliente:" GET MNOMECLI PICT "@!" valid ! empty(mNOMECLI)
          @ 04,55 GET MBAIXA PICT "@!"           
         * @ 06,30 SAY "TIPO:" GET MTIPO
         * @ 05,25 SAY "FORMA:" GET MFORMA
         * @ 05,42 SAY "COD." GET MCODIGO
         * @ 06,07 SAY "FUNCIONARIO:" GET MNOMEFUNC
          @ 05,07 SAY "VALOR..:" GET MVALOR PICT "9,999.99"
          READ
          IF LASTKEY()=27
                   RESTSCREEN(02,05,08,60,TELA)
                   RETURN(1)
          ENDIF
          IF UPDATED()
                IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                     BLOQUEIO()
                     REPLACE CLIENTE WITH MNOMECLI
                     REPLACE BAIXA    WITH MBAIXA
                     REPLACE TIPO     WITH MTIPO
                     REPLACE FORMA    WITH MFORMA
                     REPLACE NOMEFUNC WITH MNOMEFUNC
                     REPLACE VALOR    WITH MVALOR
                     REPLACE CODIGO   WITH MCODIGO
                     UNLOCK
                ENDIF
          ENDIF
          RESTSCREEN(02,05,08,60,TELA)
          RETURN(2)

       elseif lastkey()== 50 && "2"

          CLEAR GETS
          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          ORDSETFOCUS("CODCLI")
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,25
          @ 17,10 TO 19,25 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
          READ
          IF MCODCLI=0
                CONCLI1()
          ENDIF
          SEEK MCODCLI
          IF FOUND()
                 MNOMECLI=NOMECLI
              ELSE
                 OL_Yield()
                 ALERT('CODIGO NAO ENCONTRADO')
          ENDIF
          PAGAMENTO()
          ORDSETFOCUS("CLIENTE")
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 49 && "1"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("NOMEFUNC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,51
          @ 03,20 TO 05,51 DOUBLE
          @ 04,22 SAY "FUNCIONARIO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
          
        elseif lastkey()== 51 && "3"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("TIPO")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "TIPO....:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

       elseif lastkey()== 82 .OR. lastkey() == 114  && "R/r"

                PRINTER()
                NORMAL()
                MFORMA=FORMA
                MNOMEFUNC=NOMEFUNC
                MVALOR=VALOR
                MDATA=DATA
                MHORA=HORA
                MNOMECLI=CLIENTE
                @ PROW(),00 SAY CHR(27)+CHR(33)
                @ PROW(),00 SAY CHR(27)+CHR(87)
                @ PROW(),00 SAY CHR(27)+CHR(100)
                @ PROW(),00 SAY CHR(27)+CHR(45)
                @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                @ PROW()+3,00 SAY MFORMA
                @ PROW(),00 SAY CHR(27)+CHR(64)
                @ PROW()+1,00 SAY MNOMEFUNC
                @ PROW()+1,15 SAY MDATA
                @ PROW(),27 SAY MHORA
                @ PROW(),00 SAY CHR(27)+CHR(33)
                @ PROW(),00 SAY CHR(27)+CHR(87)
                @ PROW(),00 SAY CHR(27)+CHR(100) 
                @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                *@ PROW(),00 SAY CHR(27)+CHR(45)
                @ PROW()+1,00 SAY "---------------"
                @ PROW()+1,00 SAY "|R$"
                @ PROW(),04 SAY MVALOR PICT "99,999.99"
                @ PROW(),14 SAY "|"
                @ PROW()+1,00 SAY "---------------"
                @ PROW()+1,01 say " "
                @ PROW(),00 SAY CHR(27)+CHR(64)
                @ PROW()+1,00 SAY "CLIENTE:"
                @ PROW(),00 SAY CHR(27)+CHR(33)
                @ PROW(),00 SAY CHR(27)+"!"+CHR(9)
                @ PROW(),00 SAY MNOMECLI
                @ PROW(),54 SAY " "
                @ PROW()+4,00 SAY " "
                @ PROW(),00 SAY CHR(27)+CHR(109)
                LIN=0
                SET DEVICE TO SCREEN


        elseif lastkey()== 52 && "4"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("FORMA")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "FORMA...:" GET V_BUSCA PICT "@!"
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
          ORDSETFOCUS("CODIGO")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=0
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "CREDITO..:" GET V_BUSCA PICT "9999999999"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 54 && "6"
        
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("BAIXA")
          RETURN(2)
          
        elseif lastkey()== 53 && "5"
                SAVE SCREEN TO TELA
                SET CENT ON
                DINICIO=DATE()
                DFINAL=DATE()
                @ 04,10 CLEAR TO 17,45
                @ 04,10 TO 17,45 DOUBLE
                @ 06,12 SAY "DATA INICIAL:" GET DINICIO PICT "@D"       
                @ 08,12 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
                READ                
                INDEX ON DATA TO DATA FOR DATA >=DINICIO .AND. DATA <=DFINAL
                DH_P=0
                CH_P=0
                CR_P=0
                DE_P=0
                CHE_SF=0
                MTOTAL=0
                DO WHILE ! EOF()
                      IF TIPO="PAGAMENTO"
                            IF FORMA="DINHEIRO"
                                    DH_P=DH_P+VALOR
                                    MTOTAL=MTOTAL+VALOR
                            ENDIF        
                            IF FORMA="CHEQUE"
                                    CH_P=CH_P+VALOR
                                    MTOTAL=MTOTAL+VALOR
                            ENDIF        
                            IF FORMA="CREDITO"
                                    CR_P=CR_P+VALOR
                                    MTOTAL=MTOTAL+VALOR
                            ENDIF        
                            IF FORMA="DEBITO"
                                    DE_P=DE_P+VALOR
                                    MTOTAL=MTOTAL+VALOR
                            ENDIF        
                      ENDIF
                      IF TIPO="CHEQUE S/F"
                            CHE_SF=CHE_SF+VALOR
                      ENDIF      
                      SKIP
                ENDDO
                @ 10,12 SAY "DINHEIRO.:" GET DH_P PICT "9,999,999.99"
                @ 11,12 SAY "CHEQUE...:" GET CH_P PICT "9,999,999.99"
                @ 12,12 SAY "CREDITO..:" GET CR_P PICT "9,999,999.99"
                @ 13,12 SAY "DEBITO...:" GET DE_P PICT "9,999,999.99"
                @ 14,12 SAY "CHEQUE SF:" GET CHE_SF PICT "9,999,999.99"                
                @ 16,12 SAY "TOTAL PAG:" GET MTOTAL PICT "9,999,999.99"
                CLEAR GETS
                INKEY(0)
                REST SCREEN FROM TELA
                RETURN(2)

     ENDIF
ENDIF
RETURN(1)
