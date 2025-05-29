#include "FiveWin.ch"
#include "postgres.ch"
#include "hbxml.ch"
#include 'inkey.ch'
#include "fileio.ch"

function main()
         define window janela_principal from 0, 0 to 800, 600;
                title "Importando nota fiscal pelo xml";
                MENU BuildMenu()

                public odlgwait

                // Cores do sistema...................................................
                corfdojan = rgb(245,235,223)
                corobjjan = rgb(255,255,255)

                corfrtget = rgb(064,078,089)   // cor de frente para a edi‡Æo dos campos
                corfdoget = rgb(255,255,255)   // cor de fundo para a edi‡Æo dos campos
                corfdogetnotafiscal = rgb(245,235,223)   // cor de fundo para edicao dos campos

                corfrtsay = rgb(000,000,000)   // cor de frente para o say
                corfdosay = rgb(245,235,223)   // cor de fundo para o say

                corlstbxp = rgb(255,247,232)   // cor do list box linhas pares
                corlstbxi = rgb(255,247,232)   // cor do list box linhas impares
                corlstbxselecaofundo = rgb(255,247,232) // cor do list box selecao fundo
                corlstbxselecaotexto = rgb(255,247,232) // cor do list box selecao texto

                corlstbxnormal = rgb(255,255,255)
                corlstbxdifere = rgb(228,218,191)

                corlstelasconsultasuspensa = rgb(255,255,255)
                corfrtsaysuspensa = rgb(153,012,005)
                corfdosaysuspensa = rgb(228,218,191)

                corfrtsaybr = rgb(255,255,255)   // cor de frente para o say destaque branco
                corfrtsayds = rgb(153,012,005)   // cor de frente para o say destaque
                corfdosayds = rgb(255,255,255)   // cor de fundo  para o say destaque

                corteladiferente_01 = rgb(255,239,214)

                define brush obrushsuspenso color corteladiferente_01
                define brush obrushwindow COLOR rgb(255,255,255)
                define brush obrush COLOR corfdojan
                define brush obrushfolder COLOR corfdojan
                define brush obrushteladiferente_01 color corteladiferente_01

                define font mtahoma            name "Tahoma"      size 6.0,15  // font padrao para Say/Get/Botoes
                define font mtahomabold        name "Tahoma" bold size 6.0,15  // font padrao para Say/Get/Botoes
                define font mtahomameiogrande  name 'Tahoma' bold size 09,25   //
                define font mtahomagrande      name 'Tahoma' bold size 12,25   //
                define font mtahomagrandeletra name 'Tahoma' bold size 14,28   //

                define font mcourier      name 'courier'          size 0,-10

                define font mtahomamenor  name 'MS Sans Serif' size 4.5,15  // font padrao para listbox.......
                define font msanser       name 'MS Sans Serif' size 6.0,15  // font padrao para listbox.......
                define font obotaof       name 'MS Sans Serif' size 6,15    // font padrao para botoes
                define font olistagem_01  name "Courier New"   size 0,-10
                define font olistagem_02  name "Courier New"   size 0,-10 bold
                define font olistagem_03  name "Courier New"   size 0,-10 italic
                define font olistagem_04  name "Courier New"   size 0,-8
                define font olistagem_05  name "Courier New"   size 0,-13
                define font olistagem_06  name "Courier New"   size 0,-9

                SET MESSAGE OF janela_principal TO "RW" NOINSET CLOCK DATE KEYBOARD

         activate window janela_principal maximized
return nil
function BuildMenu()
         MENU oMenu
              MENUITEM "Importar NF-E ( XML )" ACTION ( consulta() )
         ENDMENU
return oMenu

// Faz uma consulta de nota fiscal.............................................
function consulta()
         if IsInternet() == .f.
             msgstop("Necessário conexão com internet."+CRLF+"Operação cancelada","Informação")
             return .f.
         endif
         define dialog consultachave title "Digite a chave...." from 10,20 to 23,065 brush obrush transparent
                define font mtahomachave  name "Tahoma"          size 5.5,13
                   f_cchave = space(50)
                   @ 35, 002 say "Chave NF-e:" of consultachave font mtahomachave color corfrtsay,corfdosay pixel
                   @ 35, 035 get of_cchave var f_cchave picture "@!" font mtahomachave size 140,9 of consultachave color corfrtget,corfdoget pixel
                   @ 082,005 BUTTON olbut3 prompt "&Consultar"    size 040,12 font mtahomachave OF consultachave pixel action ( conulta_cont(f_cchave) )
                   @ 082,134 BUTTON olbut3 prompt "&Importa XML"  size 040,12 font mtahomachave OF consultachave pixel action ( pega_nam_xml() )
         activate dialog consultachave center
return nil
function conulta_cont(f_cchave)
         local oOle, oOleDoc := Array(2)

         if empty(f_cchave)
            msgstop("Chave em branco.","Atenção")
            of_cchave:setfocus()
            of_cchave:gotfocus()
            return nil
         endif
         f_cchave = alltrim(f_cchave)

         oOle:= CreateObject("InternetExplorer.Application")
         oOle:Visible  := .T. // Apresenta o Browser
         oOle:ToolBar  := .F. // Desativa a barra de ferramentas
         oOle:StatusBar:= .f. // Desativa a barra de status
         oOle:MenuBar  := .f. // desativa a barra de menu
         oOle:Navigate2("http://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8=")
         WHILE oOle:Busy
             syswait(.5)
         END
         oOle := oOle:Document()
         oOle:All:Item("ctl00$ContentPlaceHolder1$txtChaveAcessoCompleta",0):Value:= f_cchave
         oOle:All:Item("ctl00$ContentPlaceHolder1$txtCaptcha",0):Focus()
         oOle:=Nil

         CursorArrow()
         SysRefresh()

         of_cchave:ctext := space(50)
         of_cchave:setfocus()
         of_cchave:gotfocus()
return nil

// Importa arquivo xml.........................................................
function pega_nam_xml()
         // Entrada de nota fiscal eletronica..................................
         gcFile := cGetFile( "XML (*.xml)| *.xml|";
                   ,"Por favor localize o arquivo no formato XML.", 4 )
         if !Empty( gcFile ) .and. File( gcFile )
            aa = gcfile
            bb = ""
            for xt = 1 to len(gcFile)
                if substr(gcfile,xt,1) = "\"
                   bb = ""
                else
                   bb = bb + substr(gcfile,xt,1)
                endif
            next
            mEnomearquivoxmlnfentrada = bb
            mLocaldoarquivoxml = gcfile
            if msgyesno("Deseja importar o arquivo: " + mEnomearquivoxmlnfentrada,"ATENÇÃO")
               ler_arquivo_xml(mLocaldoarquivoxml)
            endif
         endif
return nil

