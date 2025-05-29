/***
*
*       Errorsys.prg
*
*  Standard Clipper error handler
*
*  Copyright (c) 1990-1993, Computer Associates International, Inc.
*  All rights reserved.
*
*  Compile:  /m /n /w
*
*/

#include "error.ch"


// put messages to STDERR
#command ? <list,...>   =>  ?? Chr(13) + Chr(10) ; ?? <list>
#command ?? <list,...>  =>  OutErr(<list>)


// used below
#define NTRIM(n)                ( LTrim(Str(n)) )
STATIC nErros := 5
STATIC cErroCorruption := NIL


/***
*       ErrorSys()
*
*       Note:  automatically executes at startup


proc ErrorSys()
        ErrorBlock( {|e| DefError(e)} )
return
*/



/***
*       DefError()
*/
func DefError(e)
local i, cMessage, aOptions, nChoice, cNome, chave1,chave2,chave3,chave4,chave5


IF ( e:genCode == EG_PRINT )
   tone(1500,1);TONE(2000,1)
   OL_Yield()
   ALERT("Erro na Impressora ≥ "+STRZERO(nErros,2)+" Tentativa(s) Restante(s)")
   IF nErros > 0
      nErros--
      return (.T.)
   ELSE
      nErros := 05
      tone(1500,1);TONE(2000,1)
      OL_Yield()
      ALERT("Desviando p/ o Arquivo <PRINT.ERR>")
      SET PRINT TO PRINT.ERR
      return (.T.)
   ENDIF
ENDIF

        // for network open error, set NETERR() and subsystem default
        if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )

                NetErr(.t.)
                return (.f.)                                                                    // NOTE

        end


        // for lock error during APPEND BLANK, set NETERR() and subsystem default
        if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )

                NetErr(.t.)
                return (.f.)                                                                    // NOTE

        end

        // by default, division by zero yields zero
        if ( e:genCode == EG_ZERODIV )
                return (0)
        end

        cCod_erro=RTRIM(e:subSystem)+'/'+LTRIM(STR(e:subCode))

        MostraErro( e )

        // build error message
        cMessage := ErrorMessage(e)


        // build options array
        // aOptions := {"Break", "Quit"}
        aOptions := {"Quit"}

        if (e:canRetry)
                AAdd(aOptions, "Retry")
        end

        if (e:canDefault)
                AAdd(aOptions, "Default")
        end


        // put up alert box
        nChoice := 0
        while ( nChoice == 0 )

                if ( Empty(e:osCode) )
                        nChoice := Alert( cMessage, aOptions )

                else
                        nChoice := Alert( cMessage + ;
                                                        ";(DOS Error " + NTRIM(e:osCode) + ")", ;
                                                        aOptions )
                end


                if ( nChoice == NIL )
                        exit
                end

        end


        if ( !Empty(nChoice) )

                // do as instructed
                if ( aOptions[nChoice] == "Break" )
                        Break(e)

                elseif ( aOptions[nChoice] == "Retry" )
                        return (.t.)

                elseif ( aOptions[nChoice] == "Default" )
                        return (.f.)

                end

        end


        // display message and traceback
        if ( !Empty(e:osCode) )
                cMessage += " (DOS Error " + NTRIM(e:osCode) + ") "
        end

        ? cMessage
        i := 2
        while ( !Empty(ProcName(i)) )
                ? "Called from", Trim(ProcName(i)) + ;
                        "(" + NTRIM(ProcLine(i)) + ")  "

                i++
        end
        // give up
        ErrorLevel(1)
        KEYBOARD CHR(004) + CHR(013)
        QUIT

return (.f.)

/***
*       ErrorMessage()
*/
static func ErrorMessage(e)
local cMessage
        // start error message
        cMessage := if( e:severity > ES_WARNING, "Error ", "Warning " )
        // add subsystem name if available
        if ( ValType(e:subsystem) == "C" )
                cMessage += e:subsystem()
        else
                cMessage += "???"
        end

        // add subsystem's error code if available
        if ( ValType(e:subCode) == "N" )
                cMessage += ("/" + NTRIM(e:subCode))
        else
                cMessage += "/???"
        end


        // add error description if available
        if ( ValType(e:description) == "C" )
                cMessage += ("  " + e:description)
        end


        // add either filename or operation
        if ( !Empty(e:filename) )
                cMessage += (": " + e:filename)

        elseif ( !Empty(e:operation) )
                cMessage += (": " + e:operation)

        end

