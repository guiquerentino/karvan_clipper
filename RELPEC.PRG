******************************************************************************

********************************/FUN€AO RELATORIO PECAS\************************

OP=4
PECAS()
ORDSETFOCUS("NOMEPECA")
*INDEX ON NOMEPECA TO NOMEPECA
L=62
TOT=0
NUMREG=1
GO TOP
PAG=01
DO WHILE .NOT. EOF()
   IF LASTKEY()==27
      GO BOTTOM
      EXIT
   ENDIF
   Printer()
   IF L=62
      @ 00,01 SAY PADC("A U T O   P E C A S   K A R V A N",78)
      @ 00,65 SAY "Pag:"
      @ 00,70 SAY PAG PICT "999"
      @ 01,65 SAY DATE()
      @ 02,03 SAY "F O N E - F A X: 6404-2214"
      @ 02,65 SAY TIME()
      @ 04,01 SAY PADC("C O N T R O L E   D E   P E C A S",78)
      @ 05,01 SAY "============================================================================"
      @ 06,01 SAY "CODIGO"
      @ 06,09 SAY "DESCRICAO"
      @ 06,42 SAY "PRECO"
      @ 06,49 SAY "FABRICANTE"
      @ 06,66 SAY "N§ FABRIC."
      @ 07,01 SAY "============================================================================"
      L=08
   ENDIF
   SET DEVICE TO SCREEN
   SETCOLOR("W+/R")
   @ 10,29 CLEAR TO 15,52
   @ 10,29 TO 15,52 DOUBLE
   @ 12,33 SAY "Imprimindo..."
   @ 12,47 SAY "|"
   INKEY(0.01)
   @ 12,47 SAY "/"
   INKEY(0.01)
   @ 12,47 SAY "-"
   INKEY(0.01)
   @ 12,47 SAY "\"
   INKEY(0.01)
   @ 13,33 SAY "ITEM.....:" 
   @ 13,44 SAY NUMREG PICT "9999"
   Printer()
   @ L,01 SAY CODPECA PICT "@!"
   @ L,09 SAY NOMEPECA PICT "@!"
   @ L,42 SAY PRECO PICT "999.99"
   @ L,49 SAY FABRIC PICT "@!"
   @ L,66 SAY NFABRIC PICT "@!"
   @ L,07 SAY "³"
   @ L,40 SAY "³"
   @ L,48 SAY "³"
   @ L,65 SAY "³"
   INKEY(0)
   L++
   TOT++
   NUMREG++
   SKIP
   IF L=61
      @ L+1,01 SAY "============================================================================"
      @ L+2,05 SAY "Proxima folha !!!!"
      PAG++
   ENDIF
ENDDO
@ L+1,01 SAY "============================================================================"
@ L+2,05 SAY "Total de pecas:"
@ L+2,23 SAY TOT PICT "9999999"
@ L+3,01 SAY "============================================================================"
EJECT
SET DEVICE TO SCREEN
RETURN(.T.)

