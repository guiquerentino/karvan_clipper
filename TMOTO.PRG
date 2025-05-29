****************************************************************************

*****************************************************************************
    TERMINAL=NETNAME()    
    IF ALLTRIM(UPPER(TERMINAL))="LIBERA"
		    MOTOBOY()
                    NUMREG=1
		    GOTO NUMREG
		    DO WHILE ! EOF()
		        MOTOBOY()
		        GOTO NUMREG
		        IF ! EMPTY(CHEGADA)
		                IF SomaH1:=SEC2TIME( TIME2SEC(TIME())-TIME2SEC(CHEGADA) ) > TESTATIME
		                        SomaH1=SEC2TIME( TIME2SEC(TIME())-TIME2SEC(CHEGADA) )
		                        ENTREGA()
                                        QTD_ENT=0
                                        DO WHILE ! EOF()
                                             QTD_ENT++
                                             SKIP
                                        ENDDO
		                        ORDSETFOCUS("CODIGO")
		                        GOTO TOP
		                        IF EOF()
		                                RETURN
		                        ENDIF
                                        IF SomaH:=SEC2TIME( TIME2SEC(TIME())-TIME2SEC(HORA) ) > "00:10:00";
                                           .or. QTD_ENT >= 15
		                                CLOSE ALL
		                                SAVE SCREEN TO FTELA
		                                SETCOLOR("W+*/B*+,N*/W*")
		                                @ 08,22 CLEAR TO 14,54
		                                @ 08,22 TO 14,54 DOUBLE
		                                @ 11,23 SAY "LIBERE O MOTOBOY, POR FAVOR !!!"
                                                INKEY(0)
                                                IF LASTKEY()=-6
                                                        SAIDA()
                                                ENDIF
                                                IF LASTKEY()=-8
                                                        ENTRE()
                                                ENDIF
                                                TMOTO()
                                                *TESTATIME:=SEC2TIME( TIME2SEC(SOMAH1)+TIME2SEC("00:00:10") )
		                                RETURN
		                        ENDIF
		                ENDIF
		        ENDIF
		        NUMREG++
    		ENDDO
        ENDIF
RETURN



