*****************************/FUN€AO CADASTRO PECAS/**************************
LS=12
LI=12
CE=13
CD=65

DO WHILE .T.
   CLEAR GETS
   SETCOLOR("W+/BG,N/W")
   @ 00,02 CLEAR TO 23,76
   @ 00,02 TO 23,76 DOUBLE
   @ 00,12 SAY "³    CONSULTA DE VENDAS  ³"
   MCODCLI=0
   MNOMECLI=SPACE(35)
   CLIENTES()
   SET KEY -40 TO CONCLI1() // F11
   @ 01,04 SAY "CLIENTE:" GET MCODCLI PICT "9999"
   READ
   IF LASTKEY()=27
        RETURN
   ENDIF
   IF MCODCLI=0
        CONCLI1()
   ENDIF
   ORDSETFOCUS("CODCLI")
   SEEK MCODCLI
   IF FOUND()
        MNOMECLI=NOMECLI
      ELSE
        OL_Yield()
        ALERT('CODIGO NAO ENCONTRADO')
        RETURN.T.
   ENDIF
   @ 01,04 SAY MNOMECLI
   ARQCUPOM=0
   DO WHILE LASTKEY()#27
           @ 07,50 CLEAR TO 07,70
           CUPOM()
           ORDSETFOCUS("NOTCLI")
           DBSEEK(MNOMECLI,.T.,.T.)
           IF NOTCLI#MNOMECLI
                ARQCUPOM++
           ENDIF
           SKIP-ARQCUPOM
           ARQCUPOM++
           MCODNOT=CODNOT
           MDATA=D_NOT
           MHORA=HORANOT
           @ 03,04 SAY MCODNOT
           IF MDATA=DATE()
                SETCOLOR("R*/BG,N/W")
                @03,15 SAY "HOJE"
                SETCOLOR("W+/BG,N/W")
             ELSE
                @ 03,15 SAY MDATA
           ENDIF
           @ 03,27 SAY MHORA
           @ 05,04 SAY REPL ("-",70)
           ENTREGA()
           ORDSETFOCUS("CODIGO")
           SEEK MCODNOT
           IF FOUND()
                SETCOLOR("R*/BG,N/W")
                @ 03,50 SAY "AGUARDANDO LIBERACAO"
                SETCOLOR("W+/BG,N/W")
             ELSE
                ENTR_CLI()
                ORDSETFOCUS("CODIGO")
                SEEK MCODNOT
                IF FOUND()
                        MENTREGA=ENTREGA
                        REL_ENTR()
                        ORDSETFOCUS("CODENTR")
                        SEEK MENTREGA
                        SETCOLOR("R*/BG,N/W")
                        @ 01,50 SAY MOTOBOY
                        @ 02,50 SAY HORA_S
                        @ 03,50 SAY HORA_C
                        SETCOLOR("W+/BG,N/W")
                ENDIF
           ENDIF        
           PEDCUP()
           ORDSETFOCUS("PEDNUM")
           SEEK MCODNOT
           ARQPED=1
           LINHA=06
           DO WHILE PEDNUM=MCODNOT
                MCODPECA=PEDCOD
                MQTD=PEDQTD
                MPRECO=PRECOCUP
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MCODPECA
                MNOMEPECA=NOMEPECA
                @ LINHA,04 SAY MCODPECA
                @ LINHA,10 SAY MNOMEPECA
                @ LINHA,57 SAY MQTD PICT "999"
                @ LINHA,62 SAY MPRECO*MQTD
                PEDCUP()
                ORDSETFOCUS("PEDNUM")
                SEEK MCODNOT
                SKIP+ARQPED
                ARQPED++
                LINHA++
           ENDDO
           INKEY(0)
           @ 06,04 CLEAR TO 22,75
           @ 01,50 clear to 05,75
   ENDDO
ENDDO
