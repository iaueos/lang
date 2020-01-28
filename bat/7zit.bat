@echo off
SET ZZCMD="c:\Program Files\7-zip\7z.exe"
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

:ende 