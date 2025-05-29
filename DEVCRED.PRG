IF ACESSO#1
OL_Yield() 
     ALERT('ACESSO NAO AUTORIZADO')
     RETURN(.T.)
ENDIF

DO WHILE .T.
SELE 1
PECAS()
SELE 4
CLIENTES()
SELE 6
DEVOLCRE()
SELE 5
USE C:\KARVAN\DEVTEMP
MCODPECA=SPACE(05)
MQTD=0         
MCODCLI=0
CLEAR GETS
SETCOLOR("W+/R,GR/W")
@ 10,20 CLEAR TO 18,65
@ 10,20 TO 18,65 DOUBLE
@ 11,21 SAY "DIGITE O N§ DA PE€AS..:" GET MCODPECA PICT "@!"
@ 13,21 SAY "DIGITE A QUANTIDADE...:" GET MQTD PICT "999" VALID MQTD > 0
@ 15,21 SAY "DIGITE O N§ DO CLIENTE:" GET MCODCLI PICT "9999" 
READ
SELE 1
ORDSETFOCUS("CODPECA")
SEEK MCODPECA
IF ! FOUND()
OL_Yield()
          SELE 5
          IF LASTREC()=0
                ALERT('CODIGO NAO CADASTRADO !!!')
                RETURN
             ELSE
                EXIT
          ENDIF
ENDIF               
IF MCODCLI#0
        SELE 4
        ORDSETFOCUS("CODCLI")
        SEEK MCODCLI
        IF FOUND()
                MNOMECLI=NOMECLI
                xNOMECLI=NOMECLI
             ELSE
                ALERT('CLIENTE NAO CADASTRADO')
                MCODCLI=0
        ENDIF
