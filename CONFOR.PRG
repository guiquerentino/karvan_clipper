******************************************************************************

*****************************/FUN€AO CONSULTA FORNECEDORES********************

OP=3
FORNEC()
IF EOF()
OL_Yield()
   ALERT ('Nenhum Fornecedor Cadastrado...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
PRIVATE V1[7], V2[7], V3[7]
V1[01]="CODFOR"
V1[02]="NOMEFOR"
V1[03]="VENDEDOR"
V1[04]="CELVEN"
V1[05]="TELFOR"


V2[01]="999"
V2[02]="@!"
V2[03]="@!"
V2[04]="99999-9999"
V2[05]="9999-9999"

V3[01]="CODIGO"
V3[02]="FORNECEDOR"
V3[03]="VENDEDOR"
V3[04]="CEL.VENDEDOR"
V3[05]="TEL.FORNECEDOR"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [DEL] EXCLUSAO [ENTER] SELECIONA [1] VENDEDOR [2] DISTRIBUIDOR",78)

DBEDIT(01,00,21,79,v1,"EDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function Edbedit(modo,coluna)
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

       elseif lastkey()== 65 .OR. lastkey() == 97 .OR. LASTKEY()= -1 && "A"
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 02,09 CLEAR TO 22,70
          @ 02,09 TO 22,70 DOUBLE
          @ 02,24 SAY "ALTERA FORNECEDORES"
          PUVARFOR()
          IGUAVAFOR()
          @ 03,13 SAY "Codigo.........:"  GET MCODFOR PICT "999"
          CLEAR GETS
          MOSTEFOR()
          READ
          IF UPDATED()
              IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
                  REPLFOR()
              ENDIF
          ENDIF
          RETURN(2)

	ELSEIF LASTKEY()== 13 
          SETCOLOR("W+/BG,N/W")
          @ 02,09 CLEAR TO 22,70
          @ 02,09 TO 22,70 DOUBLE
          @ 02,22 SAY "CONSULTA FORNECEDORES"
          PUVARFOR()
          IGUAVAFOR()
          @ 03,13 SAY "Codigo.........:"  GET MCODFOR PICT "999"
          MOSTEFOR()
          INKEY(0)    
          RETURN(2)

    elseif lastkey()== 07 && "DELETE"
          IF ACESSO#1
          OL_Yield()
              ALERT('ACESSO NAO AUTORIZADO')
              RETURN(1)
          ENDIF
          SET CURSOR ON
          SETCOLOR("W+/BG,N/W")
          @ 02,09 CLEAR TO 22,70
          @ 02,09 TO 22,70 DOUBLE
          @ 02,22 SAY "DELETA FORNECEDORES"
          PUVARFOR()
          IGUAVAFOR()
          @ 03,13 SAY "Codigo.........:"  GET MCODFOR PICT "999"
          MOSTEFOR()
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
	      RETURN(2)

    elseif lastkey()== 51 && "1" 
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	      SET CURSOR ON
          ORDSETFOCUS("CODFOR")
          *SET INDEX TO CODFOR
          SET SOFTSEEK ON
	      V_BUSCA:=0
          @ 03,20 CLEAR TO 05,36
          @ 03,20 TO 05,36 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "99999"
	      READ
	      SEEK V_BUSCA
	      IF EOF()
              SKIP-1
              RETURN(1)
	      ENDIF
	      RETURN(2)


	elseif lastkey()== 50 && "2"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
          SET CURSOR ON
          ORDSETFOCUS("NOMEFOR")
          SET SOFTSEEK ON
	      V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,60
          @ 03,20 TO 05,60 DOUBLE
          @ 04,22 SAY "NOME FORNECEDOR:" GET V_BUSCA PICT "@!"
          READ
          IF EMPTY(V_BUSCA)
                ORDSETFOCUS("NOMEFOR")
              ELSE
                INDEX ON NOMEFOR TO TEMP FOR RTRIM(V_BUSCA) $ NOMEFOR
          ENDIF
          IF EOF()
              SKIP-1
              RETURN(1)
	     ENDIF
	     RETURN(2)
    elseif lastkey()== 49 && "3"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	      SET CURSOR ON
          ORDSETFOCUS("VENDEDOR")
          *SET INDEX TO VENDEDOR
          SET SOFTSEEK ON
	      V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,53
          @ 03,20 TO 05,53 DOUBLE
          @ 04,22 SAY "VENDEDOR:" GET V_BUSCA PICT "@!"
	      READ
	      SEEK V_BUSCA
	      IF EOF()
              SKIP-1
              RETURN(1)
	     ENDIF
	     RETURN(2)
        elseif lastkey()== 48 && "4"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
          SET CURSOR ON
          ORDSETFOCUS("FORNECEDOR")
          SET SOFTSEEK ON
	      V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,60
          @ 03,20 TO 05,60 DOUBLE
          @ 04,22 SAY "NOME FORNECEDOR:" GET V_BUSCA PICT "@!"
          READ
          IF EMPTY(V_BUSCA)
                ORDSETFOCUS("FORNECEDOR")
              ELSE
                INDEX ON FORNECEDOR TO TEMP FOR RTRIM(V_BUSCA) $ FORNECEDOR
          ENDIF
          IF EOF()
              SKIP-1
              RETURN(1)
	     ENDIF
	     RETURN(2)

      ENDIF
ENDIF
RETURN(1)
