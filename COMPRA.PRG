#INCLUDE "INKEY.CH"
*#INCLUDE "CLUBE.CH"
#INCLUDE "DIRECTRY.CH"
*#INCLUDE "LFNLIB.CH"
********************************************************************************
FUNCTION NUMEROCOM()
SELE COM
DBSETORDER(2)
DBGOBOTTOM()
RETURN(cNUMERO:=STRZERO(VAL(NUMERO_)+1,10))

********************************************
FUNCTION COMPRASXML()
LOCAL GetList 	:= {}
LOCAL PI13    	:= "@KE 99,999.9999"
LOCAL cTELA    := SAVESCREEN(0,0,24,79)


// ESTRUTURA DO ARQUIVO DE COMPRAS TEMPORARIO
LOCAL COMPRA :={{"CODFOR_"	,"C",6 ,0},;
				   {"DOCUME_"	,"C",10,0},;
				   {"DATA_"		,"D",8 ,0},;
				   {"VALOR_"	,"N",12,2},;
				   {"NUMERO_"   ,"C",10,0},;
				   {"ACRESCIMO"	,"N",12,2},;
				   {"DESCONTO"	,"N",12,2},;
				   {"FRETE_"    ,"N",12,2},;
				   {"IPI_"      ,"N",12,2},;
				   {"XML"       ,'C',47,0},;
				   {"VALORNOTA_","N",12,2}}

// ESTRUTURA DO ARQUIVO ITENS DE COMPRA TEMPORARIO
LOCAL ICOMPRA :=  {{'ID_'       ,'N',3 ,0},;
				   {'ALTERADO_' ,'C',1 ,0},;
	  		  	   {"CODFOR_"	,"C",6 ,0},;
				   {"CODPRO_"	,"C",5 ,0},;
				   {"CODGRU_"   ,"C",3 ,0},;
				   {"NOMPRO_"   ,"C",50,0},;
				   {"QTDE_"		,"N",9 ,3},;
				   {"VALOR_"	,"N",12,3},;
				   {"TOTAL_"    ,"N",12,3},;
				   {"DATA_"     ,"D",8 ,0},;
				   {'FRETE_'    ,'N',8 ,3},;
				   {'IPI_'      ,'N',8 ,3},;
				   {"NUMERO_"  	,"C",10,0},;
				   {"DOCUME_"   ,"C",10,0},;
				   {"CODBARRA"  ,"C",13,0},;
				   {"CODORIGI"  ,"C",15,0},;
				   {"NCM"       ,"C",8 ,0},;
				   {"CFOP_"     ,"C",4 ,0},;
				   {"CSOSN_"    ,"C",3 ,0},;
				   {"ICMS_"     ,"N",6 ,2},;
				   {"UND_"      ,"C",2 ,0}}

/* 				   
IF !ABREARQ(,{"COM","PRO","ICOM","FORN","HIST","GRU","NCM"})
	BEEP()
	MENSAGEMD("N„o foi poss¡vel abrir o arquivo de dados, abortando !",3)
	RETURN NIL
ENDIF
*/


// CRIANDO/ABRINDO ARQUIVO DE COMPRAS TEMPORARIO
cARQTMP := cPASTAXML+'COMPRAT.DBF'
FERASE( cARQTMP )
IF !FILE( cARQTMP )
   Dbcreate(cARQTMP,COMPRA)
ENDIF
USE &cARQTMP ALIAS COMT EXCL NEW
ZAP

IF FILE('ICOMT1.NTX')
   FERASE('ICOMT1.NTX')
ENDIF
IF FILE('ICOMT2.NTX')
   FERASE('ICOMT2.NTX')
ENDI

// CRIANDO/ABRINDO ARQ DE ITENS DA COMPRA TEMPORARIO
cARQTMP := cPASTAXML+'ICOMPRAT.DBF'
FERASE( cARQTMP )
IF !FILE( cARQTMP )
   Dbcreate(cPASTAXML+'ICOMPRAT.DBF',ICOMPRA)
ENDIF
USE &cARQTMP ALIAS ICOMT EXCL NEW
ZAP
INDEX ON CODBARRA TO ICOMT1.NTX
INDEX ON NOMPRO_  TO ICOMT2.NTX
INDEX ON ID_      TO ICOMT3.NTX
SET INDEX TO ICOMT1.NTX,ICOMT2.NTX,ICOMT3.NTX
DBGOTOP()

cCGC     := ''
cDOCUME_ := ''
ICOMTSAIR:= .T.
lCOMPROU := .F.
cCHAVE	:= ''

// DEFINICAO DA PASTA ONDE FORAM SALVOS OS XML 
cPASTAXML := 'D:\XML\'

