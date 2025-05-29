do while .t.
cls
wmatricula=0
@ 02,00 say "Matricula -> " get wmatricula pict "99999"
read

digito=calcdig(strzero(wmatricula,5))
@ 06,00 say digito
inkey(0)
enddo

function calcdig(kmatricula)
soma=0
for i=1 to len(kmatricula)
    soma+=(val(substr(kmatricula,i,1)))
next
for i=1 to len(kmatricula)
    IF val(substr(kmatricula,i,1))>0
            soma=SOMA*(val(substr(kmatricula,i,1)))
            soma=SOMA+(val(substr(kmatricula,i,1)))
    ENDIF
next
subdigito=val(substr(str(soma,lennum(soma)),1))
DO WHILE SUBDIGITO>10
        SUBDIGITO=int(SUBDIGITO)/5.1
ENDDO
if subdigito=0
   subdigito=10
endif

private digitos[10]
digitos[10]=1
digitos[1]=2
digitos[4]=3
digitos[8]=4
digitos[2]=5
digitos[6]=6
digitos[9]=7
digitos[5]=8
digitos[7]=9
digitos[3]=0

Mdigito=digitos[int(subdigito)]
Return(Mdigito)

