************************************************************************

*****************************/FUN€AO CONSULTA ENTREGAS******************

SET CENTURY ON
PECAS()
ORDSETFOCUS("CODPECA")
SEEK "88888"
VTAXA=PRECO
ENTREGA()
CLOSE INDEXES
DBGOTOP()
XT_MOTO=0
MPONTO=SPACE(2)
IF EOF()
       TONE(500,5)
       OL_Yield()
       ALERT ('Nenhuma Entrega Pendente...')
       IF CONFIRMA ("DESEJA CADASTRAR UMA ENTREGA ?")=1
                SET KEY -40 TO CONCLI1() // F11                                
                CADENTR()
                SET KEY -40 TO OTARIOS() // F11                                
                RETURN(0)
            ELSE
                RETURN(0)
       ENDIF
ENDIF

SETCOLOR("GR/B+")
PRIVATE V1[5], V2[5], V3[5]

V1[01]="CODIGO"
V1[02]="ENTREGAS"
V1[03]="PONTO"
V1[04]="T_MOTO"
V1[05]="P_EXC"

V2[01]="999999999"
V2[02]="@!"
V2[03]="@!"
V2[04]="@!"
V2[05]="@!"

V3[01]="COD.CUPOM"
V3[02]="CLIENTE"
V3[03]="PONTO"
V3[04]="T_MOTO"
V3[05]="EXCLUI"

@ 00,00 TO 00,79 DOUBLE
@ 22,00 TO 24,79 DOUBLE

@ 23,01 SAY PADC("[P] TAXA MOTO [A] ALTERA [C] CADASTRA [DELETE] DELETA ",78)

DBEDIT(01,00,21,79,v1,"ODBEDIT", v2, v3,chr(205),space(1)+chr(179))


function ODBEDIT(modo,coluna)
if modo=1
        return(1) 
      elseif modo=2
        return(1)
      elseif modo=3
        *REST SCREEN FROM FTELA
        return(0)
      elseif modo=4
        if lastkey() == 27
                set softseek off
                REST SCREEN FROM FTELA
                return(0)
                
           elseif lastkey()== 65 .OR. lastkey() == 97  && "A/a"

                  MPONTO=SPACE(2)
                  @ 10,10 CLEAR TO 12,20
                  @ 10,10 TO 12,20 DOUBLE
                  @ 11,11 SAY "PONTO:" GET MPONTO PICT "@!" VALID MPONTO $ ("P1/P2/P3/P4/P5")
                  READ
                  IF LASTKEY()=27
                         RETURN(1)
                  ENDIF
                  BLOQUEIO()
                  REPLACE PONTO WITH MPONTO
                  DBCOMMIT()
                  UNLOCK 
                  RETURN(1)
                  
           elseif lastkey()== 07 && "DELETE"

                MCODIGO=CODIGO
                IF CONFIRMA ("DESEJA DELETETAR ESSA ENTREGA ?")=1
                        BLOQUEIO()
                        DELETE
                        UNLOCK
                        OL_Yield()
                        ALERT('ENTREGA EXCLUIDA COM EXITO')
                ENDIF
                ENVIADOS()
                ORDSETFOCUS("CODNOT")
                SEEK MCODIGO
                IF FOUND()
                         ALERT('FAVOR VERIFICAR O CANHOTO!!!')
                *        IF CONFIRMA ("DESEJA DELETETAR O CANHOTO?")=1
                *                BLOQUEIO()
                *                DELETE
                *                UNLOCK
                *                OL_Yield()
                *                ALERT('CANHOTO EXCLUIDO COM EXITO')
                *        ENDIF
                ENDIF
                *REST SCREEN FROM FTELA
                ENTREGA()
                RETURN(1)

           ELSEIF lastkey() == 84 .or. lastkey() == 116 && "T/t"

                SET KEY -40 TO CONCLI1() // F11
                MCODCLI=0
                MCODNOT=CODIGO
                XENTREGAS="ENTREGAR "
                @ 18,10 CLEAR TO 20,56
                @ 18,10 TO 20,56 DOUBLE
                @ 19,12 SAY "CLIENTE:" GET MCODCLI PICT "999" 
                READ
                CLIENTES()
                ORDSETFOCUS('CODCLI')
                IF MCODCLI=0
                        CONCLI1()
                ENDIF
                SEEK MCODCLI
                IF FOUND()
                        MNOMECLI=NOMECLI
                        MPONTO=P1
                        MT_MOTO=T_MOTO
                        MENDCLI=ENDCLI
                        MKM=KM
                        @ 19,21 SAY MNOMECLI
                    ELSE
                        OL_Yield()
                        ALERT('CLIENTE NAO CADASTRADO')
                        ENTREGA()
                        RETURN(1)
                ENDIF
                IF LASTKEY() == 27
                        ENTREGA()
                        RETURN(1)
                ENDIF
                ENTREGA()
                ORDSETFOCUS("CODIGO")
                SEEK MCODNOT
                BLOQUEIO()
                REPLACE ENTREGAS WITH XENTREGAS+LEFT(MNOMECLI,38)
                REPLACE PONTO    WITH MPONTO
                REPLACE ENDERECO WITH MENDCLI
                REPLACE HORA     WITH TIME()
                REPLACE KM       WITH MKM
                IF T_MOTO<MT_MOTO
                        XT_MOTO=MT_MOTO
                ENDIF
                REPLACE T_MOTO   WITH MT_MOTO              
                DBCOMMIT()
                UNLOCK
                IF XT_MOTO>0
                        PEDCUP()
                        ORDSETFOCUS("PEDNUM")
                        SEEK MCODNOT
                        DO WHILE .T.
                                IF PEDCOD="88888"
                                        BLOQUEIO()
                                        REPLACE PRECOCUP WITH XT_MOTO*VTAXA
                                        UNLOCK
                                        XT_MOTO=0
                                        ALERT('FAVOR REIMPRIMIR O PEDIDO TAXA ALTERADA')
                                        EXIT
                                ENDIF
                                SKIP
                        ENDDO
                ENDIF
                *TESTAPONTO()
                ENTREGA()
                ORDSETFOCUS("CODIGO")
                SEEK MCODNOT
                RETURN(1)

           ELSEIF lastkey() == 67 .or. lastkey() == 99 && "C/c"

                SET KEY -40 TO CONCLI1() // F11                                
                CADENTR()
                SET KEY -40 TO OTARIOS() // F11
                RETURN(1)
        ENDIF
