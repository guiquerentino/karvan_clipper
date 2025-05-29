DO WHILE .T.

    CONFERE="S"

    RUN DEL C:\KARVAN\*.TMP

    CLEAR GETS
    PUVARPED()
    INIVAPED()
    MXML=SPACE(44)
    SETCOLOR("W+/BG,N/W")
    CLS
    HOJE=DATE()
    @ 00,00 TO 02,79 DOUBLE 
    @ 00,02 SAY " MICRO - PE€AS INFORMATICA 5.2 "
    @ 01,27 SAY "³CUPOM DE CONFERENCIA ³"
    @ 01,59 SAY "DATA:"
    @ 01,65 SAY DATE()
    @ 06,01 TO 23,78 DOUBLE    
    MD_NOT=DATE()
    @ 01,02 SAY "N§ NOTA.:"
    @ 01,12 GET  MXML  PICT "@!"
    READ
    IF LEN(ALLTRIM(MXML))=44
            MCODNOT=SUBSTR(MXML, 26,9)
        ELSE
            MCODNOT=STRZERO(VAL(MXML),9)
    ENDIF
    IF LASTKEY()=27
        RETURN
    ENDIF
    NTX=1
    MFECHA="N"
    ICMSST=0
    VENDATOTAL=0
    MPCODPEC=SPACE(05)
    MDIGITO=SPACE(02)
    MPNOMPEC=SPACE(45)
    MPQTDPEC2=1
    MPQTDPEC=1
    NFABRQTD=0
    MPC_PRECO=0
    MPPRETOT=0
    MPNFABRIC=SPACE(12)
    MPFABRIC=SPACE(10)
    MPPRECO=0
    MPTOTAL=0
    MPTOTG2=0
    MCDATA=DATE()
    RDISTRIB=SPACE(20)
    MCODFOR=0
    CAMINHO="d:\KARVAN\CONFERE\c"
    CAMINHO2="d:\KARVAN\CONFERE\f"
    EXTENSAO=".DBF"
    @ 03,02 SAY "FORNECEDOR:"
    @ 03,52 SAY "FUNCIONARIO:"
    @ 04,00 SAY REPL ("ÍÍ",79)

    ABRENOTA=RIGHT(MCODNOT,7)
    *USE d:\KARVAN\CONFERE\CONFERE SHARED
    CONFEREX()
    LOCATE FOR CCODNOT=MCODNOT
    
    IF ! FOUND()
            OL_Yield()
            INKEY(0)
            ALERT('NOTA NAO CADASTRADA')
            RETURN
         ELSE
            RDISTRIB=CDISTRIB
            MCDATA=CDATA
            MNOTFUNC=CFUNC
            MFECHA=FECHA 
            MXML=XML
            SETCOLOR("R/BG,N/W")
            @ 01,65 SAY MCDATA
            @ 03,65 SAY MNOTFUNC    
            @ 03,15 SAY RDISTRIB
    ENDIF
    EXIT
