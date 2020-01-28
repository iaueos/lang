using System;
using System.Text;
using System.Diagnostics; 

class tespad { 
	public static void Main(string[] args) {
		string v= null;
		
		Console.WriteLine("{0}\t{1}", v.PadLeft(5, '0'), v.PadRight (5, '0'));
	}
}