******************************************************************************
   
**********************************/FUN€AO C_PECA\*****************************

FUNCTION C_PECAS

SELE 1
CUPOM()
ORDSETFOCUS("CODNOT")
NUMREG=LASTREC()
SELE 2
PEDCUP()
ORDSETFOCUS("PEDNUM")
SELE 3
USE PEDIDO
LIN1=01
SELE 1
GOTO NUMREG
DO WHILE ! EOF()
        MCODNOT=CODNOT
        SELE 2
        ORDSETFOCUS("PEDNUM")
        SEEK MCODNOT
        IF ! FOUND()
                SELE 3
                APPEND BLANK
                REPLACE PNFABRIC WITH MCODNOT
        ENDIF
        NUMREG--
        SELE 1
        GOTO NUMREG
        @01,01 SAY MCODNOT
ENDDO
RETURN
