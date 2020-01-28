BEGIN { a = 0 } 
!/(^[\/\*\*\*\*][.*][\*\*\*\*\/])/ { 
	if (( $0 == "USE [PICKINGS_DB]" ) ||( $0 == "USE [IKBP_P1_DB_PRD]" ) ||($0 == "SET ANSI_NULLS ON") ||($0 == "SET QUOTED_IDENTIFIER ON") || ($0=="SET ANSI_PADDING ON") || ($0=="SET ANSI_PADDING OFF") || ($0 == "SET QUOTED_IDENTIFIER OFF"))
	{
		++a
	} else if ($0 == "GO") 
	{
		++a 
	}
	else {
		print $0 
	}
}
END {  }