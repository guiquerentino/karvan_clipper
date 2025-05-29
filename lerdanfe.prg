*** Pesquisa a existência de um determinado texto dentro de um arquivo
*** O arquivo pode ter qualquer extensão
***
*** Parâmetros
*** cArq = Nome do arquivo a ser pesquisado
*** cPesq = Cadeia a ser pesquisada 
*** cTroca = Caso seja informado ao encontrar a sequencia sera feita a troca 
*** Obs : Se a nova string for menor que a pesquisada então a diferença
***  : sera preenchida com espaços
***
*** Retorno :
*** Retorna a quantidade de ocorrências
*** Em caso de erro retorna -1, -2 ou -3 dependendo do erro
***
*** Alterada em : 11.02.2008 as 14:29 horário de Brasília
*** A pesquisa agora e feita do 1º byte em diante
*** A função agora nao diferencia maiúsculas de minusculas
***
*** Obs : Na pesquisa tanto faz se e maiúscula ou minúscula
***   porém no caso da nova string vale como ela foi passada
***   Ex : Se a nova string for "BaRtOlomEU" assim ela sera gravada
***
*** Contribuições : Maligno e Eolo
*** 
*------------------------------------*
* Function PesqByte(cArq,cPesq,cTroca)
*------------------------------------*
nume=space(44)
@01,01 get nume
read
NUME=ALLTRIM(STR(NUM))
LOC="c:\danfe\e ("
EXT=").xml"
cArq=LOC+NUME+EXT
cPesq="<xProd>"
Cpesq1="<ncm>"
Cpesq2="<cprod>"
cpesq3="<cean>"
cpesq4="<qcom>"
cpesq5="<vuncom>"
@ 01,01 SAY CARQ
inkey(0)
use teste.dbf
INDEX ON cean TO CEAN
if .not. file(cArq) // Arquivo não encontrado
  ALERT('ARQUIVO NAO ENCONTRADO')
 return(.T.)
endif
pl="<"
hand=fopen(cArq,2)
Byte=1
Tamanho=fseek(hand,0,2)
posiciona=fseek(hand,0,0)
CONTA1=0
conta=0          
mprod=space(0)                
do whil .T.
  lebyte=freadstr(hand,1)
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq3))
       if upper(leu)=upper(cPesq3)
              mcean=space(0)
              conta++     
              lebyte=freadstr(hand,1,-1)
              do while upper(lebyte)# "<"
                    @ 10,01 say mcean
                     mcean+=lebyte          
                     lebyte=freadstr(hand,1)          
              enddo                    
              use teste.dbf 
              set index to CEAN
              seek mcean
              if ! found()
                    CONTA1++
                    append blank
                    @ 13,01 say mcean
                    replace cean with mcean
              endif      
           else
              cont=len(cPesq3)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq2))
       @ 08,01 say leu
       if upper(leu)=upper(cPesq2)
              nprod=space(0)
              lebyte=freadstr(hand,1,-1)
              @ 09,01 say lebyte
              do while upper(lebyte)# "<"
                     nprod+=lebyte     
                     @ 10,01 say nprod     
                     lebyte=freadstr(hand,1)          
              enddo                    
              replace cprod with nprod
           else
              cont=len(cPesq2)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq))
       @ 02,01 say leu
       if upper(leu)=upper(cPesq)
              mprod=space(0)
              lebyte=freadstr(hand,1,-1)
              @ 03,01 say lebyte
              do while upper(lebyte)# "<"
                     mprod+=lebyte
                     @ 04,01 say mprod          
                     lebyte=freadstr(hand,1)          
              enddo                    
              replace xprod with mprod
           else
              cont=len(cPesq)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq1))
       @ 05,01 say leu
       if upper(leu)=upper(cPesq1)
              mncm=space(0)
              lebyte=freadstr(hand,1,-1)
              @ 06,01 say lebyte
              do while upper(lebyte)# "<"
                     mncm+=lebyte     
                     @ 07,01 say mncm     
                     lebyte=freadstr(hand,1)          
              enddo                    
              replace ncm with mncm
           else
              cont=len(cPesq1)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq4))
       @ 14,01 say leu
       if upper(leu)=upper(cPesq4)
              mqcom=space(0)
              lebyte=freadstr(hand,1,-1)
              @ 15,01 say lebyte
              do while upper(lebyte)# "<"
                     mqcom+=lebyte     
                     @ 16,01 say mqcom     
                     lebyte=freadstr(hand,1)          
              enddo                    
              replace qcom with mqcom
           else
              cont=len(cPesq4)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif  
  if upper(lebyte)=pl
       posiciona=fseek(hand,-1,1)
       leu=freadstr(hand,len(cPesq5))
       @ 17,01 say leu
       if upper(leu)=upper(cPesq5)
              mvuncom=space(0)
              lebyte=freadstr(hand,1,-1)
              @ 18,01 say lebyte
              do while upper(lebyte)# "<"
                     mvuncom+=lebyte     
                     @ 19,01 say mvuncom     
                     lebyte=freadstr(hand,1)          
              enddo                    
              replace vuncom with mvuncom
           else
              cont=len(cPesq5)
              posiciona=fseek(hand,(-cont)+1,1)   
       endif
  endif
  byteatual=fseek(hand,1,-1)
  byte++
  if byte>=tamanho-len(cPesq)+1
     fclose(hand)
     @ 20,60 SAY CONTA
     @ 21,61 SAY CONTA1
     IF LASTKEY()=27
            RETURN(.T.)
     ENDIF
     NUM++
     LERDANFE()       
 endif
enddo
