******************************************************************************

*****************************/FUN€AO CADASTRO FORNECEDORES********************
IF ACESSO#1
OL_Yield()
      ALERT('ACESSO NAO AUTORIZADO')
      RETURN
ENDIF
FORNEC()
LS=18
LI=10
CE=17
CD=61

DO WHILE .T.
   ORDSETFOCUS("CODFODES")
   *INDEX ON CODFOR TO CODFODES DESCENDING
   PUVARFOR()
   INIVAFOR()
   CLEAR GETS
   SETCOLOR("W+/BG,N/W")
   @ 02,09 CLEAR TO 22,70
   @ 02,09 TO 22,70 DOUBLE
   @ 02,25 SAY "³  CADASTRO DE FORNECEDORES  ³"
   SEEK MCODFOR
   @ 03,13 SAY "Codigo.........:"  GET MCODFOR PICT "999"
   READ
   IF LASTKEY()=27
        EXIT
     ELSEIF MCODFOR=0 
        TONE(500,5)
        OL_Yield()
        ALERT ('CODIGO NAO PODE SER IGUAL A ZERO')
        LOOP
     ELSEIF FOUND()
        TONE(500,5)
        OL_Yield()
        ALERT ('CODIGO JA CADASTRADO')
        LOOP
   ENDIF
   MOSTEFOR()
   READ
   IF UPDATED()
       IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
           APPEND BLANK
           REPLFOR()
       ENDIF
   ENDIF
ENDDO
