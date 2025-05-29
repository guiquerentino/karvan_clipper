*****************************************************************************

***************************/FUN€AO CONSULTA BOLETOS***************************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF
BAIXA()
ORDSETFOCUS("BCODNOT")
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT ('Nenhum Cupom Cadastrado...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
CLS

PRIVATE V1[06], V2[06], V3[06]

V1[01]="BCODNOT"
V1[02]="BCLIENTE"
V1[03]="BVALOR"
V1[04]="BDATA"
V1[05]="BFUNC"
V1[06]="FORMPAG"

V2[01]="999999999"
V2[02]="@!"
V2[03]="999,999.99"
V2[04]="99/99/99"
V2[05]="@!"
V2[06]="@!"

V3[01]="CUPOM"
V3[02]="CLIENTE"
V3[03]="VALOR"
V3[04]="DATA"
V3[05]="FUNCIONARIO"
V3[06]="FORMA PAG."

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[01] CUPOM [02] CLIENTE [03] FUNCIONARIO ",78)

DBEDIT(01,00,21,79,v1,"RDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Rdbedit(modo,coluna)
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

     elseif lastkey()== 07 && "DELETE"
          SET CURSOR ON
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
          RETURN(2)


     elseif lastkey()== 49 && "1" 
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("BCODNOT")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "CUPOM..:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 50 && "2"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("BCLIENTE")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          @ 03,10 CLEAR TO 05,56
          @ 03,10 TO 05,56 DOUBLE
          @ 04,12 SAY "CLIENTE:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
          
        elseif lastkey()== 51 && "3"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("BFUNC")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,53
          @ 03,20 TO 05,53 DOUBLE
          @ 04,22 SAY "FUNCIONARIO..:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)                             
     ENDIF
ENDIF
RETURN(1)

