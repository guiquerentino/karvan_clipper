******************************************************************************

********************************/FUN€AO ESTOQUE MINIMO************************

DO WHILE .T.
    IF .NOT. FILE ("D:\KARVAN\PEDIDO\PEDIDO.DBF")
         PEDIDODBF()
    ENDIF

    CLEAR GETS
    IF CONPED=0
            PUVARPED()
            INIVAPED()
    ENDIF
    SETCOLOR("W+/BG,N/W")
    CLS
    HOJE=DATE()
    @ 00,00 TO 02,79 DOUBLE 
    @ 00,02 SAY " MICRO - PE€AS INFORMATICA 5.2 "
    @ 01,27 SAY "³    TELA DE PEDIDO    ³"
    @ 01,53 SAY "DATA......:"
    @ 01,65 SAY DATE()
    @ 06,01 TO 23,78 DOUBLE    
    MD_NOT=DATE()
    @ 01,02 SAY "N§ NOTA.:"
    @ 01,12 GET  MCODNOT  PICT "9999999" VALID MCODNOT # 0
    IF CONPED=0
            READ
            MCODNOT=STRZERO(MCODNOT,7)
         ELSE
            CLEAR GETS    
    ENDIF
    IF LASTKEY()=27
        RETURN
    ENDIF


    NTX=1
    MPCODPEC=SPACE(05)
    MPNOMPEC=SPACE(45)
    MPQTDPEC=1
    NFABRQTD=0
    MPPRETOT=0
    MPNFABRIC=SPACE(12)
    MPNFABRIC2=SPACE(12)
    MPFABRIC=SPACE(10)
    MPPRECO=0
    MPTOTAL=0
    MCDATA=DATE()
    RDISTRIB=SPACE(20)
    PQTDPEC2=0
    MCODFOR=0
    CAMINHO="D:\KARVAN\PEDIDO\c"
    CAMINHO2="D:\KARVAN\PEDIDO\f"
    EXTENSAO=".DBF"
    @ 03,02 SAY "FORNECEDOR:"
    @ 03,52 SAY "FUNCIONARIO:"
    @ 04,00 SAY REPL ("ÍÍ",79)
    IF .NOT. FILE (CAMINHO+MCODNOT+EXTENSAO)
            @ 03,65 GET MCNOTFUNC PICT "99"
            FUNCI()
            READ
            IF LASTKEY()=27
                 SET KEY -8 TO OTARIOS() // F9
                 RETURN
            ENDIF
            ORDSETFOCUS("CODFUNC")
            
            SEEK MCNOTFUNC
            IF ! FOUND()
                 LOOP
            ENDIF
            MNOTFUNC=NOMEFUNC
            SETCOLOR("R*/BG,N/W")
            @ 03,65 SAY MNOTFUNC    
            FORNEC()
            ORDSETFOCUS("CODFOR")
            SET KEY -40 TO CONFOR1() // F11

            @ 03,15 GET MCODFOR PICT "999"
            READ
            IF LASTKEY()=27
                 SET KEY -40 TO OTARIOS() // F11
                 SET KEY -8 TO OTARIOS() // F9
                 RETURN
            ENDIF
            SEEK MCODFOR
            IF ! FOUND()
                RETURN
            ENDIF
            RDISTRIB=NOMEFOR
            @ 03,15 SAY RDISTRIB

            SET KEY -40 TO OTARIOS() // F11

            ARQ17:={}
            AADD (ARQ17, {"PCODPEC","C",05,00})
            AADD (ARQ17, {"PUNI","C",2,00})
            AADD (ARQ17, {"PNOMPEC","C",45,00})
            AADD (ARQ17, {"PPRECO","N",06,02})
            AADD (ARQ17, {"PPRETOT","N",08,02})
            AADD (ARQ17, {"PQTDPEC","N",03,00})
            AADD (ARQ17, {"PNFABRIC","C",12,00})
            AADD (ARQ17, {"PNFABRIC2","C",12,00})
            AADD (ARQ17, {"PFABRIC","C",10,00})
                    DBCREATE(CAMINHO+MCODNOT,ARQ17)

    ENDIF

    USE D:\KARVAN\PEDIDO\PEDIDO SHARED
    LOCATE FOR CCODNOT=MCODNOT
    
    IF ! FOUND()
           BLOQUEIO()
           APPEND BLANK
           REPLACE CFUNC    WITH MNOTFUNC
           REPLACE CDISTRIB WITH RDISTRIB
           REPLACE CCODNOT  WITH MCODNOT
           REPLACE CDATA    WITH MCDATA           
           COMMIT
           UNLOCK
         ELSE
            RDISTRIB=CDISTRIB
            MCDATA=CDATA           
            MNOTFUNC=CFUNC
            SETCOLOR("R*/BG,N/W")
            @ 01,65 SAY MCDATA
            @ 03,65 SAY MNOTFUNC    
            @ 03,15 SAY RDISTRIB
    ENDIF
    EXIT
