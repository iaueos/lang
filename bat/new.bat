@echo off
SET PARAMDAY=%DATE%
IF NOT ""=="%1"  (
 SET PARAMDAY=%1
)

@forfiles /s /D +"%PARAMDAY%" /M *.* /C "cmd /c echo @relpath" | "c:\Program Files\Git\usr\bin\awk.exe" "{ print substr($0,4, length($0)-4) }"