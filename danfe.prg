* STATIC wLojaEstq := '01'
/* Desenvolvido por :
   ANALISTA/PROGRAMADOR : JOAO APARECIDO FRAZATO
   CONTATO              : 14 33268464 9714-0865
                          frazato@ibest.com.br sistema_jaf@hotmail.com

   OBJETIVO : LER ARQUIVO DANFE FORMATO XML E FAZER O LANCEMENTO
   DE NOTA FISCAL

   OBSERVACAO          : MODULO FAZ PARTE DO SISTEMA JAF USANDO GTWVW

*/

//------------------------------------------------------------
Function LerDanfe()
Local Estru     := {  {'Id'        ,'C', 44,0},;
                      {'ErroJAF'   ,'l', 01,0},;  //
                      {'Ocorrenc'  ,'C', 20,0},;  //
                      {'CNPJ'      ,'C', 14,0},;  //
                      {'cProd'     ,'C', 16,0},;
                      {'xProd'     ,'C', 60,0},;  // Codigo Interno
                      {'cEAN'      ,'C', 16,0},;
                      {'qCom'      ,'N', 13,3},;
                      {'vProd'     ,'N', 13,2},;
                      {'vUnCom'    ,'N', 11,3},;
                      {'vIcms'     ,'N', 11,3},;
                      {'vPis'      ,'N', 11,3},;
                      {'vCofins'   ,'N', 11,3},;
                      {'vIpi'      ,'N', 11,3} }


    Parameters cFileDanfe

    // Pegando Arquivo na Pasta

    mDiretorio := 'C:\DANFE\'
    mArquivo   := '*.XML'
    mListaArq  := Directory(mDiretorio+mArquivo,"D")
    cLista     := {}
    For i := 1 to Len(mListaArq)
        cNomeForne := PegaNomeArquivo(mDiretorio+mListaArq[i,1])
        Aadd(cLista,Substr(mListaArq[i,1]+space(30),1,30)+' '+cNomeForne)
    Next
    CAIXATEXTO(07,08,8+Len(cLista),85,"ESCOLHA O ARQUIVO COM O DANFE ","BG+/NB+","NN/NN","N")
    nOpcao  := Achoice(08,09,9+Len(cLista),84,cLista,.t.)
    FechaJanela()
    If nOpcao== 0
       Return Nil
    Endif
    *cFileDanfe := mDiretorio+cLista[nOpcao]
    cFileDanfe := mDiretorio+mListaArq[nOpcao,1]
    

    Dbcreate('c:\temp\Danfe.dbf',Estru)
    
    If cFileDanfe==Nil
       Alerta('Informe o nome do Danfe em xml')
       Return nil
    Endif

    If ! file(cFileDanfe)
         Alerta('Arquivo nao Localizado'+cFileDanfe)
         Return nil
    Endif

    CORES()
    CAIXATEXTO(11,03,14,80,"IMPORTAR DANFE  (Xml) ","G/GR+","BG+/NB+","NN/NN","N")
    cPegaChave := Space(47)
    @ 12,05 say 'Chave Danfe ' Get cPegaChave Pict "@!" Color('WW+/RR+')
    Read
    If LastKey()==27
       FechaJanela()
       Return nil
    Endif
    FechaJanela()

    Linha       := Memoread(cFileDanfe)
    nLinhalidas := 0
    Linhatotal  := Len(Linha)
    cLinhaTxt   := Linha

    //-- Pega Id da Nota Fiscal
    nPos1 := At('Id="',Linha)
    If nPos1==0
       Alerta('Erro no Arquivo '+cFileDanfe+Chr(10)+;
               'Id=')
       Return nil
    Endif
    nPos1 := nPos1+Len('Id="')
    cChave:= Substr(Linha,nPos1,47)

    //-- Pegando Cgc para Pesquisa do Item na base de SKus

    nPos1 := At('<CNPJ>',Linha)
    If nPos1==0
       Alerta('Erro no Arquivo '+cFileDanfe)
       Return nil
    Endif

    nPos1   := nPos1+Len('<CNPJ>')
    cCGCEmit:= Substr(Linha,nPos1,14)

    //---Pegando Dados para Lancamento da Capa da Nf


    If cPegaChave#Substr(cChave,4,47)
       ALerta('Arquivo Lido nao corresponde ao Desejado!')
    Endif
    m_vNf   := PegaDados('nNF' ,Alltrim(Linha) ,.f.)
    m_cNF   := PegaDados('nNF' ,Alltrim(Linha)  ,.f.)
    m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
    m_dEmi  := PegaDados('dEmi' ,Alltrim(Linha),.f. )
    m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )

    cMsg  := '###### IMPORTA DANFE ######'+CHR(10)+;
             'Razao Social:'+m_Razao      +CHR(10)+;
             '   Nr Nota  :'+m_cnf + 'Serie Nota  :'+m_serie  +CHR(10)+;
             'Data Emissao:'+m_Demi       +CHR(10)+;
             'Valor Nota  :'+transf(Val(m_vnf),'@EZ 999,999.99')+Chr(10)+;
             'Nr.Chave   :'+Substr(cChave,4,47) +Chr(10)+;
             'CGC Emit   :'+cCGcEmit 

    IF MsgConf(cMsg,"1") == .F.
       Return nil
    Endif

    // Uso no Rauxilio
    cIdNota := StrZero(val(m_cnf),6)

    Close All
    /* Abrindo Base de dados
    */ 

    Sele 1
         Use Produto
         Set index to Produto

    Sele 2
         Use CadSkus Alias Skus
         Set index to CadSkus

    Sele 3
         use Arqnotas 
         Set index to Arqnotas

    Sele 4
         Use Forneced
         Set index to Forneced

    Sele 5
         use c:\temp\Rauxilio Alias Rauxilio 
         Set index to c:\temp\rauxilio

    Sele 6
         Centra(24,"Arquivo de Capa de Pedido")
         Use Compra02 Alias CapaPed 
         Set index to Compra02

    Sele 7
         Centra(24,"Arquivo de Item de Pedido")
         Use Compra03 Alias DPedido 
         Set index to Compra03

    Sele 8
         Use c:\temp\Danfe Alias Danfe Exclusive
         If Neterr()==.t.
            Alerta('Terminal ja esta em uso ( Recebimento)')
            Close All
            Return nil
         Endif
         Index on Id+cProd to c:\temp\danfe
         Set index to c:\temp\danfe

    Centra(24,'Lendo DANFE'+cChave)

    LancCapaNota()

    Centra(24,'Lendo DANFE (Produtos)'+cChave)


    Do While .t.

           *cLidos := PegaDados('prod',Alltrim(cLinhaTxt),.t. )
            cLidos := PegaDados('det nItem',Alltrim(cLinhaTxt),.t.,'det' )
            Linha  := cLidos
            If Linha=='0'
               Exit
            Endif

            mxProd  := PegaDados('xProd',Alltrim(Linha) ,.f.)
            mcprod  := Alltrim(Str(val(PegaDados('cProd',Alltrim(Linha) ,.f.) ),16))
            mqcom   := Val(PegaDados('qCom' ,Alltrim(Linha) ,.f.) )
            mvprod  := Val(PegaDados('vProd',Alltrim(Linha) ,.f.) )
            mcean   := PegaDados('cEan' ,Alltrim(Linha) ,.f.) 
            mvuncom := val(PegaDados('vuncom' ,Alltrim(Linha) ,.f.) )
            mvIcms  := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
            mVpis   := val(PegaDados('vPIS' ,Alltrim(Linha) ,.f.) )
            mVCofins:= val(PegaDados('vCOFINS' ,Alltrim(Linha) ,.f.) )

            

            cPesq  := Substr(cChave,4,47)+mcprod
            
            Sele Danfe
                 Go top
                 Seek cPesq
                 If ! found()
                      Append Blank
                 Endif
                 Repla Danfe->Id          With Substr(cChave,4,47)
                 Repla Danfe->cnpj        With cCGcEmit
                 Repla Danfe->xprod       With mxProd
                 Repla Danfe->cean        With mcean
                 Repla Danfe->cprod       With mcprod
                 Repla Danfe->qcom        With mqcom
                 Repla Danfe->vprod       With mvprod
                 Repla Danfe->vuncom      With mvuncom
                 Repla Danfe->vIcms       With mvIcms
                 Repla Danfe->vPis        With mVpis
                 Repla Danfe->vCofins     With mVCofins

            
            nSize         := Linhatotal-nLinhaLidas
            cLinha        := Right(cLinhaTxt,nSize)
            cLinhaTxt     := cLinha
            If nLinhaLidas >= Linhatotal
               Exit
            Endif
    Enddo
    Go top

    /* Solicitando Nr de pedido para Anexar aos itens

    */

    nNumerPedido := PegaPedido( ARQNOTAS->CLI_CODI)


    IF MsgConf("Importar Pedido ?"+chr(10)+;
                'Nr :'+nNumerPedido,"1") == .T.

       /* Gravando os dados dos produtos no Rauxilio.dbf
       */
       ProcessaDanfe(nNumerPedido)

    Endif