ENDDO

    
    SETCOLOR("W+/BG,N/W")

                     
    PRIVATE V1[06], V2[06], V3[06]

    V1[01]="LEFT(PNOMPEC,30)"
    V1[02]="PFABRIC"
    V1[03]="PNFABRIC"
    V1[04]="PQTDPEC" 
    V1[05]="PPRECO"  
    V1[06]="PNFABRIC2"

       
    V2[01]="@!"
    V2[02]="@!"
    V2[03]="@!"
    V2[04]="999"
    V2[05]="9999.999"
    V2[06]="@!"
       
    V3[01]="APLICA€ŽO"
    V3[02]="FABRICANTE"
    V3[03]="N_FABRICANTE"
    V3[04]="QTD"
    V3[05]="CUSTO"
    V3[06]="N_FABRICANTE2"

USE &CAMINHO&MCODNOT EXCLUSIVE
DO WHILE NETERR()
        SETCOLOR("W+*/R,N/W")
        OL_Yield()
        ALERT ('EXISTE ARQUIVO(S) ABERTO EM OUTRO TERMINAL VERIFIQUE !!!')
        USE &CAMINHO&MCODNOT EXCLUSIVE
ENDDO


DBEDIT(05,02,22,77,v1,"LKIDBED",v2,v3,chr(205),space(1)+chr(179))


