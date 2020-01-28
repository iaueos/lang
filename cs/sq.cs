using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;

namespace Program
{
    public class Sq
    {
        public static int Main(string[] args)
        {
            int act = 0; ///default: calc number from input 
            if (args.Length < 1)
            {
                Console.WriteLine("sq . [number] [number] @[code] [code]\r\n"
                    + "translate code to number or number to code when - parameter is met\r\n"
                    + "operations: \r\n"
                    + ". code string to long \r\n"
                    + "@ long to string code\r\n"
                    + "$ single occurence of letters\r\n"
                    + "% extract only numbers\r\n"
                    + "= Get Token <name> <num> <timestamp:hhmmss>\r\n"
                    );
                return (0);
            }
            int i = 0;
            int n = args.Length;
            while (i < n)
            {
                if (".".Equals(args[i]))
                {
                    act = 1;
                }
                else if ("@".Equals(args[i]))
                {
                    act = 0;
                }
                else if ("$".Equals(args[i]))
                {
                    act = 2;
                }
                else if ("%".Equals(args[i]))
                {
                    act = 3;
                }
                else if ("~".Equals(args[i]))
                {
                    act = 5;
                    string ky = ((i + 1) < n) ? args[i + 1] : "";
                    string nu = ((i + 2) < n) ? args[i + 2] : "";
                    i += Math.Min(n - i, 2) - 1;
                    Console.WriteLine(Roll(ky, nu));
                }

                else if ("=".Equals(args[i]))
                {
                    act = 4;

                    string uid = ((i + 1) < n) ? args[i + 1] : "";
                    string num = ((i + 2) < n) ? args[i + 2] : "0000000000";
                    string tim = ((i + 3) < n) ? args[i + 3] : DateTime.Now.ToString("HHmmss");

                    i += Math.Min(n - i, 3) - 1;

                    Console.WriteLine(GetToken(uid, num, tim));
                }
                else
                {
                    switch (act)
                    {
                        case 0:
                            Console.WriteLine(UnSexQuat(args[i]));
                            break;
                        case 1:
                            long a = 0;
                            if (long.TryParse(args[i], out a))
                                Console.WriteLine(SexQuat(a));
                            else
                                Console.WriteLine("");
                            break;
                        case 2:
                            Console.WriteLine(Simpl(args[i]));
                            break;
                        case 3:
                            Console.WriteLine(OnlyNumber(args[i]));
                            break;
                    }

                }
                i++;
            }


            return (1);
        }


        public static long UnSexQuat(string s)
        {
            string A = "0123456789etaoinshrdlucmfwypvbgkjqxzETAOINSHRDLUCMFWYPVBGKJQXZ-_";
            const byte BASE = 64;
            long l = 0;
            long j = 1;
            for (int i = s.Length - 1; i >= 0; i--)
            {
                string b = s.Substring(i, 1);

                int n = A.IndexOf(b);
                if (n >= 0)
                {
                    // Console.WriteLine("{3} n= {0,2} j= {1,10} n*j= {2,15}", n, j, n * j, b);
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
            byte n;
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

        public static string Simpl(string s)
        {
            string r = "";
            for (int i = 1; i <= s.Length; i++)
            {
                bool hasIt = false;
                string o = s.Substring(i - 1, 1);
                for (int j = 1; j <= r.Length; j++)
                {
                    if (r.Substring(j - 1, 1).Equals(o))
                    {
                        hasIt = true;
                        break;
                    }
                }
                if (!hasIt)
                    r = r + o;
            }
            return r;
        }

        public static string OnlyNumber(string s)
        {
            string r = "";
            for (int i = 0; i < s.Length; i++)
            {
                string x = s.Substring(i, 1);
                int j = 0;
                if (int.TryParse(x, out j))
                {
                    r = r + x;
                }
            }
            return r;
        }

        public static string GetToken(string UserName, string Phone, string TimeStamp)
        {
            string uid = UserName;
            string num = OnlyNumber(Simpl(Phone));
            string tim = OnlyNumber(TimeStamp);

            long n = 0;
            long t = 0;
            long.TryParse(num, out n);
            long.TryParse(tim, out t);
            long tok = 0;
            
            string u = uid;
            string rollKey = n.ToString();
            int L = 9;
            while (u.Length > 0)
            {
                string chunk = u.Substring(0, Math.Min(u.Length, L));
                long ux = Math.Abs(UnSexQuat(chunk));
                tok = tok | Roll(rollKey, ux.ToString());
                rollKey = ux.ToString();
                if (u.Length > L)
                    u = u.Substring(L, u.Length - L);
                else
                    break;
            }
            
            string s =  (Mod9(tok, t)).ToString();
            
            s = s.PadLeft(6, '0');
            s = s.Substring(s.Length - 6, 6);

            return s;           
        }

        public static long Mod9(long a, long b)
        {
            string A = a.ToString();
            string B = b.ToString();

            int la, lb;
            la = A.Length;
            lb = B.Length;
            string r = "";
            for (int i = 0; i < la; i++)
            {
                int ib = i % lb;
                int ja=0, jb=0;
                int.TryParse(A.Substring(i, 1), out ja);
                int.TryParse(B.Substring(ib, 1), out jb);

                ja = (ja + jb) % 10;

                r = r + ja.ToString();
            }
            long rx = 0;
            long.TryParse(r, out rx);
            return rx;
        }

        public static long Roll(string Key, string num)
        {
            
            int[] a = new int[10];
            Key = Simpl(Key);

            /// Console.WriteLine("key={0}", Key);
            int j = 0;
            int k = 0; 
            for (int i = 0; i < Key.Length; i++)
            {
                j = 0;
                if (int.TryParse(Key.Substring(i, 1), out j))
                {
                    a[k] = j;
                    k++;
                }
            }

            for (int n = 9; n >= 0; n--)
            {
                bool ada = false;
                int o = 0;
                while (o < k)
                {
                    if (a[o] == n)
                    {
                        ada = true;
                        break;

                    }
                    o++;
                }
                
                if (!ada)
                {
                    a[k] = n;
                    k++;
                }
                if (k > 9)
                    break;
            }

            //for (int kk = 0; kk < 10; kk++)
            //{
            //    Console.WriteLine("k[{0}]={1}", kk, a[kk]);
            //}

            string r = "";
            int lastM = 0;
            for (int x = 0; x < num.Length; x++)
            {
                int m = 0;
                
                if (int.TryParse(num.Substring(x, 1), out m))
                {
                    lastM = a[m];
                    r = r + a[(m + lastM)%10].ToString();                    
                }
            }
            long rx = 0;
            long.TryParse(r, out rx);

            return rx;

        }

    }
}