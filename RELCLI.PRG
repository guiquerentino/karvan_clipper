******************************************************************************

********************************/FUN€AO RELATORIO CLIENTES*********************

OP=4
TOT=0
L=01
CLIENTES()
ORDSETFOCUS("NOMECLI")
GO TOP
Printer()
DO WHILE .NOT. EOF()
   IF LASTKEY()==27
      GO BOTTOM
      EXIT
   ENDIF   
   @ L,03 SAY NOMECLI PICT "@!"
   L++
   @ L,03 SAY ENDCLI PICT "@!"
   TOT++
   L++
   SKIP
ENDDO
SET DEVICE TO SCREEN
RETURN(.T.)