function LKIDBED(MODO,COLUNA)

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

       ELSEIF LASTKEY()== 13 && "ENTER"
              TELA1=SAVESCREEN(07,02,21,78)

              NFABRQTD=0
              TELA=SAVESCREEN(07,02,21,78)
              SETCOLOR("R/BG,N/W")
              MPCODBAR=SPACE(20)
              MPCODPEC=SPACE(05)
              PEDPECA()
              USE &CAMINHO&MCODNOT SHARED
              SOMATOTAL()
              @ 24,50 SAY MPTOTG PICT "999,999.99"

       elseif lastkey()== 400 && "CTRL+ +"
          
          BLOQUEIO()
          MPCODPEC=PCODPEC
          MPNOMPEC=PNOMPEC
          REPLACE PQTDPEC WITH PQTDPEC+1
          DBCOMMIT()
          SOMATOTAL()
          UNLOCK
          PECAS()
          ORDSETFOCUS("CODPECA")
          SEEK MPCODPEC
          IF FOUND()
                BLOQUEIO()
                REPLACE TEMPPED WITH TEMPPED+1
                UNLOCK
          ENDIF
          USE &CAMINHO&MCODNOT SHARED
          INDEX ON PNOMPEC TO PNOMPEC
          SEEK MPNOMPEC

       elseif lastkey()== 398 && "CTRL+ -"

          BLOQUEIO()            
          MPCODPEC=PCODPEC
          MPNOMPEC=PNOMPEC
          IF PQTDPEC > 1
                  REPLACE PQTDPEC WITH PQTDPEC-1
                  DBCOMMIT()
                  SOMATOTAL()
                  UNLOCK
                  PECAS()
                  ORDSETFOCUS("CODPECA")
                  SEEK MPCODPEC
                  IF FOUND()
                        BLOQUEIO()
                        REPLACE TEMPPED WITH TEMPPED-1
                        UNLOCK
                  ENDIF
          ENDIF
          USE &CAMINHO&MCODNOT SHARED
          INDEX ON PNOMPEC TO PNOMPEC
          SEEK MPNOMPEC
        
       ELSEIF LASTKEY()== -1 && "F2"

               IF CONFIRMA ("DESEJA LIMPAR ESSE PEDIDO?")=1
                  USE &CAMINHO&MCODNOT EXCLUSIVE
                  NUMREG=1
                  DO WHILE ! EOF()
                        @ 03,45 SAY NUMREG PICT (9999)
                        GOTO NUMREG
                        MPCODPEC=PCODPEC
                        MPQTDPEC=PQTDPEC
                        PECAS()
                        ORDSETFOCUS("CODPECA")
                        SEEK MPCODPEC
                        BLOQUEIO()
                        REPLACE TEMPPED WITH TEMPPED-MPQTDPEC
                        DBCOMMIT()
                        IF TEMPPED < 0
                                REPLACE TEMPPED WITH 0
                        ENDIF
                        UNLOCK
                        DBCOMMIT()
                        USE &CAMINHO&MCODNOT EXCLUSIVE
                        NUMREG++
                        GOTO NUMREG
                  ENDDO
                  USE &CAMINHO&MCODNOT EXCLUSIVE
                  BLOQUEIO()
                  ZAP
                  PACK
                  UNLOCK
                  RETURN(0)
               ENDIF
        
       ELSEIF LASTKEY()== 07 && "DELETE"

               BLOQUEIO()
               MPCODPEC=PCODPEC
               MPQTDPEC=PQTDPEC
               USE &CAMINHO&MCODNOT EXCLU
               BLOQUEIO()
               INDEX ON PCODPEC TO PCODPEC
               SEEK MPCODPEC
               DELETE
               PACK
               KEYBOARD+CHR(13)
               UNLOCK

               USE &CAMINHO&MCODNOT SHARED
               SOMATOTAL()
               @ 24,50 SAY MPTOTG PICT "999,999.99"
               PECAS()
               ORDSETFOCUS("CODPECA")
               SEEK MPCODPEC
               BLOQUEIO()
               REPLACE TEMPPED WITH TEMPPED-MPQTDPEC
               DBCOMMIT()
               IF TEMPPED < 0
                        REPLACE TEMPPED WITH 0
               ENDIF
               UNLOCK
               OL_Yield()
               ALERT('PECA EXCLUIDA COM EXITO')
               USE &CAMINHO&MCODNOT SHARED

         elseif lastkey()== -2   && "F3 CANCELA PEDIDO"
                                     
                CAMINHO3="C:\"
                EXTENSAO2=".TXT"
                INDEX ON PFABRIC+PNOMPEC TO PFAPNOM
                MPFABRIC="PFABRIC"
                Delete File(CAMINHO3+RDISTRIB+EXTENSAO2)
                H_Handle := fcreate(CAMINHO3+RDISTRIB+EXTENSAO2)

                DO WHILE .T.               
                          HANDLE := FOPEN(CAMINHO3+RDISTRIB+EXTENSAO2, 2)
		                      IF FERROR() # 0
                                    SETCOLOR("W+/R,N/W")
		                                @ 10,18 CLEAR TO 12,48
		                                @ 10,18 TO 12,48 DOUBLE
		                                SETCOLOR("W+*/R,N/W")
		                                @ 11,19 SAY "TENTANDO ACESSO, AGUARDE !!!"
		                                INKEY(0.1)
		                                SETCOLOR("W+/BG,N/W")
		                                @ 10,18 CLEAR TO 12,48
		                                LOOP
		                            ELSE
		                                EXIT
		                      ENDIF
		            ENDDO

                BUFFER=SPACE(1024)
                BLOCO=1024
                DO WHILE FREAD(HANDLE,@BUFFER,BLOCO) # 0
                       FREAD(HANDLE,@BUFFER,BLOCO)
                ENDDO
                FWRITE(HANDLE,SPACE(10))
                FWRITE(HANDLE,"JQ KARVAN COM.DE PE€AS LTDA  FONE/FAX: 2404-6100")
                FWRITE(HANDLE,+CHR(13)+CHR(10))
                FWRITE(HANDLE,+CHR(13)+CHR(10))
                FWRITE(HANDLE,"COD.FABRIC")
                FWRITE(HANDLE,SPACE(07))
                FWRITE(HANDLE,"QTD")
                FWRITE(HANDLE,+CHR(13)+CHR(10))
                DO WHILE ! EOF()
                        IF MPFABRIC#PFABRIC
                                MPFABRIC=PFABRIC
                                FWRITE(HANDLE,+CHR(13)+CHR(10))
                                FWRITE(HANDLE,PFABRIC)
                        ENDIF        
                        FWRITE(HANDLE,+CHR(13)+CHR(10))
                        FWRITE(HANDLE,PNFABRIC)
                        FWRITE(HANDLE,SPACE(2))
                        FWRITE(HANDLE,"=")
                        FWRITE(HANDLE,STR(PQTDPEC))
                        FWRITE(HANDLE,SPACE(1))
                        FWRITE(HANDLE,PUNI)
                        SKIP
                        IF MPFABRIC=PFABRIC
                                FWRITE(HANDLE,SPACE(20))
                                FWRITE(HANDLE,PNFABRIC)
                                FWRITE(HANDLE,SPACE(2))
                                FWRITE(HANDLE,"=")
                                FWRITE(HANDLE,STR(PQTDPEC))
                                FWRITE(HANDLE,SPACE(1))
                                FWRITE(HANDLE,PUNI)
                                SKIP
                        ENDIF
               ENDDO
               OP=2
               RETURN(0)
         elseif lastkey()== -5   && "F6 ZERA OS PEDIDOS"
               
               IF CONFIRMA ("DESEJA ZERA TODOS OS PEDIDO?")=1
                        PECAS()
                        GOTO TOP
                        DO WHILE ! EOF()
                                IF TEMPPED#0
                                        BLOQUEIO()
                                        REPLACE TEMPPED WITH 0
                                        UNLOCK
                                ENDIF
                                SKIP
                        ENDDO
                        RUN DEL D:\KARVAN\PEDIDO\*.*
               ENDIF
               RETURN(0)
                                     
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
                
        elseif lastkey()== 54 && "6"

          NTX=5
          CLEAR GETS
          SET CURSOR ON
          INDEX ON PNFABRIC2 TO PNFABRIC2
          SET SOFTSEEK ON
          SETCOLOR("W+/BG,N/W")
          V_BUSCA:=SPACE(12)
          @ 06,20 CLEAR TO 08,47
          @ 06,20 TO 08,47 DOUBLE
          @ 07,22 SAY "N§ FABRIC2:" GET V_BUSCA PICT "@!"
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
