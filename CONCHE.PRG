******************************************************************************

*****************************/FUN€AO CONSULTA CHEQUE********************

OP=3
CHEQUE()
IF EOF()
OL_Yield()
   ALERT ('Nenhum Cheque Cadastrado...')
   RETURN(0)
ENDIF
MVALOR=0
SETCOLOR("GR/B+")
PRIVATE V1[5], V2[5], V3[5]
V1[01]="CLIENTE"
V1[02]="NOME"
V1[03]="DATA_D"
V1[04]="DATA_R"
V1[05]="VALOR"


V2[01]="@!"
V2[02]="@!"
V2[03]="99/99/99"
V2[04]="99/99/99"
V2[05]="99999.99"

V3[01]="CLIENTE"
V3[02]="NOME"
V3[03]="D_DEPOS."
V3[04]="D_RECEB."
V3[05]="VALOR"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[A] ALTERA€AO [DEL] EXCLUSAO [ENTER] SELECIONA [1] CLIENTE [2] CPF",78)

DBEDIT(01,00,21,79,v1,"ZZDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function ZZdbedit(modo,coluna)
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

       elseif lastkey()== 65 .OR. lastkey() == 97 && "A/a"
          
          CLEAR GETS
          MOSTEXCHE()
          @ 05,22 SAY "ALTERA CHEQUE"
          READ
          IF UPDATED()
              IF CONFIRMA ("GRAVA ESSE REGISTRO ?")=1
                  REPLCHE()
              ENDIF
          ENDIF
          RETURN(2)

	ELSEIF LASTKEY()== 13 
          
          MOSTEXCHE()
          INKEY(0)
          RETURN(2)

    elseif lastkey()== 07 && "DELETE"
          
          CLEAR GETS
          MOSTEXCHE()
          @ 05,22 SAY "DELETA CHEQUE"
          IF CONFIRMA ("DELETA ESSE REGISTRO ?")=1
              BLOQUEIO()
              DELETE
              UNLOCK
          ENDIF
  	      RETURN(2)

    elseif lastkey()== 49 && "1" 
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          SET SOFTSEEK ON
  	      V_BUSCA:=0
          @ 03,20 CLEAR TO 05,36
          @ 03,20 TO 05,36 DOUBLE
          @ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "9999"
	        READ
	        CLIENTES()
          ORDSETFOCUS("CODCLI")
          SEEK V_BUSCA
	        IF ! FOUND()
          OL_Yield()
                  ALERT('CLIENTE NAO CADASTRADO')
                  CHEQUE()
                  RETURN
               ELSE
                  MCLIENTE=NOMECLI
          ENDIF
          CHEQUE()
          ORDSETFOCUS("CLIENTE")
          SEEK MCLIENTE           
          IF EOF()
              SKIP-1
              RETURN(1)
	      ENDIF
	      RETURN(2)      

	elseif lastkey()== 50 && "2"
          
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          SET SOFTSEEK ON
	        V_BUSCA:=SPACE(35)
          @ 03,10 CLEAR TO 05,62
          @ 03,10 TO 05,62 DOUBLE
          @ 04,12 SAY "NOME CHEQUE:" GET V_BUSCA PICT "@!"
	        READ
	        INDEX ON NOME TO TEMP FOR RTRIM(V_BUSCA) $ NOME 
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)
          
    elseif lastkey()== 51 && "3"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          ORDSETFOCUS("CPF")
          SET SOFTSEEK ON
   	      V_BUSCA:=SPACE(18)
          @ 03,20 CLEAR TO 05,53
          @ 03,20 TO 05,53 DOUBLE
          @ 04,22 SAY "CPF / CNPJ:" GET V_BUSCA PICT "@!"
	        READ
	        SEEK V_BUSCA
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)
    elseif lastkey()== 52 && "4"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          ORDSETFOCUS("DATA_R")
          SET SOFTSEEK ON
          SET CENT ON
   	      V_BUSCA:=DATE()
          @ 03,20 CLEAR TO 05,51
          @ 03,20 TO 05,51 DOUBLE
          @ 04,22 SAY "DATA RECEBIMENTO:" GET V_BUSCA PICT "@D"
	        READ
	        SEEK V_BUSCA
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)

    elseif lastkey()== 53 && "5"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          ORDSETFOCUS("DATA_D")
          SET SOFTSEEK ON
   	      SET CENT ON
          V_BUSCA:=DATE()
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "DATA DEPOSITO:" GET V_BUSCA PICT "@D"
	        READ
	        SEEK V_BUSCA
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)

    elseif lastkey()== 54 && "6"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          ORDSETFOCUS("VALOR")
          SET SOFTSEEK ON
   	      V_BUSCA:=0
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "VALOR CHEQUE:" GET V_BUSCA PICT "99999.00"
	        READ
	        SEEK V_BUSCA
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)
    elseif lastkey()== 55 && "7"
          CLEAR GETS
          SETCOLOR("W+/BG,N/W")
	        SET CURSOR ON
          ORDSETFOCUS("OBS")
          SET SOFTSEEK ON
   	      V_BUSCA:=SPACE(20)
          @ 03,20 CLEAR TO 05,55
          @ 03,20 TO 05,55 DOUBLE
          @ 04,22 SAY "OBSERVACAO:" GET V_BUSCA PICT "@!"
	        READ
	        SEEK V_BUSCA
	        IF EOF()
                SKIP-1
                RETURN(1)
	        ENDIF
	        RETURN(2)
    elseif lastkey()== 56 && "8"
          CLEAR GETS
          SAVE SCREEN TO TELA
          SET CENT ON
          DINICIO=DATE()
          DFINAL=DATE()
          @ 04,10 CLEAR TO 12,40
          @ 04,10 TO 12,40 DOUBLE
          @ 04,14 SAY " DATA DEPOSITO "
          @ 06,12 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
          @ 08,12 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
          READ                
          INDEX ON DATA_D TO DATA_D FOR DATA_D>=DINICIO .AND. DATA_D<=DFINAL
          MVALOR=0
          DO WHILE ! EOF()
                  MVALOR=MVALOR+VALOR
                  SKIP
          ENDDO
          @ 10,12 SAY "VALOR DEPOSITO:" GET MVALOR PICT "99,999.99"
          INKEY(0)
          ORDSETFOCUS("VALOR")
	        RETURN(2)

    elseif lastkey()== 57 && "9"
          CLEAR GETS
          SAVE SCREEN TO TELA
          SET CENT ON
          DINICIO=DATE()
          DFINAL=DATE()
          @ 04,10 CLEAR TO 12,40
          @ 04,10 TO 12,40 DOUBLE
          @ 04,14 SAY " DATA RECEBIDO "
          @ 06,12 SAY "DATA INICIAL:" GET DINICIO PICT "@D" VALID DINICIO <=DATE()
          @ 08,12 SAY "DATA FINAL..:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
          READ                
          INDEX ON DATA_R TO DATA_R FOR DATA_R>=DINICIO .AND. DATA_R<=DFINAL
          MVALOR=0
          DO WHILE ! EOF()
                  MVALOR=MVALOR+VALOR
                  SKIP
          ENDDO
          @ 10,12 SAY "VALOR RECEBIDO:" GET MVALOR PICT "99,999.99"
          INKEY(0)
          ORDSETFOCUS("VALOR")
	        RETURN(2)

      ENDIF
ENDIF
RETURN(1)