Return nil

//------------------------------------------------------
Function PegaDados(cProc,cLinha,lItem,cTexto2)
Local InicioDoDado :=Iif(cTexto2==Nil,"<"+cProc+">" , "<"+cProc )
Local FinalDoDado := Iif(cTexto2==Nil,"</"+cProc+">",'</'+cTexto2+'>')
Local nPosIni     := At(InicioDoDado,cLinha)
Local nPosFim     := At(FinalDoDado,cLinha)
Local cRet        := '0'
If nPosIni==0 .or. nPosFim==0
   Return cRet
Endif
cRet := Substr(cLinha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
If lItem ==.t.
   nLinhalidas  += nPosFim
Endif
Return  ( cRet)


//------------------------------------------------------------
Static Function ProcessaDanfe(cIdPedido)
Local cIdForne:= ''
Sele Danfe
     nSeq    := 0
     Go top

     Do While ! Eof()
             Centra(24,'Lancando Item via DANFE.....'+Str(nSeq++,5))
             cidforne  := ''
             Sele Forneced
                  OrdsetFocus('fornece1')
                  Go top
                  Seek StrZero(Val(cCGCEmit),15)
                  If Found()
                     cidForne := Forneced->Codigo
                     If ! Empty(Forneced->Empr_Princ)
                          cidForne := Forneced->Empr_Princ
                     Endif
                  Endif

             mCodigo := ''   // Codigo Item
             mAlterar:= .F.  // Faz a inclusao

             cIdItem := Substr(Danfe->cProd+Space(16),1,16)

             Sele Skus
                  OrdSetfocus('Skus03')
                  Go Top
                  Seek ( cIdforne + cIdItem)
                  If ! Found()
                       // Grava Erro
                       Sele Danfe
                            Repla Danfe->Ocorrenc  With '1-Codigo Invalido JAF'
                            Repla Danfe->ErroJAF   With .t.
                            Skip+1
                            Loop

                  Endif

             mCodigo := Skus->Cod_Prod

             Sele Produto
                  OrdsetFocus('Prod01')
                  Go top
                  Seek mCodigo
                  If ! Found()
                       // Erro 
                       Sele Danfe
                            Repla Danfe->Ocorrenc  With '2-Skus Desativado'
                            Skip+1
                            Loop
                  Endif
                  lPed := .t.
                  cMsg := ''
                  Sele DPedido
                       OrdSetFocus('DCmp01')
                       Go top
                       Seek mCodigo+cIdPedido
                       If ! Found()
                            cMsg := '## Sem Pedido ##'
                            lPed := .f.
                       Endif

                       If (Dpedido->QPedido - Dpedido->Qtd_Receb)  <= 0
                          cMsg := '## Sem Pedido ##'
                       Endif
                       vQtdPedido := Dpedido->QPedido - Dpedido->Qtd_Receb

                       If vQtdPedido < Danfe->qCom
                          cMsg := 'Bola :'+Str(vQtdPedido - Danfe->qCom,7,3)
                       Endif
                  

             Sele Rauxilio
                  Set Filter to // 
                  OrdSetFocus("Raux1")
                  Go top
                  SEEK ( MCODIGO + CIDNOTA )
                  If Found()
                     mAlterar := .t.
                  Endif
                        
                  mPQuanti   := Danfe->qCom  // Danfe->vUnCom
                  mPQuanti1  := 0
                  mPCusto    := Danfe->vProd / Danfe->qCom
                  mPDescon   := 0
                  mPTribut   := space(1)
                  mPVenda    := 0
                  mTit_Emb   := Produto->Tit_Emb
                  mQtd_Emb   := Produto->Embalcompr
                  mTxa_Fre   := Produto->Frete
                  mPAcresc   := 0
                  nValorSubst:= 0
                  mTit_Emb   := "UND"
                  cCst       := '???'
                  mPcusto    := ( (mPcusto - (  ( mPcusto * mPDescon ) /100 )) + (  ( mPcusto * mPAcresc ) /100 ) ) 
                  mCustoNovo := mPcusto / mQtd_Emb
                  xTxaRateio := ( ( mPcusto ) * (mPQuanti +  mPQuanti1) ) * mQtd_Emb
                  xTxaRateio := ( (xTxaRateio / ArqNotas->ValorFrete) * 100 ) // 100 Colocado
                  mTxa_Fre   := 0 // Iif(ArqNotas->ValorFrete <= 0,0,xTxaRateio)
                  mQtd_Emb   := 1

                  Sele Rauxilio
                        If mAlterar == .F.    // Faz a Inclusao no Rauxilio
                           Append blank
                        Endif
                        Trav_reg()
                                 repla RAUXILIO->Qentrada   with mPQuanti  
                                 repla RAUXILIO->Qentrad1   with mPQuanti1 
                                 repla RAUXILIO->CUSTO_ATUA with mPcusto
                                 repla RAUXILIO->Dentrada   with date()
                                 repla RAUXILIO->Tit_Embal  with mTit_Emb    
                                 repla RAUXILIO->Qtd_Embal  With mQtd_Emb
                                 Repla Rauxilio->cst_nf     With cCst
                                 Repla Rauxilio->ValorSubst With nValorSubst
                                 repla RAUXILIO->tp_mvto    with "C"
                                 repla RAUXILIO->codigo     with produto->codigo
                                 repla RAUXILIO->descricao  with produto->descricao
                                 repla RAUXILIO->Venda_atua with Produto->Venda
                                 repla RAUXILIO->CUSTO_ANTI with PRODUTO->CUSTO
                                 repla RAUXILIO->DentradaA  with PRODUTO->DT_CUSTO
                                 repla RAUXILIO->icmsc      with produto->icmsc
                                 repla RAUXILIO->icmsv      with produto->icmsv
                                 repla RAUXILIO->depto      with produto->depto
                                 repla RAUXILIO->MARG_NV1   with produto->MARGEM
                                 repla RAUXILIO->MARG_NV2   with produto->MG2
                                 repla RAUXILIO->MARG_NV3   with produto->MG3
                                 repla RAUXILIO->TpoTrbto   with Produto->TpTributad
                                 repla RAUXILIO->Red_Calc   With Produto->PmargReduc
                                 Repla RAUXILIO->TxaFrete   With Produto->Frete
                                 Repla RAUXILIO->TxaIpi     With Produto->Ipi

                                 repla RAUXILIO->nf_cfo     With ArqNotas->CodContab   // CFop Notas
                                 repla RAUXILIO->nf_num     with ARQNOTAS->NUMERO_NF
                                 repla RAUXILIO->nf_serie   with ARQNOTAS->SERIE_NF
                                 repla RAUXILIO->nf_dest    with ARQNOTAS->CLI_CODI
                                 repla Rauxilio->VencNota   With Arqnotas->vencto_1


                                 If RAUXILIO->ValorIpi==0
                                         If RAUXILIO->TxaIpi > 0
                                            Repla RAUXILIO->ValorIpi   With ( ( mCustoNovo * RAUXILIO->TxaIpi / 100 ) *mQtd_Emb ) * (mPQuanti +mPQuanti1 )
                                         Endif
                                 Endif
                                 Repla Rauxilio->SeqNota    With nSeq
                                 Repla RAUXILIO->Dentrada   with date()
                                 Repla RAUXILIO->CUSTO_ANTI with PRODUTO->CUSTO


                             If lPed==.t.
                                 Repla Rauxilio->Qtd_EmbaR  With DPedido->EmbalCompr
                                 Repla Rauxilio->Ofertar    With DPedido->Ofertar
                                 repla RAUXILIO->icmsc      with DPedido->icmsc   
                                 Repla Rauxilio->ValorSubst With Dpedido->St

                                 If Dpedido->Ipi#0
                                    Repla Rauxilio->ValorIpi With Dpedido->Ipi
                                 Endif
                                 Repla RAUXILIO->Pedi_Nume  With cIdPedido

                                 Repla Rauxilio->CustoIdeal With DPedido->CustoFinal
                                 Repla Rauxilio->Desc_finan With DPedido->Desc_finan
                                 Repla Rauxilio->AbatFinan  With DPedido->AbatFinan
                                 Repla Rauxilio->Pedi_vUni  with Dpedido->Preco / Dpedido->EmbalCompr
                                 Repla RAUXILIO->CUSTO_ATUA with Dpedido->Preco / Dpedido->EmbalCompr
                                 Repla Rauxilio->Pedi_Qtd   with ( Dpedido->QPedido - Dpedido->Qtd_Receb ) * Dpedido->EmbalCompr
                              Endif
                              Destrava()
          Sele Danfe
               Repla Danfe->Ocorrenc  With cMsg
               Repla Danfe->ErroJAF   With .t.
               Skip+1
   Enddo
   // Mostra Erros
   Set filter to Danfe->ErroJAF==.t.
   Set device to Printer
   Set printer to c:\temp\danfe.txt
   Go top
   SetPrc(0,0)
   Lin := 0
   @ Lin++,00 say Repli('-',80)
   @ Lin++,00 say padc('JAF DESENV. LTDA  - IMPORTACAO ARQUIVOS',80)
   @ Lin++,00 say padc('CRITICA IMPORTACAO DANFE',80)
   @ Lin++,00 say Repli('-',80)
   @ Lin++,00 say 'FORNECEDOR  :'+m_Razao
   @ Lin++,00 say 'Nr.Nota     :'+m_cNF +' Serie :'+m_serie
   @ Lin++,00 say 'Nr.Chave    :'+Substr(cChave,4,47)
   @ Lin++,00 say Repli('-',80)
   @ Lin++,00 say 'Seq.  Codigo   ### Produto     ###            Quantidade  ### Erro Reportado ###'
   @ Lin++,00 say Repli('-',80)

   Lin++
   Do while ! Eof()
           cString := Str(Recno(),3)+'     '+;
                      Substr(Danfe->cProd,1,6)+'-'+Substr(danfe->xProd,1,30)+' '+;
                      Str(Danfe->qCom,11,3)+'  '+;
                      Danfe->Ocorrenc
           @ Lin++,00 say cString
           Skip+1
   Enddo
   @ Lin++,00 say Repli('-',80)

   Set device to Screen
   Set printer off
   preview("danfe")
Return Nil


//------------------------------------------------
Static Function LancCapaNota()
Local Ok         := .t.
Local cChaveNota
Local InicioDoDado := '<total>'
Local FinalDoDado  := '</total>'
Local nPosIni      := At(InicioDoDado,Linha)
Local nPosFim      := At(FinalDoDado,Linha)
Local cRet         := '0'
If nPosIni==0 .or. nPosFim==0
   Return cRet
Endif
cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
Linha        := cRet
mDataLanca   := Date()
mEmissao     := Char2Data( PegaDados('dEmi' ,Alltrim(Linha) ,.f.) )
mDataLanca   := Date()
mAgenda      := '003'
mContabil    := Val(PegaDados('vNF' ,Alltrim(Linha) ,.f.)) 
mNotaNumero  := StrZero( Val(PegaDados('nNF' ,Alltrim(Linha) ,.f.)),6)
mNotaSerie   := PegaDados('serie' ,Alltrim(Linha) ,.f.) 
mCodigo      := Forneced->Codigo
mVencto_1    := Ctod('//')
mVlrVenc1    := Val(PegaDados('vNF' ,Alltrim(Linha) ,.f.)) 
mTotalProd   := Val(PegaDados('vProd' ,Alltrim(Linha) ,.f.))
mTotalIcms   := Val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.))
mFreteNf     := 0
mTotalIpi    := 0
mEspecie     := 'NFe'
xEstadoForn  := PegaDados('UF' ,Alltrim(Linha) ,.f.) 
mBaseSubs    := 0
mValorSubs   := 0
mCodFisc     := '???'
mValorOutro  := 0
xPediUsar    := ''
mCodigo      := ''

         Sele Forneced
              OrdsetFocus('fornece1')
              Go top
              Seek StrZero(Val(cCGCEmit),15)
              If ! Found()
                   Return .f.
              Endif
              mCodigo    := Forneced->Codigo
              MNOTASERIE := Substr(MNOTASERIE+Space(4),1,4)
              cChaveNota := MNOTANUMERO+MNOTASERIE+mCodigo
              

              // Quando o vencimento vir embranco pegar o do cadastro!

              If Empty(mVencto_1)
                 mVencto_1 := mEmissao + val(Forneced->Pagto)
              Endif

         Sele ArqNotas
              ORDSETFOCUS("ArqNf8")
              Go Top
              Seek (cChaveNota)
              IF ! FOUND()
                   Append Blank
              ENDIF
              Trav_reg()
                     repla ArqNotas->data_lc          with mDataLanca
                     repla ArqNotas->data_nf          with mEmissao
                     Repla ArqNotas->Lanc_Livro       with mDataLanca
                     repla ArqNotas->agenda           with mAgenda
                     repla ArqNotas->movto            with "C"
                     repla ArqNotas->Status           with "I"
                     repla ArqNotas->valor_nf         with mContabil
                     repla ArqNotas->numero_nf        with mNotaNumero
                     repla ArqNotas->serie_nf         with mNotaSerie
                     repla ArqNotas->cli_codi         with mCodigo
                     repla ArqNotas->cli_nome         with Forneced->Razao

                     repla ArqNotas->vencto_1         with mVencto_1
                    *repla ArqNotas->vencto_2         with mVencto_2
                    *repla ArqNotas->vencto_3         with mVencto_3
                    *repla ArqNotas->vencto_4         with mVencto_4
                     repla ArqNotas->ctrl_int         with "I"

                     Repla ArqNotas->VlrVenc1         With mVlrVenc1   
                    *Repla ArqNotas->VlrVenc2         With mVlrVenc2
                    *Repla ArqNotas->VlrVenc3         With mVlrVenc3
                    *Repla ArqNotas->VlrVenc4         With mVlrVenc4   

                     Repla ArqNotas->ValorProd        With mTotalProd 
                     Repla ArqNotas->ValorIcms        With mTotalIcms
                     Repla ArqNotas->ValorFrete       With mFreteNf
                     Repla ArqNotas->ValorIpi         With mTotalIpi
                     Repla ArqNotas->Especie_Nf       With mEspecie

                     Repla ArqNotas->RotaEntrg        With xEstadoForn
                     Repla ArqNotas->Uf_Nota          With Forneced->UF

                     Repla ArqNotas->BaseSubstr       With mBaseSubs
                     Repla ArqNotas->ValorSubst       With mValorSubs
                     Repla ArqNotas->CodContab        With mCodFisc
                     Repla ArqNotas->ValorOutro       With mValorOutro
                     Repla Arqnotas->PEDNUMERO        With StrZero(Val(xPediUsar),7)
                     Repla Arqnotas->Loja             With StrZero(val(wLojaEstq),2)
                     Repla Arqnotas->MsgAdicio        With Substr(cChave,4,47)
                   Destrava()
