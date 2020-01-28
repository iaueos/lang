using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Collections;

public class Rx
{
	public static void say(string format, params object [] o)
    {
        Console.Write(format, o);
    }

    public static int Main(string[] args)
    {
        string fRegex = "";
        string fFilex = "";
        string ex = "";
        string[] l = new string[] {} ;
        Regex x=null;

        if (args.Length <= 0)
        {
            Help();
            return 1;
        }

        List<string> s = new List<string>();
        int i = 0;
		
		try 
		{ 
			while (i < args.Length)
			{
				if ("@".Equals(args[i]))
				{
					if (string.IsNullOrEmpty(fRegex) && args.Length > i)
					{
						fRegex = args[i + 1];
						ex = File.ReadAllText(fRegex);
						x = new Regex(ex);
						i += 2;
						continue;
					}
					if (string.IsNullOrEmpty(fFilex) && args.Length > i)
					{
						fFilex = args[i + 1];

						string lines = File.ReadAllText(fFilex);
						if (! ".".Equals( args[args.Length-1])) 
							l = lines.Split(new string[] { "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries);
						else 
							s.Add(lines);
							
						for (int j = 0; j < l.Length; j++)
						{
							s.Add(l[j]);
						}

						i += 2;
						continue;
					}

				}
				else if (string.IsNullOrEmpty(ex))
				{
					x = new Regex(ex);
				}
				s.Add(args[i]);
				i++;
			}
		}
		catch (Exception xx) 
        {
			say(xx.Message+"\r\n"+xx.StackTrace);			
		}
        if (x == null)
        {
            Help();
            return 1;
        }
        say(ex + "\r\n");
        if (s.Count < 1)
        {
            string line;
            while ((line = Console.ReadLine()) != null)
            {
                s.Add(line);
            }
        }
        foreach (string z in s)
        {           
            say(z + "\t" + x.MatchesList(z) + "\r\n");
        }
        return 0;
    }

    private static void Help()
    {
        Console.WriteLine("RX - Regular eXpression test\r\n\r\n"
            + "Usage:\r\n"
            + "\trx expression string string ... string\r\n"
            + "\trx @ expression-file string string ... string\r\n"
            + "\trx @ expression-file @ string-list-file\r\n"
            + "\trx expression\r\n"
            + "\trx @ expression-file\r\n"
            );
    }
}

public static class RxHelper
{
    public static string MatchesList(this Regex r, string t=null)
    {
        MatchCollection x = r.Matches(t);
        StringBuilder s = new StringBuilder("");

        if (x.Count > 0)
        {
            for (int i = 0; i < x.Count; i++)
            {
                Match m = x[i];
                string g0 = string.Format("{0} {1}", i, m.Value);
				s.Append("{");
                s.Append(g0);                
                if (m.Groups.Count > 0)
                {
                    s.Append("\t");
                    
                    int k = 0;
                    for (int j = 0; j < m.Groups.Count; j++)
                    {
                        if (k > 0)
                        {
                            s.Append("\t");                            
                        }
                        string g1 = string.Format("[{0}] {1}", j, m.Groups[j].Value);

                        if (string.Compare(g0, g1) != 0)
                        {
                            s.Append(g1);
                            ++k;
                        }
                    }
                }
				s.Append("}");
            }
        }
        return s.ToString();
    }
}