return (cMessage)

STATIC FUNCTION MostraError( e )
LOCAL i, cTelaErro
IF cErroCorruption # NIL
   J_ANELA(10,10,18,70,"R+/R","N/R","","")
   SET COLOR TO W+/R
   @ 12,14 SAY "Foi Detectado um ERRO em um dos Arquivos do Sistema !!"
   @ 13,14 SAY "O ERRO Nao Foi  Corrigido,  Porque  Nao  Foi  Possivel"
   @ 14,14 SAY PADC("Identificar a Chave. O Arquivo e: "+cErroCorruption,54)
   @ 15,14 SAY "Ligue para "+LEFT(msg_tel,28) COLOR "W/R"
   @ 16,14 SAY "               PRESSIONE QUALQUER TECLA               "
   INKEY(0)
   SET COLOR TO
   CLS
   QUIT
ENDIF

IF UPPER(e:descriptio) == "CORRUPTION DETECTED" .AND. "CDX" $ UPPER(e:filename)
   IF EMPTY(NETNAME())
      @ 24,00 SAY PADC("Aguarde, Estou Reindexando Arquivo...",80) COLOR "W+/R"
      cErroCorruption := e:filename
      nH := FOPEN(e:filename,2)
      cTexto := SPACE(512)
      cIndex := FREAD(nH,@cTexto,512)
      cIndex := ALLTRIM(SUBSTR(cTexto,23))
      FCLOSE(nH)
      ordCreate((e:filename),,(cIndex),{||&(cIndex)},)
      cErroCorruption := NIL
      J_ANELA(10,10,17,70,"R+/R","N/R","","")
      SET COLOR TO W+/R
      @ 12,14 SAY "Foi Detectado um ERRO em um dos Arquivos do Sistema !!"
      @ 13,14 SAY "O ERRO ja Foi Corrigido, Porem Sera Necessario Abortar"
      @ 14,14 SAY "a Aplicacao."
      @ 14,26 SAY             "           Reinicialize o Sistema         " COLOR "W/R"
      @ 15,14 SAY "               PRESSIONE QUALQUER TECLA               "
      INKEY(0)
      SET COLOR TO
      CLS
      QUIT
   ELSE
      J_ANELA(10,10,18,70,"R+/R","N/R","","")
      SET COLOR TO W+/R
      @ 12,14 SAY "Foi Detectado um ERRO em um dos Arquivos do Sistema !!"
      @ 13,14 SAY "O ERRO nao Foi Corrigido, Porque voce Esta  Rodando  o"
      @ 14,14 SAY PADC("Programa em REDE. O Arquivo e: "+e:filename,54)
      @ 15,14 SAY "Ligue para "+LEFT(msg_tel,28) COLOR "W/R"
      @ 16,14 SAY "               PRESSIONE QUALQUER TECLA               "
      INKEY(0)
      SET COLOR TO
      CLS
      QUIT
   ENDIF
ENDIF

SETCANCEL(.F.)
SET CURSOR OFF
SET DEVICE TO SCREEN
cTelaErro := SAVESCREEN(00,00,24,79)
J_ANELA(0,0,24,79,"B+/B","N/B","W/B"," (ERRO NO SISTEMA) ")
@ 23,02 SAY " <Alt+I> Imprime   <Alt+C> Causa   <Alt+S> SoluáÑo   <ESC> Sai  ≥ PC Toledo" COLOR "GR+/B"
SET COLOR TO W/B
@ 23,04 SAY "Alt+I"
@ 23,22 SAY "Alt+C"
@ 23,38 SAY "Alt+S"
@ 23,56 SAY "ESC"
SET COLOR TO W/B
@ 02,02 SAY "Data do Erro.............: " + DTOC(DATE()) + "      Hora: " + TIME()
@ 03,02 SAY "Memoria para Caracteres..: " + ALLTRIM(STR(MEMORY(0))) + " para Blocos: " + ALLTRIM(STR(MEMORY(1))) ;
            +" para RUN: " + ALLTRIM(STR(MEMORY(2)))
