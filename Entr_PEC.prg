****************************************************************************

************************/FUN€AO CONSULTA ENTRADAS NOTAS*********************

OP=3
SET CENT ON
PUBLIC GRAVA
SELE 1
ENTRADA()
SET FILTER TO ECODPECA=MCODPECA

GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhuma entrada de nota...')
   RETURN(0)
ENDIF

SETCOLOR("R/B+")
PRIVATE V1[11], V2[11], V3[11]

V1[01]="EDISTRIB"
V1[02]="ENUMNOTA"
V1[03]="EQTD"
V1[04]="EVALOR"
V1[05]="EDATA"
V1[06]="ENFABRIC"
V1[07]="EFABRIC"
V1[08]="ENOMEFUNC"
V1[09]="ELOJA"
V1[10]="ECNPJ"
V1[11]="EXML"

V2[01]="@!"
V2[02]="@!"
V2[03]="@!"
V2[04]="9999.99"
V2[05]="99/99/99"
V2[06]="@!"
V2[07]="@!"
V2[08]="@!"
V2[09]="@!"
V2[10]="@!"
V2[11]="@!"

     
V3[01]="DISTRIBUIDORA"
V3[02]="NOTA"
V3[03]="QTD"
V3[04]="VALOR"
V3[05]="DATA"
V3[06]="N_FABRIC"
V3[07]="FABRIC"
V3[08]="FUNC"
V3[09]="LOJA"
V3[10]="CNPJ"
V3[11]="XML"
           

*@ 00,00 TO 00,79 DOUBLE
*@ 22,00 TO 24,79 DOUBLE
           
DBEDIT(01,00,17,79,v1,"CEBEDIT",v2,v3,chr(205),space(1)+chr(179))

function CEbedit(modo,coluna)
if modo=1
   return(1)
elseif modo=2
   return(1)
elseif modo=3
   return(0)
elseif modo=4
       if lastkey() == 27
          GRAVA="N"   //se aperta esc nao grava os replace
          set softseek off
          return(0)

        elseif lastkey()== 13 && "ENTER" 
          GRAVA="S"
          IF CONPEC=0 
                RETURN(0)
          ENDIF
          PUBLIC MDISTRIB
          PUBLIC MCUSTO
          PUBLIC MNOTA
          MDISTRIB=EDISTRIB
          MCUSTO=EVALOR
          MNOTA=ENUMNOTA
          TELA1=SAVESCREEN(10,10,12,41)
          IF EMPTY(MGPROTOCOLO)
                  @ 10,10 CLEAR TO 12,41
                  @ 10,10 TO 12,41 DOUBLE
                  @ 11,11 SAY "PROTOCOLO:" GET MGPROTOCOLO PICT "@!"
                  READ
          ENDIF
          RESTSCREEN(10,10,12,41,TELA1)
          RETURN(0)
       ENDIF


ENDIF
RETURN(1)
