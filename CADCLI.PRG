******************************************************************************

*****************************/FUN€AO CADASTRO CLIENTES************************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF

CLIENTES()

LS=13
LI=09
CE=21
CD=57

DO WHILE .T.
   ORDSETFOCUS("CODMEDES")
   GOTO TOP
   *INDEX ON CODCLI TO CODMEDES DESCENDING
   PUVARCLI()
   INIVACLI()
   CLEAR GETS
   SETCOLOR("W+/BG,N/W")
   DO WHILE LS#02
      @ LS,CE CLEAR TO LI,CD
      @ LS,CE TO LI,CD DOUBLE
      LS--
      LI++
      CE--
      CD++
      INKEY(0.01)
   ENDDO
   @ 03,23 SAY "³    CADASTRO DE CLIENTES   ³"
   SEEK MCODCLI
   @ 04,14 SAY "CODIGO......:" GET MCODCLI PICT "9999"
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK MCODCLI
   IF FOUND()
        TONE(500,5)
        OL_Yield()
        ALERT('CODIGO JA CADASTRADO !!!')
        LOOP
      ELSEIF MCODCLI <=0
        TONE(500,5)
        OL_Yield()
        ALERT('CODIGO NAO PODE SER IGUAL A ZERO !!!')
        LOOP
   ENDIF
   MTAXA="T"
   MMANDANOTA="N"
   MBLOQUEIO="S"
   MOSTECLI()
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF UPDATED()
        IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
            APPEND BLANK
            REPLCLI()
        ENDIF
   ENDIF
   @ LS+2,CE+2 CLEAR TO LI-2,CD-2
ENDDO
