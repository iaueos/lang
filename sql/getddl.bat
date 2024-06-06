sqlcmd -S 10.0.2.3 -U PCSQA -P PC5Q4 -d IPPCS_QA -Q "SET NOCOUNT ON;select routine_definition[ddl] from information_schema.routines where routine_name='%1'" -o "%1.%2.SQL" -h -1 -W 
