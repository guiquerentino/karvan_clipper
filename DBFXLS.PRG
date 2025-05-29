******************************************************************
* Exemplo de como criar um arquivo XLS (Excel) a partir de um
* arquivo DBF (VENDAS.DBF).
* Note abaixo que para fazer a divisao das colunas e' usado CHR(9).
* Voce tambem pode utilizar formulas no conteudo das colunas.
* Exemplo 1: 
* "=C2*D2" onde o conteudo da celula C2 sera multiplicado pela celula D2
* 
* o exemplo acima corresponde a
* ( "=C"+LTRIM(STR(v_l,5,0))+"*D"+LTRIM(STR(v_l,5,0)) )
*
* Exemplo 2:
* "=SOMA(C2:C11)"  soma da celula C2 ate C11
*
* o exemplo acima corresponde a
* "=SOMA(C2:C"+LTRIM(STR(v_l,5,0))+")"
* 
* Este exemplo vai criar um arquivo chamado VENDAS.XLS
*
* Para compilar este Exemplo, digite:
* CLIPPER DBFXLS
* RTLINK FI DBFXLS
*
* Site Clipper On Line (www.pctoledo.com.br)
* Autor: Paulo Cesar Toledo (toledo@expressnet.com.br)
*
* P.S.: abra primeiro o EXCEL para depois abrir o arquivo VENDAS.XLS.
*       Se o Assistente de Importacao for aberto, clique no botao
*       Concluir.
******************************************************************
CLEAR
*SELECT 1
USE D:\KARVAN\CLIENTES
INDEX ON NOMECLI TO NOMECLI
vArq:="VENDAS.XLS"
SET PRINTER TO (vArq)
SET DEVICE TO PRINT
vTit:="=HOJE()"
@ 00,00 SAY vTit
v_l=1
DO WHILE !EOF()
 v_l++
 vValor:=STRTRAN(LTRIM(STR(VALSEMANA,10,2)),'.',',')
 mcod:=str(codcli)
 vLinha:=mcod+chr(9)+nomecli+chr(9)+vValor+chr(9)

 IF VALSEMANA#0
        @ PROW()+1,00 SAY vLinha
 ENDIF
 SKIP
ENDDO
vRod:="TOTAL GERAL ===>>>"
@ PROW()+1,00 SAY vRod
SET PRINTER TO
SET DEVICE TO SCREEN
CLOSE ALL
TONE(400,3)
vMen:="O ARQUIVO VENDAS.XLS FOI CRIADO COM SUCESSO...;"+;
      "ABRA O ARQUIVO NO EXCEL E FA€A AS FORMATA€OES;"+;
      "NECESSARIAS."
ALERT(vMen,,"15/3")
RETU