ENDIF
RETURN(1)


FUNCTION CADENTR
                IF ACESSO#1
                        OL_Yield()
                        ALERT('ACESSO NAO AUTORIZADO')
                        RETURN(1)
                ENDIF

                SAVE SCREEN TO TELAPAG
                @ 23,02 CLEAR TO 23,70
                @ 06,10 CLEAR TO 15,22
                @ 06,10 TO 15,22 DOUBLE
                @ 07,12 PROMPT "1-RECEBER " MESS ""
                @ 08,12 PROMPT "2-TROCAR  " MESS ""
                @ 09,12 PROMPT "3-CARTAO  " MESS "" 
                @ 10,12 PROMPT "4-CONTAS  " MESS ""
                @ 11,12 PROMPT "5-GARANTIA" MESS "" 
                @ 12,12 PROMPT "6-ENTREGAR" MESS "" 
                @ 13,12 PROMPT "7-AMOSTRA " MESS "" 
                @ 14,12 PROMPT "8-Ret.Maq." MESS "" 
                MENU TO MOP
                     DO CASE
                          CASE MOP == 1
                               XENTREGAS="RECEBER "
                          CASE MOP == 2
                               XENTREGAS="TROCAR "
                          CASE MOP == 3
                               XENTREGAS="CARTAO "
                          CASE MOP == 4
                               XENTREGAS="CONTAS "
                          CASE MOP == 5
                               XENTREGAS="GARANTIA "
                          CASE MOP == 6
                               XENTREGAS="ENTREGAR "
                          CASE MOP == 7
                               XENTREGAS="AMOSTRA "
                          CASE MOP == 8
                               XENTREGAS="Ret.Maq."
                     ENDCASE
                REST SCREEN FROM TELAPAG
                MCODCLI=0
                @ 18,10 CLEAR TO 20,56
                @ 18,10 TO 20,56 DOUBLE
                @ 19,12 SAY "CLIENTE:" GET MCODCLI PICT "999" 
                READ
                CLIENTES()
                ORDSETFOCUS('CODCLI')
                IF MCODCLI=0
                        CONCLI1()
                ENDIF
                SEEK MCODCLI
                IF FOUND()
                        IF XENTREGAS="CONTAS "
                                BLOQUEIO()
                                REPLACE MANDANOTA WITH "N"
                                DBCOMMIT()
                                UNLOCK
                        ENDIF
                        MNOMECLI=NOMECLI
                        MPONTO=P1
                        MT_MOTO=T_MOTO
                        MENDCLI=ENDCLI
                        MCODNOT=99999990
                        MKM=KM
                        @ 19,21 SAY MNOMECLI
                    ELSE
                    OL_Yield()
                        ALERT('CLIENTE NAO CADASTRADO')
                        ENTREGA()
                        RETURN(1)
                ENDIF
                IF LASTKEY() == 27
                        ENTREGA()
                        RETURN(1)
                ENDIF
                ENTREGA()
                BLOQUEIO()
                APPEND BLANK
                REPLACE ENTREGAS WITH XENTREGAS+LEFT(MNOMECLI,38)
                REPLACE PONTO    WITH MPONTO
                REPLACE ENDERECO WITH MENDCLI
                REPLACE CODIGO   WITH MCODNOT
                REPLACE HORA     WITH TIME()
                REPLACE KM       WITH MKM
                REPLACE T_MOTO   WITH MT_MOTO
                UNLOCK
                TESTAPONTO()
                DBCOMMIT()
                UNLOCK
                RETURN
