@echo off
rem using the script:
rem   script.cmd <SOURCE_PATH> <OUTPUT_NAME>
 
rem location of the source image files. The first argument followed the script.
set img=%1
rem location of the C44 command not used really... see below
set CMD1="C:\Program Files (x86)\DjVuLibre\c44.exe"
rem location of the djvm.exe
set CMD2="C:\Program Files (x86)\DjVuLibre\djvm.exe"
rem location of the temp file you can change it to whatever you want.
set WORK="D:\`\tmp.djvu"
rem location of the output file. The second argument followed the script
set OUT="D:\`\%2.djvu"
cd %IMG%
FOR  %%G IN (*.jpg) DO (
	rem real location of the C44 command 
	"C:\Program Files (x86)\DjVuLibre\c44.exe" -decibel 48 "%%G" %WORK% 
	IF EXIST %OUT% (
		%CMD2% -i %OUT% %WORK% 
	) ELSE (
		%CMD2% -c %OUT% %WORK% 
	)
)
timeout /t 10