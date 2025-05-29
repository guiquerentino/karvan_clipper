******************************************************************************

******************************FUNCAO RELATORIO CUPOM**************************

OP=4
CUPOM()
ORDSETFOCUS("CODNOT")
*INDEX ON CODNOT TO CODNOT
L=55
TOT=0
GO TOP
PAG=01
DO WHILE .NOT. EOF()
   IF LASTKEY()==27
      GO BOTTOM
      EXIT
   ENDIF
   Printer()
   IF L=55
      @ 00,01 SAY PADC("A U T O   P E C A S   K A R V A N",78)
      @ 00,65 SAY "Pag:"
      @ 00,70 SAY PAG PICT "999"
      @ 01,65 SAY DATE()
      @ 02,03 SAY "F O N E - F A X: 6404-2214"
      @ 02,65 SAY TIME()
      @ 04,01 SAY PADC("C O N T R O L E   D E   N O T A S   F I S C A I S",78)
      @ 05,02 SAY "=============================================================================="
      @ 06,02 SAY "N§ CUPOM"
      @ 06,14 SAY "CLIENTE"
      @ 06,52 SAY "TIPO PAG."
      @ 06,68 SAY "TOTAL CUPOM"
      @ 07,02 SAY "=============================================================================="
      L=08
   ENDIF
   SET DEVICE TO SCREEN
   SETCOLOR("W+/R")
   @10,29 CLEAR TO 14,52
   @10,29 TO 14,52 DOUBLE
   @12,33 SAY "Imprimindo..."
   @12,47 SAY "|"
   INKEY(0.1)
   @12,47 SAY "/"
   INKEY(0.1)
   @12,47 SAY "-"
   INKEY(0.1)
   @12,47 SAY "\"
   INKEY(0.1)
   Printer()
   @ L,02 SAY CODNOT PICT "999999"
   @ L,14 SAY NOTCLI PICT "@!"
   @ L,52 SAY NOTPAG PICT "@!"
   @ L,65 SAY NOTTOTG PICT "999999.99"
   L++
   TOT++
   SKIP
   IF L=40
      @ L+1,03 SAY "============================================================================="
      @ L+2,05 SAY "Proxima folha !!!!"
      PAG++
   ENDIF
ENDDO
@ L+1,03 SAY "============================================================================="
@ L+2,05 SAY "Total de cupom emitidos:"
@ L+2,30 SAY TOT PICT "99999999"
@ L+3,03 SAY "============================================================================="
EJECT
SET DEVICE TO SCREEN
RETURN(.T.)