Return Ok

//---------------------------------------
Static Function Char2Data(cString)
Local i
Local lRet := ''
Local cAno := Substr(cString,1,4)
Local cMes := Substr(cString,6,2)
Local cDia := Substr(cString,9,2)
lRet := cDia+'/'+cMes+'/'+cAno
Return Ctod(lRet)


//------------------------------------------------------------
Static Function PegaPedido(mcodiForne)
  Sele Forneced
       OrdSetFocus("Forneced")
       Go Top
       Seek mCodiForne
       If Found() .And. ! Empty(Forneced->Empr_Princ)
          mCodiForne := Forneced->Empr_Princ
       Endif
    Cores()
    CAIXATEXTO(03,00,24,79,"Pedido colocado pra este fornecedor ","BG+/B+","NN/NN","N","GR+/NN")
    @ 04,05 say "Fornecedor :"
    @ 05,01 say Repli("Ä",78)
    @ 20,01 say Repli("Ä",78)

    Sele CapaPed
         OrdSetFocus("CCmp02")
         Seek mCodiForne

         If ! Found()
              Alerta("Fornecedor sem pedido colocado !!")
              Fechajanela()
              Select(DbaOld)
              RestScreen(00,00,24,79,Tela01)
              Return nil
         Endif

         Index On CapaPed->DtaEntreg + CapaPed->DtaEmissa To c:\temp\xPedido ;
                  While ( CapaPed->CodiForne== mCodiForne )


         Declare Dados[8] ; Declare Cabeca[8]

         Dados[1]="CapaPed->Situacao+Iif(empty(CapaPed->Anotacoes),' ','*')"
         Dados[2]="CapaPed->NumPedido"
         Dados[3]="Dtoc(CapaPed->DtaEmissa)"
         Dados[4]="Dtoc(CapaPed->DtaEntreg)"
         Dados[5]="Transf(CapaPed->ValorTota - CapaPed->ValorDesc + CapaPed->ValorAcre,'@E 9999,999.99')"
         Dados[6]="Transf(CapaPed->ValorBoni, '@E 9999,999.99')"
         Dados[7]="Transf(CapaPed->Valor_rec, '@E 9999,999.99')"
         Dados[8]="Transf(CapaPed->DiasVenct, '@E 99')"

         Cabeca[1]:= "Sit."
         Cabeca[2]:= "N£mero"
         Cabeca[3]:= "Emiss„o"
         Cabeca[4]:= "Entrega"
         Cabeca[5]:= "Total"
         Cabeca[6]:= "Bonif."
         Cabeca[7]:= "Baixado"
         Cabeca[8]:= "Prazo"
         Go Bott
         Dbedit(06,01,20,78,Dados,"Tlc_Danfe","",Cabeca,"ß","³","Ü", NIL )