WHILE .T.

   // Pegando Arquivo XML  na Pasta

   mLISTAARQ	:= LF_DIRECTORY( cPASTAXML+'*.XML','D')
   
   // SE NÃO TEM NENHUM AQRUIVO XML 
   IF LEN(MLISTAARQ)=0
      BEEP()
      ALERT('NAO TEM ARQUIVOS XML NA PASTA: '+cPASTAXML+'   VERIFIQUE...')
      EXIT
   ENDIF
   
   // MATRIZ COM OS ARQUIVOS XML
   cLISTA  := {}
   For i := 1 to Len(mListaArq)
      cNomeForne := PGNARQ(cPASTAXML+mListaArq[i,1])
      Aadd(cLista,cNomeForne)
   Next
    
   * JANELA(05,02,6+Len(cLista),79,"ESCOLHA O ARQUIVO COM O DANFE ")
   nOpcao  := Achoice(06,03,7+Len(cLista),78,cLista,.t.)
   If nOpcao== 0
      EXIT
   Endif
   cFileDanfe  := cPASTAXML+mListaArq[nOpcao,1]
   cFileOrig	:= cFileDanfe
   
   // PEGA NUMERO DA NOTA
   cDOCUME_ 	:= ALLTRIM(SUBSTR(cLISTA[nOPCAO],4,8))
   // PEGA O CGC DO FORNECEDOD
   cCGC_       := SUBSTR(cLISTA[nOPCAO],36,18)
   
   // VERIFICA SE A NFE JA FOI LANCADA PARA ESTE FORNECEDOR

	// ARQUIVO DE FORNECEDORES
   SELE FORN
   DBSETORDER(3)
   DBGOTOP()
   IF DBSEEK( cCGC_ )
	
      cCODFOR_ := FORN->CODIGO
      cDOCUME_ := ALLTRIM(cDOCUME_)
		
   	// ARQUIVO DE COMPRAS
	   SELE COM
	   // COLOCA NA ORDEM DE CODIGO DE FORNECEDOR + NUMERO DA NFE
	   // PARA VERIFICAR SE JÁ FOI LANCADA ESTA NFE
      DBSETORDER(5)
      DBGOTOP()
      SET EXACT ON
      IF DBSEEK( cCODFOR_+cDOCUME_ )
         BEEP()
         ALERT('NOTA FISCAL: '+cDOCUME_+'  FORNECEDOR: '+cCODFOR_+'; NOTA FISCAL JA FOI LANCADA PARA ESSE FORNECEDOR...')
         EXIT
      ENDIF
      SET EXACT OFF
		
   ENDIF

	// FUNCAO LEXML() - VAI LER OS DADOS DO XML 
   // PROCESSA LEITURA DO XML
   // E GRAVA DADOS NOS ARQ TEMPORARIOS
   IF !LEXML()
   	EXIT
  	ENDIF

   // PROCESSA ARQUIVO DE ITENS E ASSOCIA
   // AO CADASTRO DE PRODUTOS
   
   // SELECIONA O ARQUIVO DE ITENS DA COMPRA TEMPORARIO 
   SELE ICOMT
   DBGOTOP()
   WHILE !EOF()
	
      cCODBARRA := ICOMT->CODBARRA
	
		// PESQUISA NO ARQUIVO DE PRODUTOS SE EXISTE O CODIGO DE BARRAS CADASTRADO      
      SELE PRO
      // COLOCA NO INDICE DE CODIGO DE BARRAS
      DBSETORDER(5)
      DBGOTOP()
	      
      ACHOBARRA    := .F.
      // VERIFICA PELO CODIGO DE BARRAS
	      
      // SE ACHOU CODIGO DE BARRAS ASSOCIA COM O ARQUIVO DE PRODUTOS
      IF !EMPTY( cCODBARRA )
      	
         IF DBSEEK( cCODBARRA )
            ICOMT->CODPRO_ := PRO->CODPRO_
            ICOMT->NOMPRO_ := PRO->NOMPRO_
            ICOMT->CODGRU_ := PRO->CODGRU_
            ACHOBARRA := .T.
         ENDIF
         
      ENDIF
		  
      // VERIFICA PELO CODIGO DO FABRICANTE
      // CODORIGI - CODIGO DO FORNECEDOR 
      IF !ACHOBARRA .AND. !EMPTY(ICOMT->CODORIGI)
         cCODORIGI := ICOMT->CODORIGI
         SELE PRO
         // INDICE DE CODIGO DO FABRICANTE
         DBSETORDER(6)
         DBGOTOP()
         IF DBSEEK( ALLTRIM(cCODORIGI) )
         	// SE ACHOU O CODIGO ORIGINAL
         	// SE O FORNECEDOR CADASTRADO E O MESMO DO FORNECEDOR DA NFE
         	// ASSOCIA 
            IF PRO->CODFOR_ = FORN->CODIGO
               ICOMT->CODPRO_  := PRO->CODPRO_
               ICOMT->NOMPRO_  := PRO->NOMPRO_
               ICOMT->CODGRU_  := PRO->CODGRU_
               ICOMT->CODBARRA := PRO->CODBARRA
               cCODBARRA		 := ICOMT->CODBARRA
            ENDIF
         ENDIF
      ENDIF

      SELE ICOMT
      DBSKIP()
		  
   ENDDO
	      
   // MONTA TELA E APRESENTA O BROWSE
   // COM OS ITENS TEMPORARIOS DA NFE

   SETCURSOR(1)
   RESTSCREEN( ,,,,cTela )
   * JANELA( 01,02,22,78, "Lancamento de Compras pelo XML" )
   * COR("GETS")
   @ 02,03 SAY 'FORNECEDOR: ' + FORN->CODIGO+'-'+LEFT(FORN->NOME,30)
   @ 03,03 SAY 'CHAVE NFE.: ' + COMT->XML

   aCabecalho :={;
    'A'         ,;
    'Cod'	    ,;
    'Descricao' ,;
    'Un'        ,;
    'Qtde'      ,;
    'Unitar'    ,;
    '   Total'  ,;
    'Gru'       }

   aCampos	 :=	{;
    'ALTERADO_'                 ,;
    'CODPRO_'   				,;
    {|| LEFT(NOMPRO_,22)} 		,;
    'UND_'                      ,;
    {|| TRAN(QTDE_,"@KE 9999")} ,;
    {|| TRAN(VALOR_,"@KE 9999.99")},;
    {|| TRAN(TOTAL_,PI8)} 		,;
    'CODGRU_'              }

   aPicture :=	{;
    '!'         ,;
    '99999'	    ,;
    '@!'	    ,;
    '!!'        ,;
    '99999'     ,;
    '@KE 9,999.99',;
    '@KE 9,999.99',;
    '999'}
				
   aTeclas	 :=	{ ;
    { K_F7,    'FECHACOM()'} ,;  // MOSTRA COMPRA DO NUMERO
    { K_INS,   'APROXML()'}  ,;
    { K_ENTER, 'ASSPRO()' }  ,;
    { K_F9   , 'ALTGXML()'}  ,;
    { K_ALT_G, 'ALTGXMLT()'} ,;
    { K_ALT_N, 'ALTDESC()'}  ,;
    { K_F3	 , 'CALEN()'}    ,;
    { K_F4	 , 'CALCU()'}}

   aCoordenadas := { 05,03,16,77 }

   aMensagem := { " <F9>-Alt Grupo <ALT+G>-Todos Grupos <ENTER>-Ass_Prod ALT+N-NOME <F7>-Proc Compra" }
   cCODGRU_  := SPACE(3)
   SETCURSOR(0)
   Visualiza( aCabecalho, aCampos, aPicture, "ICOMT", aMensagem, 2, aTeclas, aCoordenadas, .F. )

   EXIT

ENDDO
SELE COMT
USE
SELE ICOMT
USE

