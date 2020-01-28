@echo off 
rem echo %date%
set todaysdate=%date:~0,2%%date:~3,2%%date:~6,2%_%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
 rem echo %time%
rem set mydate=%date%-%time:~0,2%-%time:~3,2%-%time:~6,2%


echo %todaysdate%