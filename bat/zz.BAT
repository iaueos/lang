@ECHO OFF 
IF (%1)==() EXIT /B 1

for /f "tokens=*" %%a in ('timatum %%Y%%m%%d') do (
    set timatum=%%a
)
SET BAK=d:\~\BAK\%1\%1%
SET ZZCMD="c:\Program Files\7-zip\7zG.exe"
IF NOT EXIST D:\~\BAK\%1 (
 MD d:\~\BAK\%1
)

%ZZCMD% a -tzip %BAK%_%timatum%.zip -r   %CD%\%1\* -x@"C:\BIN\ex.txt"
SET BAK=
SET NEWSET=
SET ZZCMD=
set todaysdatum= 