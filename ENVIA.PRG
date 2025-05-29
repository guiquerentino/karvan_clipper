******************************************************************************

*****************************/CONSULTA PEDIDOS ASSINADOS E ENVIADOS***********
SET CENTURY ON
OP=3
ENVIADOS()
MCODNOT=CODNOT
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhuma pendencia ate o momento...')
   RETURN(0)
ENDIF


*SETCOLOR("R/B+")
SETCOLOR("W+/R,N/W")

PRIVATE V1[09], V2[09], V3[09]
V1[01]="CODNOT"
V1[08]="NOTPAG"
V1[02]="NOTCLI"
V1[09]="NOTFUNC"
V1[04]="TROCO"
V1[05]="NOTTOTG"
V1[03]="NOTDESC"
V1[06]="MOTOCA"
V1[07]="D_NOT"


V2[01]="999999999"
V2[08]="@!"   
V2[02]="@!"
V2[09]="@!"
V2[04]="999.99"
V2[05]="9999,999.99"   
V2[03]="9999,999.99"
V2[06]="@!"
V2[07]="99/99/9999"

V3[01]="N§ CUPOM"
V3[08]="NOME CLIENTE"
V3[02]="FORMA"
V3[09]="FUNC."
V3[04]="TROCO"
V3[05]="VALOR"
V3[03]="VALOR DESC."
V3[06]="MOTOCA"
V3[07]="DATA"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[1] CODIGO [2] NOME CLIENTE [3] FUNCIONARIO [4] MOTOCA",78)

DBEDIT(01,00,21,79,v1,"XXBEDIT ", v2, v3,chr(205),space(1)+chr(179))


function XXbedit(modo,coluna)
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
          ENVIADOS()

       ELSEIF LASTKEY()= 13 && "ENTER"

          SETCOLOR("W+/BG,N/W")
          PUVARENV()
          IGUAVAENV()
          @ 03,07 CLEAR TO 15,67
          @ 03,07 TO 15,67 DOUBLE
          @ 03,11 SAY "CONSULTA ENVIADAS"
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          CLEAR GETS
          MOSTEENV()
          INKEY(0)
          RETURN(2)

       elseif lastkey()== 65 .OR. lastkey() == 97 && "A/a"

          SETCOLOR("W+/BG,N/W")
          PUVARENV()
          IGUAVAENV()
          @ 03,07 CLEAR TO 15,67
          @ 03,07 TO 15,67 DOUBLE
          @ 03,11 SAY "CONSULTA ENVIADAS"
          @ 05,12 SAY "N§ NOTA.....:" GET MCODNOT   PICT "999999999"
          MOSTEENV()
          READ
          IF UPDATED()
                IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                     REPLENV()
                ENDIF
          ENDIF             
          RETURN(2)

    elseif lastkey()== 07 && "DELETE"
          
          SETCOLOR("W+/BG,N/W")
          PUVARENV()
          IGUAVAENV()
          @ 03,07 CLEAR TO 15,67
          @ 03,07 TO 15,67 DOUBLE
          @ 03,11 SAY "DELETA CANHOTO"
          CLEAR GETS
          MOSTEENV()
          IF CONFIRMA ("DELETA ESSE CANHOTO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
          RETURN(2)

       elseif lastkey()== 49 && "1"

          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=0
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,40
          @ 03,20 TO 05,40 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
	  READ
	  SEEK V_BUSCA
	  IF EOF()
             SKIP-1
             RETURN(1)
	  ENDIF
	  RETURN(2)

    elseif lastkey()== 50 && "2"

          MCODCLI=0
          MNOMECLI=SPACE(35)
          CLIENTES()
          SET KEY -40 TO CONCLI1() // F11
          @ 17,10 CLEAR TO 19,25
          @ 17,10 TO 19,25 DOUBLE
          @ 18,12 SAY "CLIENTE:" GET MCODCLI PICT "9999"
          READ
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
          ENDIF
          ENVIADOS()
          ORDSETFOCUS("NOTCLI")
          DBSEEK(MNOMECLI,.T.,.T.)
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)
                 
    elseif lastkey()== 51 && "3"

          ORDSETFOCUS("NOTFUNC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,55
          @ 03,20 TO 05,55 DOUBLE
          @ 04,22 SAY "FUNCIONARIO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)
     
       elseif lastkey()== 52 && "4"

          ORDSETFOCUS("MOTOCA")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,41
          @ 03,20 TO 05,41 DOUBLE
          @ 04,22 SAY "Motoca:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
             SKIP-1
             RETURN(1)
          ENDIF
          RETURN(2)

      elseif lastkey()== 82 .OR. lastkey() == 114 && "R/r"

          SET DELE OFF
          ORDSETFOCUS("CODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=MCODNOT
          SET CURSOR ON
          CLEAR GETS
          @ 03,20 CLEAR TO 05,40
          @ 03,20 TO 05,40 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
	  READ
	  SEEK V_BUSCA
          IF ! FOUND()
             ALERT("PEDIDO NAO ENCONTRADO")
             SET DELE ON
             RETURN(2)
	  ENDIF
          BLOQUEIO()
          RECALL
          UNLOCK
          ALERT("PEDIDO RECUPERADO")
          SET DELE ON
          RETURN(2)

      elseif lastkey()== 66 .OR. lastkey() == 98 && "B/b"

          BLOQUEIO()
          PUVARENV()
          IGUAVAENV()
          DELETE
          UNLOCK
          RETURN(2)

       elseif lastkey()== 286  && "ALT+A"

          CLEAR GETS
          NUNREG=RECNO()
          BLOQUEIO()
          PUVARENV()
          IGUAVAENV()
          DELETE
          UNLOCK          
          CUPOM()
          ORDSETFOCUS("CODNOT")
          SEEK MCODNOT
          BLOQUEIO()
          REPLACE NOTPAG  WITH "ASSINAR"
          REPLACE ALTFUNC WITH FUNCIONARIO
          REPLACE DATAULT WITH DATE()
          REPLACE HORAULT WITH TIME()
          UNLOCK
          ENVIADOS()
          GOTO NUNREG
          RETURN(2)

      elseif lastkey()== 84 .OR. lastkey() == 116 && "T/t"

          MTROCO=0
          @ 18,20 CLEAR TO 20,41
          @ 18,20 TO 20,41 DOUBLE
          @ 19,22 SAY "VALOR TOTAL:"
          ENVIADOS()
          DO WHILE ! EOF()
                MTROCO=MTROCO+TROCO
                @ 19,35 SAY MTROCO PICT "999.99"
                SKIP
          ENDDO
          INKEY(0)
          RETURN(2)

      ENDIF
     ENDIF
RETURN(1)

