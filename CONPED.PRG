**************************************************************************

*****************************/FUN€AO CONSULTA PEDIDOS/COMPRAS*************

OP=3
USE D:\KARVAN\PEDIDO\PEDIDO SHARED
IF EOF()
OL_Yield()
   ALERT ('Nenhum pedido Cadastrado...')
   RETURN(0)
ENDIF
SETCOLOR("GR/B+")
PRIVATE V1[4], V2[4], V3[4]
V1[01]="ccodnot"
V1[02]="CDISTRIB"
V1[03]="CDATA"
V1[04]="CFUNC"


V2[01]="999999999"
V2[02]="@!"
V2[03]="99/99/9999"
V2[04]="@!"

V3[01]="CODIGO"
V3[02]="FORNECEDOR"
V3[03]="DATA"
V3[04]="FUNCIONARIO"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE


DBEDIT(01,00,21,79,v1,"YZDBEDIT",v2,v3,chr(205),space(1)+chr(179))

function YZdbedit(modo,coluna)
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
          
        ELSEIF LASTKEY() == 13 
                CONPED=1
                PUVARPED()
                INIVAPED()
                MCODNOT=CCODNOT
                ESTMIN()
                CONPED=0
                RETURN(0)


        ELSEIF LASTKEY() == 66 .OR. lastkey() == 98 && "B/b"

             NUMREG=LASTREC()
             GOTO NUMREG
             CLEAR GETS
             SET CURSOR ON
             SET SOFTSEEK ON
             SETCOLOR("W+/BG,N/W")
             MCODPECA=SPACE(05)
             @ 03,04 CLEAR TO 05,20
             @ 03,04 TO 05,20 DOUBLE
             @ 04,06 SAY "CODIGO:" GET MCODPECA PICT "@!"
             READ             
             NUMREG=LASTREC()
             GOTO NUMREG
             LINHA=06
             @ LINHA,04 CLEAR TO LINHA+1,51
             @ LINHA,04 TO LINHA+1,51 DOUBLE

             DO WHILE ! BOF()
                     MCODNOT=CCODNOT
                     MRDISTRIB=CDISTRIB
                     MCDATA=CDATA
                     CAMINHO="D:\KARVAN\PEDIDO\c"
                     USE &CAMINHO&MCODNOT SHARED
                     INDEX ON PCODPEC TO PCODPEC
                     SEEK MCODPECA
                     IF FOUND()
                        @ LINHA+1,04 CLEAR TO LINHA+1,51
                        @ LINHA+1,05 SAY MCODNOT
                        @ LINHA+1,15 SAY "-"
                        @ LINHA+1,17 SAY MRDISTRIB
                        @ LINHA+1,39 SAY "-"
                        @ LINHA+1,41 SAY MCDATA
                        LINHA++
                        @ 05,04 TO LINHA+1,51 DOUBLE
                     ENDIF
                     NUMREG--
                     USE D:\KARVAN\PEDIDO\PEDIDO SHARED
                     GOTO NUMREG
             ENDDO
             INKEY(0)
             RETURN(2)

	elseif lastkey()== 49 && "1" 

          CLEAR GETS
          SET CURSOR ON
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(09)
          INDEX ON CCODNOT TO CCODNOT
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "CODIGO:" GET V_BUSCA PICT "999999999"
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
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          INDEX ON CDISTRIB TO CDISTRIB
          @ 03,20 CLEAR TO 05,56
          @ 03,20 TO 05,56 DOUBLE
          @ 04,22 SAY "DISTRIB.:" GET V_BUSCA PICT "@!"
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
