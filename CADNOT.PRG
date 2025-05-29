DO WHILE .T.

    CONFERE="S"
    IMPRIME=0    

    CLEAR GETS
    PUVARPED()
    INIVAPED()
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
    MXML=SPACE(44)
    @ 01,02 SAY "N§ NOTA.:"    
    @ 01,12 GET  MXML  PICT "@!" VALID MXML # " "
    READ
    INKEY(0)
    IF CONFIRMA("CONFIRMA XML ???")=2
        RETURN
    ENDIF    
    IF LEN(ALLTRIM(MXML))=44
            MCODNOT=SUBSTR(MXML, 26,9)
            MCNPJFOR=(SUBSTR(MXML, 07,14))
            MCNPJ=SPACE(18)
            FOR I=1 TO 18
                IF I=3 .OR. I=6 
                        MCNPJ+="."
                ENDIF
                IF I=9
                        MCNPJ+="/"
                ENDIF        
                IF I=13
                        MCNPJ+="-"
                ENDIF             
                MCNPJ+=SUBSTR(MCNPJFOR,I,1)
            NEXT
            MCNPJFOR=ALLTRIM(MCNPJ)
         ELSE
            MCODNOT=STRZERO(VAL(MXML),9)
    ENDIF
    ABRENOTA=ALLTRIM(RIGHT(MCODNOT,7))
    @ 03,65 GET MCNOTFUNC PICT "99" VALID MCNOTFUNC > 0
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
    SETCOLOR("W+/BG,N/W") 
    IF LASTKEY()=27
        RETURN
    ENDIF
    NTX=1
    MFECHA="N"
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
    CONTZEBRA=0
    LINZEBRA=-255
    CAMINHO="d:\KARVAN\CONFERE\c"
    CAMINHO2="d:\KARVAN\CONFERE\f"
    EXTENSAO=".DBF"
    @ 03,02 SAY "FORNECEDOR:"
    @ 03,53 SAY "FUNCIONARIO:"
    @ 04,00 SAY REPL ("ÍÍ",79)
    IF .NOT. FILE (CAMINHO+ABRENOTA+EXTENSAO)
            FORNEC()
            IF LEN(ALLTRIM(MXML))<44
                    SET KEY -40 TO CONFOR1() // F11
                    @ 03,15 GET MCODFOR PICT "999" VALID MCODFOR > 0
                    READ
                    ORDSETFOCUS("CODFOR")
                    SEEK MCODFOR
                    IF LASTKEY()=27
                        SET KEY -40 TO OTARIOS() // F11
                        SET KEY -8 TO OTARIOS() // F9
                        RETURN
                    ENDIF
                 ELSE
                    ORDSETFOCUS("CNPJFOR")
                    SEEK MCNPJFOR
            ENDIF
            IF ! FOUND()
                ALERT('FORNECEDOR NAO ENCONTRADO!; FAVOR EFETUAR CADASTRO !!!')
                RETURN
            ENDIF
            RDISTRIB=NOMEFOR
            @ 03,15 SAY RDISTRIB
            SET KEY -40 TO OTARIOS() // F11

            ARQ15:={}
            AADD (ARQ15, {"PCODPEC ","C",05,00})
            AADD (ARQ15, {"DIGITO ","C",02,00})
            AADD (ARQ15, {"PNOMPEC ","C",45,00})
            AADD (ARQ15, {"PC_PRECO","N",09,03})
            AADD (ARQ15, {"PPRECO  ","N",09,02})
            AADD (ARQ15, {"PPRETOT ","N",09,02})
            AADD (ARQ15, {"PPRETOT2","N",09,02})
            AADD (ARQ15, {"PQTDPEC ","N",03,00})
            AADD (ARQ15, {"PQTDPEC2","N",03,00})
            AADD (ARQ15, {"PNFABRIC","C",12,00})
            AADD (ARQ15, {"VERIFIC","N",1,00})
            AADD (ARQ15, {"NCM","C",8,00})
            AADD (ARQ15, {"CFOP","C",4,00})
            AADD (ARQ15, {"PFABRIC ","C",10,00})
            AADD (ARQ15, {"NOTFUNC ","C",10,00})
            AADD (ARQ15, {"LOCAL ","C",10,00})
                    DBCREATE(CAMINHO+ABRENOTA,ARQ15)

    ENDIF

    USE d:\KARVAN\CONFERE\CONFERE SHARED
    DO WHILE NETERR()
        SETCOLOR("W+*/R,N/W")
        OL_Yield()
        ALERT ('EXISTE ARQUIVO(S) ABERTO EM OUTRO TERMINAL VERIFIQUE !!!')
        USE d:\KARVAN\CONFERE\CONFERE SHARED
    ENDDO

    LOCATE FOR CCODNOT=MCODNOT
    
    IF ! FOUND()
           BLOQUEIO()
           APPEND BLANK
           REPLACE CFUNC    WITH MNOTFUNC
           REPLACE CDISTRIB WITH RDISTRIB
           REPLACE CCODNOT  WITH MCODNOT
           REPLACE CDATA    WITH MCDATA
	   REPLACE FECHA    WITH MFECHA
           REPLACE XML      WITH MXML    
           COMMIT
           UNLOCK
         ELSE
            BLOQUEIO()
            REPLACE CFUNC WITH MNOTFUNC
            UNLOCK
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
    USE &CAMINHO&ABRENOTA EXCLU
    DO WHILE NETERR()
    OL_Yield()
           ALERT('NOTA ABERTA EM OUTRO TERMINAL !!!')
           USE &CAMINHO&ABRENOTA EXCLUSIVE
           RETURN(0)
    ENDDO
    IF CONFIRMA("LIBERAR IMPRESSORA DE ETIQUETA?")=1

                IMPRIME=1
    ENDIF
    PRIVATE V1[10], V2[10], V3[10]

    V1[01]="LEFT(PNOMPEC,30)"
    V1[02]="PFABRIC"
    V1[03]="PNFABRIC"
    V1[04]="PQTDPEC" 
    V1[05]="PQTDPEC2"  
    V1[06]="PC_PRECO"  
    V1[07]="PPRECO"  
    V1[08]="LOCAL"
    V1[09]="NCM"
    V1[10]="CFOP"

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

    V3[01]="APLICA€ŽO"
    V3[02]="FABRICANTE"
    V3[03]="NFABRIC"
    V3[04]="QTD"
    V3[05]="QTD2"
    V3[06]="CUSTO"
    V3[07]="PRECO"
    V3[08]="LOCAL"
    V3[09]="NCM"
    V3[10]="CFOP"
    
