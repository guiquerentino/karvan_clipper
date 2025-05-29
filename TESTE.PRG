clear
PRIVATE msg_tel:="PC Toledo - (018) 771-2317"
PRIVATE aVet:={}
AADD(aVet,{"1"})
AADD(aVet,{"2"})
AADD(aVet,{"3"})
AADD(aVet,{"4"})
AADD(aVet,{"5"})
AADD(aVet,{"6"})
AADD(aVet,{"7"})
@ 10,10 say ""
FOR i=1 TO 8
  @ ROW()+1,10 SAY aVet[i]
NEXT
return

proc ErrorSys()
  ErrorBlock( {|e| DefError(e)} )
return
