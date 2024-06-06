@echo off
SET ZZCMD="c:\Program Files\7-zip\7zG.exe"
if "%1"=="" goto noParam 
if "%2"=="" goto singleParam 
if "%3"=="" goto duoParam

:third 
%ZZCMD% a  %1 -p%3 @%2
goto ende 

:duoParam 
%ZZCMD% a %1 @%2
goto ende

:singleParam
set ft=%~d1%~p1%~n1.txt
 %ZZCMD% a %1 @"%ft%"

:noParam
echo 7zit [archive] 
echo make [archive].7z from file list  in [archive].txt 
echo.
echo 7zit [archive] [listfile]
echo make [archive].7z from [listfile].txt
echo. 
echo 7zit [archive] [listfile]  
echo make [archive].[type] from [listfile].txt 

:ende 