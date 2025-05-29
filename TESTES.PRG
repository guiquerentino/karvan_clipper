# INCLUDE "FILEIO.CH"
handle:= fopen("d:\karvan\teste.TXT", 2)
   RET_TAM =  FSeek( Handle, 0, FS_END )
   CLS
   COL=1
   POS_RET = 0
   VAR_RET_CMD=" "
   VAR_AUX =" "

      for POS_RET = 1 to 10
         fread( Handle, @VAR_AUX, 1)
         *if VAR_AUX <> chr(13)
           VAR_RET_CMD= VAR_RET_CMD + VAR_AUX
         *end if
         COL++
      next
        Fclose(Handle)
       @ 01,01 SAY VAR_RET_CMD
                           INKEY(0)
