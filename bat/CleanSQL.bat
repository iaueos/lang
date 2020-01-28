@echo off
md _
for %%f in (*.sql) do awk -f "c:\bin\comment.awk" "%%f" > _\"%%f"
zip -m _.zip *.sql 
move _\*.sql .\
rd _