ENDIF
SELE 2
CUPOM()
SELE 3
PEDCUP()
*IF MCODCLI=0
                SAVE SCREEN TO FTELA
                SELE 2                
                ORDSETFOCUS("CODNOT")
                SELE 3
                ORDSETFOCUS("PEDCOD")
                @ 02,01 CLEAR TO 22,78
                @ 02,01 TO 22,78
                LIN1=05
                @ 03,03 SAY "PECA"
                @ 03,17 SAY "COD.NOTA"
                @ 03,30 SAY "CLIENTE"
                @ 03,68 SAY "DATA"
                NUMREG=LASTREC()
                DO WHILE ! BOF()
                            MDATACUP=DATACUP
                            @ LIN1,68 SAY MDATACUP
                            IF LASTKEY()=27
                                  RETURN
                            ENDIF
                            SELE 3
                            GOTO NUMREG
                            MPEDNUM=PEDNUM                          
                            IF PEDCOD = MCODPECA 
                               IF ! DELETED()
                                    MPEDCOD=PEDCOD
                                    MPEDNUM=PEDNUM
                                    MPEDQTD=PEDQTD
                                    MPRECO=PRECOCUP
                                    MVERIFIC=VERIFIC
                                    SELE 1
                                    ORDSETFOCUS("CODPECA")
                                    SEEK MPEDCOD                         
                                    MNOMEPECA=NOMEPECA
                                    IF MVERIFIC=0
                                          MVERIFIC=1
                                    ENDIF           
                                    IF MVERIFIC<=1
                                           MPFABRIC=FABRIC
                                           MPNFABRIC=NFABRIC
                                    ENDIF
                                    IF MVERIFIC=2
                                            MPFABRIC=FABRIC2
                                            MPNFABRIC=NFABRIC2
                                    ENDIF
                                    IF MVERIFIC=3
                                            MPFABRIC=FABRIC3
                                            MPNFABRIC=NFABRIC3
                                    ENDIF
                                    IF MVERIFIC=4
                                            MPFABRIC=FABRIC4
                                            MPNFABRIC=NFABRIC4
                                    ENDIF
                                    IF MVERIFIC=5
                                            MPFABRIC=FABRIC5
                                            MPNFABRIC=NFABRIC5
                                    ENDIF
                                    SELE 2
                                    ORDSETFOCUS("CODNOT")
                                    SEEK MPEDNUM
                                    @ LIN1,03 SAY MPEDCOD
                                    @ LIN1,08 SAY "-"
                                    @ LIN1,09 SAY MVERIFIC
                                    @ LIN1,12 SAY MPEDQTD
                                    @ LIN1,15 SAY MPEDNUM
                                    @ LIN1,30 SAY NOTCLI
                                    MNOMECLI=NOTCLI
                                    VNOMECLI=NOTCLI
                                    @ LIN1,68 SAY D_NOT
                                    MD_NOT=D_NOT
                                    LIN1++
                                    @ LIN1,03 SAY MPFABRIC
                                    @ LIN1,15 SAY MPNFABRIC
                                    LIN1++
                                    IF MCODCLI=0
                                        INKEY(0)
                                    ENDIF
                                    IF MCODCLI#0
                                        IF xNOMECLI=NOTCLI
                                                INKEY(0)
                                        ENDIF
                                    ENDIF
                                    CLOSE ALL
                                    SELE 6
                                    DEVOLCRE()
                                    SELE 5
                                    USE C:\KARVAN\DEVTEMP
                                    SELE 1
                                    PECAS()
                                    SELE 4
                                    CLIENTES()
                                    SELE 2
                                    CUPOM()
                                    ORDSETFOCUS("CODNOT")                                   
                                    SELE 3
                                    PEDCUP()                                                 
                                    ORDSETFOCUS("PEDCOD")
                                    IF LASTKEY()=27
                                        EXIT
                                    ENDIF
                               ENDIF
                            ENDIF
                            NUMREG--
                            IF LIN1>=20
                                SETCOLOR("W+/R,GR/W")
                                @ 21,15 SAY "FIM DE PAGINA PRESIONE ENTER PARA CONTINUAR ..."
                                CLOSE ALL
                                SELE 6
                                DEVOLCRE()
                                SELE 5
                                USE C:\KARVAN\DEVTEMP
                                SELE 1
                                PECAS()
                                SELE 4
                                CLIENTES()
                                SELE 2
                                CUPOM()
                                ORDSETFOCUS("CODNOT")                                       
                                SELE 3
                                PEDCUP()                                                     
                                ORDSETFOCUS("PEDCOD")
                                IF LASTKEY()=27
                                        EXIT
                                ENDIF
                                SETCOLOR("W+/R,GR/W")
                                LIN1=5
                                @ 05,03 CLEAR TO 21,77
                            ENDIF
                            IF NUMREG=-1
                            OL_Yield()
                                  ALERT('CLIENTE NAO ENCONTRADO')
                                  RETURN
                            ENDIF
                ENDDO
                RESTORE SCREEN FROM FTELA
                @ 15,21 SAY "DIGITE O N§ DO PEDIDO.:" GET MPEDNUM PICT "999999999"
*ENDIF


@ 10,20 CLEAR TO 18,65
@ 10,20 TO 18,65 DOUBLE
@ 11,21 SAY "N§ DO CUPOM.:"
@ 11,36 SAY MPEDNUM
@ 13,21 SAY "CLIENTE:"
@ 13,30 SAY MNOMECLI
@ 15,21 SAY "FABRIC.:"
@ 15,30 SAY MPFABRIC
@ 15,41 SAY "N.FABRIC:"
@ 15,52 SAY MPNFABRIC
@ 17,21 SAY "DATA :"
@ 17,28 SAY MD_NOT
@ 17,44 SAY "PRECO :"
@ 17,50 SAY MPRECO PICT "9999.99"
IF CONFIRMA("DADOS CORRETOS...?") = 1

        ELSE
                RETURN
ENDIF
SELE 5
APPEND BLANK
REPLACE NOMECLI  WITH VNOMECLI
REPLACE CODPECA  WITH MCODPECA
REPLACE NOMEPECA WITH MNOMEPECA
REPLACE PRECO    WITH MPRECO
REPLACE CODNOT   WITH MPEDNUM
REPLACE QTD      WITH MQTD
DBCOMMIT()
UNLOCK
INKEY(0)
NUMREG=1
IF LASTKEY()#13
        EXIT
ENDIF   
ENDDO
CLOSE ALL
USE C:\KARVAN\DEVTEMP
MVALOR=0
DO WHILE ! EOF()
        MVALOR=MVALOR+(PRECO*QTD)
        SKIP