DEFERROR2(e,1)
@ 09,02 SAY "Erro a Nivel Sistema DOS.: "+LTRIM(STR(e:osCode))
@ 10,02 SAY "Nome do SubSistema.......: "+e:subSystem
@ 11,02 SAY "Erro a Nivel Subsistema..: "+LTRIM(STR(e:subCode))
@ 12,02 SAY "Codigo do Erro Generico..: "+LTRIM(STR(e:genCode))
@ 14,02 SAY "Numero de Vezes da Falha.: "+LTRIM(STR(e:tries))
@ 15,02 SAY "Numero do Erro...........: "+LTRIM(STR(e:severity))
@ 16,02 SAY "Possibilita DEFAULT......: "+IF(e:canDefault,"SIM","NAO")
@ 17,02 SAY "Possibilita RETRY........: "+IF(e:canRetry,"SIM","NAO")
@ 18,02 SAY "Pos.Subst. Erro p/ Valor.: "+IF(e:canSubstitute,"SIM","NAO")
IF ALIAS() # ""
   @ 06,02 SAY "Arq. em Uso: " + ALIAS() + " Ordem: "+INDEXKEY(INDEXORD())
ENDIF
@ 07,40 SAY "Argumento Funcao: "
IF VALTYPE(e:args) == "A"
      @ 07,58 SAY "Matriz: "+ LTRIM(STR(LEN(e:args)))+" Elementos "
      i := 1
      DO WHIL i < 4
         @ 07 + i , 40  SAY  "Elemen[" + STR(i,2) + "]......: "
         @ 07 + i , 58  SAY  e:args[i]
         IF i == LEN(e:args)
            EXIT
         ENDIF
         i++
      ENDDO
ELSE
      @ 07,60 SAY e:args
ENDIF
J_ANELA(11,40,22,77,"B+/B","N/B","","")
@ 11,50 SAY " (FUNCOES COM ERRO) " COLOR "W/B"
SET COLOR TO G+/B
j := 1
i := 3
while ( !Empty(ProcName(i)) )
      @ j + 11,41 SAY "Funcao: " + Trim(ProcName(i)) + ;
                     "(" + NTRIM(ProcLine(i)) + ")  "

      i++
      j++
      IF j > 7
         EXIT
      ENDIF
end


IF e:osCode # 4
   GRAVAERRO(e)
ENDIF
v_tel_a=SAVESCREEN(00,00,24,79)
DO WHILE .T.
 v_tem_po=0
 DO WHILE .T.
   te_cl_a=INKEY(1)
   IF te_cl_a != 0
     EXIT
   ENDIF
   IF v_tem_po>=30
     v_tel_desc=SAVESCREEN(00,00,24,79)
     BILD5()
     RESTSCREEN(00,00,24,79,v_tel_desc)
     v_tem_po=0
   ENDIF
   v_tem_po++
 ENDDO
 IF te_cl_a == 27
   EXIT
 ELSEIF te_cl_a == 279
  DO WHIL .T.
   IF ISPRINTER()
      SET DEVICE TO PRINTER
      SETPRC(0,0)
      @ 00,00 SAY CHR(27) + CHR(18)
      @ 00,01 SAY "PC Toledo Software-Desenvolvimento de Sistemas Especificos as Suas Necessidades"
      @ 01,01 SAY "Relat¢rio de erros genÇricos                        "
