using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace kon
{

    public class RxData
    {
        public string fr;
        public string to;
    }

    class Program
    {
        static void Main(string[] args)
        {
            List<RxData> rx = new List<RxData>();

            string inputfile = null, outputfile = null, regexFile = null;
            char[] rsplit = new char[] { '\t' };

            if (args != null)
                if (args.Length > 0)
                {

                    foreach (string s in args)
                    {
                        if (s.StartsWith("--"))
                        {
                            regexFile = s;
                        }
                        else
                        {
                            if (string.IsNullOrEmpty(inputfile))
                            {
                                inputfile = s;
                            }
                            else
                            {
                                outputfile = s;
                            }
                        }
                    }
                    if (!File.Exists(inputfile))
                    {
                        return;
                    }
                    string rxfile = "";
                    if (string.IsNullOrEmpty(regexFile) || !File.Exists(regexFile))
                    {
                        rx.Add(new RxData() { fr = "([0-9][0-9][0-9][0-9]\\-[0-9][0-9]\\-[0-9][0-9])", to = "$1 00:00:00" });
                        rx.Add(new RxData() { fr = "([0-9][0-9][0-9][0-9]\\-[0-9][0-9]\\-[0-9][0-9] [0-9][0-9]\\:[0-9][0-9]\\:[0-9][0-9])\\.[0-9]+", to = "$1" });
                        rx.Add(new RxData() { fr = "([0-9][0-9]\\:[0-9][0-9]\\:[0-9][0-9])\\.[0-9]+", to = "$1" });
                        rx.Add(new RxData() { fr = "NULL", to = "" });
                    }
                    else
                    {
                        rxfile = File.ReadAllText(regexFile);

                        foreach (string rxs in rxfile.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            string[] bx = rxs.Split(new char[] { '\t' }, StringSplitOptions.None);
                            rx.Add(new RxData() { fr = ((bx.Length > 0) ? bx[0] : ""), to = ((bx.Length > 1) ? bx[1] : "") });
                        }
                    }

                    if (string.IsNullOrEmpty(outputfile))
                    {
                        outputfile = Path.GetDirectoryName(inputfile) + Path.GetFileNameWithoutExtension(inputfile) + "_" + DateTime.Now.ToString("HHmmss") + DateTime.Now.Millisecond.ToString() + Path.GetExtension(inputfile);

                    }
                    Console.WriteLine("Output: {0}", outputfile);
                    StreamReader r = new StreamReader(new FileStream(inputfile, FileMode.Open, FileAccess.ReadWrite, FileShare.ReadWrite));
                    StreamWriter w = new StreamWriter(new FileStream(outputfile, FileMode.OpenOrCreate));

                    string lin = "";
                    lin = r.ReadLine();
                    int[] rindex = new int[] { };
                    int linum = 0;
                    string[] th = lin.Split(rsplit);
                    Array.Resize(ref rindex, th.Length);

                    while (lin != null)
                    {
                        lin = lin.Replace(((char) 0).ToString(), String.Empty);

                        string[] t = lin.Split(rsplit);
                        int chgs = 0;

                        if (linum > 0 && linum < 2)
                        {
                            //Array.Resize(ref rindex, t.Length);
                            for (int x = 0; x < rindex.Length; x++)
                            {
                                rindex[x] = -1;
                            }
                            for (int i = 0; i < t.Length; i++)
                            {
                                for (int j = 0; j < rx.Count; j++)
                                {
                                    MatchCollection m = Regex.Matches(t[i], rx[j].fr, RegexOptions.IgnoreCase);
                                    if ((m.Count > 0) && (m[0].Length == t[i].Length))
                                    {
                                        rindex[i] = j;
                                    }
                                }
                            }
                        }
                        if (rindex.Length > 0 && linum > 0)
                        {

                            for (int ti = 0; ti < t.Length; ti++)
                            {
                                if (rindex.Length > ti && rindex[ti] >= 0 && !string.IsNullOrEmpty(t[ti]))
                                {
                                    t[ti] = Regex.Replace(t[ti], rx[rindex[ti]].fr, rx[rindex[ti]].to);
                                    chgs++;
                                }
                                else if (!string.IsNullOrEmpty(t[ti]))
                                {
                                    for (int j = 0; j < rx.Count; j++)
                                    {
                                        MatchCollection m = Regex.Matches(t[ti], rx[j].fr, RegexOptions.IgnoreCase);
                                        if ((m.Count > 0) && (m[0].Length == t[ti].Length))
                                        {
                                            rindex[ti] = j;
                                            t[ti] = Regex.Replace(t[ti], rx[rindex[ti]].fr, rx[rindex[ti]].to);
                                            chgs++;
                                            break;
                                        }
                                    }
                                }

                            }

                            if (chgs > 0)
                                w.WriteLine(string.Join("\t", t));
                            else
                                w.WriteLine(lin);
                        }
                        else
                            w.WriteLine(lin);

                        ++linum;
                        lin = r.ReadLine();
                    }
                    r.Close();
                    w.Flush();
                    w.Close();


                }
                else
                {
                    Console.WriteLine("norm --regexReplacementFile input-file output-file");
                }
            else
            {
                Console.WriteLine("?");
            }
        }
    }
}
