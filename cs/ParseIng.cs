using System;
using System.Text;
using System.Globalization; 

public class Parseing {
	public static long RoundDecimal(string x) {
		NumberStyles ns = NumberStyles.Number;
		CultureInfo ci = new CultureInfo( "en-US", false );
		if (x.LastIndexOf(",") > x.LastIndexOf("."))
			ci = new CultureInfo("id-ID", false);
			
		decimal dx = 0;
		decimal.TryParse(x, ns, ci, out dx);
		return (long) Math.Round(dx, 0);
	}

	public static void Main(string [] args) {
		long l = 0;
		DateTime d = new DateTime();
		// decimal n = 0;
		
		int op = 0;// long 
		for (int i =0; i < args.Length; i++) {
			if (args[i].StartsWith("/")) {
				string x = args[i].Substring(1);
				switch (x)  {
					case "D" : op = 2; break; // datetime 
					case "N" : op = 1; break; // decimal 
					case "I" : op = 0; break; // long 
					default: op = 0; break;
				}
			}
		}
		
		for (int i = 0; i < args.Length; i ++) {
			if (!args[i].StartsWith("/")) {
				switch(op) {
					case 1:
						Console.Write(RoundDecimal(args[i]));
						/*
						
						if (decimal.TryParse(args[i], out n))
							Console.Write(n);							
						else 
							Console.Write("?"); 
							
						*/
						break;
					case 2: 
						if (DateTime.TryParse(args[i], out d))
							Console.Write(d);
						else 
							Console.Write("?"); 
						break;
							
					default:
						if (long.TryParse(args[i], out l))
							Console.Write(l);
						else 
							Console.Write("?"); 
						break;
				}
			}
			Console.Write("\t");
		}
		Console.WriteLine("");
	}
}