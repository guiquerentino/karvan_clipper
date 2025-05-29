*****************************************************************************

***************************/FUN€AO CONSULTA BOLETOS***************************
IF ACESSO#1
OL_Yield()
    ALERT('ACESSO NAO AUTORIZADO')
    RETURN(.T.)
ENDIF
NOTAS()
ORDSETFOCUS("DATA")
set cent ON
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT ('Nenhum Nota Cadastrada...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
CLS

PRIVATE V1[10], V2[10], V3[10]

V1[01]="NOTA"
V1[02]="VALORCN"
V1[03]="VALORSN"
V1[04]="VALOR_C"
V1[05]="DATA"
V1[06]="DISTRIB"
V1[07]="XML"
V1[08]="RECIBO"
V1[09]="((VALOR_C/(VALORCN+VALORSN)-1))*100"
V1[10]="EMP"

V2[01]="@!"
V2[02]="99,999.99"
V2[03]="99,999.99"
V2[04]="99,999.99"
V2[05]="99/99/99"
V2[06]="@!"
V2[07]="@!"
V2[08]="@!"
V2[09]="999.99%"
V2[10]="@!"

V3[01]="NOTA"
V3[02]="VALOR C/N"
V3[03]="VALOR S/N"
V3[04]="V.VENDA"
V3[05]="DATA"
V3[06]="DISTRIB."
V3[07]="XML"
V3[08]="R"
V3[09]="LUCRO"
V3[10]="EMP"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[01] NOTA [02] DISTRIB [03] RECIBO  [04] SOMA",78)

DBEDIT(01,00,21,79,v1,"CRDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function CRdbedit(modo,coluna)
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

    elseif lastkey()== 65 .OR. lastkey() == 97 .OR. LASTKEY()= -1 && "A"

          SET CURSOR ON
          MNOTA=NOTA
          MDATA=DATA
          MXML=XML
          MRECIBO=RECIBO
          MDISTRIB=DISTRIB
          MVALORCN=VALORCN
          MVALORSN=VALORSN
          MVALOR_C=VALOR_C
          MEMP=EMP
          TELA=SAVESCREEN(02,05,23,74)
          SETCOLOR("W+/BG,N/W")
          @ 04,12 CLEAR TO 19,63
          @ 04,12 TO 19,63 DOUBLE
          @ 05,14 SAY "NOTA:" GET MNOTA PICT "@!" VALID ! EMPTY(MNOTA)
          @ 05,31 SAY "DATA NOTA:" GET MDATA PICT "@D"
          @ 05,53 SAY "R.XML:" GET MRECIBO PICT "@!" VALID MRECIBO $ ("S/N")
          @ 07,14 SAY "DISTRIB.:" GET MDISTRIB PICT "@!"
          @ 09,14 SAY "VALOR_CN:" GET MVALORCN PICT "999,999.99"
          @ 11,14 SAY "VALOR_SN:" GET MVALORSN PICT "999,999.99"
          @ 13,14 SAY "VALOR_V.:" GET MVALOR_C PICT "999,999.99"  
          @ 15,13 SAY "EMPRESA.:" GET MEMP PICT "@!"
          @ 17,13 GET MXML PICT "@!"
          READ
          IF LASTKEY()=27
                   RESTSCREEN(02,05,23,74,TELA)
                   RETURN(1)
          ENDIF
          IF UPDATED()
                IF CONFIRMA ("ALTERA ESSE REGISTRO ?")=1
                   BLOQUEIO()
                   REPLACE NOTA     WITH MNOTA
              	   REPLACE DATA     WITH MDATA
              	   REPLACE XML      WITH MXML
               	   REPLACE RECIBO   WITH MRECIBO
                   REPLACE DISTRIB  WITH MDISTRIB
                   REPLACE VALORCN  WITH MVALORCN
                   REPLACE VALORSN  WITH MVALORSN
                   REPLACE VALOR_C  WITH MVALOR_C
                   REPLACE EMP      WITH MEMP
                   UNLOCK
                ENDIF
          ENDIF
          RESTSCREEN(02,05,22,74,TELA)
          RETURN(2)

	      elseif lastkey()== 49 && "1" 
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("NOTA")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "NOTA...:" GET V_BUSCA PICT "@!"
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
          ORDSETFOCUS("DISTRIB")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "DISTRIB.:" GET V_BUSCA PICT "@!"
          READ
          DBSEEK(V_BUSCA,.F.,.T.)
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
          
        elseif lastkey()== 51 && "3"
          CLEAR GETS
          SET CURSOR ON
          ORDSETFOCUS("RECIBO")
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(15)
          @ 03,20 CLEAR TO 05,48
          @ 03,20 TO 05,48 DOUBLE
          @ 04,22 SAY "RECIBO..:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

        elseif lastkey()== 52 && "4"
                SAVE SCREEN TO TELA
                SET CENT ON
                DINICIO=DATE()
                DFINAL=DATE()
                MCREDOR=SPACE(12)
                @ 04,04 CLEAR TO 17,77
                @ 04,04 TO 17,77 DOUBLE
                @ 06,25 SAY "DATA INICIAL...:" GET DINICIO PICT "@D"       
                @ 08,25 SAY "DATA FINAL.....:" GET DFINAL  PICT "@D" VALID DFINAL >=DINICIO
                SET KEY -40 TO CONFOR1() // F11
                MCREDOR=LEFT(MCREDOR,12)
                READ
                NOTAS()
                IF EMPTY(MCREDOR)
                        INDEX ON DATA TO DATA FOR DATA >=DINICIO .AND. DATA<=DFINAL
                    ELSE
                        INDEX ON DATA TO DATA FOR DATA >=DINICIO .AND. DATA<=DFINAL .AND. MCREDOR=DISTRIB
                ENDIF
                @ 09,12 SAY MCREDOR
                MVALORTOT=0
                MVALOR_C=0
                MVALORSN1=0
                MVALORCN1=0
                MVALORSN2=0
                MVALORCN2=0
                MVALORSN3=0
                MVALORCN3=0

                DO WHILE ! EOF()
                      IF EMP="1" .OR. EMPTY(EMP) 
                              MVALORSN1=MVALORSN1+VALORSN
                              MVALORCN1=MVALORCN1+VALORCN
                      ENDIF
                      IF EMP="2" 
                              MVALORSN2=MVALORSN2+VALORSN
                              MVALORCN2=MVALORCN2+VALORCN
                      ENDIF                      
                      IF EMP="3" 
                              MVALORSN3=MVALORSN3+VALORSN
                              MVALORCN3=MVALORCN3+VALORCN
                      ENDIF                      
                      MVALORTOT=MVALORTOT+VALORSN+VALORCN
                      MVALOR_C=MVALOR_C+VALOR_C
                      SKIP
                ENDDO
                @ 12,05 SAY "C/NOTA 1:"GET MVALORCN1 PICT "99,999,999.99"
                @ 14,05 SAY "S/NOTA 1:"GET MVALORSN1 PICT "99,999,999.99"

                @ 12,29 SAY "C/NOTA 2:"GET MVALORCN2 PICT "99,999,999.99"
                @ 14,29 SAY "S/NOTA 2:"GET MVALORSN2 PICT "99,999,999.99"

                @ 12,53 SAY "C/NOTA 3:"GET MVALORCN3 PICT "99,999,999.99"
                @ 14,53 SAY "S/NOTA 3:"GET MVALORSN3 PICT "99,999,999.99"

                @ 16,10 SAY "COMPRA T:"GET MVALORTOT PICT "99,999,999.99"
                @ 16,36 SAY "VENDA..T:"GET MVALOR_C  PICT "99,999,999.99"
                CLEAR GETS
                INKEY(0)
                REST SCREEN FROM TELA
                RETURN(2)

     ENDIF
ENDIF
RETURN(1)

