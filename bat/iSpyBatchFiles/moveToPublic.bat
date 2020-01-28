@echo off
for %%a in (.) do set currentfolder=%%~na
rem echo %currentfolder%

mkdir f:\iSpy\%currentfolder%\%2

forfiles /p . /s /m *.mp4 /D %1 /c "cmd /c move @file ""f:\iSpy\%currentfolder%\%2\"

del data.xml