ENDDO

MCODCLI=MCODCLI
MNOMEFUNC=FUNCIONARIO
MNOMECLI=VNOMECLI
set device to print
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
DO WHILE .T.
        MCODIGO=STR(DAY(DATE()))+STRZERO(MONTH(DATE()),2)+STRZERO(RANDOM(),6)
        MCODIGO=VAL(MCODIGO)
        PAGAMENTO()
        ORDSETFOCUS("CODIGO")
        SEEK MCODIGO
        IF ! FOUND()
                EXIT
        ENDIF
ENDDO
MFORMA="CREDITO EM PECAS"
L_DUPLA()
@ PROW()+1,COL() SAY MCODIGO
NORMAL()
@ PROW()+1,COL() SAY MFORMA
@ PROW()+1,00 SAY MNOMEFUNC
PEQUENO()
@ PROW()+2,32 SAY "---------------"
@ PROW()+1,32 SAY "|R$"
@ PROW(),36 SAY MVALOR PICT "99,999.99"
@ PROW(),46 SAY "|"
@ PROW()+1,32 SAY "---------------"

@ PROW()+1,00  SAY " "
MTIPO="CREDITO"
PAGAMENTO()
BLOQUEIO()
APPEND BLANK
REPLACE CODIGO   WITH MCODIGO
REPLACE CLIENTE  WITH MNOMECLI
REPLACE NOMEFUNC WITH MNOMEFUNC
REPLACE VALOR    WITH MVALOR
REPLACE DATA     WITH DATE()
REPLACE HORA     WITH TIME()
REPLACE TIPO     WITH "CREDITO"
REPLACE FORMA    WITH MTIPO 
@ PROW(),40 SAY MTIPO
@ PROW(),00 SAY CHR(27)+CHR(64)
@ PROW()+1,00 SAY "Autorizamos credito para:"
@ PROW(),00 SAY CHR(27)+CHR(33)
@ PROW(),00 SAY CHR(27)+"!"+CHR(9)
@ PROW(),00 SAY MNOMECLI
@ PROW(),54 SAY " "
@ PROW(),00 SAY CHR(27)+CHR(64)
@ PROW()+1,00 SAY "A importancia de:"
@ PROW(),00 SAY CHR(27)+CHR(33)
EXTE=EXT(MVALOR)
FOR I=1 TO 48
        IF SUBSTR(EXTE,I,1)=" "
                SP=I              
        ENDIF     
NEXT 
@ PROW()+1,00 SAY LEFT(EXTE,SP)
@ PROW()+1,00 SAY SUBSTR(EXTE, SP+1, 48)
IF MFORMA="CREDITO EM PECAS"
        @ PROW()+1,00 SAY PADC("VALIDADE 3 MESES",48)
ENDIF
LIN=0
LIN++
@ LIN,54 SAY " "
MOSTEXCUPOM()
@ PROW()+4,01 SAY " "                       
@ PROW(),00 SAY CHR(27)+chr(109)
SET DEVICE TO SCREEN

USE C:\KARVAN\DEVTEMP
GOTO NUMREG
DO WHILE .NOT. EOF()
        VNOMECLI=NOMECLI
        MCODPECA=CODPECA
        MNOMEPECA=NOMEPECA
        MPRECO=PRECO
        MPEDNUM=CODNOT
        MQTD=QTD
        DEVOLCRE()
        BLOQUEIO()
        APPEND BLANK
        REPLACE NOMECLI  WITH VNOMECLI
        REPLACE CODPECA  WITH MCODPECA
        REPLACE NOMEPECA WITH MNOMEPECA
        REPLACE PRECO    WITH MPRECO
        REPLACE CODNOT   WITH MPEDNUM
        REPLACE QTD      WITH MQTD
        REPLACE DATA     WITH DATE()
        REPLACE NOMEFUNC WITH MNOMEFUNC
        REPLACE CREDITO  WITH MCODIGO
        DBCOMMIT()
        UNLOCK
        USE C:\KARVAN\DEVTEMP
        NUMREG++
        GOTO NUMREG
ENDDO
RETURN
