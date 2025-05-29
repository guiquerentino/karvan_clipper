*****************************/FUN€AO CADASTRA ESTOQUE MAXIMO******************

IF ACESSO#1 .OR. ALLTRIM(FUNCIONARIO) # "MARCELO"
OL_Yield() 
     ALERT('ACESSO NAO AUTORIZADO')
     RETURN(.T.)
ENDIF

ANO=YEAR(DATE())
MES=MONTH(DATE())

RUN COPY D:\KARVAN\CUPOM.DBF C:\TEMP
RUN COPY D:\KARVAN\CUPOM.CDX C:\TEMP

RUN COPY D:\KARVAN\PEDCUP.DBF C:\TEMP
RUN COPY D:\KARVAN\PEDCUP.CDX C:\TEMP

USE C:\TEMP\CUPOM
ORDSETFOCUS("CODNOT")
COPY TO C:\TEMP\CUPOM1 FOR MONTH(D_NOT)=MES .AND. YEAR(D_NOT)=ANO

MES=MONTH(DATE())-1
IF MES=0
        MES=12
        ANO=YEAR(DATE())-1
ENDIF    
IF MES=-1 
        MES=11
        ANO=YEAR(DATE())-1
ENDIF        
COPY TO C:\TEMP\CUPOM2 FOR MONTH(D_NOT)=MES .AND. YEAR(D_NOT)=ANO

MES=MONTH(DATE())-2
IF MES=0 
        MES=12
        ANO=YEAR(DATE())-1
ENDIF        
IF MES=-1 
        MES=11
        ANO=YEAR(DATE())-1
ENDIF        
IF MES=-2 
        MES=10
        ANO=YEAR(DATE())-1
ENDIF        
COPY TO C:\TEMP\CUPOM3 FOR MONTH(D_NOT)=MES .AND. YEAR(D_NOT)=ANO

MES=MONTH(DATE())-3
IF MES=0 
        MES=12
        ANO=YEAR(DATE())-1
ENDIF        
IF MES=-1 
        MES=11
        ANO=YEAR(DATE())-1
ENDIF        
IF MES=-2 
        MES=10
        ANO=YEAR(DATE())-1
ENDIF        
IF MES=-3 
        MES=09
        ANO=YEAR(DATE())-1
ENDIF        
COPY TO C:\TEMP\CUPOM4 FOR MONTH(D_NOT)=MES .AND. YEAR(D_NOT)=ANO

N=1
DO WHILE N<5
        IF N=1
                USE C:\TEMP\CUPOM1
             ELSEIF N=2
                USE C:\TEMP\CUPOM2
             ELSEIF N=3
                USE C:\TEMP\CUPOM3
             ELSEIF N=4
                USE C:\TEMP\CUPOM4
        ENDIF
        INDEX ON CODNOT TO CODNOT
        GOTO TOP
        CODINI=CODNOT
        GOTO BOTTOM
        CODFIM=CODNOT
        USE C:\TEMP\PEDCUP        
        IF N=1
                COPY TO C:\TEMP\PEDCUP1 FOR PEDNUM>=CODINI .AND. PEDNUM<=CODFIM
             ELSEIF N=2
                COPY TO C:\TEMP\PEDCUP2 FOR PEDNUM>=CODINI .AND. PEDNUM<=CODFIM
             ELSEIF N=3
                COPY TO C:\TEMP\PEDCUP3 FOR PEDNUM>=CODINI .AND. PEDNUM<=CODFIM
             ELSEIF N=4
                COPY TO C:\TEMP\PEDCUP4 FOR PEDNUM>=CODINI .AND. PEDNUM<=CODFIM
        ENDIF
        N++
ENDDO
SELE 2
USE C:\TEMP\PEDCUP1
SELE 3
USE C:\TEMP\PEDCUP2
SELE 4
USE C:\TEMP\PEDCUP3 
SELE 5
USE C:\TEMP\PEDCUP4 

SELE 1
PECAS()
MPEDQTD=0
DO WHILE ! EOF()
	BLOQUEIO()
        REPLACE QTDMAX  WITH MPEDQTD
        REPLACE QTDMAX1 WITH MPEDQTD
        REPLACE QTDMAX2 WITH MPEDQTD
        REPLACE QTDMAX3 WITH MPEDQTD
        SKIP
ENDDO
DBCOMMIT()
UNLOCK
@ 11,16 CLEAR TO 13,40
@ 11,16 TO 13,40 DOUBLE
NUMREG=LASTREC()
@ 07,16 CLEAR TO 09,40
@ 07,16 TO 09,40 DOUBLE
DO WHILE NUMREG>=1
        SELE 1
        @ 08,17 SAY NUMREG 
        GOTO NUMREG
        MCODPECA=CODPECA
        N=1
        MPEDQTD=0
        MPEDQTD1=0
        MPEDQTD2=0
        MPEDQTD3=0
        DO WHILE N<5
                IF N=1
                        SELE 2
                    ELSEIF N=2
                        SELE 3
                    ELSEIF N=3
                        SELE 4
                    ELSEIF N=4
                        SELE 5
                ENDIF
                NUMREG2=LASTREC()
                DO WHILE NUMREG2>=1
                        GOTO NUMREG2
                        @ 12,17 SAY NUMREG2
                        IF PEDCOD=MCODPECA
                                IF N=1
                                        MPEDQTD=PEDQTD+MPEDQTD
                                    ELSEIF N=2
                                        MPEDQTD1=PEDQTD+MPEDQTD1
                                    ELSEIF N=3
                                        MPEDQTD2=PEDQTD+MPEDQTD2
                                    ELSEIF N=4
                                        MPEDQTD3=PEDQTD+MPEDQTD3
                                ENDIF
                        ENDIF
                        NUMREG2--
                ENDDO
                N++
        ENDDO
        SELE 1
        GOTO NUMREG
        BLOQUEIO()
        REPLACE QTDMAX  WITH MPEDQTD+QTDMAX
        REPLACE QTDMAX1 WITH MPEDQTD1
        REPLACE QTDMAX2 WITH MPEDQTD2
        REPLACE QTDMAX3 WITH MPEDQTD3
        UNLOCK
        NUMREG--
ENDDO
          
RETURN

