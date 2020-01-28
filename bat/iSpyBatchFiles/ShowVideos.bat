@echo off
mkdir c:\users\public\videos\iSpy\%2
forfiles /p . /s /m *.mp4 /D %1 /c "cmd /c echo move @file ""c:\users\public\videos\iSpy\%2\"