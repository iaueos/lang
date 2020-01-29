--- GetEmployee 
DECLARE @@ID BIGINT = @EMPLOYEE_ID 

SELECT [EMPLOYEE_ID]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[BORN]
      ,[BIRTH_PLACE]
      ,[GENDER]
      ,[EMAIL]
      ,[USERNAME]
      ,[BEGUN]
      ,[ENDED]
  FROM [dbo].[EMPLOYEE]
  WHERE (NULLIF(@@ID,0) IS NULL) OR (EMPLOYEE_ID = @@ID)