******
******
******  comeca a impressao do dados dos erros
      @ 03,05 SAY "Data do Erro.............: " + DTOC(DATE()) + "      Hora: " + TIME()
      @ 04,05 SAY "Memoria para Caracteres..: " + ALLTRIM(STR(MEMORY(0))) + " para blocos: " + ALLTRIM(STR(MEMORY(1))) ;
            +" para RUN: " + ALLTRIM(STR(MEMORY(2)))
      DEFERROR2(e,2)
      @ 08,05 SAY "Erro a Nivel Sistema DOS.: "+LTRIM(STR(e:osCode))
      @ 09,05 SAY "Erro a Nivel SubSistema..: "+LTRIM(STR(e:subCode))
      @ 10,05 SAY "Nome do SubSistema.......: "+e:subSystem
      @ 11,05 SAY "Codigo do Erro Generico..: "+LTRIM(STR(e:genCode))
      @ 13,05 SAY "Numero de Vezes da Falha.: "+LTRIM(STR(e:tries))
      @ 14,05 SAY "Numero do Erro...........: "+LTRIM(STR(e:severity))
      @ 15,05 SAY "Possibilita DEFAULT......: "+IF(e:canDefault,"SIM","NAO")
      @ 16,05 SAY "Possibilita RETRY........: "+IF(e:canRetry,"SIM","NAO")
      @ 17,05 SAY "Pos.Subst. Erro p/ Valor.: "+IF(e:canSubstitute,"SIM","NAO")
      IF ALIAS() # ""
         @ 18,05 SAY "Arquivo em Uso...........: "+ALIAS() + " Ordem: " + INDEXKEY(INDEXORD())
      ENDIF
      @ 19,05 SAY "Argumento Funcao: "
      v_lin_ha=19
      IF VALTYPE(e:args) == "A"
         @ v_lin_ha,23 SAY "Matriz: "+ LTRIM(STR(LEN(e:args)))+" Elementos "
         i := 1
         DO WHIL .T.
            rel_li_nha(1)
            @ v_lin_ha , 05  SAY  "Elemen[" + STR(i,2) + "]......: "
            @ v_lin_ha , 23  SAY  e:args[i]
            IF i == LEN(e:args)
               EXIT
            ENDIF
            i++
         ENDDO
      ELSE
         @ v_lin_ha,25 SAY e:args
      ENDIF
      v_lin_ha=v_lin_ha+1
      i := 3
      while ( !Empty(ProcName(i)) )
                rel_li_nha(1)
                @ v_lin_ha,05 SAY "Funcao: " + Trim(ProcName(i)) + ;
                        "(" + NTRIM(ProcLine(i)) + ")  "

                i++
      end
      rel_li_nha(2)
      @ v_lin_ha,05 SAY "Causa: "
      Mos_tra(cCod_erro,'C',.t.)
      rel_li_nha(2)
      @ v_lin_ha,05 SAY "Possivel Solucao: "
      rel_li_nha(1)
      Mos_tra(cCod_erro,'S',.t.)

      rel_li_nha(2)
      @ v_lin_ha,05 SAY "Fim de Relatorio de Erros, Ligue para "+LEFT(msg_tel,28)
      EJECT
      SET DEVICE TO SCREEN
      EXIT
   ELSE
      tone(1500,1);TONE(2000,1)
      aaOPTIONS := {"Continuar","Sair"}
      OL_Yield()
      nnOPCAO := ALERT("Impressora Desligada ou Desconectada", aaOPTIONS)
      IF nnOPCAO == 1
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDIF
  ENDDO
 ELSEIF te_cl_a == 302
     Mos_tra(cCod_erro,'C',.f.)
 ELSEIF te_cl_a == 287
     Mos_tra(cCod_erro,'S',.f.)
 ENDIF
 RESTSCREEN(00,00,24,79,v_tel_a)
ENDDO
RESTSCREEN(00,00,24,79,cTelaErro)
SETCANCEL(.T.)
SET CURSOR ON
RETURN (NIL)
**************************************************************************
static proc rel_li_nha(v_q_t)
v_lin_ha+=v_q_t
if v_lin_ha>56
  v_lin_ha=1
endif
return
***************************************************************************
static func DefError2(e,tip_)
local i, cMessage, aOptions, nChoice

        if ( e:genCode == EG_ZERODIV )
                return (0)
        end

        if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )

                NetErr(.t.)
                return (.f.)                                                                    // NOTE

        end

        if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )

                NetErr(.t.)
                return (.f.)                                                                    // NOTE

        end

        cMessage := ErrorMessage(e)

        IF tip_ = 1
          @ 05,05 SAY cMessage
        ELSE
          @ 06,05 SAY cMessage
        ENDIF

