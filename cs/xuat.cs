using System;
using System.Text;


public class xuat {
	public static void Main(string[] args) {
		long l;
		int u = 0;
		if (args.Length > 0) {
			if (args[0].Equals("-")) 
				u = 1;
			if (u < 1)
				for (int i = 0; i < args.Length; i++) 
					if (long.TryParse(args[i], out l)) 
						Console.WriteLine(SexQuat(l));
					else 
						Console.WriteLine();
			else 
				for (int i = 1; i < args.Length; i++) 
					Console.WriteLine(UnSexQuat(args[i]));
		} 
	}
	
	public static long UnSexQuat(string s) {
		string A = "0123456789etaoinshrdlucmfwypvbgkjqxzETAOINSHRDLUCMFWYPVBGKJQXZ-_";
		const byte BASE = 64;
		long l = 0;
		int j = 1;
		for (int i = s.Length-1; i >=0; i--) {
			string b = s.Substring(i, 1); 
			
			int n = A.IndexOf(b);
			if (n >= 0) {
				Console.WriteLine("{3} n= {0,2} j= {1,10} n*j= {2,15}", n, j,n * j, b );
				l = l + ((n) * j);
			}
			
			j = j * BASE;
		}
		return l;
	}
	
	
	public static string SexQuat(long l)
        {
            const byte BASE = 64;
			const string A = "0123456789etaoinshrdlucmfwypvbgkjqxzETAOINSHRDLUCMFWYPVBGKJQXZ-_#";
            StringBuilder x = new StringBuilder("");
            byte n ;
            do
            {
                n = (byte)(l % BASE);
                if (n < BASE)
                    x.Insert(0, A.Substring(n, 1));
                l = (l - n) / BASE;
            }
            while (l > 0);
            return x.ToString();
        }
}