Fechajanela()
RESTSCREEN(00,00,24,79, TELA01 )
RETURN (CapaPed->NumPedido)

//------------------------------------------------------------
Function Tlc_Danfe(Reg)
DO CASE
  Case Reg == 3
        Alerta("Sem pedido Colocado!!!")
        VoltaFoco()
        Return 0
  Case Reg == 4
       Do Case
          Case Lastkey()=27
               Return 0
          Case LastKey()= -1
               *Rece_Item_Pedido(CapaPed->NumPedido)
               VoltaFoco()
          Case LastKey()= -2 
               If MSGCONF("Digita Automatico ?","1") == .T.
                     lCota    := .f.
                     If ! Empty(CapaPed->NumCotacao) .or. Capaped->NumCotacao#'00000'
                        lCota := .t.
                     Endif
                    *Rece_Intg_Pedido(ArqNotas->Numero_nf,CapaPed->NumPedido,lCota)
                     Sele ArqNotas
                     Trav_Reg()
                     Repla ArqNotas->PedNumero    With CapaPed->NumPedido
                     Destrava()
               Endif
               Return 0
          Case LastKey()= -3
               DbaOld := Select()
              *Rela_Mensag(CapaPed->NumPedido)
               Select(DbaOld)
               Set index to c:\temp\xPedido
               VoltaFoco()
               Return 1
       EndCase
EndCase
Return 


//--------------------------------------------
Static Function PegaNomeArquivo(cArq)
Local cFileDanfe := cArq
Local Linha       := Memoread(cFileDanfe)
Local nLinhalidas := 0
Local Linhatotal  := Len(Linha)
Local cLinhaTxt   := Linha
Local m_cNF   := PegaDados('nNF' ,Alltrim(Linha)  ,.f.)
Local m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
Local m_dEmi  := PegaDados('dEmi' ,Alltrim(Linha),.f. )
Local m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )

cString := "NF:"+m_cNF+' / '+m_serie+" - "+m_Razao+;
           ' Emissao '+m_dEmi
Return cString