return (.t.)
********************************
FUNCTION GRAVAERRO(e)
SET DEVICE TO PRINT
SET PRINTER TO "ERROS.TXT"
@ 00,00 SAY "Data do Erro.............: " + DTOC(DATE()) + "      Hora: " + TIME()
@ 01,00 SAY "Mem¢ria para Caracteres..: " + ALLTRIM(STR(MEMORY(0)))
@ 02,00 SAY "Erro a Nivel Sistema DOS.: "+LTRIM(STR(e:osCode))
@ 03,00 SAY "Nome do Subsistema.......: "+e:subSystem
@ 04,00 SAY "Erro a Nivel Subsistema..: "+LTRIM(STR(e:subCode))
@ 05,00 SAY "Codigo do Erro Generico..: "+LTRIM(STR(e:genCode))
@ 06,00 SAY "Numero de Vezes da Falha.: "+LTRIM(STR(e:tries))
@ 07,00 SAY "Numero do Erro...........: "+LTRIM(STR(e:severity))
@ 08,00 SAY "Possibilita DEFAULT......: "+IF(e:canDefault,"SIM","NAO")
@ 09,00 SAY "Possibilita RETRY........: "+IF(e:canRetry,"SIM","NAO")
@ 10,00 SAY "Pos.Subst. Erro p/ Valor.: "+IF(e:canSubstitute,"SIM","NAO")
IF ALIAS() # ""
   @ 11,00 SAY "Arq. em Uso: " + ALIAS() + " ordem: "+INDEXKEY(INDEXORD())
ENDIF
@ 12,00 SAY "Argumento Funcao: "
i := 1
IF VALTYPE(e:args) == "A"
   @ 13,00 SAY "Matriz: "+ LTRIM(STR(LEN(e:args)))+" Elementos "
   DO WHIL i < 4
      @ 13+i,00 SAY "Elemen[" + STR(i,2) + "]......: "
      @ 13+i,20 SAY e:args[i]
      IF i == LEN(e:args)
         EXIT
      ENDIF
      i++
   ENDDO
ELSE
   @ 13+i+1,00 SAY e:args
ENDIF
@ 13+i+2,00 SAY " Funcoes com Erro : "
j := 1
i := 3
while ( !Empty(ProcName(i)) )
        @ 13+i+3,00 SAY "Funcao: " + Trim(ProcName(i)) + ;
                "(" + NTRIM(ProcLine(i)) + ")  "

        i++
        j++
        IF j > 7
           EXIT
        ENDIF
end
SET DEVICE TO SCREEN
SET PRINTER TO
RETURN NIL

****************************************************************************
STATIC PROC Mos_tra(ycod,ti_po,imp_ri_me)
LOCAL ar_, ar_db, yultreg, cod_enc
ar_=SELECT()
ar_db=ALIAS()
yultreg=RECNO()
IF !FILE("d:\karvan\ERROR.DBF") //--- VERIFICA SE ARQUIVO ".DBF" EXISTE
   aaOPTIONS := {"Ok!"}
   OL_Yield()
   nnOPCAO := ALERT("Arquivo ERROR.DBF Nao Foi Encontrado!", aaOPTIONS)
   TONE(1500,1);TONE(2000,1)
   INKEY(0)
   RETURN
ENDIF

SELECT 0               //--- SELECIONA A PROXIMA AREA DE TRABALHO LIVRE
USE D:\KARVAN\ERROR EXCLUSIVE   //-- ABRE O ARQUIVO EM MODO EXCLUSIVO
e_x_t:=ORDBAGEXT()
IF e_x_t=".CDX"
  IF !FILE("ERROR1.CDX")  //--- VERIFICA SE ARQUIVO ".CDX" EXISTE
     INDEX ON CODIGO_ER TAG "INDICE1" TO ERROR1  //--CRIA O "ERROR1.CDX"
  ENDIF
ELSE
  IF !FILE("ERROR1.NTX")
    INDEX ON CODIGO_ER TO ERROR1
  ENDIF
