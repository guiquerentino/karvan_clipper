******************************************************************************

********************************/FUN€AO RELATORIO FORNECEDOR*******************

OP=4
FORNEC()
ORDSETFOCUS("CODFOR")
*INDEX ON CODFOR TO CODFOR
L=40
TOT=0
GO TOP
PAG=01
Printer()
DO WHILE .NOT. EOF()
   IF LASTKEY()==27
      GO BOTTOM
      EXIT
   ENDIF
   IF L=40
      @ 00,01 SAY PADC("A U T O   P E C A S   K A R V A N",78)
      @ 00,65 SAY "Pag:"
      @ 00,70 SAY PAG PICT "999"
      @ 01,65 SAY DATE()
      @ 02,03 SAY "F O N E - F A X: 6404-2214"
      @ 02,65 SAY TIME()
      @ 04,01 SAY PADC("C O N T R O L E  D E  F O R N E C E D O R E S",78)
      @ 05,03 SAY "========================================================================"
      @ 06,03 SAY "CODIGO"
      @ 06,11 SAY "FORNECEDOR"
      @ 06,34 SAY "VENDEDOR"
      @ 06,52 SAY "TEL.FORNECEDOR"
      @ 07,03 SAY "========================================================================"
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
   @ L,04 SAY CODFOR   PICT "999"
   @ L,11 SAY NOMEFOR  PICT "@!"
   @ L,34 SAY VENDEDOR PICT "@!"
   @ L,52 SAY TELFOR   PICT "9999-9999"
   L++
   TOT++
   SKIP
   IF L=40
      @ L+1,03 SAY "========================================================================"
      @ L+2,05 SAY "Proxima folha !!!!"
      PAG++
   ENDIF
ENDDO
@ L+1,03 SAY "========================================================================"
@ L+2,05 SAY "Total de Fornecedores:"
@ L+2,29 SAY TOT PICT "999"
@ L+3,03 SAY "========================================================================"
EJECT
SET DEVICE TO SCREEN
RETURN(.T.)
