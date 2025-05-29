***********************************/FUN€AO ORCAMEN****************************
IF .NOT. FILE ("D:\KARVAN\ORCA.DBF")
        ARQ12:={}
        AADD(ARQ12,{"CODNOT",   "N",09,0})
        AADD(ARQ12,{"NOTCLI",   "C",35,0})
        AADD(ARQ12,{"NOTFUNC",  "C",10,0})
        AADD(ARQ12,{"NOTPAG",   "C",10,2})
        AADD(ARQ12,{"NOTTOTG",  "N",15,2})
        AADD(ARQ12,{"D_NOT",    "D",08,0})
        AADD(ARQ12,{"PCUSTO",   "N",10,2})
        AADD(ARQ12,{"HORANOT",  "C",05,0})
        DBCREATE("D:\KARVAN\ORCA",ARQ12)
ENDIF
IF .NOT. FILE ("D:\KARVAN\ORCAPED.DBF")
        ARQ6:={}
        AADD (ARQ6,{"PEDCOD  ","C",05,00})
        AADD (ARQ6,{"PEDNUM  ","N",09,00})
        AADD (ARQ6,{"PEDQTD  ","N",03,00})
        AADD (ARQ6,{"PRECOCUP","N",08,02})
        AADD (ARQ6,{"DATACUP ","D",08,00})
        DBCREATE("D:\KARVAN\ORCAPED", ARQ6)
ENDIF
IF .NOT. FILE ("D:\KARVAN\ORCAPED.CDX")
        REINORPE()
ENDIF
IF .NOT. FILE ("D:\KARVAN\ORCA.CDX")
        REINORCA()
ENDIF
MTEL=SPACE(10)
DO WHILE .T.

    CLEAR GETS
    PUVARPED()
    INIVAPED()
    SETCOLOR("W+/R,N/W")
    CLS
    HOJE=DATE()
    @ 00,00 TO 02,79 DOUBLE 
    @ 00,02 SAY " MICRO - PE€AS INFORMATICA 5.2 "
    SETCOLOR("R*/R,N/W")
    @ 01,27 SAY "³     ORCAMENTO      ³"
    @ 23,27 SAY "      ORCAMENTO       "
    SETCOLOR("W+/R,N/W")
    @ 01,53 SAY "DATA......:"
    @ 01,65 SAY DATE()
    @ 06,01 TO 21,78 DOUBLE
    @ 22,62 SAY "TOTAL:"
    @ 22,46 SAY "DESC:"
    @ 22,02 SAY "CODIGO...:"
    @ 22,25 SAY "QTD...:" 
    MD_NOT=DATE()
    ORCA()
    CLOSE INDEXES
    GOTO BOTTOM
    MCODNOT=CODNOT+1
    @ 01,02 SAY "ORCAMENTO:"
    @ 01,12 SAY  MCODNOT PICT "999999999"
    @ 03,02 SAY "CLIENTE...:"
    @ 03,52 SAY "FUNCIONARIO:"
    @ 04,00 SAY REPL ("ÍÍ",79)
    @ 03,65 GET MCNOTFUNC PICT "99"
    FUNCI()
    READ
    IF LASTKEY()=27
         SET KEY -8 TO OTARIOS() // F9
         EXIT
    ENDIF
    ORDSETFOCUS("CODFUNC")
    
    SEEK MCNOTFUNC
    IF ! FOUND()
         LOOP
    ENDIF
    MNOTFUNC=NOMEFUNC
    @ 03,65 SAY MNOTFUNC
    CLIENTES()
    
    SET KEY -40 TO CONCLI1() // F11
                                
    @ 03,13 GET MCNOTCLI PICT "9999"
    READ
    ORDSETFOCUS("CODCLI")
    SEEK MCNOTCLI
    MNOTCLI=NOMECLI
    MENDCLI=ENDCLI
    MTAXA=TAXA
    MTAXA_DUPLA=TAXA_DUPLA
    MTEL=TEL    
    SET KEY -40 TO OTARIOS() // F11        

    IF LASTKEY()=27
        RETURN(.T.)
      ELSEIF MCNOTCLI=0
       SET ESCAPE OFF
       LETRAALETRA()
       SET ESCAPE ON
      ELSEIF ! FOUND()
      OL_Yield()
         ALERT ('CLIENTE NAO CADASTRADO !!!')
         LOOP
    ENDIF                                                                     
    IF EMPTY(MNOTCLI)
        LOOP
    ENDIF
    @ 03,13 SAY MNOTCLI
    KEYBOARD CHR(13)
    CLIENTES()
    CONPEC=1    
    PEDORCA()
ENDDO
