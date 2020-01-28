using System;
using System.Text;

namespace tod {
	class Program 
	{
		static void Main(string[] args)
		{
            long l = 0;
            foreach (string s in args)
                if (long.TryParse(s, out l))
                    Console.WriteLine("{0} {1}", s, lxxii(l));
                else
                    Console.WriteLine(s + " !");
		}

        public static void tp()
        {
                TimeSpan t = new TimeSpan(0, 23, 59, 59, 999);

                Console.WriteLine("mentok {0} s {1} ms {2}", t
                    , t.TotalSeconds
                    , t.TotalMilliseconds);


			    Console.WriteLine("tod {0} s {1} ms {2}", DateTime.Now.TimeOfDay
			        , DateTime.Now.TimeOfDay.TotalSeconds
			        , DateTime.Now.TimeOfDay.TotalMilliseconds);
        }


        public static string lxxii(long l)
        {
            const byte BASE = 72;
            const string a = "0123456789ETAOINSHRDLUCMFWYPVBGKJQXZetaoinshrdlucmfwypvbgkjqxz-_#@$()[]~";
            StringBuilder x = new StringBuilder(new string(' ',12),12);
            if ((l<0) && (l>long.MinValue)) l = Math.Abs(l);
            int j = x.Length - 1;
			byte n;
            do
            {
                n = (byte)(l % BASE);
                x[j] = a[n];
                /// l = (l - n) / BASE;
                l /= BASE;
                j--;
            }
            while (l > 0);
            return x.ToString(j+1, 11-j);
        }
	}
}

