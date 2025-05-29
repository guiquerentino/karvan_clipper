****************************************************************************

*****************************/FUN€AO ENTRADA DE NOTAS***********************
SET CENTURY ON
CONFEREX()
*USE D:\KARVAN\CONFERE\CONFERE EXCLUSIVE
*DO WHILE NETERR()
*        SETCOLOR("W+/R*,N/W")
*        OL_Yield()
*        ALERT ('AGUARDE, ARQUIVOS ABERTOS')
*        CLOSE ALL
*        USE D:\KARVAN\CONFERE\CONFERE EXCLUSIVE
*ENDDO   

CLOSE INDEXES
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhuma entrada de Notas ate o momento...')
   RETURN(0)
ENDIF

SETCOLOR("GR/B+")
PRIVATE V1[5], V2[5], V3[5]
V1[01]="CFUNC"
V1[02]="CDISTRIB"
V1[03]="CDATA"
V1[04]="CCODNOT"
V1[05]="FECHA"

V2[01]="@!"
V2[02]="@!"
V2[03]="99/99/9999"
V2[04]="999999999999"
V2[05]="@!"

V3[01]="FUNCIONARIO"
V3[02]="DISTRIBUIDOR"
V3[03]="DATA"
V3[04]="NOTA"
V3[05]="FECHA"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE


DBEDIT(01,00,21,79,v1,"ZDBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function ZDBEDIT(modo,coluna)
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
       ENDIF
ENDIF
RETURN(1)
