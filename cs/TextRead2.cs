using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.IO;

namespace TextRead
{
    public class TheRead
    {
        static void Main(string[] args)
        {
            List<string> files = new List<string>();

            using (StreamReader s = new StreamReader(args[0]))
            {
                string l;
                StringBuilder b = new StringBuilder("");
                int j = 0;
                string fn = "", lastfn = "";
                string v = "";
                while ((l = s.ReadLine()) != null)
                {
					if (string.IsNullOrEmpty(l)) continue;
                    
                    if (l.StartsWith("    "))
                    {
                        j = 0;
                        fn = l.Trim();
                        Console.WriteLine("");
						fn = SanitizeFilename(fn);
						b.Append("\r\n");
						Flush(b, fn, ref j);
						
                        if (string.Compare(fn, lastfn) != 0)
                        {
                            lastfn = fn;
                            if (!files.Contains(fn) && File.Exists(fn))
                            {
                                ReMoveFile(fn);
								files.Add(fn);
                            }
                        }
                        else
                            b.Append("\r\n");
                    }
                    else if (l.StartsWith("\t"))
                    {
                        int colPos = l.IndexOf(":");
                        if (colPos < 1 || (colPos + 1 >= l.Length)) continue;
                        v = l.Substring(colPos + 1, l.Length - colPos - 1).TrimStart();
                        
                        if (j > 0)
                            b.Append("\t");
                        j++;
                        Console.Write(v);
                        b.Append(v);
                    }
                }
                j = 1;
                Flush(b, fn, ref j);
            }
        }

        static void Flush(StringBuilder bx, string f, ref int a)
        {
            if ((!string.IsNullOrEmpty(f)) && a > 0)
            {
                File.AppendAllText(f, bx.ToString());
                bx.Clear();
                a = 0;
            }
            else
            {
                Console.WriteLine("filename is empty");
            }
        }

        readonly static string DirtyFileNamePattern = "[\\+/\\\\\\#%&*{}/:<>?|\"-]";

        public static string SanitizeFilename(string insane)
        {
            //string pattern = "[\\+/\\\\\\~#%&*{}/:<>?|\"-]";
            string replacement = "_";

            Regex regEx = new Regex(DirtyFileNamePattern);
            return Regex.Replace(regEx.Replace(insane, replacement), @"\s+", " ");
        }

        public static string Unique(string n)
        {
            string dir = Path.GetDirectoryName(n)
                , fn = Path.GetFileNameWithoutExtension(n)
                , ext = Path.GetExtension(n)
                , fx = "";
            int i = 0;
            do
            {
                fx = Path.Combine(dir,
                        fn
                        + Base52((int)Math.Round(DateTime.Now.TimeOfDay.TotalSeconds))
                        + Base52((int)Math.Round((double)DateTime.Now.Millisecond / 38))
                        + Base52(i++)
                        + ext);
            } while (File.Exists(fx));
            return (fx);
        }

        public static string ReMoveFile(string n)
        {
            string newname = n;
            if (!File.Exists(n)) return n;

            try
            {
                newname = Unique(n);
                File.Move(n, newname);
            }
            catch (Exception ex)
            {
                Console.WriteLine("RemoveFile ({0})", n);
                Console.WriteLine(ex);
                newname = null;
            }
            return newname;
        }

        public static string Base52(long l)
        {
            const byte BASE = 52;
            const string a = "etaoinshrdlucmfwypvbgkjqxzETAOINSHRDLUCMFWYPVBGKJQXZ";
            StringBuilder x = new StringBuilder("");
            byte n;
            do
            {
                n = (byte)(l % BASE);
                x.Insert(0, a.Substring(n, 1));
                l = (l - n) / BASE;
            }
            while (l > 0);
            return x.ToString();
        }


    }
}