IF lCOMPROU

	// MOVENDO ARQUIVO XML PARA PASTA XML\LANCADOS
	MOSTRA('APAGANDO ARQUIVO XML')
	LF_FCOPY(cFILEDANFE, ( 'LANCADOS\'+cFILEORIG ))
	FERASE( cFILEDANFE )
	
	IF ALERT('COMPRA EFETUADA COM SUCESSO !!! IMPRIME O RELATORIO ?', {'SIM','NAO'})=1
		* IMPCOMPRA()
	ENDIF
	
ENDIF

// FECHA TODOS OS ARQUIVOS
ABREARQ( ,.F. )
RESTSCREEN(0,0,24,79,cTELA)
Return nil


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
function LEXml()
LOCAL lRETORNO := .T.

// POSICAO DO PONTEIRO DENTRO DO ARQUIVO XML 
nPOINTER 	:= 0 
nLinhalidas := 0

DO WHILE .T.
	
   // Abre arquivo XML
   nHandle 			:= Fopen( cFileDanfe, 2 )
	
   // Verifica se Abriu com sucesso
   If FError() != 0
      Alert( "Nao foi possivel abrir: " + cFileDanfe )
      lRETORNO := .F.
   EndIf
	
	// VERIFICA O TAMANHO DO ARQUIVO 
   nTAMANHO		:= FSEEK( nHANDLE, 0, 2 )
   
   IF nTAMANHO > 65000
   	// SE MAIOR DO QUE 65000 VOU LER O TAMANHO MENOS 65000
   	// PARA PEGAR OS TOTAIS
      cLINHATXT := SPACE(65000)
      FSEEK( nHANDLE, nTAMANHO-65000,0 )
      FREAD( nHANDLE, @cLINHATXT, 65000 )
   ELSE
   	// SE NAO FOR MAIOR DO 65000 CABE NA MEMORIA
   	// LEIO TODO O ARQUIVO 
      FSEEK( nHANDLE,0,0)
      cLINHATXT := SPACE( nTAMANHO )
      FREAD( nHANDLE, @cLINHATXT, nTAMANHO )
   ENDIF
   FCLOSE( nHANDLE )
  	
   // pega dados dos totais
   cLidos1 	  	:= PegaDados('ICMSTot',Alltrim(cLinhaTxt),.t.,'ICMSTot')
   Linha1     	:= cLidos1
   nValorNota_	:= val( PegaDados('vNF'  ,Alltrim(Linha1,.f.)) )
   nValor_    	:= val( PegaDados('vProd',Alltrim(Linha1,.f.)) )
   nFrete_    	:= val( PegaDados('vFrete',Alltrim(Linha1,.f.)) )
   nDif       	:= nValorNota_-nValor_
   nAcrescimo 	:= If( nDif > 0 , nDif, 0 )
   nDesconto  	:= If( nDif < 0 , nDif, 0 )
   nIpi_      	:= 0.00
   cNUMERO_   	:= ''
   nFrete_  	:= If( nFrete_ > 0.00 , nFrete_ / (nValor_/100), 0.00 )

	// LEIO O ARQUIVO NOVAMENTE
	// E COMEÇA DO INICIO
	// TENTEI MOVER O PONTEIRO PARA O INICIO MAS DEU UMS PROBLEMAS 
	// RESOLVI LER O ARQUIVO DE NOVO
   nHandle 			:= Fopen( cFileDanfe, 2 )                    
   nTAMANHO			:= FSEEK( nHANDLE, 0, 2 )
   FSEEK( nHANDLE,0,0)
   LINHA				:= SPACE( IF( nTAMANHO>65000,65000,nTAMANHO))
   FSEEK( nHANDLE,0,0)
   // AQUI LE 65000 BYTES DO ARQUIVO
   // MAIS ABAIXO SERA TESTADO SE A QTDE LIDA E O TAMANHO DO ARQUIVO 
   FREAD( nHANDLE, @LINHA, IF( nTAMANHO>65000,65000,nTAMANHO) )
   nPOINTER 		:= 65000
   nLINHALIDAS		:= 0
   Linhatotal  	:= nTAMANHO
   cLinhaTxt   	:= Linha
   
   // identificao arquivo
   nPos1 := At('Id="',Linha)
   If nPos1==0
      Alert('Erro no Arquivo '+cFileDanfe+Chr(10)+;
       'Id=')
      EXIT
   Endif
  
   nPos1 	:= nPos1+Len('Id="')
   cChave	:= Substr(Linha,nPos1,48)
   cXml     := cChave

   nPos1 	:= At(' ',Linha)
   If nPos1==0
      Alert('Erro no Arquivo '+cFileDanfe)
      EXIT
   Endif
   nPos1		:= nPos1+Len(' ')
  
   // SELECIONA ARQUIVO DE FORNECEDORES
   SELE FORN
   // CRIA VARIAVEIS CONFORME CAMPOS DO ARQUIVO
   FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := IF(TYPE(FIELD(nI))=="C",SPACE(LEN(&(FIELD(nI)))),IF(TYPE(FIELD(nI))=="N",0,IF(TYPE(FIELD(nI))=="L",.F.,IF(TYPE(FIELD(nI))=="D",CTOD(""),""))) )
   NEXT
   
   cLidos1	:= PegaDados('emit',Alltrim(cLinhaTxt),.t.,'emit')
   Linha1   := cLidos1
   cCGC     := PegaDados('CNPJ',Alltrim(Linha1,.f.))
   cCGC     := LEFT(cCGC,2)+'.'+SUBSTR(cCGC,3,3)+'.'+SUBSTR(cCGC,6,3)+'/'+SUBSTR(cCGC,9,4)+'-'+SUBSTR(cCGC,13,2)

  	cNOME 		:= UPPER(PegaDados('xNome'	,Alltrim(Linha1,.f.)))
   cFantasia   := UPPER(PegaDados('xFant'	,Alltrim(Linha1,.f.)))
   cEndereco   := UPPER(PegaDados('xLgr' 	,Alltrim(Linha1,.f.)))
   cNumero     := PegaDados('nro'    	,Alltrim(Linha1,.f.))
   cBairro     := UPPER(PegaDados('xBairro'	,Alltrim(Linha1,.f.)))
   cCidadeCod  := PegaDados('cMun'		,Alltrim(Linha1,.f.))
   cCidade     := UPPER(PegaDados('xMun'		,Alltrim(Linha1,.f.)))
   cEstado     := PegaDados('UF'		,Alltrim(Linha1,.f.))
   cCep        := PegaDados('CEP'		,Alltrim(Linha1,.f.))
   cCep        := LEFT( cCEP,5)+'-'+SUBSTR(cCep,6,3)
   cTelefone1  := PegaDados('fone'		,Alltrim(Linha1,.f.))
   cTelefone1  := Transform( Val(cTelefone1),'( 99)9999-9999' )
   cInsc_Est   := PegaDados('IE'		,Alltrim(Linha1,.f.))

   // VERIFICA SE O FORNECEDOR JÁ ESTÁ CADASTRADO
 	SELE FORN
   DBSETORDER(3)
   DBGOTOP()

   IF !DBSEEK( cCGC )

      IF ALERT("CGC NAO FOI ENCONTRADO ; CADASTRO UM NOVO FORNECEDOR ; OU ASSOCIO O FORNECEDOR?", {'CADASTRAR','ASSOCIAR'})=1
 
 			// SE CADASTRA UM NOVO FORNECEDOR
 			// A FUNCAO GRAVA_VAR() - GRAVA DADOS DAS VARIAVEIS NOS CAMPOS DO ARQUIVO
         SELE FORN
         FORN->(DBSETORDER(2))
         FORN->(DBGOBOTTOM())
         cCodigo 	:= STRZERO(VAL(FORN->CODIGO)+1,6)
         cCodFor_    := cCodigo
         DBAPPEND()
         GRAVA_VAR()

      ELSE
 
      	// FUNCAO ASSFORN()
			// NO MEU SISTEMA PESQUISA FORNECEDOR E ASSOCIA     
			
         IF ASSFORN()

            SELE FORN
            cTelefone2  := FORN->TELEFONE2
            cFax        := FORN->FAX
            lSpc        := FORN->SPC
            cObservacao := FORN->OBSERVACAO
            nSaldo      := 0.00
            cDeletado   := ''
            cEmail      := FORN->EMAIL
	
            SELE FORN
            WHILE (.T.)
               IF RLOCK()
                  GRAVA_VAR()
                  UNLOCK
                  EXIT
               ENDIF
            ENDDO
         ELSE
         
         	// SENAO ASSOCIAR ELE GRAVA NOVO FORNECEDOR
            SELE FORN
            FORN->(DBSETORDER(2))
            FORN->(DBGOBOTTOM())
            cCodigo 	:= STRZERO(VAL(FORN->CODIGO)+1,6)
            cCodFor_    := cCodigo
            DBAPPEND()
            GRAVA_VAR()
         ENDIF
         
      ENDIF
 
   ENDIF

   cCodFor_    := Forn->Codigo
   
   // Cabecalho da nota
   cLidos1 		:= PegaDados('ide',Alltrim(cLinhaTxt),.t.,'ide')
   Linha1    	:= cLidos1

   cDocume_		:= PegaDados('nNF',Alltrim(Linha1,.f.))
   dData     	:= PegaDados('dEmi',Alltrim(Linha1,.f.))
   dData     	:= RIGHT(dData,2)+"/"+SUBSTR(dData,6,2)+"/"+LEFT(dData,4 )
   dData_    	:= CTOD( dData )
   
   // Seleciona arquivo de compras temp e salva dados
   Sele ComT
   dbAppend()
   Grava_Var()
  	
  	
   linha 		:= []
   cLIDOS		:= []
   nsize			:= 0
   nLinhaLidas	:= 0
   nINICIO		:= AT( '<det nItem', cLINHATXT )
   cLINHATXT	:= RIGHT( cLINHATXT, LEN(cLINHATXT)-nINICIO+1 )
   nTAMLINHA 	:= LEN( cLINHATXT )

	// COMECA A PROCURA PELOS ITENS

   While (.T.)
   
   	// SE O COMPRIMENTO DA LINHA ATUAL E MENOR DO QUE 1000 BYTES
   	// VAI PARA A FUNCAO VERESTO
   	// QUE FAZ A LEITURA DO RESTANTE DO ARQUIVO
      IF LEN( cLINHATXT ) < 1000
         cLINHATXT := VERRESTO()
      ENDIF
		
		
      cLidos := PegaDados('det nItem',Alltrim(cLinhaTxt),.t.,'det' )
      Linha  := cLidos
     		
      If Linha=='0'
         Exit
      Endif
 
      // PEGA OS DADOS DO XML 
      // E ARMAZENA NAS VARIÁVEIS DO ARQUIVO COMPRA E ITENS DA COMPRA TEMPORARIOS

      cCodpro_   	:= ""
      cNompro_   	:= PegaDados('xProd' ,Alltrim(Linha) ,.f.)
      nQtde_     	:= Val(PegaDados('qCom'  ,Alltrim(Linha) ,.f.) )
      nValor_    	:= val(PegaDados('vUnCom',Alltrim(Linha) ,.f.) )
      nTotal_    	:= val(PegaDados('vProd' ,Alltrim(Linha) ,.f.) )
      cUnd_      	:= PegaDados('uCom'  ,Alltrim(Linha) ,.f.)
      dData_     	:= Comt->Data_
      cNumero_   	:= Comt->Numero_
      cCodOrigi  	:= PegaDados('cProd' ,Alltrim(Linha) ,.f.)
      
      cCodBarra  	:= ALLTRIM(PegaDados('cEAN'  ,Alltrim(Linha) ,.f.))
      cCODBARRA 	:=  IF( cCODBARRA=='0','',cCODBARRA )
     
      IF !EMPTY(cCODBARRA)
      
      	// VERIFICA SE É CÓDIGO DE BARRA DE CAIXA
         IF LEN( ALLTRIM( cCODBARRA ) )=14
            cCODBARRA := SUBSTR( cCODBARRA,2,12 )
            // SE FOR GERA NOVO CÓDIGO DE BARRA DE UNITARIO
            cCODBARRA := GERAEAN( @cCODBARRA )
         ENDIF
			
			// VALIDA O CODIGO DE BARRAS
         IF !VALIDAEAN( @cCODBARRA )
            BEEP()
            IF ALERT('CODIGO DE BARRAS NAO VALIDOU !!! ENTRA COM CODIGO DE BARRA AGORA ?', {'SIM','NAO'} ) = 1
               cTELACB := SAVESCREEN()
               JANELA( 08,20,14,70,  'CODIGO DE BARRA NAO VALIDADO' )
               @ 10,22 SAY 'CODIGO DA NOTA.: '+cCODBARRA
               @ 12,22 SAY 'NOME PRODUTO...: '+cNOMPRO_
               @ 12,22 SAY 'CODIGO DE BARRA:' GET cCODBARRA PICTURE EAN13G VALID VALIDAEAN( @cCODBARRA )
               READ
               RESTSCREEN( cTELACB, 08,20,14,70 )
            ENDIF
         ENDIF
						
      ENDIF
		
      cNCM       	:= PegaDados('NCM'   ,Alltrim(Linha) ,.f.)
      nIcms_     	:= val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
      cCfop_     	:= PegaDados('CFOP'  ,Alltrim(Linha) ,.f.)
      nIpi_      	:= val( PegaDados('pIPI' ,Alltrim(Linha) ,.f.) )
      cCfop_     	:= If( cCfop_ = '6102','5102','5405')
      IF cCRT = '1'
         cCSOSN_    := If( cCfop_ = '5102','900','500' )
      ELSE
         cCSOSN_    := If( cCfop_ = '5102','90','60' )
      ENDIF
      cCODGRU_   	:= ""
      cALTERADO_	:= ''
      // SELECIONA ARQUIVO DE ITENS DA COMPRA TEMPORARIO
      // E SALVA O ITEM DA COMPRA
      Sele Icomt
      dbAppend()
      nID_       	:= RECNO()
      Grava_var()
      
      // DIMINUI DO TEXTO LIDO O ITEM QUE FOIS SALVO
      nSize	    	:= nTAMLINHA-nLinhaLidas
      cLinhaTxt   := Right(cLinhaTxt,nSize)
      If EMPTY(cLINHATXT)
         Exit
      Endif
		
   Enddo

   EXIT

ENDDO

FCLOSE( nHANDLE )

return lRETORNO 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Function PgNArq(cArq)
// PEGA E LÊ DADOS DO XML
// VALOR DA NOTA, NOME DO FORNECEDOR, DATA DE EMISSAO

   Local nHANDLE  	:= FOPEN( cARQ,2 )
   Local	nTam			:= FSEEK( nHANDLE, 0, 2 )
   LINHA					:= IF( nTAM>65000,SPACE(10000),SPACE(nTAM) )
	FSEEK( nHANDLE, 0, 0 )
   FREAD( nHANDLE, @LINHA, IF( nTAM> 65000, 10000, nTAM)  )
	m_dEmi				:= PegaDados('dEmi'  ,Alltrim(Linha),.f. )
   m_Razao				:= PegaDados('xNome' ,Alltrim(Linha),.f. )
   
   IF nTAM > 65000
   	FSEEK( nHANDLE, nTAM - 10000, 0 ) 
   	LINHA2 := SPACE(10000)
   	FREAD( nHANDLE, @LINHA2, 10000 )
   	m_VALOR := Pegadados('vNF',  Alltrim(Linha2),.f. )
  	ELSE
  	   m_VALOR := Pegadados('vNF',  Alltrim(Linha),.f. )
   ENDIF
   
   m_cNF				:= PegaDados('nNF'   ,Alltrim(Linha),.f. )
   m_dEmi         := RIGHT( m_dEmi, 2 )+"/"+SUBSTR(m_dEmi,6,2)+"/"+LEFT(m_dEmi,4 )
   cDOCUME_			:= IF( LEN( m_cNF ) < 8 , m_cNF + SPACE( 8 - LEN(m_cNF) ), m_cNF )
   cCGC      		:= Pegadados('CNPJ', Alltrim(Linha),.f. )
   cCGC       		:= LEFT(cCGC,2)+'.'+SUBSTR(cCGC,3,3)+'.'+SUBSTR(cCGC,6,3)+'/'+SUBSTR(cCGC,9,4)+'-'+SUBSTR(cCGC,13,2)
   cString 			:= 'NF:'+cDOCUME_+' - '+UPPER(LEFT(m_Razao,18))+' / '+cCGC+' - '+m_dEmi+' - '+m_VALOR
   
   FCLOSE( nHANDLE )
   
   Return cString

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Function PegaDados(cProc, cLinha, lItem, cTexto2)

   Local InicioDoDado	:= Iif(cTexto2==Nil,"<"+cProc+">" , "<"+cProc )
   Local FinalDoDado 	:= Iif(cTexto2==Nil,"</"+cProc+">",'</'+cTexto2)
   Local nPosIni   		:= At(InicioDoDado,cLinha)
   Local nPosFim   		:= At(FinalDoDado,cLinha)
   Local cRet				:= '0'
   If nPosIni==0 .or. nPosFim==0
      Return cRet // aqui que ela aborta... retorna '0'
   Endif
   cRet := Substr(cLinha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
   If lItem ==.t.
      nLinhalidas += nPosFim
   Endif
   Return(cRet)


********************************************************************************
FUNCTION VERRESTO()
// FUNCAO PARA VERIFICAR E LER O RESTO DO ARQUIVO XML
LOCAL cTEXTO := cLINHATXT
nPOSICAO := FSEEK( nHANDLE, 0, 1 )
nRESTO 	:= nTAMANHO - nPOSICAO 
cLATUAL	:= SPACE(IF(nRESTO>64000,64000,nRESTO))
IF nRESTO != 0 
	IF nRESTO > 64000
   	FSEEK( nHANDLE, nPOSICAO, 0 )
   	FREAD( nHANDLE, @cLATUAL, 64000 )
	ELSE
   	FSEEK( nHANDLE, nPOSICAO, 0 )
   	FREAD( nHANDLE, @cLATUAL, nRESTO )
	ENDIF
ENDIF
nLINHALIDAS	:= 0
cTEXTO 		:= cTEXTO + cLATUAL
nTAMLINHA	:= LEN(cTEXTO)

RETURN cTEXTO 

********************************************************************************
// ALTERA O GRUPO DE TODOS OS ITENS DA COMPRA XML
// FUNCAO PARA ALTERAR O GRUPO DE TODOS OS ITENS DO XML 
FUNCTION ALTGXML()
LOCAL nRECNO := RECNO()

SETCURSOR(1)
JANELA(08,20,14,50)
COR("GETS")
nQTDE_ 	 	:= ICOMT->QTDE_
nQTDEARQ 	:= ICOMT->QTDE_
nUNITARIO	:= ICOMT->VALOR_ / ICOMT->QTDE_
cCODGRU_ 	:= ICOMT->CODGRU_
@ 10,22 SAY 'QTDE...:' GET nQTDE_    PICTURE "99999" VALID nQTDE_ > 0
@ 12,22 SAY 'GRUPO..:' GET cCODGRU_  PICTURE "@K999"  VALID  MUDACOD( @cCODGRU_ ) .AND. PESQGRU( @cCODGRU_ ) .AND. cCODGRU_!='99999'
READ

// ATUALIZA GRUPO
SELE ICOMT
DBGOTO( nRECNO )
WHILE(.T.)
	IF RLOCK()
		_FIELD->CODGRU_	:= cCODGRU_
		_FIELD->ALTERADO_ := 'S'
		DBCOMMIT()
		UNLOCK
		EXIT
	ENDIF
ENDDO

// ATUALIZA QTDES
* IF nQTDE_ > ICOMT->QTDE_
   WHILE(.T.)
      IF RLOCK()
         _FIELD->QTDE_ 	:= nQTDE_
         _FIELD->VALOR_	:= ICOMT->TOTAL_ / ICOMT->QTDE_
         _FIELD->UND_  	:= 'UN'
         DBCOMMIT()
         UNLOCK
         EXIT
      ENDIF
   ENDDO

RETURN NIL

*******************************************************
// ALTERA O NOME DO ITEM
FUNCTION ALTDESC()
LOCAL nRECNO := RECNO()

SETCURSOR(1)
JANELA(08,10,14,74)
COR("GETS")
cDESC      := ICOMT->NOMPRO_
cUND       := ICOMT->UND_
@ 10,12 SAY 'DESCRICAO:' GET cDESC PICTURE '@!'
@ 12,12 SAY 'UNIDADE..:' GET cUND  PICTURE '!!'
READ

// ATUALIZA GRUPO
SELE ICOMT
DBGOTO( nRECNO )
WHILE(.T.)
   IF RLOCK()
      _FIELD->NOMPRO_	:= cDESC
      _FIELD->ALTERADO_	:= 'S'
      _FIELD->UND_      := cUND
      DBCOMMIT()
      UNLOCK
      EXIT
   ENDIF
ENDDO

RETURN NIL

*******************************************************
// ALTERA GRUPO DOS ITENS DA COMPRA XML
FUNCTION ALTGXMLT()
LOCAL nRECNO := RECNO()

SETCURSOR(1)
JANELA(10,20,14,50) ; COR("GETS")
* cCODGRU_:=SPACE(03)
@ 12,22 SAY "GRUPO..:" GET cCODGRU_  PICTURE "999" VALID MUDACOD( @cCODGRU_ ) 
READ
SELE ICOMT
DBGOTOP()
WHILE !EOF()
   IF EMPTY(ICOMT->CODGRU_)
      WHILE (.T.)
         IF RLOCK()
            _FIELD->CODGRU_ 	:= cCODGRU_
            UNLOCK
            EXIT
         ENDIF
      ENDDO
   ENDIF
   DBSKIP()
ENDDO
DBCOMMIT()
DBGOTO( nRECNO )

RETURN NIL

*******************************************************
// ASSOCIA O PRODUTO A UM PRODUTO CADASTRADO NO SISTEMA
FUNCTION ASSPRO()
LOCAL cTELA  := SAVESCREEN(0,0,24,79)
LOCAL nRECNO := RECNO()

cCODPRO_ := SPACE(5)
cCODPRO_ := PESQUISA(cCODPRO_,.T.,"PRO",2,1,2,{"CODPRO_","ESPACO+NOMPRO_ +'³'+ UND_ + '³'+TRAN( CUSTONT_ ,PI8 ) +'³'+TRAN(PRO->ESTOQUE_,'99999')+'³'+PRO->CODGRU_"},{"CODI","PRODUTO                                         PRECO ESTOQ GRU" },{"@!","@K!"},{5,04,16,76},,.T.,.T.)

IF !ESC()
   SELE ICOMT
   _FIELD->CODPRO_ 		:= cCODPRO_
   _FIELD->NOMPRO_      := PRO->NOMPRO_
   _FIELD->CODGRU_ 		:= PRO->CODGRU_
   _FIELD->ALTERADO_  	:= 'S'
   DBCOMMIT()
ELSE
	ICOMT->CODPRO_ := SPACE(05)
ENDIF

SELE ICOMT
DBGOTO( nRECNO )
RESTSCREEN( 0,0,24,79, cTELA )
RETURN NIL

*******************************************************************************
// ASSOCIA O FORNECEDOR A UM FORNECEDOR CADASTRADO
FUNCTION ASSFORN()
LOCAL cTELA  	:= SAVESCREEN(0,0,24,79)
LOCAL lRETORNO := .F.

cCODIGO := SPACE(6)
cCODIGO := PESQUISA(cCODIGO,.T.,"FORN",1,2,1,{"CODIGO","NOME"},{"CODIGO","CLIENTE"},{"999999","@K!"},{15,10,23,75},,.T.,.T.)

IF !EMPTY( cCODIGO )
	SELE COMT
	_FIELD->CODFOR_ := cCODIGO
	cCODFOR_        := cCODIGO
	DBCOMMIT()
	lRETORNO := .T.
ENDIF

RESTSCREEN( 0,0,24,79, cTELA )
RETURN lRETORNO

********************************************************************************
STATIC FUNCTION PESQPRO2( cCODPRO_,LINHA,COLUNA )
LOCAL cALIAS := ALIAS()
LOCAL nORDEM := INDEXORD()
LOCAL ESPACO := " "
LOCAL nRECNO := RECNO()

PC	 := "@KE 9,999.999"

IF cCODPRO="99999"
	RETURN(.T.)
ENDIF

cCODPRO  := STRZERO( VAL( cCODPRO ),LEN( cCODPRO ) )
cCODPRO_ := PESQUISA(cCODPRO_,.T.,"PRO",2,1,2,{'CODPRO_',"ESPACO+NOMPRO_+'³'+PRO->UND_+'³'+TRAN( CUSTONT_ ,PC ) +'³'+TRAN(PRO->ESTOQUE_,'99999.999')"},{"CODI","PRODUTO                                UN    PRECO    ESTOQUE" },{"@!","@K!"},{5,03,23,77},,.T.,.T.)
COR("GETS")
cNOMPRO		:= LEFT(PRO->NOMPRO_,35)
nESTOQUE	:= PRO->ESTOQUE_
nVALOR		:= PRO->CUSTONT_
nLUCRO		:= PRO->LUCRO_
nVALORQ		:= PRO->PRVENDA_
cTRIB		:= PRO->TRIBUTO
cOBSIV_		:= PRO->OBSIV_
cUND		:= PRO->UND_
@ LINHA,COLUNA SAY "-"+LEFT(PRO->NOMPRO_,25)
@ 05,067 SAY TRAN( nVALOR, PI13C )

SELECT(cALIAS)
DBSETORDER(nORDEM)
DBGOTO(nRECNO)
RETURN(.T.)

****************************************************
Function FechaCom()
// FUNCAO PARA FECHAMENTO DA COMPRA
LOCAL nRECNO 	:= RECNO()
LOCAL cTELA     := SAVESCREEN(0,0,24,79)

IF ALERT('Confirma Processamento da Compra?',{'SIM','NAO'})=2
   RETURN NIL
ENDIF

MOSTRA('VERIFICANDO INTEGRIDADE DO DADOS...')

// VERIFICA SE TEM INFORMACAO DE GRUPO NO ITEM
SELE ICOMT
DBGOTOP()
WHILE !EOF()
  IF EMPTY(ICOMT->CODGRU_)
     BEEP()
   	 ALERT('NAO E POSSIVEL GERAR A COMPRA. EXISTE PRODUTOS SEM GRUPO')
   	 DBGOTO( nRECNO )
   	 RETURN NIL
  ENDIF
  DBSKIP()
ENDDO

SETCURSOR(1)
cCRT        := PERS->CRT
nMARGEMLC   := PERS->MVA
nFRETEP     := COMT->FRETE_
nVALOR_     := COMT->VALOR_
nVALORNOTA_ := COMT->VALORNOTA_
* JANELA(06,30,16,60,'MARGEM LUCRO')
@ 08,32 SAY 'TOT PROD:' GET nVALOR_     PICT PI12
@ 10,32 SAY 'TOT NOTA:' GET nVALORNOTA_ PICT PI12
@ 12,32 SAY 'MARGEM..:' GET nMARGEMLC 	PICT '999.99'
@ 14,32 SAY 'FRETE...:' GET nFRETEP   	PICT '999.99%'
READ
SETCURSOR(0)

IF ESC() .OR. PERG('CONFIRMA INCLUSAO DA COMPRA?')='N'
   RESTSCREEN( 0,0,24,79, cTELA )
   oTAB:REFRESHALL()
   RETURN NIL
ENDIF

RESTSCREEN( 0,0,24,79, cTELA )
*---> GRAVANDO O DOCUMENTO <---*
// LENDO DO ARQUIVO TEMPORARIO DE COMPRAS
SELE COMT
FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := IF(TYPE(FIELD(nI))=="C",SPACE(LEN(&(FIELD(nI)))),IF(TYPE(FIELD(nI))=="N",0,IF(TYPE(FIELD(nI))=="L",.F.,IF(TYPE(FIELD(nI))=="D",CTOD(""),""))) ) ; NEXT
IGUAL_VAR()

// GRAVANDO NO ARQUIVO DEFINITIVO DE COMPRAS
SELE COM
cNUMERO_:=NUMEROCOM()
DBAPPEND()
GRAVA_VAR()


// SELECIONA ARQUIVO DE ITENS TEMPORARIOS
SELE ICOMT
DBGOTOP()

// NUMERO DO ITEM A SER GRAVADO
nITEMT	:= RECCOUNT()
nITEM   	:= 0

WHILE !EOF()

   nITEM ++
   MOSTRA("GRAVANDO ITEM "+STR(nITEM,3)+" DE "+STR( nITEMT, 3 ))

   FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := IF(TYPE(FIELD(nI))=="C",SPACE(LEN(&(FIELD(nI)))),IF(TYPE(FIELD(nI))=="N",0,IF(TYPE(FIELD(nI))=="L",.F.,IF(TYPE(FIELD(nI))=="D",CTOD(""),""))) )
   NEXT
   // LIMPA VARIÁVEIS DO ARQUIVO DE ITENS
   LIMPA_VAR()
   // BUSCA DADOS DOS CAMPOS E COLOCA NAS VARIÁVEIS
   IGUAL_VAR()

	// SE A VARIÁVEL cCODPRO_ É VAZIA É PORQUE NÃO FOI ASSOCIADO NENHUM PRODUTO
   IF EMPTY( cCODPRO_ )

      // GERAR UM NOVO CODIGO
      cCODGRU_ := ICOMT->CODGRU_
      SELE GRU
      DBSETORDER(1)
      DBSEEK( cCODGRU_ )
      WHILE (.T.)
         // CRIA O NOVO CODIGO DE PRODUTO E GRAVA NO
         // CADASTRO DE GRUPO
         SELE GRU
         cCODPRO_= STRZERO( VAL(GRU->CODPRO_)+1,5 )
         WHILE(.T.)
            IF RLOCK()
               _FIELD->CODPRO_ := cCODPRO_
               EXIT
            ENDIF
         ENDDO
         // VERIFICA SE O CODIGO JÁ EXISTE
         SELE PRO
         DBSETORDER(1)
         DBGOTOP()
         IF DBSEEK( cCODPRO_ )
            LOOP
         ELSE
            EXIT
         ENDIF
      ENDDO

      SELE PRO

		// CRIA VARIÁVEIS CONFORME OS CAMPOS DO ARQUIVO DE PRODUTOS      
      FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := IF(TYPE(FIELD(nI))=="C",SPACE(LEN(&(FIELD(nI)))),IF(TYPE(FIELD(nI))=="N",0,IF(TYPE(FIELD(nI))=="L",.F.,IF(TYPE(FIELD(nI))=="D",CTOD(""),""))) )
      NEXT
      
      // LIMPA AS VARIÁVEIS
      LIMPA_VAR()

		// DEFINE VALORES PARAS AS VARIÁVEIS
		// ALGUNS VALORES SÃO DEFAULT
		// ESSE DADOS DEPENDERÁ DO SISTEMA
      cCODPRO_      := GRU->CODPRO_
      cCODGRU_      := GRU->CODGRU_
      cNOMPRO_      := ICOMT->NOMPRO_
      cUND_         := ICOMT->UND_
      cCFOPSAIDA    := IF( ICOMT->CFOP_ ='5102','6102','6404')
      cTRAVAPRO_    := 'N'
      cPISCOFINS    := 'N'
      cREFERE_      := ICOMT->DATA_
      cCODFOR_      := FORN->CODIGO
      cNCM          := ICOMT->NCM
      cCODBARRA     := ICOMT->CODBARRA
		cCODORIGI     := ICOMT->CODORIGI
      cTRIBUTO      := IF( ICOMT->CFOP_='5102','NN','FF')
      cCFOP_        := ICOMT->CFOP_
      cCSOSN_       := ICOMT->CSOSN_
      nICMS_        := ICOMT->ICMS_

      nCARGAM_      := PERS->CARGAM
      nCUSTOOP_     := PERS->CUSTOOP                                                   	
      nSIMPLES_     := PERS->SIMPLES

      nCUSTONT_     := ICOMT->VALOR_
      nFRETE_       := nFRETEP
      nIPI_         := ICOMT->IPI_
      nMARGEM_      := nMARGEMLC
      nMARGEML_     := PERS->MARGEML_

      nCUSTOTMP   	:= nCUSTONT_ + ( nCUSTONT_ * PERS->MVA / 100 )
      nFRETETMP   	:= nCUSTONT_ * nFRETE_ / 100
      nVLPIS	  		:= 0.00
      nVLPISCOFINS	:= 0.00

      nSIMPLE_			:= PERS->SIMPLES + ( PERS->SIMPLES * PERS->MVA / 100 )
      nCUSTO_			:= nCUSTOOP_ + ( nCUSTOOP_ * PERS->MVA / 100 )
      nPRCUSTO_ 		:= nCUSTONT_ +  ( nCUSTONT_ * ( nCARGAM_ + nCUSTO_ + nIPI_ + nFRETE_ + nDIV_ + nSIMPLE_ ) / 100 )

      // LUCRO REAL
      IF cCRT ="3"

         // CALCULO DO PRECO DE CUSTO
         cPISCOFINS 	:= "S"
         nCUSTOTMP   := nCUSTONT_ + ( nCUSTONT_ * PERS->MVA / 100 )
         nFRETETMP   := nCUSTONT_ * nFRETE_ / 100
         nVLPIS	  	:= 0.00
         nVLPISCOFINS:= 0.00
         nCRCOFINS	:= ( nCUSTONT_ + nFRETETMP )  * PERS->COFINS / 100
         nDBCOFINS	:= nCUSTOTMP * PERS->COFINS / 100
         nVLCOFINS	:= nDBCOFINS - nCRCOFINS
         nCRPIS		:= ( nCUSTONT_ + nFRETETMP ) * PERS->PIS / 100
         nDBPIS		:= nCUSTOTMP * PERS->PIS / 100
         nVLPIS		:= nDBPIS - nCRPIS
         nIRPJPRO		:= nCUSTOTMP * PERS->IRPJPRO / 100
         nVLPISCOFINS:= nVLCOFINS + nVLPIS + nIRPJPRO

         nSIMPLE_		:= 0.00
         nCUSTO_		:= nCUSTOOP_ + ( nCUSTOOP_ * PERS->MVA / 100 )
         nPRCUSTO_	:= nCUSTONT_ + nVLPISCOFINS + ( nCUSTONT_ * ( nCARGAM_ + nCUSTO_ + nIPI_ + nFRETE_ + nDIV_ + nSIMPLE_ ) / 100 )

      ENDIF

      // CALCULO DO PRECO DE VENDA  SUGERIDO
      nPRVENDASG_ := nPRCUSTO_+ ( nPRCUSTO_ * nMARGEM_ / 100 )
      nPRVENDA_   := nPRVENDASG_
      nLUCRO_     := nPRVENDA_ - nPRCUSTO_

      // CALCULA O LUCRO
      nLUCRO_ := nPRVENDA_ - nPRCUSTO_

      // CALCULA O PRECO DE VENDA DO LIVRO
      * CALCPLV( @nPRVENDAL_ )
      nPRVENDAL_ := nPRVENDA_ + ( nPRVENDA_ * nMARGEML_ / 100 )

      DBAPPEND()
      GRAVA_VAR()
      
   ELSE

      // JA VEIO O CODIGO DO PRODUTO
      SELE PRO
      DBSETORDER(1)
      DBGOTOP()
      DBSEEK( cCODPRO_ )
 	   cNOMPRO_ := ICOMT->NOMPRO_
      cUND     := ICOMT->UND_
      cNCM     := ICOMT->NCM
      * cCODBARRA:= ICOMT->CODBARRA
      cCODORIGI:= ICOMT->CODORIGI

   ENDIF

   *---> GRAVANDO ITENS DO DOCUMENTO <---*
   cNUMERO_ := COM->NUMERO_
   cDOCUME_ := COM->DOCUME_
   SELE ICOM
   DBAPPEND()
   GRAVA_VAR()

   IF PERS->KARDEX="S"
      SELE HIST
      DBAPPEND()
      _FIELD->CODPRO_  := ICOM->CODPRO_
      _FIELD->CODCLI_  := FORN->CODIGO
      _FIELD->NOMCLI_  := FORN->NOME
      _FIELD->QTDE_	  := ICOM->QTDE_
      _FIELD->DATA_	  := ICOM->DATA_
      _FIELD->NUMVEN_  := ALLTRIM(ICOM->DOCUME_)
      _FIELD->LANCA_   := "C"
      _FIELD->HORA_	  := TIME()
   ENDIF

   *---> ATUALIZANDO ESTOQUE <---*

   SELE PRO
   WHILE(.T.)

      IF RECLOCK()

         // ALTERA ESTOQUE
         _FIELD->PRO->ESTOQUE_	:= PRO->ESTOQUE_+ICOM->QTDE_
         _FIELD->PRO->NOMPRO_ 	:= ICOMT->NOMPRO_
         _FIELD->PRO->NCM     	:= ICOMT->NCM
         * _FIELD->PRO->CODBARRA:= ICOMT->CODBARRA
         _FIELD->PRO->CODORIGI	:= ICOMT->CODORIGI
         _FIELD->PRO->REFERE_		:= ICOM->DATA_
         _FIELD->PRO->CODFOR_		:= FORN->CODIGO
         
         IF PERS->CALCOMPRA="S"

            // ALTERA PRECOS
            _FIELD->PRO->CUSTONT_ 	:= ICOM->VALOR_

         ENDIF

         EXIT

      ENDIF

   ENDDO

   SELE ICOMT
   DBSKIP()
   lCOMPROU := .T.
   
ENDDO

DBCOMMITALL()
ICOMTSAIR := .F.
KEYBOARD CHR(27)

RETURN NIL


********************************************************************************
Static Function ValidaEAN(cCodBar)

Local nInd	:= 0
Local nUnidade := 0
Local nDigito	:= 0
Local lRetorno := .T.
Local aPosicao[12]

IF EMPTY( cCODBAR )
	RETURN lRETORNO
ENDIF

MUDACOD( @cCODBAR )

cCODBAR := StrZero(Val(AllTrim(cCODBAR)), 13, 0)

For nInd := 1 to 12
	aPosicao[nInd] := Val(SubStr(cCODBAR, nInd, 1))
Next

nUnidade := Val(Right(Str(((aPosicao[2]+aPosicao[4]+aPosicao[6]+aPosicao[8]+aPosicao[10]+aPosicao[12])*3) + ( aPosicao[1]+aPosicao[3]+aPosicao[5]+aPosicao[7]+aPosicao[9]+aPosicao[11])), 1))
nDigito  := If((10-nUnidade ) > 9, 0, 10-nUnidade)
lRetorno := nDigito = Val(Right(AllTrim(cCODBAR), 1))

Return lRetorno

********************************************************************************
* Funcao para gerar o digito do codigo de barra
Function GeraEan( cCodBar )
Local nInd		:= 0
Local nUnidade := 0
Local nDigito	:= 0
Local lRetorno := .T.
Local aPosicao[12]


* cCodBar := StrZero(Val(AllTrim(cCODBAR)), 13, 0)

// Atribui valores pare e negativos nos respectivos campos
For nInd := 1 to 12
	aPosicao[nInd] := Val(SubStr(cCodBar, nInd, 1))
Next

nUnidade := Val(Right(Str(((aPosicao[2]+aPosicao[4]+aPosicao[6]+aPosicao[8]+aPosicao[10]+aPosicao[12])*3) + ( aPosicao[1]+aPosicao[3]+aPosicao[5]+aPosicao[7]+aPosicao[9]+aPosicao[11])), 1))
nDigito  := If((10-nUnidade ) > 9, 0, 10-nUnidade)

Return cCodBar + str( nDigito, 1 )

***************************************************************************
/*
Funcao para limpeza das variaveis criadas automaticamente em cada funcao de
inclusao do sistema. Deixa todas as variaveis em branco.
*/
FUNCTION Limpa_Var()
LOCAL nI
FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := IF(TYPE(FIELD(nI))=="C",SPACE(LEN(&(FIELD(nI)))),IF(TYPE(FIELD(nI))=="N",0,IF(TYPE(FIELD(nI))=="L",.F.,IF(TYPE(FIELD(nI))=="D",CTOD(""),""))) ) ; NEXT
RETURN NIL
***************************************************************************
/*
Funcao que iguala as variaveis criadas automaticamente no inicio de cada
inclusao do sistema com os dados no arquivo DBF.
*/
FUNCTION Igual_Var()
LOCAL nI
FOR nI:= 1 TO FCOUNT() ; &(TYPE(FIELD(nI))+FIELD(nI)) := &(FIELD(nI)) ; NEXT
RETURN NIL
***************************************************************************
/*
Funcao que retira as variaveis criadas automaticamente no inicio de cada
inclusao do sistema da memoria.
*/
FUNCTION Apaga_Var()
LOCAL nI
FOR nI := 01 TO FCOUNT(); NomeCampo := (TYPE(FIELD(nI))+FIELD(nI)) ; RELEASE &NomeCampo ; NEXT
RETURN NIL
***************************************************************************
/*
Funcao que grava o conteudo das variaveis criadas automaticamente no inicio
de cada rotina de inclusao no banco de dados.
*/
FUNCTION Grava_Var()
LOCAL nI
FOR nI := 01 TO FCOUNT() ;_FIELD->&(FIELD(nI)) := &(TYPE(FIELD(nI))+FIELD(nI)) ; NEXT
RETURN NIL
