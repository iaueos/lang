WbExport
  -sourceTable=TB_M_*
  -type=text
  -types=TABLE
  -excludeTables=TB_R_LOG_*,TB_T_*
  -outputDir='D:\-\SPTT\sc_db_dev_2'
  -sqlDateLiterals=ansi
  -delimiter='\t'
  -sourceTable=*
  -lineEnding=crlf
  -encoding=UTF-8
  -header=true
  -escapeText=8bit
  -trimCharData=true
  -createTable=false
  -useSchema=true
  -dateFormat='yyyy-MM-dd HH:mm:ss'
  -includeAutoIncColumns=true
  -showProgress=true

  
