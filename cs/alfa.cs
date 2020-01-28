using System;

public class Alfa {
	public static void Main(string[] args) {	
		int a = 0, i = 0;
		if (args.Length > 0 {
			if (int.TryParse(args[0], out  a))  {
				i = a; 
				while (i > 0) {
					a = i % 26; 
					i = i / 26 
				}
			} 
		}
	}
}