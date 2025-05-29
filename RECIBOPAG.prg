MCODCLI=0
VALOR=0
MCODFUN=0
DESC=5
LIN=4
LS=13
LI=13
CE=19
CD=58
DO WHILE LS#04
      @ LS,CE CLEAR TO LI,CD
      @ LS,CE TO LI,CD DOUBLE
      LS--
      LI++
      CE--
      CD++
      INKEY(0.01)
ENDDO
@ 05,25 SAY "³    RECIBO / CREDITO   ³"
@ 06,14 SAY "FUNCIONARIO..:" GET MCODFUN PICT "999"
READ
IF LASTKEY()=27
      RETURN
ENDIF
FUNCI()
ORDSETFOCUS("CODFUNC")
SEEK MCODFUN
IF FOUND()
        MNOMEFUNC=NOMEFUNC
        @ 06,29 SAY MNOMEFUNC
     ELSE
     OL_Yield()
        ALERT('FUNCIONARIO NAO CADASTRADO')
        RETURN
ENDIF
SET KEY -40 TO CONCLI1() // F11
@ 08,14 SAY "CLIENTE......:" GET MCODCLI PICT "9999"
READ
IF LASTKEY()=27
      RETURN
ENDIF
SET KEY -40 TO OTARIOS()
CLIENTES()
SEEK MCODCLI
IF ! FOUND()
        TONE(500,5)
        OL_Yield()
        ALERT('CLIENTE NAO CADASTRADO !!!')
        RETURN
ENDIF
MNOMECLI=NOMECLI
MPONTO=P1
MENDCLI=ENDCLI
MCODNOT=99999990
MKM=KM
@ 08,29 SAY MNOMECLI
@ 10,14 SAY "DIGITE VALOR.:" GET VALOR PICT "99999.99" VALID VALOR > 0
READ                
IF LASTKEY()=27
      RETURN
ENDIF
IF FORMA="RECIBO DE PAGAMENTO"
        IF TIPO="CARTAO"
                @ 12,14 SAY "DESCONTO.....:" GET DESC PICT "99" VALID DESC > 0
                READ
                IF LASTKEY()=27
                      RETURN
                ENDIF
                VALOR=VALOR*((100-DESC)/100)
        ENDIF
ENDIF
set device to print
*Printer()
CLS           
DADOS2()
@ LIN,00 SAY RSOCIAL
LIN++
@ LIN,00 SAY ENDEMPR
LIN++
@ LIN,00 SAY "DATA:"
@ LIN,06 SAY DATE()
@ LIN,20 SAY "HORA:"
@ LIN,26 SAY TIME()
LIN=LIN+2
@ PROW(),00 SAY CHR(27)+CHR(33)
@ PROW(),00 SAY CHR(27)+CHR(87)
@ PROW(),00 SAY CHR(27)+CHR(100)
@ PROW(),00 SAY CHR(27)+CHR(45)
@ LIN,00 SAY FORMA
@ PROW(),00 SAY CHR(27)+CHR(64)
LIN++
@ LIN,00 SAY MNOMEFUNC
LIN=LIN+2
@ PROW(),00 SAY CHR(27)+CHR(33)
@ LIN,32 SAY "---------------"
LIN++
@ LIN,32 SAY "|R$"
@ LIN,36 SAY VALOR PICT "99,999.99"
@ LIN,46 SAY "|"
LIN++
@ LIN,32 SAY "---------------"
LIN++                 
@ LIN,40 SAY TIPO
@ PROW(),00 SAY CHR(27)+CHR(64)
LIN++
CLIENTES()
SEEK MCODCLI
IF FORMA="RECIBO DE PAGAMENTO"
        @ LIN,00 SAY "Recebemos de....:"
        IF TIPO="CARTAO"
                MPCARTAO=PCARTAO+VALOR
                BLOQUEIO()
                REPLACE PCARTAO WITH MPCARTAO
                UNLOCK
            ELSEIF TIPO="CHEQUE"
                MPCHEQUE=PCHEQUE+VALOR
                BLOQUEIO()
                REPLACE PCHEQUE WITH MPCHEQUE
                UNLOCK
        ENDIF
    ELSEIF FORMA="CREDITO EM PECAS"
        @ LIN,00 SAY "Autorizamos credito para:"
    ELSEIF FORMA="CHEQUE DEVOLVIDO"
        @ LIN,00 SAY "Devolvemos Cheque para:"
        BLOQUEIO()
        REPLACE PCHEQUE_SF WITH PCHEQUE_SF+VALOR
        UNLOCK
