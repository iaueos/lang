@echo off
if "%~x1"==".webm" goto webmogg
if "%~x1"==".mp4" goto mp4aac
goto exit 


:webmogg 
ffmpeg -i %1 -i "%~n1.ogg" -c:v copy -c:a vorbis -strict experimental "%~n1.mkv"
goto exit 

:mp4aac 
ffmpeg -i %1 -i "%~n1.aac" -c:v copy -c:a aac -strict experimental "%~n1-out.%~x1"
goto exit 

:exit 