ENDIF
USE
SELECT 0                  //-- SELECIONA PROXIMA AREA DE TRABALHO LIVRE
USE D:\KARVAN\ERROR SHARED  //-- ABRE ARQUIVO ".DBF" COMPARTILHADO
SET INDEX TO ERROR1     //-- ABRE ARQUIVO "ERROR1.CDX"
GO TOP
cod_enc=PCTENCRYPT(ycod," !")
SEEK cod_enc
IF !FOUND()
   IF imp_ri_me
      @ v_lin_ha,12 SAY "DESCULPE, Nao Ha Comentario Sobre este ERRO."
   ELSE
      tone(1500,1);TONE(2000,1)
      aaOPTIONS := {"Desculpe!"}
      OL_Yield()
      nnOPCAO := ALERT("Nao Ha Comentario Sobre este ERRO.", aaOPTIONS)
   ENDIF
   USE
   IF !EMPT(ar_db)
     SELE(ar_)
     GO yultreg
   ELSE
     SELE 0
   ENDIF
   RETURN
ENDIF
PRIVATE cMsg:={}
ycod=CODIGO_ER
vti_po=PCTENCRYPT(ti_po," !")
DO WHILE ycod=CODIGO_ER
        IF vti_po!=TIPO_ER
                SKIP
                LOOP
        ENDIF
        v_m_s_g=PCTDECRYPT(ALLTRIM(MENSAGE_ER)," !")
        IF '|' $ v_m_s_g
          AADD(cMsg,LEFT(v_m_s_g,AT('|',v_m_s_g)-1))
          AADD(cMsg,SUBS(v_m_s_g,AT('|',v_m_s_g)+1))
        ELSE
          AADD(cMsg,v_m_s_g)
        ENDIF
        SKIP
ENDDO
v_t_a=LEN(cMsg)
IF imp_ri_me
  IF ti_po='C'
    @ v_lin_ha,12 SAY cMsg[1]
    rel_li_nha(1)
  ENDIF
  FOR v_i=3 TO LEN(cMsg)
    rel_li_nha(1)
    @ v_lin_ha,12 SAY cMsg[v_i]
  NEXT
ELSE
  v_l_i=INT((24-(v_t_a+2))/2)
  *SET COLOR TO W/B
  *@ v_l_i,09,v_l_i+v_t_a+2,72 BOX "€€€€€€€€€"
  J_ANELA(v_l_i,9,v_l_i+v_t_a+2,72,"R+/R","N/R","","")
  SET COLOR TO GR+/R
  FOR v_i=1 TO LEN(cMsg)
    @ v_l_i+v_i,11 SAY PADC(ALLTRIM(cMsg[v_i]),60)
  NEXT
  inkey(0)
ENDIF
USE
IF !EMPT(ar_db)
    SELE(ar_)
    GO yultreg
ELSE
    SELE 0
ENDIF
return
****************************************************************************


STATIC FUNCTION PCTENCRYPT(ycTexto,ycSenha)
LOCAL yi,e,cri,sen,sen1,let,ret,tip

tip    = IF(VALTYPE(ycSenha)="U",.t.,.f.)
ycSenha = IF(VALTYPE(ycSenha)="U"," ",ycSenha)

