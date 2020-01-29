SELECT X.SEQ, X.SEQ & 1 _1, X.SEQ & 2 _2, X.SEQ & 4 _4, X.SEQ & 8 _8
FROM 
(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) SEQ FROM string_split('                   ',' ')) X 