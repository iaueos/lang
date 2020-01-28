BEGIN { a = 0 } 
!/^(COMMIT)/ { print $0 }