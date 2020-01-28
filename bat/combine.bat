@echo off
if  ""=="%1" goto exit
if  ""=="%2" goto exit

ffmpeg -i "%1" -i "%2" -c:v copy -c:a copy -strict experimental "%~n1-output.%~x1"

:exit 