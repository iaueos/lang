using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace stringRepl
{
    class Program
    {
        private static readonly string CSV_SEP = ",;";

        static void Main(string[] args)
        {
            for (int i = 0; i < args.Length; i++)
            {
                
                List <string> l = explode(args[i]);
                for (int j = 0; j < l.Count; j++)
                {
                    if (j > 0) Console.Write("\t");
                    Console.Write(l[j]);
                }
                Console.WriteLine();
                
                // Console.Write(CleanInvNo(args[i]));
            }
            Console.WriteLine();
        }

        static string CleanInvNo(string ino)
        {
            /// replace ~ @ # $ % & * ; = < > ` ! ^ - with /
            Regex CleanInoRegex = new Regex("[~@#\\$%&\\*\\;=<>`!\\^\\-]");
            ino = CleanInoRegex.Replace(ino, "/");

            return ino;
        }

        static List<string> explode(string s)
        {
            List<string> b = new List<string>();
            Regex rx = new Regex("([\"]([^\"]+)[\"]|([^" + CSV_SEP
                            + "]+)|)[\\" + CSV_SEP + "]?");
            MatchCollection c = rx.Matches(s);
            if (c.Count > 0)
            {
                for (int i = 0; i < c.Count; i++)
                {
                    if (c[i].Groups.Count > 1 && c[i].Groups[2].Value.Length > 0)
                        b.Add(c[i].Groups[2].Value);
                    else if (c[i].Groups.Count > 0 && c[i].Groups[1].Value.Length > 0)
                        b.Add(c[i].Groups[1].Value);
                    else
                        b.Add("");
                }
            }
            return b;
        }
    }
}

