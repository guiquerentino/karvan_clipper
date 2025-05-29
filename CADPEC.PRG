*****************************/FUN€AO CADASTRO PECAS/**************************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF

LS=12
LI=12
CE=13
CD=65

PECAS()

DO WHILE .T.
   MCAD=1
   PUVARPE()
   INIVARPE()
   CLEAR GETS
   SETCOLOR("W+/BG,N/W")
   DO WHILE LS#00
      @ LS,CE CLEAR TO LI,CD
      @ LS,CE TO LI,CD DOUBLE
      LS--
      LI++
      CE--
      CD++
      INKEY(0.01)
   ENDDO
   @ 00,02 CLEAR TO 23,76
   @ 00,02 TO 23,76 DOUBLE
   @ 00,12 SAY "³    CADASTRO DE PE€AS   ³"
   ORDSETFOCUS("CODPECA")
   BUSCANUMERO()
   MCODPECA=STRZERO(N1,5)
   @ 01,04 SAY "Codigo:" GET MCODPECA PICT "@!"
   READ
   @ 01,17 SAY "-" + MDIGITO
   IF LASTKEY()=27
           EXIT
   ENDIF
   IF MCODPECA=" "
           TONE(500,5)
           OL_Yield()
           ALERT ('CODIGO NAO PODE SER IGUAL A ZERO !!!')
           LOOP
   ENDIF
   SEEK MCODPECA
   IF FOUND()
           TONE(500,5)
           OL_Yield()
           ALERT ('CODIGO JA EXISTE !!!')
           LOOP
   ENDIF
   DO WHILE .T.
              MOSTEXPE()
              READ
              IF EMPTY(MFABRIC)
              OL_Yield()
                    ALERT('VALOR FABRICANTE INVALIDO')
                    LOOP
              ENDIF
              IF EMPTY(MTEMPUNI)
              OL_Yield()
                        ALERT('VALOR UNIDADE INVALIDO')
                        LOOP
              ENDIF
              IF EMPTY(MNFABRIC)
              OL_Yield()
                    ALERT('VALOR N§ FABRICANTE INVALIDO')
                    LOOP
              ENDIF
              IF EMPTY(MNOMEPECA)
              OL_Yield()
                    ALERT('VALOR DESCRI€AO INVALIDO')
                    LOOP
              ENDIF
              IF EMPTY(MNCM)
              OL_Yield()
                    ALERT('CODIGO NCM/SH INVALIDO')
                    LOOP
              ENDIF
              IF EMPTY(MUNIDADE)
              OL_Yield()
                    ALERT('VALOR UNIDADE INVALIDO')
                    LOOP
              ENDIF
              IF ! EMPTY(MCODBARRA)
                      ORDSETFOCUS("CODBARRA")
                      SEEK MCODBARRA
                      IF FOUND()
                      OL_Yield()
                            ALERT('CODIGO BARRA JA EXISTE')
                            LOOP
                      ENDIF
              ENDIF
              EXIT
   ENDDO
   IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
           ORDSETFOCUS("CODPECA")
           SEEK MCODPECA
           IF FOUND()
           OL_Yield()
                   ALERT ('CODIGO JA EXISTE, E TROCADO POR OUTO !!!')
                   BUSCANUMERO()
                   MCODPECA=STRZERO(N1,5)
           ENDIF
           BLOQUEIO() 
           APPEND BLANK
           MQTDMIN=999
           REPLPEC()
           DBCOMMIT()
           UNLOCK
   ENDIF
   @ 02,05 CLEAR TO 22,71
   RETURN(.T.)
ENDDO