ENDIF
LIN++
@ PROW(),00 SAY CHR(27)+CHR(33)
@ LIN,00 SAY MNOMECLI
@ PROW(),00 SAY CHR(27)+CHR(64)
LIN++
LIN++
@ LIN,00 SAY "A importancia de:"
LIN++
@ PROW(),00 SAY CHR(27)+CHR(33)
EXTE=EXT(VALOR)
FOR I=1 TO 48
        IF SUBSTR(EXTE,I,1)=" "
                SP=I              
        ENDIF     
NEXT 
@ LIN,00 SAY LEFT(EXTE,SP)
LIN++
@ LIN,00 SAY SUBSTR(EXTE, SP+1, 48)
IF TIPO="CREDITO EM PECAS"
        LIN++
        LIN++
        LIN=LIN+4
        @ LIN,00 SAY PADC("VALIDADE 3 MESES",40)
ENDIF
MOSTEXCUPOM()
LIN++
@ LIN,01 SAY " "                       
@ PROW(),00 SAY CHR(27)+chr(109)
LIN=0
IF FORMA="CHEQUE DEVOLVIDO"
                     ENTREGA()
                     BLOQUEIO()
                     APPEND BLANK
                     REPLACE ENTREGAS WITH "CHEQUE "+LEFT(MNOMECLI,38)
                     REPLACE PONTO    WITH MPONTO
                     REPLACE ENDERECO WITH MENDCLI
                     REPLACE CODIGO   WITH MCODNOT
                     REPLACE HORA     WITH TIME()
                     REPLACE KM       WITH MKM
                     UNLOCK
                     TESTAPONTO()
ENDIF
IF FORMA="RECIBO DE PAGAMENTO"
        LIN=3
        @ PROW(),00 SAY CHR(27)+CHR(33)
        @ PROW(),00 SAY CHR(27)+CHR(87)
        @ PROW(),00 SAY CHR(27)+CHR(100)
        @ PROW(),00 SAY CHR(27)+CHR(45)
        @ LIN,00 SAY FORMA
        @ PROW(),00 SAY CHR(27)+CHR(64)
        LIN++
        @ LIN,00 SAY MNOMEFUNC
        @ LIN,15 SAY DATE()
        @ LIN,27 SAY TIME()
        LIN++
        @ PROW(),00 SAY CHR(27)+CHR(33)
        @ PROW(),00 SAY CHR(27)+CHR(87)
        @ PROW(),00 SAY CHR(27)+CHR(100)
        *@ PROW(),00 SAY CHR(27)+CHR(45)
        LIN++
        @ LIN,00 SAY "---------------"
        LIN++
        @ LIN,00 SAY "|R$"
        @ LIN,04 SAY VALOR PICT "99,999.99"
        @ LIN,14 SAY "|"
        LIN++
        @ LIN,00 SAY "---------------"
        @ PROW(),00 SAY CHR(27)+CHR(64)
        LIN++                 
        @ LIN,00 SAY TIPO
        LIN++                 
        LIN++
        @ LIN,00 SAY "CLIENTE:"
        LIN++
        @ LIN,00 SAY MNOMECLI
        @ PROW(),00 SAY CHR(27)+CHR(64)
        LIN=LIN+5
        @ LIN,00 SAY " "
        @ PROW(),00 SAY CHR(27)+CHR(109)
        LIN=0
ENDIF
SET DEVICE TO SCREEN
RETURN


