Set Bin=d:\Clipper\Bin
Set Lib=d:\Clipper\Lib
Set Include=d:\Clipper\Include
Set Obj=d:\Clipper\Obj
set Lib=d:\Clipper\Blinker\Lib;%Lib%
set Obj=d:\Clipper\Blinker\Obj;%Obj%
SET PATH=d:\CLIPPER\BIN;d:\CLIPPER\CPMI;d:\CLIPPER\INCLUDE;d:\Clipper\Blinker\Bin;%PATH%
@echo ofF
CLIPPER DBFXLS /B
blinker @DBFXLS.lnk