function ler_arquivo_xml(mLocaldoarquivoxml)


         fwait("  ...Aguarde processando...")

         hFile := FOpen( mLocaldoarquivoxml )
         xmlDoc := TXmlDocument():New( hFile )
         if xmlDoc:nStatus != HBXML_STATUS_OK
             msgstop("Falha no arquivo XML ","ERRO Arquivo XML")
             return nil
         endif
         xmlIter := TXmlIterator():New( xmlDoc:oRoot )
         xmlNode := xmlIter:Find()

         // variaveis ........................................................

         nfe_notafiscalsimounao = "N"
         nfe_cabecalho = ""
         muf = space(02)

         // dados da nota
         nfe_estado        = space(02) // estado do emitente da nf-e
         nfe_cdchvacesso   = space(08) // codigo que compoe chave de acesso
         nfe_operacao      = space(60) // natureza de operacao
         nfe_pagamento     = space(01) // 0-A vista 1-Prazo 2-Outros
         nfe_modelo        = space(02) // modelo do documento fiscal
         nfe_serie         = space(03) // serie do documento fiscal
         nfe_numero        = space(09) // numero do documento fiscal
         nfe_emissao       = space(10) // data de emissÆo
         nfe_saida         = space(10) // data de sa¡da
         nfe_hora          = space(08) // hora
         nfe_tipo          = space(01) // 0-entrada 1-saida
         nfe_ibgeGerador   = space(07) // c¢digo do munic¡pio ocorrˆncia do fato gerador
         nfe_impressao     = space(01) // 1-retrato 2-paisagem
         nfe_tipoemissao   = space(01) // 1-Normal 2-Contigˆncia FS 3-Contigˆncia Scan 4-Contigˆncia DPEC 5-Contigˆncia FS-DA
         nfe_digitochave   = space(01) // digitoverificador da chave
         nfe_tipoambiente  = space(01) // 1-produ‡Æo 2-homologa‡Æo
         nfe_finalidade    = space(01) // 1-normal 2-complementar 3-Ajuste
         nfe_processo      = space(01) // 0-aplicativo contribuinte 1-avulsa pelo fisco 2-avulsa pelo contribuinte 3-aplicativo do fisco
         nfe_versao        = space(20) // identificador da versÆo
         nfe_dtcontigencia = space(19) // data e hora de contigencia
         nfe_justificativa = space(256)// Justificativa da contigencia

         // emitente
         nfe_e_cnpj          = space(14) // CNPJ
         nfe_e_cpf           = space(11) // CPF
         nfe_e_razaonome     = space(60) // nome ou razao social
         nfe_e_fantasia      = space(60) // fantasia
         nfe_e_logradouro    = space(60) // logradouro
         nfe_e_numero        = space(60) // numero
         nfe_e_complemento   = space(60) // complemento
         nfe_e_bairro        = space(60) // bairro
         nfe_e_ibgemunicipio = space(07) // codigo ibge municipio
         nfe_e_municipio     = space(60) // munic¡pio
         nfe_e_estado        = space(02) // estado
         nfe_e_cep           = space(08) // cep
         nfe_e_codigopais    = space(04) // c¢digo do pa¡s
         nfe_e_nomepais      = space(60) // nome do pa¡s
         nfe_e_telefone      = space(14) // telefone
         nfe_e_inscricao     = space(14) // inscri‡Æo estadual
         nfe_e_inscricaost   = space(14) // inscri‡Æo estadual substituto tribut rio
         nfe_e_inscricaomun  = space(15) // inscri‡Æo municipal
         nfe_e_cnae          = space(07) // c¢digo CNAE
         nfe_e_crt           = space(01) // regime tribut rio 1-simples nacional 2-simples nacional excesso receita 3-regime normal

         // destinat rio
         nfe_d_cnpj        = space(14) // cnpj do destinat rio
         nfe_d_cpf         = space(11) // cpf do destinat rio
         nfe_d_nome        = space(60) // razao ou nome do destinat rio
         nfe_d_logradouro  = space(60) // logradouro de destinat rio
         nfe_d_numero      = space(60) // n£mero do destinat rio
         nfe_d_complemento = space(60) // complemento do destinar rio
         nfe_d_bairro      = space(60) // bairro do destinat rio
         nfe_d_ibgemunicip = space(07) // c¢digo do ibge do munic¡pi
         nfe_d_municipio   = space(60) // munic¡pio
         nfe_d_estado      = space(02) // estado
         nfe_d_cep         = space(08) // cep do destinat rio
         nfe_d_cpais       = space(04) // c¢digo do pa¡s
         nfe_d_pais        = space(60) // nome do pa¡s
         nfe_d_telefone    = space(14) // telefone do destinatario
         nfe_d_ie          = space(14) // inscri‡Æo estadual
         nfe_d_isuf        = space(08) // suframa
         nfe_d_email       = space(60) // e-mail


         // produtos...........................................................
         nfe_dadosproduto  = {}
         nfe_verosproduto  = {}

         nfe_p_codigo      = space(60)  // (03) c¢digo do produto
         nfe_p_barras      = space(14)  // (04) c¢digo EAN ( barras )
         nfe_p_produto     = space(120) // (05) nome do produto
         nfe_p_ncm         = space(08)  // (06) ncm
         nfe_p_extipi      = space(03)  // (07) ex da tipi.
         nfe_p_cfop        = space(04)  // (08) cfop
         nfe_p_unidade     = space(06)  // (09) unidade comercial
         nfe_p_quantidade  = space(15)  // (10) 15,4  quantidade
         nfe_p_valor       = space(21)  // (11) 21,10 valor
         nfe_p_bruto       = space(15)  // (12) 15,2  valor total do item
         nfe_p_ceantrib    = space(14)  // (13) barras
         nfe_p_unidadetrib = space(06)  // (14) unidade tributavel
         nfe_p_qtdtributa  = space(15)  // (15) 15,4 quantidade tribut vel do produto
         nfe_p_valortribut = space(21)  // (16) 21,10 valor tributavel
         nfe_p_frete       = space(15)  // (17) 15,2 frete do item
         nfe_p_seguro      = space(15)  // (18) 15,2 seguro do item
         nfe_p_desconto    = space(15)  // (19) 15,2 desconto do item
         nfe_p_outro       = space(15)  // (20) 15,2 outros do item
         nfe_p_entratotal  = space(01)  // (21) 0-nÆo compäe total 1-compäe total

         nfe_i_origem      = space(01)  // (22) 0-nacional 1-estrangeira 2-estrangeira adquirida no mercado interno
         nfe_i_cst         = space(02)  // (23) cst
         nfe_i_modbc       = space(01)  // (24) 0-margem valor agregado 1-pauta 2-pre‡o tabelado 3-valor da opera‡Æo
         nfe_i_valorbase   = space(15)  // (25) 15,2 valor da base de c lculo
         nfe_i_aliquota    = space(05)  // (26) 05,2 aliquota
         nfe_i_valoricms   = space(15)  // (27) 15,2 valor do icms
         nfe_i_reducaobase = space(05)  // (28) 05,2 percentual de redu‡Æo da base de c lculo
         nfe_i_modbcst     = space(01)  // (29) 0-tabelado 1-lista negativa 2-lista positiva 3-lista neutra 4-margem valor agregado 5-pauta
         nfe_i_mvast       = space(05)  // (30) 05,2 percentual da margem de valor adicionado do icms st
         nfe_i_redbcst     = space(05)  // (31) 05,2 percentual da redu‡Æo de bc do icms st
         nfe_i_valorbasest = space(15)  // (32) 15,2 valor da base de calculo st
         nfe_i_aliquotast  = space(05)  // (33) 05,2 aliquota do icms st
         nfe_i_valoricmsst = space(15)  // (34) 15,2 valor do icms st
         nfe_i_motivodeson = space(01)  // (35) motivo da desonera‡Æo conforme manual 4.0.1
         nfe_i_vbcstret    = space(15)  // (36) 15,2 valor da base de calculo do icms retido
         nfe_i_vicmsstret  = space(15)  // (37) 15,2 valor do icms st retido
         nfe_i_csosn       = space(03)  // (38) tipo
         nfe_i_aliqcredit  = space(05)  // (39) 05,2 Al¡quota aplicavel de c lculo do cr‚dito
         nfe_i_valorcredi  = space(15)  // (40) 15,2 valor do cr‚dito de icms que pode ser aproveitado.

         nfe_cstipi        = space(02)  // (41) c¢digo da situa‡Æo tribut ria do ipi
         nfe_valorbaseipi  = space(15)  // (42) 15,2 valor da base de calculo do ipi
         nfe_aliquotaipi   = space(05)  // (43) 05,2 al¡quota do ipi
         nfe_valoripi      = space(15)  // (44) 15,2 valor do ipi

         nfe_cstpis        = space(02)  // (45) c¢digo da situa‡Æo tribut ria do pis
         nfe_valorbasepis  = space(15)  // (46) 15,02 valor da base de c lculo do pis
         nfe_aliquotapis   = space(05)  // (47) 05,2 al¡quota do pis
         nfe_valorpis      = space(15)  // (48) 15,02 valor do pis

         nfe_valorbasepisst= space(15)  // (49) 15,02 valor da base de c lculo do pis
         nfe_aliquotapisst = space(05)  // (50) 05,2 al¡quota do pis
         nfe_valorpisst    = space(15)  // (51) 15,02 valor do pis

         nfe_cstcof        = space(02)  // (52) c¢digo da situa‡Æo tribut ria do cofins
         nfe_valorbasecof  = space(15)  // (53) 15,02 valor da base do cofine
         nfe_aliquotacof   = space(05)  // (54) 05,2 al¡quota do cofins
         nfe_valorcof      = space(15)  // (55) 15,2 valor do cofins

         nfe_valorbasecofst= space(15)  // (56) 15,02 valor da base do cofine
         nfe_aliquotacofst = space(05)  // (57) 05,2 al¡quota do cofins
         nfe_valorcofst    = space(15)  // (58) 15,2 valor do cofins

         // o array nfe_verosproduto ‚ so para mostras o listbox... ou para
         // outro uso qualquer...
         // os produtos serao lancados no array nfe_dadosproduto, bastando
         // fazer um for xx = 1 to len(nfe_dadosproduto) para pegar as informa‡äes..
         // ex: nfe_verosproduto[xx, 3] = nfe_p_codigo      -> c¢digo do produto
         //     nfe_verosproduto[xx, 4] = nfe_p_barras      -> c¢digo EAN ( barras )
         //     nfe_verosproduto[xx, 5] = nfe_p_produto     -> nome do produto
         //     nfe_verosproduto[xx, 6] = nfe_p_ncm         -> ncm
         //     nfe_verosproduto[xx, 7] = nfe_p_extipi      -> ex da tipi.
         //     nfe_verosproduto[xx, 8] = nfe_p_cfop        -> cfop
         //     nfe_verosproduto[xx, 9] = nfe_p_unidade     -> unidade comercial
         //     nfe_verosproduto[xx,10] = nfe_p_quantidade  -> quantidade
         //     nfe_verosproduto[xx,11] = nfe_p_valor       -> valor
         //     nfe_verosproduto[xx,12] = nfe_p_bruto       -> valor total do item
         //     nfe_verosproduto[xx,13] = nfe_p_ceantrib    -> barras
         //     nfe_verosproduto[xx,14] = nfe_p_unidadetrib -> unidade tributavel
         //     nfe_verosproduto[xx,15] = nfe_p_qtdtributa  -> quantidade tribut vel do produto
         //     nfe_verosproduto[xx,16] = nfe_p_valortribut -> valor tributavel
         //     nfe_verosproduto[xx,17] = nfe_p_frete       -> frete do item
         //     nfe_verosproduto[xx,18] = nfe_p_seguro      -> seguro do item
         //     nfe_verosproduto[xx,19] = nfe_p_desconto    -> desconto do item
         //     nfe_verosproduto[xx,20] = nfe_p_outro       -> outros do item
         //     nfe_verosproduto[xx,21] = nfe_p_entratotal  -> 0-nÆo compäe total 1-compäe total
         //     nfe_verosproduto[xx,22] = nfe_i_origem      -> 0-nacional 1-estrangeira 2-estrangeira adquirida no mercado interno
         //     nfe_verosproduto[xx,23] = nfe_i_cst         -> cst
         //     nfe_verosproduto[xx,24] = nfe_i_modbc       -> 0-margem valor agregado 1-pauta 2-pre‡o tabelado 3-valor da opera‡Æo
         //     nfe_verosproduto[xx,25] = nfe_i_valorbase   -> valor da base de c lculo
         //     nfe_verosproduto[xx,26] = nfe_i_aliquota    -> aliquota
         //     nfe_verosproduto[xx,27] = nfe_i_valoricms   -> valor do icms
         //     nfe_verosproduto[xx,28] = nfe_i_reducaobase -> percentual de redu‡Æo da base de c lculo
         //     nfe_verosproduto[xx,29] = nfe_i_modbcst     -> 0-tabelado 1-lista negativa 2-lista positiva 3-lista neutra 4-margem valor agregado 5-pauta
         //     nfe_verosproduto[xx,30] = nfe_i_mvast       -> percentual da margem de valor adicionado do icms st
         //     nfe_verosproduto[xx,31] = nfe_i_redbcst     -> percentual da redu‡Æo de bc do icms st
         //     nfe_verosproduto[xx,32] = nfe_i_valorbasest -> valor da base de calculo st
         //     nfe_verosproduto[xx,33] = nfe_i_aliquotast  -> aliquota do icms st
         //     nfe_verosproduto[xx,34] = nfe_i_valoricmsst -> valor do icms st
         //     nfe_verosproduto[xx,35] = nfe_i_motivodeson -> motivo da desonera‡Æo conforme manual 4.0.1
         //     nfe_verosproduto[xx,36] = nfe_i_vbcstret    -> valor da base de calculo do icms retido
         //     nfe_verosproduto[xx,37] = nfe_i_vicmsstret  -> valor do icms st retido
         //     nfe_verosproduto[xx,38] = nfe_i_csosn       -> tipo
         //     nfe_verosproduto[xx,39] = nfe_i_aliqcredit  -> Al¡quota aplicavel de c lculo do cr‚dito
         //     nfe_verosproduto[xx,40] = nfe_i_valorcredi  -> valor do cr‚dito de icms que pode ser aproveitado.
         //     nfe_verosproduto[xx,41] = nfe_cstipi        -> c¢digo da situa‡Æo tribut ria do ipi
         //     nfe_verosproduto[xx,42] = nfe_valorbaseipi  -> valor da base de calculo do ipi
         //     nfe_verosproduto[xx,43] = nfe_aliquotaipi   -> al¡quota do ipi
         //     nfe_verosproduto[xx,44] = nfe_valoripi      -> valor do ipi
         //     nfe_verosproduto[xx,45] = nfe_cstpis        -> c¢digo da situa‡Æo tribut ria do pis
         //     nfe_verosproduto[xx,46] = nfe_valorbasepis  -> valor da base de c lculo do pis
         //     nfe_verosproduto[xx,47] = nfe_aliquotapis   -> al¡quota do pis
         //     nfe_verosproduto[xx,48] = nfe_valorpis      -> valor do pis
         //     nfe_verosproduto[xx,49] = nfe_valorbasepisst-> valor da base de c lculo do pis
         //     nfe_verosproduto[xx,50] = nfe_aliquotapisst -> al¡quota do pis
         //     nfe_verosproduto[xx,51] = nfe_valorpisst    -> valor do pis
         //     nfe_verosproduto[xx,52] = nfe_cstcof        -> c¢digo da situa‡Æo tribut ria do cofins
         //     nfe_verosproduto[xx,53] = nfe_valorbasecof  -> valor da base do cofine
         //     nfe_verosproduto[xx,54] = nfe_aliquotacof   -> al¡quota do cofins
         //     nfe_verosproduto[xx,55] = nfe_valorcof      -> valor do cofins
         //     nfe_verosproduto[xx,56] = nfe_valorbasecofst-> valor da base do cofine
         //     nfe_verosproduto[xx,57] = nfe_aliquotacofst -> al¡quota do cofins
         //     nfe_verosproduto[xx,58] = nfe_valorcofst    -> valor do cofins

         // totais da nota
         nfe_t_basecalculo = space(15) // 15,2 total da base de calculo
         nfe_t_valoricms   = space(15) // 15,2 valor total do icms
         nfe_t_basecalcst  = space(15) // 15,2 valor da da base de calculo st
         nfe_t_valoricmsst = space(15) // 15,2 valor do icms st
         nfe_t_produtos    = space(15) // 15,2 valor total dos produtos
         nfe_t_frete       = space(15) // 15,2 valor total do frete
         nfe_t_Seguro      = space(15) // 15,2 valor total do seguro
         nfe_t_desconto    = space(15) // 15,2 valor total do desconto
         nfe_t_vII         = space(15) // 15,2 valor tota VII
         nfe_t_ipi         = space(15) // 15,2 valor total do ipi
         nfe_t_pis         = space(15) // 15,2 valor total do pis
         nfe_t_cofins      = space(15) // 15,2 valor total do cofins
         nfe_t_Outro       = space(15) // 15,2 valor total despesas acessorias e/ou outros.
         nfe_t_valornota   = space(15) // 15,2 valor total da nota fiscal

         // transportadora
         nfe_r_moffrete    = space(01) // 0-emitente 1-destinatario 2-terceiros 9-sem frete
         nfe_r_cnpj        = space(14) // cnpj
         nfe_r_cpf         = space(11) // cpf
         nfe_r_nometransp  = space(60) // nome da transportadora
         nfe_r_ie          = space(14) // inscri‡Æo estadural da transportadora
         nfe_r_endereco    = space(60) // endere‡o da transportadora
         nfe_r_municipio   = space(60) // nome do municipio da transportadora
         nfe_r_estado      = space(05) // estado da transportadora
         nfe_r_placa       = space(08) // placa do veiculo da transportadora
         nfe_r_placauf     = space(02) // estado da placa
         nfe_r_rntc        = space(20) // ANTT

         nfe_v_quantidade  = space(15) // quantidade
         nfe_v_especie     = space(60) // especie
         nfe_v_marca       = space(60) // marca
         nfe_v_volume      = space(60) // volume
         nfe_v_pesoliquido = space(15) // 15,3 peso l¡quido
         nfe_v_pesobruto   = space(15) // 15,3 peso bruto

         nfe_infadicionais = ""

         nfe_chave        = space(100) // chave da nota fiscal
         nfe_protocolo    = space(100) // protocolo da nota fiscal

         do while xmlNode != NIL
            cName := xmlNode:cName
            cData := xmlNode:cData

            if cName = "infNFe"
               nfe_notafiscalsimounao = "S"
            endif

            if upper(cName) = "IDE"        .or.;  // dados da nota fiscal
               upper(cName) = "NFREF"      .or.;  // referenciada
               upper(cName) = "REFNF"      .or.;  // referenciada
               upper(cName) = "REFNP"      .or.;  // referenciada
               upper(cName) = "REFECF"     .or.;  // referenciada
               upper(cName) = "EMIT"       .or.;  // emitente
               upper(cName) = "AVULSA"     .or.;  // emitente avulsa pelo fisco
               upper(cName) = "DEST"       .or.;  // destinatario
               upper(cName) = "RETIRADA"   .or.;  // destinatario
               upper(cName) = "ENTREGA"    .or.;  // destinatario
               upper(cName) = "DET"        .or.;  // cabecalho de produtos..
               upper(cName) = "PROD"       .or.;  // produtos
               upper(cName) = "IMPOSTO"    .or.;  // icms
               upper(cName) = "ICMS"       .or.;  // icms
               upper(cName) = "IPI"        .or.;  // ipi
               upper(cName) = "IPITRIB"    .or.;  // ipi
               upper(cName) = "IPINT"      .or.;  // ipi
               upper(cName) = "PIS"        .or.;  // pis
               upper(cName) = "PISALIQ"    .or.;  // pis
               upper(cName) = "PISQTDE"    .or.;  // pis
               upper(cName) = "PISNT"      .or.;  // pis
               upper(cName) = "PISOUTR"    .or.;  // pis
               upper(cName) = "PISST"      .or.;  // pis
               upper(cName) = "COFINS"     .or.;  // cofins
               upper(cName) = "COFINSALIQ" .or.;  // cofins
               upper(cName) = "COFINSQTDE" .or.;  // cofins
               upper(cName) = "COFINSNT"   .or.;  // cofins
               upper(cName) = "COFINSOUTR" .or.;  // cofins
               upper(cName) = "COFINSST"   .or.;  // cofins
               upper(cName) = "ISSQN"      .or.;  // issqn
               upper(cName) = "TOTAL"      .or.;  // total
               upper(cName) = "ICMSTOT"    .or.;  // total icms
               upper(cName) = "ISSQNTOT"   .or.;  // issqn
               upper(cName) = "RETTRIB"    .or.;  // restitui‡Æo tribu
               upper(cName) = "TRANSP"     .or.;  // transportador
               upper(cName) = "RETTRANSP"  .or.;  // transportador
               upper(cName) = "VEICTRANSP" .or.;  // transportador
               upper(cName) = "VOL"        .or.;  // volumes
               upper(cName) = "COBR"       .or.;  // cobran‡a
               upper(cName) = "INFADIC"    .or.;  // informa‡äes adicionais
               upper(cName) = "INFPROT"

               nfe_cabecalho = upper(cName)

               if upper(cName) = "DET"
                  if !empty(nfe_p_codigo)

                     aadd(nfe_verosproduto,{space(10),;
                                            space(100),;
                                            alltrim(nfe_p_codigo),;
                                            alltrim(nfe_p_produto),;
                                            alltrim(nfe_p_quantidade),;
                                            alltrim(nfe_p_valor),;
                                            alltrim(nfe_p_bruto)})

                     aadd(nfe_dadosproduto,{space(10),;
                                            space(20),;
                                            nfe_p_codigo,;
                                            nfe_p_barras,;
                                            nfe_p_produto,;
                                            nfe_p_ncm,;
                                            nfe_p_extipi,;
                                            nfe_p_cfop,;
                                            nfe_p_unidade,;
                                            nfe_p_quantidade,;
                                            nfe_p_valor,;
                                            nfe_p_bruto,;
                                            nfe_p_ceantrib,;
                                            nfe_p_unidadetrib,;
                                            nfe_p_qtdtributa,;
                                            nfe_p_valortribut,;
                                            nfe_p_frete,;
                                            nfe_p_seguro,;
                                            nfe_p_desconto,;
                                            nfe_p_outro,;
                                            nfe_p_entratotal,;
                                            nfe_i_origem,;
                                            nfe_i_cst,;
                                            nfe_i_modbc,;
                                            nfe_i_valorbase,;
                                            nfe_i_aliquota,;
                                            nfe_i_valoricms,;
                                            nfe_i_reducaobase,;
                                            nfe_i_modbcst,;
                                            nfe_i_mvast,;
                                            nfe_i_redbcst,;
                                            nfe_i_valorbasest,;
                                            nfe_i_aliquotast,;
                                            nfe_i_valoricmsst,;
                                            nfe_i_motivodeson,;
                                            nfe_i_vbcstret,;
                                            nfe_i_vicmsstret,;
                                            nfe_i_csosn,;
                                            nfe_i_aliqcredit,;
                                            nfe_i_valorcredi,;
                                            nfe_cstipi,;
                                            nfe_valorbaseipi,;
                                            nfe_aliquotaipi,;
                                            nfe_valoripi,;
                                            nfe_cstpis,;
                                            nfe_valorbasepis,;
                                            nfe_aliquotapis,;
                                            nfe_valorpis,;
                                            nfe_valorbasepisst,;
                                            nfe_aliquotapisst,;
                                            nfe_valorpisst,;
                                            nfe_cstcof,;
                                            nfe_valorbasecof,;
                                            nfe_aliquotacof,;
                                            nfe_valorcof,;
                                            nfe_valorbasecofst,;
                                            nfe_aliquotacofst,;
                                            nfe_valorcofst})

                     nfe_p_codigo      = space(60)  // c¢digo do produto
                     nfe_p_barras      = space(14)  // c¢digo EAN ( barras )
                     nfe_p_produto     = space(120) // nome do produto
                     nfe_p_ncm         = space(08)  // ncm
                     nfe_p_extipi      = space(03)  // ex da tipi.
                     nfe_p_cfop        = space(04)  // cfop
                     nfe_p_unidade     = space(06)  // unidade comercial
                     nfe_p_quantidade  = space(15)  // 15,4  quantidade
                     nfe_p_valor       = space(21)  // 21,10 valor
                     nfe_p_bruto       = space(15)  // 15,2  valor total do item
                     nfe_p_ceantrib    = space(14)  // barras
                     nfe_p_unidadetrib = space(06)  // unidade tributavel
                     nfe_p_qtdtributa  = space(15)  // 15,4 quantidade tribut vel do produto
                     nfe_p_valortribut = space(21)  // 21,10 valor tributavel
                     nfe_p_frete       = space(15)  // 15,2 frete do item
                     nfe_p_seguro      = space(15)  // 15,2 seguro do item
                     nfe_p_desconto    = space(15)  // 15,2 desconto do item
                     nfe_p_outro       = space(15)  // 15,2 outros do item
                     nfe_p_entratotal  = space(01)  // 0-nÆo compäe total 1-compäe total

                     nfe_i_origem      = space(01)  // 0-nacional 1-estrangeira 2-estrangeira adquirida no mercado interno
                     nfe_i_cst         = space(02)  // cst
                     nfe_i_modbc       = space(01)  // 0-margem valor agregado 1-pauta 2-pre‡o tabelado 3-valor da opera‡Æo
                     nfe_i_valorbase   = space(15)  // 15,2 valor da base de c lculo
                     nfe_i_aliquota    = space(05)  // 05,2 aliquota
                     nfe_i_valoricms   = space(15)  // 15,2 valor do icms
                     nfe_i_reducaobase = space(05)  // 05,2 percentual de redu‡Æo da base de c lculo
                     nfe_i_modbcst     = space(01)  // 0-tabelado 1-lista negativa 2-lista positiva 3-lista neutra 4-margem valor agregado 5-pauta
                     nfe_i_mvast       = space(05)  // 05,2 percentual da margem de valor adicionado do icms st
                     nfe_i_redbcst     = space(05)  // 05,2 percentual da redu‡Æo de bc do icms st
                     nfe_i_valorbasest = space(15)  // 15,2 valor da base de calculo st
                     nfe_i_aliquotast  = space(05)  // 05,2 aliquota do icms st
                     nfe_i_valoricmsst = space(15)  // 15,2 valor do icms st
                     nfe_i_motivodeson = space(01)  // motivo da desonera‡Æo conforme manual 4.0.1
                     nfe_i_vbcstret    = space(15)  // 15,2 valor da base de calculo do icms retido
                     nfe_i_vicmsstret  = space(15)  // 15,2 valor do icms st retido
                     nfe_i_csosn       = space(03)  // tipo
                     nfe_i_aliqcredit  = space(05)  // 05,2 Al¡quota aplicavel de c lculo do cr‚dito
                     nfe_i_valorcredi  = space(15)  // 15,2 valor do cr‚dito de icms que pode ser aproveitado.

                     nfe_cstipi        = space(02) // c¢digo da situa‡Æo tribut ria do ipi
                     nfe_valorbaseipi  = space(15) // 15,2 valor da base de calculo do ipi
                     nfe_aliquotaipi   = space(05) // 05,2 al¡quota do ipi
                     nfe_valoripi      = space(15) // 15,2 valor do ipi

                     nfe_cstpis        = space(02) // c¢digo da situa‡Æo tribut ria do pis
                     nfe_valorbasepis  = space(15) // 15,02 valor da base de c lculo do pis
                     nfe_aliquotapis   = space(05) // 05,2 al¡quota do pis
                     nfe_valorpis      = space(15) // 15,02 valor do pis

                     nfe_valorbasepisst= space(15) // 15,02 valor da base de c lculo do pis
                     nfe_aliquotapisst = space(05) // 05,2 al¡quota do pis
                     nfe_valorpisst    = space(15) // 15,02 valor do pis

                     nfe_cstcof        = space(02) // c¢digo da situa‡Æo tribut ria do cofins
                     nfe_valorbasecof  = space(15) // 15,02 valor da base do cofine
                     nfe_aliquotacof   = space(05) // 05,2 al¡quota do cofins
                     nfe_valorcof      = space(15) // 15,2 valor do cofins

                     nfe_valorbasecofst= space(15) // 15,02 valor da base do cofine
                     nfe_aliquotacofst = space(05) // 05,2 al¡quota do cofins
                     nfe_valorcofst    = space(15) // 15,2 valor do cofins

                  endif
               endif
            endif

            if nfe_cabecalho = "IDE"
               if !empty(cData)
                  nfe_estado        = iif(cName = "cUF"    ,cData,retorna_volta(nfe_estado        ))
                  nfe_cdchvacesso   = iif(cName = "cNF"    ,cData,retorna_volta(nfe_cdchvacesso   ))
                  nfe_operacao      = iif(cName = "natOp"  ,cData,retorna_volta(nfe_operacao      ))
                  nfe_pagamento     = iif(cName = "indPag" ,cData,retorna_volta(nfe_pagamento     ))
                  nfe_modelo        = iif(cName = "mod"    ,cData,retorna_volta(nfe_modelo        ))
                  nfe_serie         = iif(cName = "serie"  ,cData,retorna_volta(nfe_serie         ))
                  nfe_numero        = iif(cName = "nNF"    ,cData,retorna_volta(nfe_numero        ))
                  nfe_emissao       = iif(cName = "dEmi"   ,cData,retorna_volta(nfe_emissao       ))
                  nfe_saida         = iif(cName = "dSaiEnt",cData,retorna_volta(nfe_saida         ))
                  nfe_hora          = iif(cName = "hSaiEnt",cData,retorna_volta(nfe_hora          ))
                  nfe_tipo          = iif(cName = "tpNF"   ,cData,retorna_volta(nfe_tipo          ))
                  nfe_ibgeGerador   = iif(cName = "cMunFG" ,cData,retorna_volta(nfe_ibgeGerador   ))
                  nfe_impressao     = iif(cName = "tpImp"  ,cData,retorna_volta(nfe_impressao     ))
                  nfe_tipoemissao   = iif(cName = "tpEmis" ,cData,retorna_volta(nfe_tipoemissao   ))
                  nfe_digitochave   = iif(cName = "cDV"    ,cData,retorna_volta(nfe_digitochave   ))
                  nfe_tipoambiente  = iif(cName = "tpAmb"  ,cData,retorna_volta(nfe_tipoambiente  ))
                  nfe_finalidade    = iif(cName = "finNFe" ,cData,retorna_volta(nfe_finalidade    ))
                  nfe_processo      = iif(cName = "procEmi",cData,retorna_volta(nfe_processo      ))
                  nfe_versao        = iif(cName = "verProc",cData,retorna_volta(nfe_versao        ))
                  nfe_dtcontigencia = iif(cName = "dhCont" ,cData,retorna_volta(nfe_dtcontigencia ))
                  nfe_justificativa = iif(cName = "xJust"  ,cData,retorna_volta(nfe_justificativa ))
               endif
            endif
            if nfe_cabecalho = "EMIT"
               if !empty(cData)
                  nfe_e_cnpj          = iif(cName = "CNPJ"   ,cData,retorna_volta(nfe_e_cnpj          ))
                  nfe_e_cpf           = iif(cName = "CPF"    ,cData,retorna_volta(nfe_e_cpf           ))
                  nfe_e_razaonome     = iif(cName = "xNome"  ,cData,retorna_volta(nfe_e_razaonome     ))
                  nfe_e_fantasia      = iif(cName = "xFant"  ,cData,retorna_volta(nfe_e_fantasia      ))
                  nfe_e_logradouro    = iif(cName = "xLgr"   ,cData,retorna_volta(nfe_e_logradouro    ))
                  nfe_e_numero        = iif(cName = "nro"    ,cData,retorna_volta(nfe_e_numero        ))
                  nfe_e_complemento   = iif(cName = "xCpl"   ,cData,retorna_volta(nfe_e_complemento   ))
                  nfe_e_bairro        = iif(cName = "xBairro",cData,retorna_volta(nfe_e_bairro        ))
                  nfe_e_ibgemunicipio = iif(cName = "cMun"   ,cData,retorna_volta(nfe_e_ibgemunicipio ))
                  nfe_e_municipio     = iif(cName = "xMun"   ,cData,retorna_volta(nfe_e_municipio     ))
                  nfe_e_estado        = iif(cName = "UF"     ,cData,retorna_volta(nfe_e_estado        ))
                  nfe_e_cep           = iif(cName = "CEP"    ,cData,retorna_volta(nfe_e_cep           ))
                  nfe_e_codigopais    = iif(cName = "cPais"  ,cData,retorna_volta(nfe_e_codigopais    ))
                  nfe_e_nomepais      = iif(cName = "xPais"  ,cData,retorna_volta(nfe_e_nomepais      ))
                  nfe_e_telefone      = iif(cName = "fone"   ,cData,retorna_volta(nfe_e_telefone      ))
                  nfe_e_inscricao     = iif(cName = "IE"     ,cData,retorna_volta(nfe_e_inscricao     ))
                  nfe_e_inscricaost   = iif(cName = "IEST"   ,cData,retorna_volta(nfe_e_inscricaost   ))
                  nfe_e_inscricaomun  = iif(cName = "IM"     ,cData,retorna_volta(nfe_e_inscricaomun  ))
                  nfe_e_cnae          = iif(cName = "CNAE"   ,cData,retorna_volta(nfe_e_cnae          ))
                  nfe_e_crt           = iif(cName = "CRT"    ,cData,retorna_volta(nfe_e_crt           ))
               endif
            endif
            if nfe_cabecalho = "DEST"
               if !empty(cData)
                  nfe_d_cnpj        = iif(cName = "CNPJ"   ,cData,retorna_volta(nfe_d_cnpj        ))
                  nfe_d_cpf         = iif(cName = "CPF"    ,cData,retorna_volta(nfe_d_cpf         ))
                  nfe_d_nome        = iif(cName = "xNome"  ,cData,retorna_volta(nfe_d_nome        ))
                  nfe_d_logradouro  = iif(cName = "xLgr"   ,cData,retorna_volta(nfe_d_logradouro  ))
                  nfe_d_numero      = iif(cName = "nro"    ,cData,retorna_volta(nfe_d_numero      ))
                  nfe_d_complemento = iif(cName = "xCpl"   ,cData,retorna_volta(nfe_d_complemento ))
                  nfe_d_bairro      = iif(cName = "xBairro",cData,retorna_volta(nfe_d_bairro      ))
                  nfe_d_ibgemunicip = iif(cName = "cMun"   ,cData,retorna_volta(nfe_d_ibgemunicip ))
                  nfe_d_municipio   = iif(cName = "xMun"   ,cData,retorna_volta(nfe_d_municipio   ))
                  nfe_d_estado      = iif(cName = "UF"     ,cData,retorna_volta(nfe_d_estado      ))
                  nfe_d_cep         = iif(cName = "CEP"    ,cData,retorna_volta(nfe_d_cep         ))
                  nfe_d_cpais       = iif(cName = "cPais"  ,cData,retorna_volta(nfe_d_cpais       ))
                  nfe_d_pais        = iif(cName = "xPais"  ,cData,retorna_volta(nfe_d_pais        ))
                  nfe_d_telefone    = iif(cName = "fone"   ,cData,retorna_volta(nfe_d_telefone    ))
                  nfe_d_ie          = iif(cName = "IE"     ,cData,retorna_volta(nfe_d_ie          ))
                  nfe_d_isuf        = iif(cName = "ISUF"   ,cData,retorna_volta(nfe_d_isuf        ))
                  nfe_d_email       = iif(cName = "email"  ,cData,retorna_volta(nfe_d_email       ))
               endif
            endif
            // dados de produtos,impostos,ipi,pis,cofins gravar em array........
            if nfe_cabecalho = "PROD"
               if !empty(cData)
                  nfe_p_codigo      = iif(cName = "cProd"      ,cData,retorna_volta(nfe_p_codigo      ))
                  nfe_p_barras      = iif(cName = "cEAN"       ,cData,retorna_volta(nfe_p_barras      ))
                  nfe_p_produto     = iif(cName = "xProd"      ,cData,retorna_volta(nfe_p_produto     ))
                  nfe_p_ncm         = iif(cName = "NCM"        ,cData,retorna_volta(nfe_p_ncm         ))
                  nfe_p_extipi      = iif(cName = "EXTIPI"     ,cData,retorna_volta(nfe_p_extipi      ))
                  nfe_p_cfop        = iif(cName = "CFOP"       ,cData,retorna_volta(nfe_p_cfop        ))
                  nfe_p_unidade     = iif(cName = "uCom"       ,cData,retorna_volta(nfe_p_unidade     ))
                  nfe_p_quantidade  = iif(cName = "qCom"       ,cData,retorna_volta(nfe_p_quantidade  ))
                  nfe_p_valor       = iif(cName = "vUnCom"     ,cData,retorna_volta(nfe_p_valor       ))
                  nfe_p_bruto       = iif(cName = "vProd"      ,cData,retorna_volta(nfe_p_bruto       ))
                  nfe_p_ceantrib    = iif(cName = "cEANTrib"   ,cData,retorna_volta(nfe_p_ceantrib    ))
                  nfe_p_unidadetrib = iif(cName = "uTrib"      ,cData,retorna_volta(nfe_p_unidadetrib ))
                  nfe_p_qtdtributa  = iif(cName = "qTrib"      ,cData,retorna_volta(nfe_p_qtdtributa  ))
                  nfe_p_valortribut = iif(cName = "vUnTrib"    ,cData,retorna_volta(nfe_p_valortribut ))
                  nfe_p_frete       = iif(cName = "vFrete"     ,cData,retorna_volta(nfe_p_frete       ))
                  nfe_p_seguro      = iif(cName = "vSeg"       ,cData,retorna_volta(nfe_p_seguro      ))
                  nfe_p_desconto    = iif(cName = "vDesc"      ,cData,retorna_volta(nfe_p_desconto    ))
                  nfe_p_outro       = iif(cName = "vOutro"     ,cData,retorna_volta(nfe_p_outro       ))
                  nfe_p_entratotal  = iif(cName = "indTot"     ,cData,retorna_volta(nfe_p_entratotal  ))
               endif
            endif
            if nfe_cabecalho = "ICMS"
               if !empty(cData)
                  nfe_i_origem      = iif(cName = "orig"       ,cData,retorna_volta(nfe_i_origem      ))
                  nfe_i_cst         = iif(cName = "CST"        ,cData,retorna_volta(nfe_i_cst         ))
                  nfe_i_modbc       = iif(cName = "modBC"      ,cData,retorna_volta(nfe_i_modbc       ))
                  nfe_i_valorbase   = iif(cName = "vBC"        ,cData,retorna_volta(nfe_i_valorbase   ))
                  nfe_i_aliquota    = iif(cName = "pICMS"      ,cData,retorna_volta(nfe_i_aliquota    ))
                  nfe_i_valoricms   = iif(cName = "vICMS"      ,cData,retorna_volta(nfe_i_valoricms   ))
                  nfe_i_reducaobase = iif(cName = "pRedBC"     ,cData,retorna_volta(nfe_i_reducaobase ))
                  nfe_i_modbcst     = iif(cName = "modBCST"    ,cData,retorna_volta(nfe_i_modbcst     ))
                  nfe_i_mvast       = iif(cName = "pMVAST"     ,cData,retorna_volta(nfe_i_mvast       ))
                  nfe_i_redbcst     = iif(cName = "pRedBCST"   ,cData,retorna_volta(nfe_i_redbcst     ))
                  nfe_i_valorbasest = iif(cName = "vBCST"      ,cData,retorna_volta(nfe_i_valorbasest ))
                  nfe_i_aliquotast  = iif(cName = "pICMSST"    ,cData,retorna_volta(nfe_i_aliquotast  ))
                  nfe_i_valoricmsst = iif(cName = "vICMSST"    ,cData,retorna_volta(nfe_i_valoricmsst ))
                  nfe_i_motivodeson = iif(cName = "motDesICMS" ,cData,retorna_volta(nfe_i_motivodeson ))
                  nfe_i_vbcstret    = iif(cName = "vBCSTRet"   ,cData,retorna_volta(nfe_i_vbcstret    ))
                  nfe_i_vicmsstret  = iif(cName = "vICMSSTRet" ,cData,retorna_volta(nfe_i_vicmsstret  ))
                  nfe_i_csosn       = iif(cName = "CSOSN"      ,cData,retorna_volta(nfe_i_csosn       ))
                  nfe_i_aliqcredit  = iif(cName = "pCredSN"    ,cData,retorna_volta(nfe_i_aliqcredit  ))
                  nfe_i_valorcredi  = iif(cName = "vCredICMSSN",cData,retorna_volta(nfe_i_valorcredi  ))
               endif
            endif
            if nfe_cabecalho = "IPITRIB"
               if !empty(cData)
                  nfe_cstipi        = iif(cName = "CST"        ,cData,retorna_volta(nfe_cstipi        ))
                  nfe_valorbaseipi  = iif(cName = "vBC"        ,cData,retorna_volta(nfe_valorbaseipi  ))
                  nfe_aliquotaipi   = iif(cName = "pIPI"       ,cData,retorna_volta(nfe_aliquotaipi   ))
                  nfe_valoripi      = iif(cName = "vIPI"       ,cData,retorna_volta(nfe_valoripi      ))
               endif
            endif
            if nfe_cabecalho = "PISALIQ"
               if !empty(cData)
                  nfe_cstpis        = iif(cName = "CST"        ,cData,retorna_volta(nfe_cstpis        ))
                  nfe_valorbasepis  = iif(cName = "vBC"        ,cData,retorna_volta(nfe_valorbasepis  ))
                  nfe_aliquotapis   = iif(cName = "pPIS"       ,cData,retorna_volta(nfe_aliquotapis   ))
                  nfe_valorpis      = iif(cName = "vPIS"       ,cData,retorna_volta(nfe_valorpis      ))
               endif
            endif
            if nfe_cabecalho = "PISST"
               if !empty(cData)
                  nfe_valorbasepisst  = iif(cName = "vBC"      ,cData,retorna_volta(nfe_valorbasepis  ))
                  nfe_aliquotapisst   = iif(cName = "pPIS"     ,cData,retorna_volta(nfe_aliquotapis   ))
                  nfe_valorpisst      = iif(cName = "vPIS"     ,cData,retorna_volta(nfe_valorpis      ))
               endif
            endif
            if nfe_cabecalho = "COFINSALIQ"
               if !empty(cData)
                  nfe_cstcof        = iif(cName = "CST"        ,cData,retorna_volta(nfe_cstcof        ))
                  nfe_valorbasecof  = iif(cName = "vBC"        ,cData,retorna_volta(nfe_valorbasecof  ))
                  nfe_aliquotacof   = iif(cName = "pCOFINS"    ,cData,retorna_volta(nfe_aliquotacof   ))
                  nfe_valorcof      = iif(cName = "vCOFINS"    ,cData,retorna_volta(nfe_valorcof      ))
               endif
            endif
            if nfe_cabecalho = "COFINSST"
               if !empty(cData)
                  nfe_valorbasecofst= iif(cName = "vBC"        ,cData,retorna_volta(nfe_valorbasecofst))
                  nfe_aliquotacofst = iif(cName = "pCOFINS"    ,cData,retorna_volta(nfe_aliquotacofst ))
                  nfe_valorcofst    = iif(cName = "vCOFINS"    ,cData,retorna_volta(nfe_valorcofst    ))
               endif
            endif
            if nfe_cabecalho = "ICMSTOT"
               if !empty(cData)
                  nfe_t_basecalculo = iif(cName = "vBC"        ,cData,retorna_volta(nfe_t_basecalculo ))
                  nfe_t_valoricms   = iif(cName = "vICMS"      ,cData,retorna_volta(nfe_t_valoricms   ))
                  nfe_t_basecalcst  = iif(cName = "vBCST"      ,cData,retorna_volta(nfe_t_basecalcst  ))
                  nfe_t_valoricmsst = iif(cName = "vST"        ,cData,retorna_volta(nfe_t_valoricmsst ))
                  nfe_t_produtos    = iif(cName = "vProd"      ,cData,retorna_volta(nfe_t_produtos    ))
                  nfe_t_frete       = iif(cName = "vFrete"     ,cData,retorna_volta(nfe_t_frete       ))
                  nfe_t_Seguro      = iif(cName = "vSeg"       ,cData,retorna_volta(nfe_t_Seguro      ))
                  nfe_t_desconto    = iif(cName = "vDesc"      ,cData,retorna_volta(nfe_t_desconto    ))
                  nfe_t_vII         = iif(cName = "vII"        ,cData,retorna_volta(nfe_t_vII         ))
                  nfe_t_ipi         = iif(cName = "vIPI"       ,cData,retorna_volta(nfe_t_ipi         ))
                  nfe_t_pis         = iif(cName = "vPIS"       ,cData,retorna_volta(nfe_t_pis         ))
                  nfe_t_cofins      = iif(cName = "vCOFINS"    ,cData,retorna_volta(nfe_t_cofins      ))
                  nfe_t_Outro       = iif(cName = "vOutro"     ,cData,retorna_volta(nfe_t_Outro       ))
                  nfe_t_valornota   = iif(cName = "vNF"        ,cData,retorna_volta(nfe_t_valornota   ))
               endif
            endif
            if nfe_cabecalho = "TRANSP"
               if !empty(cData)
                  nfe_r_moffrete    = iif(cName = "modFrete"   ,cData,retorna_volta(nfe_r_moffrete    ))
                  nfe_r_cnpj        = iif(cName = "CNPJ"       ,cData,retorna_volta(nfe_r_cnpj        ))
                  nfe_r_cpf         = iif(cName = "CPF"        ,cData,retorna_volta(nfe_r_cpf         ))
                  nfe_r_nometransp  = iif(cName = "xNOME"      ,cData,retorna_volta(nfe_r_nometransp  ))
                  nfe_r_ie          = iif(cName = "IE"         ,cData,retorna_volta(nfe_r_ie          ))
                  nfe_r_endereco    = iif(cName = "xEnder"     ,cData,retorna_volta(nfe_r_endereco    ))
                  nfe_r_municipio   = iif(cName = "xMun"       ,cData,retorna_volta(nfe_r_municipio   ))
                  nfe_r_estado      = iif(cName = "UF"         ,cData,retorna_volta(nfe_r_estado      ))
               endif
            endif
            if nfe_cabecalho = "VEICTRANSP"
               if !empty(cData)
                  nfe_r_placa       = iif(cName = "placa"      ,cData,retorna_volta(nfe_r_placa       ))
                  nfe_r_placauf     = iif(cName = "UF"         ,cData,retorna_volta(nfe_r_placauf     ))
                  nfe_r_rntc        = iif(cName = "RNTC"       ,cData,retorna_volta(nfe_r_rntc        ))
               endif
            endif
            if nfe_cabecalho = "VOL"
               if !empty(cData)
                  nfe_v_quantidade  = iif(cName = "qVol"       ,cData,retorna_volta(nfe_v_quantidade  ))
                  nfe_v_especie     = iif(cName = "esp"        ,cData,retorna_volta(nfe_v_especie     ))
                  nfe_v_marca       = iif(cName = "marca"      ,cData,retorna_volta(nfe_v_marca       ))
                  nfe_v_volume      = iif(cName = "nVol"       ,cData,retorna_volta(nfe_v_volume      ))
                  nfe_v_pesoliquido = iif(cName = "pesoL"      ,cData,retorna_volta(nfe_v_pesoliquido ))
                  nfe_v_pesobruto   = iif(cName = "pesoB"      ,cData,retorna_volta(nfe_v_pesobruto   ))
               endif
            endif
            if nfe_cabecalho = "INFADIC"
               if !empty(cData)
                  nfe_infadicionais = iif(cName = "infCpl"     ,cData,retorna_volta(nfe_infadicionais ))
               endif
            endif
            if nfe_cabecalho = "INFPROT"
               if !empty(cData)
                  nfe_chave        = iif(cName = "chNFe"       ,cData,retorna_volta(nfe_chave        ))
                  nfe_protocolo    = iif(cName = "nProt"       ,cData,retorna_volta(nfe_protocolo    ))
               endif
            endif

            xmlNode := xmlIter:Next()
         enddo
         fclose(hFile)
         if !empty(nfe_p_codigo)
            aadd(nfe_verosproduto,{space(10),;
                                   space(100),;
                                   alltrim(nfe_p_codigo),;
                                   alltrim(nfe_p_produto),;
                                   alltrim(nfe_p_quantidade),;
                                   alltrim(nfe_p_valor),;
                                   alltrim(nfe_p_bruto)})
            aadd(nfe_dadosproduto,{space(10),;
                                   space(20),;
                                   nfe_p_codigo,;
                                   nfe_p_barras,;
                                   nfe_p_produto,;
                                   nfe_p_ncm,;
                                   nfe_p_extipi,;
                                   nfe_p_cfop,;
                                   nfe_p_unidade,;
                                   nfe_p_quantidade,;
                                   nfe_p_valor,;
                                   nfe_p_bruto,;
                                   nfe_p_ceantrib,;
                                   nfe_p_unidadetrib,;
                                   nfe_p_qtdtributa,;
                                   nfe_p_valortribut,;
                                   nfe_p_frete,;
                                   nfe_p_seguro,;
                                   nfe_p_desconto,;
                                   nfe_p_outro,;
                                   nfe_p_entratotal,;
                                   nfe_i_origem,;
                                   nfe_i_cst,;
                                   nfe_i_modbc,;
                                   nfe_i_valorbase,;
                                   nfe_i_aliquota,;
                                   nfe_i_valoricms,;
                                   nfe_i_reducaobase,;
                                   nfe_i_modbcst,;
                                   nfe_i_mvast,;
                                   nfe_i_redbcst,;
                                   nfe_i_valorbasest,;
                                   nfe_i_aliquotast,;
                                   nfe_i_valoricmsst,;
                                   nfe_i_motivodeson,;
                                   nfe_i_vbcstret,;
                                   nfe_i_vicmsstret,;
                                   nfe_i_csosn,;
                                   nfe_i_aliqcredit,;
                                   nfe_i_valorcredi,;
                                   nfe_cstipi,;
                                   nfe_valorbaseipi,;
                                   nfe_aliquotaipi,;
                                   nfe_valoripi,;
                                   nfe_cstpis,;
                                   nfe_valorbasepis,;
                                   nfe_aliquotapis,;
                                   nfe_valorpis,;
                                   nfe_valorbasepisst,;
                                   nfe_aliquotapisst,;
                                   nfe_valorpisst,;
                                   nfe_cstcof,;
                                   nfe_valorbasecof,;
                                   nfe_aliquotacof,;
                                   nfe_valorcof,;
                                   nfe_valorbasecofst,;
                                   nfe_aliquotacofst,;
                                   nfe_valorcofst})
         endif
         odlgwait:end()
            define dialog listbox_entrada_xml title "NF-e (Entrada - xml)" from 000,000 to 620,1020 pixel brush obrush transparent

                   @ 0.1,0.3 to 1.5,72.7  label "" of listbox_entrada_xml color corfrtsay,corfdosay
                   @ 1.7,0.3 to 19.9,72.7 label "" of listbox_entrada_xml color corfrtsay,corfdosay
                   @ 20,0.3  to 22,72.7   label "" of listbox_entrada_xml color corfrtsay,corfdosay

                   mlinha    = alltrim(nfe_e_razaonome) + "-" +;
                               iif(!empty(nfe_e_cnpj),alltrim(nfe_e_cnpj),alltrim(nfe_e_cpf))+;
                               " | Modelo: "+ alltrim(nfe_modelo)+" | Serie: "+alltrim(nfe_serie)+" | Numero: "+;
                               alltrim(nfe_numero)+" | Emissao: "+substr(nfe_emissao,9,2)+"-"+ substr(nfe_emissao,6,2)+"-"+substr(nfe_emissao,1,4)+;
                               " | Chave: "+alltrim(nfe_chave)

                   @ 009,005 say mlinha of listbox_entrada_xml font mtahoma color corfrtsay,corfdosay pixel

                   @ 029.5,005 listbox onfe_verosproduto fields nfe_verosproduto[onfe_verosproduto:nat,1],nfe_verosproduto[onfe_verosproduto:nat,2],;
                               nfe_verosproduto[onfe_verosproduto:nat,3],nfe_verosproduto[onfe_verosproduto:nat,4],nfe_verosproduto[onfe_verosproduto:nat,5],;
                               nfe_verosproduto[onfe_verosproduto:nat,6],nfe_verosproduto[onfe_verosproduto:nat,7];
                               headers "Codigo","Tamanho/Cor","Código NF-e","Produto","Quantidade","Unitário","Total" FIELDSIZES 070,120,090,480,070,070,070;
                               size 500,247;
                               pixel of listbox_entrada_xml
                   onfe_verosproduto:nClrPane      := {|| iif((onfe_verosproduto:nat/2) = int(onfe_verosproduto:nat/2),corfdogetnotafiscal,corlstbxnormal) }
                   onfe_verosproduto:aJustify      := { .F.,.F., .F., .F., .T.,.T.,.T. }
                   onfe_verosproduto:nLineStyle := 2
                   onfe_verosproduto:lCellStyle = .t.
                   onfe_verosproduto:lAutoSkip  = .t.
                   onfe_verosproduto:SetArray(nfe_verosproduto)
                   onfe_verosproduto:bGoTop = { || onfe_verosproduto:nat := 1 }
                   onfe_verosproduto:bGoBottom = { || onfe_verosproduto:nat := Eval( onfe_verosproduto:bLogicLen ) }
                   onfe_verosproduto:bSkip = { | nWant, nOld | nOld := onfe_verosproduto:nat, onfe_verosproduto:nat += nWant,;
                   onfe_verosproduto:nat := Max( 1, Min( onfe_verosproduto:nat, Eval( onfe_verosproduto:bLogicLen ) ) ),;
                   onfe_verosproduto:nat - nOld }
                   onfe_verosproduto:bLogicLen = { || Len( nfe_verosproduto ) }
                   onfe_verosproduto:cAlias = "Array"
                   onfe_verosproduto:nColAct       := 1
                   onfe_verosproduto:lMChange      := .F.
                   onfe_verosproduto:SetFocus()
                   onfe_verosproduto:Refresh()

                   @ 289,012 buttonbmp olisclibut00 bitmap ""            left prompt "Processa" textright size 040,12 font obotaof of listbox_entrada_xml pixel action ( processa_xml_entrada(mLocaldoarquivoxml) )
                   @ 289,452 buttonbmp olisclibut10 bitmap "bmpsair"     left prompt "Sair" textright size 040,12 font obotaof of listbox_entrada_xml pixel action ( listbox_entrada_xml:end() )
            activate dialog listbox_entrada_xml center
