SELECT
    r.Routine_Definition [DDL]
FROM INFORMATION_SCHEMA.Routines r 
where r.routine_name = 'fn_get_last_process_id'