e=1
ret=""
FOR yi=1 TO LEN(ALLTRIM(ycTexto))
    sen1=ASC(SUBSTR(ycSenha,e,1))
    IF sen1 < 128
        sen=sen1+128
    ELSE
        sen=sen1
    ENDIF
    IF tip
        let=ASC(SUBSTR(ycTexto,(LEN(ALLTRIM(ycTexto))+1)-yi,1))
    ELSE
        let=ASC(SUBSTR(ycTexto,yi,1))
    ENDIF
    cri=sen-let
    if cri <= -64 .AND. cri >= -95
        cri = ABS(cri)
    elseif cri <= -32 .AND. cri >= -63
        cri = 128-(ABS(cri) -((ABS(cri)-32)*2))
    elseif cri <= 0 .AND. cri >= -31
        cri = ABS(cri)
    elseif cri >= 1 .AND. cri <= 32
        cri = cri+((32-cri)*2)
    elseif cri >= 33 .AND. cri <= 64
        cri = cri+(((64-cri)*2)+128)
    elseif cri >= 65 .AND. cri <= 96
        cri = cri+(((96-cri)*2)+128)
    elseif cri >= 97 .AND. cri <= 128
        cri = cri+((128-cri)*2)
    endif
    if sen1 = 33
        if let >=34
            if substr(str(cri),LEN(str(cri)),1) $ "13579"
                cri=cri+2
            endif
        endif
        if let = 64
            cri=225
        elseif let = 96
            cri=193
        elseif let = 128
            cri=33
        elseif let = 160
            cri=1
        elseif let = 192
            cri=97
        elseif let = 224
            cri=65
        endif
    endif
    ret+=CHR(cri)
    e++
    IF e > LEN(ycSenha)
        e=1
    ENDIF
NEXT
RETURN(ret)

STATIC FUNCTION PCTDECRYPT(ycTexto,ycSenha)
LOCAL yi,e,cri,sen,sen1,let,ret,tip

tip    = IF(VALTYPE(ycSenha)="U",.t.,.f.)
ycSenha = IF(VALTYPE(ycSenha)="U"," ",ycSenha)

e=1
ret=""
FOR yi=1 TO LEN(ALLTRIM(ycTexto))
    sen1=ASC(SUBSTR(ycSenha,e,1))
    IF tip
        let=ASC(SUBSTR(ycTexto,(LEN(ALLTRIM(ycTexto))+1)-yi,1))
    ELSE
        let=ASC(SUBSTR(ycTexto,yi,1))
    ENDIF
    if let >= 0 .AND. let <= 31
        cri = (let+sen1)+128
    elseif let >= 32 .AND. let <= 63
        cri = (let+sen1)+64
    elseif let >= 64 .AND. let <= 95
        cri = (let+sen1)+128
    elseif let >= 96 .AND. let <= 127
        cri = (let+sen1)+64
    elseif let >= 128 .AND. let <= 159
        cri = (let+sen1)-128
    elseif let >= 192 .AND. let <= 223
        cri = (let+sen1)-128
    elseif let >= 224 .AND. let <= 255
        cri = (let+sen1)-192
    endif
    if sen1 = 33
        if substr(str(cri),LEN(str(cri)),1) $ "24680"
            cri=cri-2
        endif
        if let = 32
            cri = 129
        elseif let = 9
            cri = 168
        elseif let = 10
            cri = 171
        elseif let = 13
            cri = 172
        endif
    else
        if let = 32
            cri = 128
        elseif let = 9
            cri = 169
        elseif let = 10
            cri = 170
        elseif let = 13
            cri = 173
        endif
    endif
    ret+=CHR(cri)
    e++
    IF e > LEN(ycSenha)
        e=1
    ENDIF
NEXT
RETURN(ret)

STATIC FUNCTION BILD5()
local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
   Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
   Local15
Local1:= {}
Local2:= 1
Local3:= 1
Local4:= 4
Local5:= 4
Local6:= 0
Local7:= 2
Local8:= {{3, 3}, {2, 2}, {1, 1}, {0, 0}}
Local9:= -1
Local10:= -1
Local11:= MaxRow() - 4
Local12:= MaxCol() - 4
Local13:= 0
Local14:= 7
Local15:= {{MaxRow() - 3, MaxCol() - 3}, {MaxRow() - 2, MaxCol() ;
   - 2}, {MaxRow() - 1, MaxCol() - 1}, {MaxRow(), MaxCol()}}
Local1:= {"n/n", "b/n", "g/n", "bg/n", "r/n", "rb/n", "gr/n", ;
   "w/n", "n+/n", "b+/n", "g+/n", "bg+/n", "r+/n", "rb+/n", ;
   "gr+/n", "w+/n"}
