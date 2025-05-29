******************************************************************************

*****************************/FUN€AO CADASTRO CHEQUE**************************
LS=11
LI=11
CE=14
CD=65
MCODCLI=0
DO WHILE .T.
   OK:=.f.
   PUVARCHE()
   INIVACHE()
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
   @ 03,27 SAY "³    CADASTRO DE CHEQUE   ³"
   SET KEY -40 TO CONCLI1() // F11
   @ 05,13 SAY "CLIENTE....:" GET MCODCLI PICT "9999"
   READ
   IF LASTKEY()=27
          RETURN(.T.)
   ENDIF       
   IF MCODCLI=0
        CONCLI1()
   ENDIF
   CLIENTES()
   ORDSETFOCUS("CODCLI")
   SEEK MCODCLI
   IF ! FOUND()
   OL_Yield()
        ALERT('CLIENTE NAO CADASTRADO')
        DO CADCHE
      ELSE
        MCLIENTE=NOMECLI
        @ 05,26 SAY MCLIENTE
   ENDIF
   SET KEY -40 TO OTARIOS() // F11

   DO WHILE OK=.f.
            @ 07,13 SAY "CPF/CNPJ...:" GET MCPF PICT "999999999999999999"
             READ
             CONT=LEN(ALLTRIM(MCPF))
             IF LASTKEY()=27
                  EXIT                  
              ENDIF
              IF CONT=11
                    CNPJ=MCPF
                    TESTA_CPF()
                  ELSE
                    CNPJ=MCPF
                    TESTA_CNPJ()
              ENDIF
   ENDDO       
   CHEQUE()
   ORDSETFOCUS("CPF")
   SEEK MCPF
   IF FOUND()
       MNOME=NOME
   ENDIF
   IF LASTKEY()=27
        RETURN(.T.)
   ENDIF
   @ 07,13 SAY "NOME.......:" GET MNOME   PICT "@!"
   @ 09,13 SAY "DATA DEPOS.:" GET MDATA_D PICT "@D"
   @ 11,13 SAY "VALOR......:" GET MVALOR  PICT "99999.99"
   READ
   MDATA_R=DATE()
   IF UPDATED()
        IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
           APPEND BLANK
           REPLCHE()
        ENDIF
   ENDIF
   @ 04,07 CLEAR TO 18,72
ENDDO
DO CADCHE