return nil
function retorna_volta(objetnfe)
return(objetnfe)
function processa_xml_entrada(mLocaldoarquivoxml)

         cInfo:=      "Dados da nota:"
         cInfo+=CRLF+ " "
         cInfo+=CRLF+ "Chave de acesso: " + nfe_cdchvacesso
         cInfo+=CRLF+ "Natureza da operacao: " + nfe_operacao
         cInfo+=CRLF+ "Modelo: "  + nfe_modelo
         cInfo+=CRLF+ "Serie: "   + nfe_serie
         cInfo+=CRLF+ "Numero: "  + nfe_numero
         cInfo+=CRLF+ "Emissao: " + nfe_emissao
         cInfo+=CRLF+ " "
         cInfo+=CRLF+ "Dados do fornecedor: "
         cInfo+=CRLF+ " "
         cInfo+=CRLF+ iif(empty(nfe_e_cnpj),"CPF: ","CNPJ: ") + iif(empty(nfe_e_cnpj),nfe_e_cpf,nfe_e_cnpj)
         cInfo+=CRLF+ "Razao: "         + nfe_e_razaonome
         cInfo+=CRLF+ "Fantasia: "      + nfe_e_fantasia
         cInfo+=CRLF+ "Endereco: "      + nfe_e_logradouro
         cInfo+=CRLF+ "Numero: "        + nfe_e_numero
         cInfo+=CRLF+ "Complemento: "   + nfe_e_complemento
         cInfo+=CRLF+ "Bairro: "        + nfe_e_bairro
         cInfo+=CRLF+ "Cidade: "        + nfe_e_municipio
         cInfo+=CRLF+ "Estado: "        + nfe_e_estado
         cInfo+=CRLF+ " "
         cInfo+=CRLF+ "E ASSIM POR DIANTE............. "

         msginfo(cInfo)

         listbox_entrada_xml:end()
         odlgwait:end()
return nil

FUNCTION fWait( cMens )
         CursorWait()
         define dialog oDlgWait title "" from 10,20 to 23,60 brush obrush STYLE nOr( WS_BORDER, WS_POPUP, WS_VISIBLE ) //transparent
                define font mtahoma_desc name "Tahoma"          size 11.2,30.8
                @ 35,010 say oMens var cMens of odlgWait font mtahoma_desc color corfrtsay,corfdosay pixel
         ACTIVATE DIALOG oDlgWait CENTERED NOWAIT
         CursorArrow()
         release font mtahoma_desc
RETURN nil

function IsInternet()
         local cip, cvret := .F.
         wsastartup()
         cip := gethostbyname("www.microsoft.com")
         wsacleanup()
         if cip = "0.0.0.0"
            return .f.
         else
            return .t.
         endif
return .t.