ENDDO
    INKEY(0)
    SAVE SCREEN TO TELAPAG
    @ 06,10 CLEAR TO 10,28
    @ 06,10 TO 10,28 DOUBLE
    @ 07,12 PROMPT "1-JQ KARVAN"
    @ 08,12 PROMPT "2-APK PE€AS"
    @ 09,12 PROMPT "3-KV AUTO PECAS"
    MENU TO MOP
    if lastkey()=13 .OR. LASTKEY()=27
            RETURN(0)
    endif
    DO CASE
            CASE MOP == 1
                 MEMPRESA="1"
            CASE MOP == 2
                 MEMPRESA="2"
            CASE MOP == 3
                 MEMPRESA="3"
    ENDCASE
    REST SCREEN FROM TELAPAG
    SETCOLOR("W+/BG,N/W")

    USE &CAMINHO&ABRENOTA EXCLU
    DO WHILE NETERR()
           OL_Yield()
           ALERT('NOTA ABERTA EM OUTRO TERMINAL !!!')
           USE &CAMINHO&ABRENOTA EXCLUSIVE
           RETURN(0)
    ENDDO

    IF MFECHA="N"
            USE &CAMINHO&ABRENOTA SHARED
	    NUMREG=1
	    GOTO NUMREG	    
            DO WHILE ! EOF()
                    SETCOLOR("W+/R,N/W")
                    @ 10,18 CLEAR TO 12,48
                    @ 10,18 TO 12,48 DOUBLE
                    SETCOLOR("W+*/R,N/W")
                    @ 11,19 SAY "ATUALIZANDO OS PRECOS !!!"
                    MPCODPEC=PCODPEC
                    MDIGITO=DIGITO
                    PECAS()
                    ORDSETFOCUS("CODPECA")
                    SEEK MPCODPEC
                    IF ! FOUND()
                         @ 01,01 SAY MPCODPEC
                         OL_Yield()
                         ALERT('FAVOR INDEXAR OS ARQUIVOS E REFAZER...')
                         RETURN(0)
                    ENDIF
                    MPRECO=PRECO
                    USE &CAMINHO&ABRENOTA SHARED
                    GOTO NUMREG
                    BLOQUEIO()
                    REPLACE PPRECO WITH MPRECO
                    UNLOCK
                    NUMREG++
                    GOTO NUMREG
            ENDDO
    ENDIF
    SETCOLOR("W+/BG,N/W")
                     
    PRIVATE V1[11], V2[11], V3[11]

    V1[01]="LEFT(PNOMPEC,30)"
    V1[02]="PFABRIC"
    V1[03]="PNFABRIC"
    V1[04]="PQTDPEC" 
    V1[05]="PQTDPEC2"  
    V1[06]="PC_PRECO"  
    V1[07]="PPRECO"  
    V1[08]="LOCAL"
    V1[09]="NCM"
    V1[10]="NOTFUNC"   
    V1[11]="CFOP"   

    V2[01]="@!"
    V2[02]="@!"
    V2[03]="@!"
    V2[04]="999"
    V2[05]="999"
    V2[06]="9999.999"
    V2[07]="9999.99"
    V2[08]="@!"
    V2[09]="@!"
    V2[10]="@!"
    V2[11]="9999"

    V3[01]="APLICA€ŽO"
    V3[02]="FABRICANTE"
    V3[03]="NFABRIC"
    V3[04]="QTD"
    V3[05]="QTD2"
    V3[06]="CUSTO"
    V3[07]="PRECO"
    V3[08]="LOCAL"
    V3[09]="NCM"
    V3[10]="FUNC"
    V3[11]="CFOP"
    
SOMATOTAL()

DBEDIT(05,02,22,77,v1,"PKIDBED",v2,v3,chr(205),space(1)+chr(179))


function PKIDBED(MODO,COLUNA)

SETCURSOR (1)

