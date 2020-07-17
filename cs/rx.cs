using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Collections;

namespace Rex
{
    public class Rx
    {
        public static int Main(string[] args)
        {
            string konten = "";
            string fRegex = "";
            string fFilex = "";

            string[] l = new string[] { };
            Regex x = null;

            if (args.Length <= 0)
            {
                Help();
                return 1;
            }

            List<string> s = new List<string>();
            int i;

            try
            {
                i = 0;
                while (i < args.Length)
                {
                    if ("@".Equals(args[i].Substring(0)))
                    {
                        string fn = args[i].Substring(1, args[i].Length - 1);
                        Console.WriteLine($"{i} {fn}");
                        if (File.Exists(fn))
                        {
                            konten = File.ReadAllText(fn).Trim();
                            if (string.IsNullOrEmpty(fRegex))
                            {
                                fRegex = konten;

                            }
                            else if (string.IsNullOrEmpty(fFilex))
                            {
                                fFilex = fn;
                                s.AddRange(konten.Split(new char[] { '\r', '\n' },
                                    StringSplitOptions.RemoveEmptyEntries));
                            }
                        }
                        else
                        {
                            Console.WriteLine("No file: {fn}");
                        }
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(fRegex))
                            fRegex = args[i];
                        else
                            s.Add(args[i]);
                    }
                    i++;
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine("{0}\r\n{1}", ex.Message, ex.StackTrace);
            }

            if (fRegex == null)
            {
                Help();
                return 1;
            }
            for (int j = s.Count - 1; j >= 0; j--)
            {
                if (string.IsNullOrEmpty(s[j])) s.RemoveAt(j);
            }
            x = new Regex(fRegex);
            foreach (string a in s)
            {
                x.MatchesList(a);
            }
            return 0;
        }

        public const string Hilfe =
@"RX - Regular eXpression test

Usage:
	rx expression
	rx expression string string ... string
	rx @expression_file string string ... string
	rx @expression_file @string_list_file
";
        private static void Help()
        {
            Console.WriteLine(Hilfe);
        }
    }



    public static class RxHelper
    {
        public static void MatchesList(this Regex r, string t = null)
        {
            string opat = "{0,4:0000} {1}";
            MatchCollection x = r.Matches(t);
            if (x.Count < 1) return;
            Console.WriteLine(t);
            if (x.Count > 1)
                Console.WriteLine($"{x.Count} matches");
            else
                Console.WriteLine("match");

            for (int i = 0; i < x.Count; i++)
            {
                Match m = x[i];
                string g0 = string.Format(opat, i, m.Value);
                Console.WriteLine(g0);

                if (m.Groups.Count > 0)
                {
                    Console.Write("    ");
                    int k = 0;
                    for (int j = 0; j < m.Groups.Count; j++)
                    {
                        if (k > 0)
                        {
                            Console.Write("    ");
                        }
                        string g1 = string.Format(opat, j, m.Groups[j].Value);

                        if (string.Compare(g0, g1) != 0)
                        {
                            Console.WriteLine(g1);
                            ++k;
                        }
                        else
                        {
                            Console.WriteLine("____");
                        }
                    }
                }
            }
        }
    }

}