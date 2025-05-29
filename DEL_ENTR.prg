           elseif lastkey()== 07 && "DELETE"
                IF CONFIRMA ("DESEJA EXCLUIR ESSA ENTREGA?")=2
                      RETURN(1)
                ENDIF            
                
                IF EMPTY(HORA_C)
                    BLOQUEIO()
                    MCODENTR=CODENTR
                    MPONTO=PONTO
                    MMOTOBOY=MOTOBOY
                    DELETE
                    UNLOCK
                    ENTR_CLI()
                    ORDSETFOCUS("ENTREGA")
                    DO WHILE .T.
                            SEEK MCODENTR
                            MCODIGO=999999000
                            IF FOUND()
                                    BLOQUEIO()
                                    MENTREGA=CLIENTE                                    
                                    DELETE
                                    DBCOMMIT()
                                    ENTREGA()
                                    BLOQUEIO()
                                    APPEND BLANK
                                    REPLACE ENTREGAS WITH MENTREGA
                                    REPLACE PONTO    WITH MPONTO
                                    REPLACE CODIGO   WITH MCODIGO
                                    REPLACE PRIORI   WITH "P"
                                    REPLACE HORA     WITH TIME()
                                    UNLOCK
                                    MCODIGO++
                                ELSE
                                    EXIT
                            ENDIF
                            ENTR_CLI()
                            ORDSETFOCUS("ENTREGA")
                    ENDDO
                    MOTOBOY()
                    ORDSETFOCUS("CHEGADA")
                    GOTO TOP
                    MCHEGADA=CHEGADA
                    IF ! EMPTY(MCHEGADA)
                            @ 01,01 SAY MCHEGADA
                            SomaH:=SEC2TIME( TIME2SEC(MCHEGADA)-TIME2SEC("00:10") )
                            @ 02,01 SAY SOMAH
                          ELSE
                            SOMAH=TIME()
                    ENDIF
                    ORDSETFOCUS("MOTOCA")
                    SEEK MMOTOBOY
                    BLOQUEIO()
                    REPLACE CHEGADA WITH SOMAH
                    DBCOMMIT()
                    UNLOCK
                    REST SCREEN FROM FTELA
                    RETURN(0)
                  ELSE
                    OL_Yield()
                    ALERT('ENTREGAS JA REALIZADAS')
                ENDIF       