do while (.T.)
   dispbegin()
   @ Local4, Local5 say "€€€" color Local1[Local7]
   @ Local4 + 1, Local5 say "€€€" color Local1[Local7]
   @ Local8[1][1], Local8[1][2] say "≤≤≤" color Local1[Local7]
   @ Local8[1][1] + 1, Local8[1][2] say "≤≤≤" color Local1[Local7]
   @ Local8[2][1], Local8[2][2] say "±±±" color Local1[Local7]
   @ Local8[2][1] + 1, Local8[2][2] say "±±±" color Local1[Local7]
   @ Local8[3][1], Local8[3][2] say "∞∞∞" color Local1[Local7]
   @ Local8[3][1] + 1, Local8[3][2] say "∞∞∞" color Local1[Local7]
   @ Local8[4][1], Local8[4][2] say "   " color Local1[Local7]
   @ Local8[4][1] + 1, Local8[4][2] say "   " color Local1[Local7]
   Local8[4]:= Local8[3]
   Local8[3]:= Local8[2]
   Local8[2]:= Local8[1]
   Local8[1]:= {Local4, Local5}
   @ Local11, Local12 say "€€€" color Local1[Local14]
   @ Local11 + 1, Local12 say "€€€" color Local1[Local14]
   @ Local15[1][1], Local15[1][2] say "≤≤≤" color Local1[Local14]
   @ Local15[1][1] + 1, Local15[1][2] say "≤≤≤" color ;
      Local1[Local14]
   @ Local15[2][1], Local15[2][2] say "±±±" color Local1[Local14]
   @ Local15[2][1] + 1, Local15[2][2] say "±±±" color ;
      Local1[Local14]
   @ Local15[3][1], Local15[3][2] say "∞∞∞" color Local1[Local14]
   @ Local15[3][1] + 1, Local15[3][2] say "∞∞∞" color ;
      Local1[Local14]
   @ Local15[4][1], Local15[4][2] say "   " color Local1[Local14]
   @ Local15[4][1] + 1, Local15[4][2] say "   " color ;
      Local1[Local14]
   Local15[4]:= Local15[3]
   Local15[3]:= Local15[2]
   Local15[2]:= Local15[1]
   Local15[1]:= {Local11, Local12}
   dispend()
   Local4:= Local4 + Local2
   if (Local4 > MaxRow() - 1)
      Local2:= -1
   endif
   if (Local4 < 1)
      Local2:= 1
   endif
   Local5:= Local5 + Local3
   if (Local5 > MaxCol() - 1)
      Local3:= -1
   endif
   if (Local5 < 1)
      Local3:= 1
   endif
   Local11:= Local11 + Local9
   if (Local11 > MaxRow() - 1)
      Local9:= -1
   endif
   if (Local11 < 1)
      Local9:= 1
   endif
   Local12:= Local12 + Local10
   if (Local12 > MaxCol() - 1)
      Local10:= -1
   endif
   if (Local12 < 1)
      Local10:= 1
   endif
   if (InKey(0.01) != 0)
      exit
   endif
   Local6++
   if (Local6 > 500) //1000)
      Local6:= 0
      Local5++
      Local7++
      if (Local7 > 16)
         Local7:= 2
      endif
   endif
   Local13++
   if (Local13 > 500) //1000)
      Local13:= 0
      Local12++
      Local14++
      if (Local14 > 16)
         Local14:= 2
      endif
   endif
enddo
return

FUNCTION J_ANELA
PARAMETERS L1,C1,L2,C2,C_OR1,C_OR2,C_OR3,T_ITULO
CORR=SETCOLOR()
SET COLOR TO &C_OR1
@ L1,C1 CLEAR TO L2,C2
@ L1,C1 SAY '⁄'+REPLICATE(CHR(196),C2-C1-1)+'ø'
SET COLOR TO &C_OR3
@ L1,(80-LEN(T_ITULO))/2 SAY T_ITULO
FOR A=L1+1 TO L2-1
   SET COLOR TO &C_OR1
   @ A,C1 SAY '≥'
   SET COLOR TO &C_OR2
   @ A,C2 SAY '≥'
NEXT A
SET COLOR TO &C_OR2
@ L2,C1 SAY '¿'+REPLICATE(CHR(196),C2-C1-1)+'Ÿ'
SETCOLOR(CORR)
RETURN


