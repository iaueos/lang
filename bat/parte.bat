@echo off 
if %1=="" goto ende

echo full:  %~f1
echo drive: %~d1 
echo path:  %~p1
echo name:  %~n1
echo ext:   %~x1
echo short: %~s1
echo attr:  %~a1
echo time:  %~t1
echo size:  %~z1
echo fnex:  %~nx1


set ft=%~d1%~p1%~n1.txt
echo FT     %ft%
rem start notepad %ft%
:ende