if modo=1
    return(1)
  elseif modo=2
    return(1)
  elseif modo=3
     KEYBOARD CHR(13)
  elseif modo=4
     if lastkey() == 27
         set softseek off
          return(1)

       ELSEIF LASTKEY()== 07 && "DELETE"

               MPCODPEC=PCODPEC
               MPQTDPEC=PQTDPEC
               MVERIFIC=VERIFIC

               PECAS()
               ORDSETFOCUS("CODPECA")
               SEEK MPCODPEC
               IF TRAVA="A"
               OL_Yield()
                    ALERT('PRODUTO SENDO ALTERADO EM OUTRO TERMINAL; IMPOSSIVEL DE DELETAR, AGUARDE!!!')
                    USE &CAMINHO&ABRENOTA SHARED
                    RETURN(1)
               ENDIF     
               BLOQUEIO()
               MTEMP=TEMP-MPQTDPEC
               IF MTEMP < 0
                        OL_Yield()
                        ALERT('ERRO AO EXCLUIR O PRODUTO TEMP < 0')
                        MTEMP=0
               ENDIF
               REPLACE TEMP WITH MTEMP
               IF MVERIFIC<=1 
                      REPLACE CQTD2 WITH CQTD2-MPQTDPEC
               ENDIF       
               IF MVERIFIC=2 
                      REPLACE CQTD3 WITH CQTD3-MPQTDPEC
               ENDIF       
               IF MVERIFIC=3 
                      REPLACE CQTD4 WITH CQTD4-MPQTDPEC
               ENDIF       
               IF MVERIFIC=4 
                      REPLACE CQTD5 WITH CQTD5-MPQTDPEC
               ENDIF       
               IF MVERIFIC=5 
                      REPLACE CQTD6 WITH CQTD6-MPQTDPEC
               ENDIF       
               IF NOTA=MCODNOT
                       REPLACE NOTA WITH SPACE(10)
               ENDIF    
               IF NOTA10=MCODNOT
                       REPLACE NOTA10 WITH SPACE(10)
               ENDIF    
               IF NOTA11=MCODNOT
                       REPLACE NOTA11 WITH SPACE(10)
               ENDIF    
               COMMIT
               UNLOCK
               BLOQUEIO()
               USE &CAMINHO&ABRENOTA EXCLU
               BLOQUEIO()
               INDEX ON PCODPEC TO PCODPEC FOR VERIFIC=MVERIFIC
               SEEK MPCODPEC
               DELETE
               PACK
               KEYBOARD+CHR(13)
               UNLOCK

               USE &CAMINHO&ABRENOTA SHARED

               SOMATOTAL()
               @ 24,47 SAY MPTOTG PICT "9999999.99"
               @ 24,57 SAY MPTOTG2 PICT "9999999.99"
               @ 24,67 SAY VENDATOTAL PICT "9999999.99"
               OL_Yield()
               ALERT('PECA EXCLUIDA COM EXITO')
               RETURN(1)

         elseif lastkey()== -3   && "F4 CANCELA PEDIDO"

                SET KEY -8 TO OTARIOS() // F9
                RETURN(0)

	elseif lastkey()== 49 && "1" 
          NTX=1
          CLEAR GETS
          SET CURSOR ON
          INDEX ON PCODPEC TO PCODPEC
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(05)
          @ 06,20 CLEAR TO 08,36
          @ 06,20 TO 08,36 DOUBLE
          @ 07,22 SAY "CODIGO:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
          
	elseif lastkey()== 50 && "2"
          NTX=2
          CLEAR GETS
          SET CURSOR ON
          INDEX ON PNOMPEC TO PNOMPEC
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_APLIC:=SPACE(20)
          V_DESCR:=SPACE(20)
          @ 06,20 CLEAR TO 10,54
          @ 06,20 TO 10,54 DOUBLE
          @ 07,22 SAY "APLICACAO:" GET V_APLIC PICT "@!"
          @ 09,22 SAY "DESCRICAO:" GET V_DESCR PICT "@!"
          READ
          IF EMPTY(V_APLIC) .AND. EMPTY(V_DESCR)
                SET INDEX TO PNOMPEC
                GOTO TOP
              ELSEIF EMPTY(V_APLIC)
                INDEX ON PNOMPEC TO TEMP FOR RTRIM(V_DESCR) $ PNOMPEC
              ELSEIF EMPTY(V_DESCR)
                INDEX ON PNOMPEC TO TEMP FOR RTRIM(V_APLIC) $ PNOMPEC
              ELSE
                INDEX ON PNOMPEC TO TEMP FOR RTRIM(V_APLIC) $ PNOMPEC .AND. RTRIM(V_DESCR) $ PNOMPEC
          ENDIF          
          MPNOMPEC=PNOMPEC
          IF EOF()
          OL_Yield()
              ALERT ('Consulta nao Encontrada....!!!')              
              SET INDEX TO PNOMPEC
              GOTO TOP
              RETURN(2)
          ENDIF
          RETURN(2)
          
        elseif lastkey()== 51 && "3"
          NTX=3
          CLEAR GETS
          SET CURSOR ON
          INDEX ON PFABRIC TO PFABRIC
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(10)
          @ 06,20 CLEAR TO 08,47
          @ 06,20 TO 08,47 DOUBLE
          @ 07,22 SAY "NOME FABRIC.:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)

	elseif lastkey()== 52 && "4"
          NTX=4
          CLEAR GETS
          SET CURSOR ON
          INDEX ON PNFABRIC TO PNFABRIC
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(12)
          @ 06,20 CLEAR TO 08,47
          @ 06,20 TO 08,47 DOUBLE
          @ 07,22 SAY "N§ FABRIC.:" GET V_BUSCA PICT "@!"
          READ
          SEEK V_BUSCA
          IF EOF()
              SKIP-1
              RETURN(1)
          ENDIF
          RETURN(2)
                

      elseif lastkey()== 99 .OR. lastkey() == 67 .OR. lastkey() == 43 && "c/C/+"          
          
         
          MPQTDPEC2=0
          MPCODPEC=PCODPEC
          MPPRECO=PPRECO
          MPC_PRECO=PC_PRECO
          MPNFABRIC=PNFABRIC
          MNCM=NCM
          MCFOP=CFOP
          NUMREG=RECNO()
          DO WHILE EMPTY(MNCM) .OR. EMPTY(MCFOP)
                  TELA1=SAVESCREEN(10,10,13,35)
                  @ 10,10 CLEAR TO 12,35
                  @ 10,10 TO 13,35 DOUBLE
                  @ 11,12 SAY "DIGITE O NCM.:" GET MNCM PICT "99999999"  
                  @ 12,12 SAY "DIGITE O CFOP:" GET MCFOP PICT "9999"
                  READ
                  IBPT()
                  ORDSETFOCUS("NCM")
                  SEEK VAL(MNCM)
                  IF ! FOUND()
                        ALERT ('CODIGO INCORRETO')
                        MNCM=SPACE(08)
                        USE &CAMINHO&ABRENOTA SHARED
                        GOTO NUMREG
                        LOOP
                  ENDIF
                  USE &CAMINHO&ABRENOTA SHARED
                  GOTO NUMREG
                  BLOQUEIO()
                  REPLACE NCM  WITH MNCM
                  REPLACE CFOP WITH MCFOP
                  RESTSCREEN(10,10,13,35,TELA1)
          ENDDO
          SET CURSOR ON
          IF PQTDPEC2=0
                  SETCOLOR("W+/BG,N/W")
              ELSE
                  TONE(300,18)
                  SETCOLOR("R/BG,N/W")
          ENDIF
          @ 06,06 CLEAR TO 20,45
          @ 06,06 TO 20,45 DOUBLE
          @ 06,12 SAY "CONFERE PE€AS"
          MQTD=0
          ICMSST=0
          XPRECO=PQTDPEC2*PC_PRECO
          @ 08,13 SAY "Preco..........:" GET MPPRECO PICT "9999.99"
          @ 16,13 SAY "N§ Fabricante..:" GET MPNFABRIC
          CLEAR GETS
          @ 10,13 SAY "Quantidade.....:" GET MPQTDPEC2 PICT "999"
          @ 12,13 SAY "P_custo distrib:" GET MPC_PRECO PICT "9999.999"
          @ 14,13 SAY "ICMS-ST........." GET ICMSST    PICT "9999.999"
          @ 16,13 SAY "CODIGO NCM......" GET MNCM      PICT "99999999"
          @ 18,13 SAY "CODIGO CFOP....." GET MCFOP     PICT "9999"
          READ
          MPC_PRECO=((MPC_PRECO*MPQTDPEC2)+ICMSST)/MPQTDPEC2
          TPRECO=MPC_PRECO*MPQTDPEC2
          MPQTDPEC2=MPQTDPEC2+PQTDPEC2
          MPC_PRECO=(TPRECO+XPRECO)/MPQTDPEC2
          IF LASTKEY()=27
                RETURN(2)
          ENDIF

          @ 06,06 CLEAR TO 16,45
          @ 06,06 TO 16,45 DOUBLE
          @ 06,08 SAY "ESCOLHA SUA OP€AO"
          @ 07,10 SAY MPC_PRECO * 1.25 PICT "9999.99"
          @ 07,19 SAY "25% = 1"
          @ 08,10 SAY MPC_PRECO * 1.30 PICT "9999.99"
          @ 08,19 SAY "30% = 1"
          @ 09,10 SAY MPC_PRECO * 1.35 PICT "9999.99"
          @ 09,19 SAY "35% = 2"
          @ 10,10 SAY MPC_PRECO * 1.40 PICT "9999.99"
          @ 10,19 SAY "40% = 3"
          @ 11,10 SAY MPC_PRECO * 1.45 PICT "9999.99"
          @ 11,19 SAY "45% = 4"
          @ 12,10 SAY MPC_PRECO * 1.50 PICT "9999.99"
          @ 12,19 SAY "50% = 5"
          @ 13,10 SAY MPC_PRECO * 1.60 PICT "9999.99"
          @ 13,19 SAY "60% = 6"
          @ 15,13 SAY "DIGITE O PRE€O:"GET MPPRECO PICT "9999.99" VALID MPPRECO > MPC_PRECO * 1.24
          READ
          BLOQUEIO()
          MPPRETOT=MPC_PRECO*MPQTDPEC2
          REPLACE PPRETOT2 WITH MPPRETOT
          REPLACE NCM      WITH MNCM
          REPLACE CFOP     WITH MCFOP
          REPLACE PC_PRECO WITH MPC_PRECO
          REPLACE PQTDPEC2 WITH MPQTDPEC2
          INDEX ON PCODPEC TO PCODPEC FOR PCODPEC=MPCODPEC
          DO WHILE ! EOF()  
                    BLOQUEIO()
                    REPLACE PPRECO   WITH MPPRECO
                    SKIP
          ENDDO            
          SOMATOTAL()
          @ 24,47 SAY MPTOTG PICT "9999999.99"
          @ 24,57 SAY MPTOTG2 PICT "9999999.99"
          @ 24,67 SAY VENDATOTAL PICT "99999999.99"
          COMMIT
          UNLOCK
          IF MFECHA="N"
                  MFECHA="S"
                  CONFEREX()
                  LOCATE FOR CCODNOT=MCODNOT
                  BLOQUEIO()
                  REPLACE FECHA WITH MFECHA
                  COMMIT
                  UNLOCK
                  USE &CAMINHO&ABRENOTA SHARED
          ENDIF
          IF NTX=1
                INDEX ON PCODPEC TO PCODPEC
                SEEK V_BUSCA
             ELSEIF NTX=2
                INDEX ON PNOMPEC TO PNOMPEC
                SEEK MPNOMPEC
             ELSEIF NTX=3
                INDEX ON PFABRIC TO PFABRIC
                SEEK V_BUSCA
             ELSEIF NTX=4
                INDEX ON PNFABRIC TO PNFABRIC
                SEEK V_BUSCA
          ENDIF          
          RETURN(2)

         elseif lastkey()== -2   && " F3 TRANSFERE DADOS"

          PECAS()
          ORDSETFOCUS("CODPECA")
          USE &CAMINHO&ABRENOTA EXCLUSIVE
          DO WHILE NETERR()
                OL_Yield()
                ALERT('NOTA ABERTA EM OUTRO TERMINAL !!!')
                USE &CAMINHO&ABRENOTA EXCLUSIVE
          ENDDO
          GOTO TOP
          DO WHILE ! EOF()
                IF PQTDPEC#PQTDPEC2 
                        @ 20,15 CLEAR TO 22,23
                        @ 20,15 TO 22,23 DOUBLE
                        @ 21,16 SAY PCODPEC
                        OL_Yield()
                        ALERT('QUANTIDADE ENTRADA DIFERENTE!!!')
                        RETURN(2)
                ENDIF
                IF PC_PRECO<=0
                        @ 20,15 CLEAR TO 22,23
                        @ 20,15 TO 22,23 DOUBLE
                        @ 21,16 SAY PCODPEC
                        OL_Yield()
                        ALERT('PRECO CUSTO ZERO, VERIFIQUE!!!')
                        RETURN(2)
                ENDIF
                IF PPRECO<=0
                        @ 20,15 CLEAR TO 22,23
                        @ 20,15 TO 22,23 DOUBLE
                        @ 21,16 SAY PCODPEC
                        OL_Yield()
                        ALERT('PRECO VENDA ZERO, VERIFIQUE!!!')
                        RETURN(2)
                ENDIF
                SKIP
          ENDDO
          IF LASTKEY()=27
                  USE &CAMINHO&ABRENOTA EXCLUSIVE
                  RETURN(2)
          ENDIF        
          SETCOLOR("W+/R*,N/W")
          IF CONFIRMA ("DADOS CORRETOS DESEJA CONTINUAR ?")=2
                RETURN(0)
          ENDIF
          USE &CAMINHO&ABRENOTA EXCLUSIVE
          GOTO TOP
          NUMREG=1
          SET CENT OFF
          DO WHILE ! EOF()
                 GOTO NUMREG
                 MPQTDPEC=PQTDPEC
                 MPCODPEC=PCODPEC
                 MPC_PRECO=PC_PRECO
                 MPPRECO=PPRECO       
                 MNCM=NCM         
                 MCFOP=CFOP
                 MVERIFIC=VERIFIC
                 MPNFABRIC=PNFABRIC
                 MPFABRIC=PFABRIC
                 PECAS()
                 ORDSETFOCUS("CODPECA")
                 SEEK MPCODPEC
                 IF ! FOUND()
                         @ 01,01 SAY MPCODPEC
                         OL_Yield()
                         ALERT('CODIGO NAO ENCONTRADO, VERIFIQUE O ERRO...')
                         USE &CAMINHO&ABRENOTA EXCLUSIVE
                         BLOQUEIO()
                         DELETE
                         PACK
                         LOOP
                         UNLOCK
                         GOTO NUMREG
                 ENDIF
                 IF EMPTY(TRAVA)
                        BLOQUEIO()
                        REPLACE TRAVA WITH "A"
                        DBCOMMIT()
                        UNLOCK
                      ELSE
                        OL_Yield()
                        ALERT('PECA NAO AUTORIZADA PARA ALTERACAO NO MOMENTO')
                        USE &CAMINHO&ABRENOTA EXCLUSIVE
                        LOOP
                 ENDIF
                 BLOQUEIO()
                 IF MVERIFIC<=1
                        REPLACE QTD2 WITH QTD2+MPQTDPEC
                        REPLACE CQTD2 WITH CQTD2-MPQTDPEC
                        REPLACE CUSTO1 WITH MPC_PRECO
                 ENDIF       
                 IF MVERIFIC=2
                        REPLACE QTD3 WITH QTD3+MPQTDPEC
                        REPLACE CQTD3 WITH CQTD3-MPQTDPEC
                        REPLACE CUSTO2 WITH MPC_PRECO
                 ENDIF       
                 IF MVERIFIC=3
                       REPLACE QTD4 WITH QTD4+MPQTDPEC
                       REPLACE CQTD4 WITH CQTD4-MPQTDPEC
                       REPLACE CUSTO3 WITH MPC_PRECO
                 ENDIF
                 IF MVERIFIC=4
                       REPLACE QTD5 WITH QTD5+MPQTDPEC
                       REPLACE CQTD5 WITH CQTD5-MPQTDPEC
                       REPLACE CUSTO4 WITH MPC_PRECO
                 ENDIF
                 IF MVERIFIC=5
                       REPLACE QTD6 WITH QTD6+MPQTDPEC                 
                       REPLACE CQTD6 WITH CQTD6-MPQTDPEC
                       REPLACE CUSTO5 WITH MPC_PRECO
                 ENDIF

                 MNOTA4=NOTA4
                 MDATA4=DATA4
                 MDISTRIB4=DISTRIB4
                 MP_CUSTO4=P_CUSTO4

                 IF EQTD4>0
                        MEQTD4=EQTD3+EQTD4
                        MP_CUSTO5=((P_CUSTO4*EQTD4)+(P_CUSTO3*EQTD3))/MEQTD4
                        REPLACE XQTD4 WITH MEQTD4
                        REPLACE EQTD4 WITH MEQTD4
                        REPLACE P_CUSTO4 WITH MP_CUSTO5
                     ELSE
                        REPLACE EQTD4 WITH EQTD3
                        REPLACE XQTD4 WITH XQTD3
                        REPLACE P_CUSTO4 WITH P_CUSTO3
                 ENDIF
                 REPLACE EQTD3  WITH EQTD2
                 IF EQTD1<0
                        MEQTD1=0
                        REPLACE EQTD2 WITH MEQTD1
                        REPLACE EQTD1 WITH MPQTDPEC+EQTD1
                     ELSE   
                        REPLACE EQTD2 WITH EQTD1
                        REPLACE EQTD1  WITH MPQTDPEC
                 ENDIF
                 REPLACE XQTD3 WITH XQTD2
                 REPLACE XQTD2 WITH XQTD1
                 REPLACE XQTD1 WITH MPQTDPEC  
                 
                 REPLACE DISTRIB4 WITH DISTRIB3
                 REPLACE NOTA4    WITH NOTA3
                 REPLACE DATA4    WITH DATA3
                 REPLACE P_CUSTO3 WITH P_CUSTO2
                 REPLACE DISTRIB3 WITH DISTRIB2
                 REPLACE NOTA3    WITH NOTA2
                 REPLACE DATA3    WITH DATA2
                 REPLACE P_CUSTO2 WITH P_CUSTO
                 REPLACE DISTRIB2 WITH DISTRIB
                 REPLACE NOTA2    WITH NOTA1 
                 REPLACE DATA2    WITH DATA1
                 REPLACE P_CUSTO  WITH MPC_PRECO
                 TEMPQTD=QTD+MPQTDPEC
                 
                 REPLACE DATAENTR WITH DATE()
                 REPLACE QTD WITH TEMPQTD
                 REPLACE NCM WITH MNCM
                 REPLACE CFOP WITH MCFOP
                 REPLACE PRECO   WITH MPPRECO
                 REPLACE DISTRIB WITH RDISTRIB
                 REPLACE NOTA1   WITH MCODNOT
                 REPLACE DATA1   WITH MCDATA
                 MTEMP=TEMP-MPQTDPEC
                 REPLACE TEMP WITH MTEMP
                 REPLACE TRAVA WITH SPACE(01)
                 IF NOTA=MCODNOT
                       REPLACE NOTA WITH SPACE(10)
                 ENDIF    
                 IF NOTA10=MCODNOT
                       REPLACE NOTA10 WITH SPACE(10)
                 ENDIF    
                 IF NOTA11=MCODNOT
                       REPLACE NOTA11 WITH SPACE(10)
                 ENDIF    
                 REPLACE ATUALIZADO WITH "S"
                 COMMIT
                 UNLOCK 
                 IF TEMP>0 .AND. EMPTY(NOTA) .AND. EMPTY(NOTA10) .AND. EMPTY(NOTA11)
                        @ 20,15 CLEAR TO 22,23
                        @ 20,15 TO 22,23 DOUBLE
                        @ 21,16 SAY MPCODPEC
                        OL_Yield()
                        ALERT('VERIFIQUE O TEMPORARIO DESSE REGISTRO')
                 ENDIF
                 IF QTD>(QTDMIN*2)
                        @ 20,15 CLEAR TO 22,23
                        @ 20,15 TO 22,23 DOUBLE
                        @ 21,16 SAY MPCODPEC
                        OL_Yield()
                        ALERT('PRODUTO COM QUANTIDADE MUITO ACIMA!!!')
                 ENDIF
                 ENTRADA()
                 BLOQUEIO()
                 APPEND BLANK
                 REPLACE ECODPECA  WITH MPCODPEC
                 REPLACE EDISTRIB  WITH RDISTRIB
                 REPLACE ECNPJ     WITH (SUBSTR(MXML, 07,14))
                 REPLACE ENUMNOTA  WITH MCODNOT
                 REPLACE EQTD      WITH MPQTDPEC
                 REPLACE EVALOR    WITH MPC_PRECO
                 REPLACE EDATA     WITH MCDATA
                 REPLACE EXML      WITH MXML       
                 REPLACE ELOJA     WITH MEMPRESA
                 REPLACE ENFABRIC  WITH MPNFABRIC
                 REPLACE EFABRIC   WITH MPFABRIC
                 REPLACE ENOMEFUNC WITH MNOTFUNC
                 COMMIT
                 UNLOCK

                 USE &CAMINHO&ABRENOTA EXCLUSIVE
                 DO WHILE NETERR()
                 OL_Yield()
                        ALERT('NOTA ABERTA EM OUTRO TERMINAL !!!')
                        USE &CAMINHO&ABRENOTA EXCLUSIVE
                 ENDDO
                 GOTO NUMREG
                 BLOQUEIO()
                 DELETE
                 PACK
                 UNLOCK
                 GOTO NUMREG
          ENDDO
          SET CENT ON
          USE d:\KARVAN\CONFERE\CONFERE EXCLUSIVE
          DO WHILE NETERR()
          OL_Yield()
                ALERT('NOTA ABERTA EM OUTRO TERMINAL !!!')
                USE d:\KARVAN\CONFERE\CONFERE EXCLUSIVE
          ENDDO
          LOCATE FOR CCODNOT=MCODNOT    
          IF FOUND()
                BLOQUEIO()
                DELETE
                PACK
                COMMIT
                UNLOCK
          ENDIF
          USE          
          SAVE SCREEN TO TELA
          DO WHILE .T.
                  RESTORE SCREEN FROM TELA
                  DO CADNOTA
                  exit
          ENDDO
          RESTORE SCREEN FROM TELA
          RUN DEL &CAMINHO&ABRENOTA&EXTENSAO  
          RETURN(0)
     ENDIF             
ENDIF
RETURN(1)