DBEDIT(05,02,22,77,v1,"KKIDBED",v2,v3,chr(205),space(1)+chr(179))


function KKIDBED(MODO,COLUNA)

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
        DO WHILE .T.
              NFABRQTD=0
              TELA=SAVESCREEN(07,02,21,78)
              SETCOLOR("R/BG,N/W")
              MPCODBAR=SPACE(20)
              MPCODPEC=SPACE(05)
              MDIGITO=SPACE(02)
              USE &CAMINHO&ABRENOTA SHARED
              SOMATOTAL()

              @ 24,47 SAY MPTOTG PICT "9999999.99"
              @ 24,57 SAY MPTOTG2 PICT "9999999.99"
              @ 24,67 SAY VENDATOTAL PICT "99999999.99"
              MPQTDPEC=1
              @ 24,00 CLEAR TO 22,24
              @ 24,01 GET MPCODBAR PICT "@!"

              READ
              IF LASTKEY()=27

                  SET KEY -41 TO OTARIOS() // F12                  
                  RESTSCREEN(07,02,19,78,TELA1)
                  IF ! EOF()
                     KEYBOARD CHR(03)
                  ENDIF
                  RETURN(1)
              ENDIF
              PECAS()
              ORDSETFOCUS("CODBARRA")              
              SEEK MPCODBAR              
              BARRA=1
              IF ! FOUND() .AND. MPCODBAR # SPACE(20)
                    ORDSETFOCUS("CODBARRA1")
                    SEEK MPCODBAR
                    BARRA=2
                    IF ! FOUND() 
                         ORDSETFOCUS("CODBARRA2")
                         SEEK MPCODBAR
                         BARRA=3
                         IF ! FOUND()
                             ORDSETFOCUS("CODBARRA3")
                             SEEK MPCODBAR
                             BARRA=4
                             IF ! FOUND()
                                 ORDSETFOCUS("CODBARRA4")
                                 SEEK MPCODBAR
                                 BARRA=5
                                 IF ! FOUND()
                                      TONE(200,26)
                                      OL_Yield()
                                      ALERT ('CODIGO NÇO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                                      NFABRQTD=1
                                  ENDIF
                             ENDIF     
                         ENDIF    
                    ENDIF
              ENDIF
              MPQTDPEC=1
              IF NFABRQTD=1 .OR. MPCODBAR = SPACE(20)
                   @ 24,00 CLEAR TO 24,21
                   @ 24,01 SAY "CODIGO:"
                   @ 24,09 GET MPCODPEC PICT "@!"
                   @ 24,15 GET MDIGITO PICT "99"
                   READ
                   ORDSETFOCUS("CODPECA")
                   SEEK MPCODPEC
                   BARRA=VAL(SUBSTR(MDIGITO,2,1))
                   IF ! FOUND()
                       TONE(200,26)
                       OL_Yield()
                       ALERT ('CODIGO NÇO EXISTE VERIFIQUE O ERRO ; E TENTE NOVAMENTE')
                       LOOP
                   ENDIF
                   IF MDIGITO#DIGITO .OR. BARRA > 5
                   OL_Yield()
                         ALERT('DIGITO VERIFICADOR INCORRETO')
                         LOOP
                   ENDIF
                   @ 24,17 SAY "QTD:" GET MPQTDPEC PICT "999" VALID MPQTDPEC > 0
                   READ
              ENDIF
              IF LASTKEY()=27
                  LOOP
              ENDIF
              IF TRAVA="A"
              OL_Yield()
                    ALERT('PRODUTO SENDO ALTERADO EM OUTRO TERMINAL; IMPOSSIVEL ADICIONAR, AGUARDE!!!')
                    LOOP
              ENDIF      

              BLOQUEIO()
              IF BARRA<=1
                     REPLACE CQTD2 WITH CQTD2+MPQTDPEC
                     MPFABRIC=FABRIC
                     MPNFABRIC=NFABRIC
                 ELSEIF BARRA=2
                     MPFABRIC=FABRIC2
                     MPNFABRIC=NFABRIC2
                     IF EMPTY(MPFABRIC)
                     OL_Yield()
                           ALERT('DIGITO VERIFICADOR INCORRETO')
                           LOOP
                     ENDIF
                     REPLACE CQTD3 WITH CQTD3+MPQTDPEC
                 ELSEIF BARRA=3
                     MPFABRIC=FABRIC3
                     MPNFABRIC=NFABRIC3
                     IF EMPTY(MPFABRIC)
                     OL_Yield()
                           ALERT('DIGITO VERIFICADOR INCORRETO')
                           LOOP
                     ENDIF
                     REPLACE CQTD4 WITH CQTD4+MPQTDPEC
                 ELSEIF BARRA=4
                     MPFABRIC=FABRIC4
                     MPNFABRIC=NFABRIC4
                     IF EMPTY(MPFABRIC)
                     OL_Yield()
                           ALERT('DIGITO VERIFICADOR INCORRETO')
                           LOOP
                     ENDIF
                     REPLACE CQTD5 WITH CQTD5+MPQTDPEC
                 ELSEIF BARRA=5
                     MPFABRIC=FABRIC5
                     MPNFABRIC=NFABRIC5
                     IF EMPTY(MPFABRIC)
                     OL_Yield()
                           ALERT('DIGITO VERIFICADOR INCORRETO')
                           LOOP
                     ENDIF
                     REPLACE CQTD6 WITH CQTD6+MPQTDPEC
              ENDIF
              UNLOCK
              MPPRECO=PRECO              
              MPC_PRECO=P_CUSTO
              MPCODPEC=CODPECA
              MDIGITO=DIGITO
              MPNOMPEC=NOMEPECA
              MLOCAL=LOCAL
              MLOCAL_E=LOCAL_E
              MNCM=NCM
              MCFOP=CFOP
              *MLACRE=LACRE
              SETCOLOR("R/BG,N/W")
              @ 24,32 SAY MLOCAL
              SETCOLOR("W+/BG,N/W")
              BLOQUEIO()
              REPLACE TEMP WITH TEMP+MPQTDPEC              
              IF TEMPPED-MPQTDPEC < 0
                    REPLACE TEMPPED WITH 0
                  ELSE
                    REPLACE TEMPPED WITH TEMPPED-MPQTDPEC
              ENDIF         
              IF EMPTY(NOTA) .OR. NOTA=MCODNOT
                      REPLACE NOTA WITH MCODNOT
                  ELSEIF EMPTY(NOTA10) .OR. NOTA10=MCODNOT
                      REPLACE NOTA10 WITH MCODNOT
                  ELSEIF EMPTY(NOTA11) .OR. NOTA11=MCODNOT
                      REPLACE NOTA11 WITH MCODNOT
              ENDIF
              ETIQ_EST="N"
              IF QTD_C>0
                        XMQTD=MPQTDPEC
                        DO WHILE QTD_P<QTD_C .AND. XMQTD>0
                                REPLACE QTD_P WITH QTD_P+1
                                XMQTD--
                        ENDDO                
                        IF XMQTD>0
                                ETIQ_EST="S"
                                REPLACE QTD_E WITH QTD_E+XMQTD
                        ENDIF        
              ENDIF
              COMMIT
              UNLOCK              
              MPPRETOT=MPC_PRECO*MPQTDPEC
              IF IMPRIME=1
                    ZEBRA()
              ENDIF
              USE &CAMINHO&ABRENOTA SHARED
              INDEX ON PCODPEC TO PCODPEC FOR VERIFIC=BARRA
              SEEK MPCODPEC
              BLOQUEIO()
              IF FOUND()
                 MPQTDPEC=PQTDPEC+MPQTDPEC
                 REPLACE PQTDPEC WITH MPQTDPEC
                 REPLACE PPRETOT WITH MPC_PRECO*PQTDPEC
                ELSE
                 APPEND BLANK
                 REPLACE VERIFIC  WITH BARRA                 
                 REPLACE PC_PRECO WITH MPC_PRECO
                 REPLACE PPRECO   WITH MPPRECO
                 REPLACE PCODPEC  WITH MPCODPEC
                 REPLACE DIGITO   WITH MDIGITO
                 REPLACE PNOMPEC  WITH MPNOMPEC
                 REPLACE NCM      WITH MNCM
                 REPLACE CFOP     WITH MCFOP
                 REPLACE PQTDPEC  WITH MPQTDPEC
                 REPLACE PFABRIC  WITH MPFABRIC
                 REPLACE PNFABRIC WITH MPNFABRIC
                 REPLACE NOTFUNC  WITH MNOTFUNC
                 REPLACE PPRETOT  WITH MPC_PRECO*PQTDPEC
                 REPLACE LOCAL    WITH MLOCAL
              ENDIF
              COMMIT
              UNLOCK
              SOMATOTAL()
              @ 24,47 SAY MPTOTG PICT "9999999.99"
              @ 24,57 SAY MPTOTG2 PICT "9999999.99"
              @ 24,67 SAY VENDATOTAL PICT "99999999.99"
              @ 24,22 SAY MPCODPEC PICT "99999"
              @ 24,28 SAY MDIGITO PICT "9"
              @ 24,29 SAY BARRA PICT "9"
              @ 07,06 SAY LEFT(MPNOMPEC,30)
              @ 07,38 SAY MPFABRIC
              @ 07,50 SAY MPNFABRIC
              @ 07,64 SAY MPQTDPEC PICT "999"              
              RESTSCREEN(08,02,20,78,TELA)
        ENDDO

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
               IF QTD_C>0
                       XMQTD=MPQTDPEC
                       DO WHILE QTD_P>0 .AND. XMQTD>0
                               REPLACE QTD_P WITH QTD_P-1
                               XMQTD--
                       ENDDO                
                       IF XMQTD>0
                               REPLACE QTD_E WITH QTD_E-XMQTD
                       ENDIF        
               ENDIF
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
               @ 24,67 SAY VENDATOTAL PICT "99999999.99"
               OL_Yield()
               ALERT('PECA EXCLUIDA COM EXITO')
               RETURN(1)

           ELSEIF lastkey() == 80 .or. lastkey() == 112 && "P/p"

                MPCODPEC=PCODPEC
                MPNOMPEC=PNOMPEC
                MPFABRIC=PFABRIC
                MPNFABRIC=PNFABRIC
                BARRA=VERIFIC
                PECAS()
                ORDSETFOCUS("CODPECA")
                SEEK MPCODPEC
                MLOCAL=LOCAL
                MDIGITO=DIGITO
                ZEBRA()
                USE &CAMINHO&ABRENOTA SHARED
                INDEX ON PCODPEC TO PCODPEC
                SEEK MPCODPEC

         elseif lastkey()== -3   && "F4 CANCELA PEDIDO"

                SET KEY -8 TO OTARIOS() // F9
                CLS
                RUN DEL c:\karvan\*.tmp
                RUN DEL c:\karvan\*.txt
                CLOSE ALL
                BREAK
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
     ENDIF             
ENDIF
RETURN(1)
