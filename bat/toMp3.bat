@echo off 
c:\bin\ffmpeg\bin\ffmpeg.exe -i %1 -vn -b:a 192k -c:a libmp3lame "%~n1.mp3"