
************************************************************************

*****************************/FUN€AO RELATORIO ENTREGAS******************

SET CENTURY ON
CLEAR GETS
ENTR_CLI()
CLOSE INDEXES
GOTO BOTTOM
IF EOF()
   TONE(500,5)
   OL_Yield()
   ALERT('Nenhuma Entrega no momento...')
   REST SCREEN FROM FTELA
   RETURN(0)
ENDIF


SETCOLOR("GR/B+")
PRIVATE V1[5], V2[5], V3[5]

V1[01]="CLIENTE"
V1[02]="ENTREGA"
V1[03]="ENDERECO"
V1[04]="TELEFONE"
V1[05]="CODIGO"
               
V2[01]="@!"
V2[02]="@!"
V2[03]="@!"
V2[04]="@!"
V2[05]="999999999"

V3[01]="CLIENTE"
V3[02]="ENTREGA"
V3[03]="ENDERECO"
V3[04]="TELEFONE"
V3[05]="PEDIDO"
    
@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("  [DELETE] DELETA  [01] CLIENTE [02] ENDERECO [03] TELEFONE",78)

DBEDIT(01,00,21,79,v1,"MDBEDIT", v2, v3,chr(205),space(1)+chr(179))

function MDBEDIT(modo,coluna)

if modo=1
        return(1) 
      elseif modo=2
        return(1)
      elseif modo=3
        REST SCREEN FROM FTELA
        return(0)
      elseif modo=4
        if lastkey() == 27
               set softseek off
               REST SCREEN FROM FTELA
               return(0)
    elseif lastkey()== 13 && "ENTER"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          MENTREGA=ENTREGA
          REL_ENTR()
          ORDSETFOCUS("CODENTR")
          SEEK MENTREGA
          IF FOUND()
                MMOTOBOY=MOTOBOY
                MDATA=DATA
                MHORA_S=HORA_S
                MHORA_C=HORA_C
          ENDIF
          @ 05,05 CLEAR TO 13,20
          @ 05,05 TO 13,20 DOUBLE
          @ 06,06 SAY MMOTOBOY
          @ 08,06 SAY MDATA
          @ 10,06 SAY MHORA_S
          @ 12,06 SAY MHORA_C
          INKEY(0)
          ENTR_CLI()
          ORDSETFOCUS("ENTREGA")
          SEEK MENTREGA
          RETURN(1)

    elseif lastkey()== 49 && "1"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(35)
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,67
          @ 03,20 TO 05,67 DOUBLE
          @ 04,22 SAY "CLIENTE:" GET V_BUSCA PICT "@!"
          READ          
          IF ! EMPTY(V_BUSCA)          
                ORDSETFOCUS("CLIENTE")
                INDEX ON CLIENTE TO ENDERECO FOR RTRIM(V_BUSCA) $ CLIENTE
                DBSEEK (V_BUSCA,.T.,.T.)
          ENDIF
          IF EOF()
             SKIP-1
             ORDSETFOCUS("CLIENTE") 
             RETURN(2)
          ENDIF
          RETURN(1)
    elseif lastkey()== 50 && "2"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(20)
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,52
          @ 03,20 TO 05,52 DOUBLE
          @ 04,22 SAY "ENDERECO:" GET V_BUSCA PICT "@!"
          READ          
          IF ! EMPTY(V_BUSCA)          
                ORDSETFOCUS("ENDERECO")
                INDEX ON ENTREGA TO ENDERECO FOR RTRIM(V_BUSCA) $ ENDERECO
                DBSEEK (V_BUSCA,.T.,.T.)
          ENDIF
          IF EOF()
             SKIP-1
             ORDSETFOCUS("ENDERECO") 
             RETURN(2)
          ENDIF
          RETURN(1)
    elseif lastkey()== 51 && "3"

          SET CURSOR ON
          CLEAR GETS
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          SET CURSOR ON
          @ 03,20 CLEAR TO 05,52
          @ 03,20 TO 05,52 DOUBLE
          @ 04,22 SAY "TELEFONE:" GET V_BUSCA PICT "99999-9999"
          READ          
          IF ! EMPTY(V_BUSCA)          
                ORDSETFOCUS("TELEFONE")
                DBSEEK (V_BUSCA,.T.,.T.)
          ENDIF
          IF EOF()
             SKIP-1
             ORDSETFOCUS("TELEFONE") 
             RETURN(2)
          ENDIF
          RETURN(1)
          
           elseif lastkey()== 07 && "DELETE"

                IF ACESSO#1
                OL_Yield()
                     ALERT('ACESSO NAO AUTORIZADO')
                     RETURN(1)
                ENDIF
                IF CONFIRMA ("DESEJA EXCLUIR ESSA ENTREGA?")=2
                      RETURN(1)
                ENDIF            
                MT_MOTO=T_MOTO
                BLOQUEIO()
                DELETE
                UNLOCK
                MCODENTR=ENTREGA
                REL_ENTR()
                ORDSETFOCUS("CODENTR")
                SEEK MCODENTR
                BLOQUEIO()                
                REPLACE QTDENTR WITH QTDENTR-MT_MOTO
                REPLACE KM WITH KM * 0.9
                UNLOCK
                ENTR_CLI()
        ENDIF
ENDIF
RETURN(1)
