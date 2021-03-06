--- AddEmployee

INSERT INTO dbo.EMPLOYEE
(
  FIRST_NAME
  , LAST_NAME
  , BORN
  , BIRTH_PLACE
  , GENDER
  , EMAIL
  , USERNAME
  , BEGUN
  , ENDED
)
VALUES
(
  @FIRST_NAME
  , @LAST_NAME
  , @BORN
  , @BIRTH_PLACE
  , @GENDER
  , @EMAIL
  , @USERNAME
  , @BEGUN
  , @ENDED
);

SELECT SCOPE_IDENTITY() AS [EMPLOYEE_ID]
