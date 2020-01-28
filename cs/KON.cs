using System;
using System.Text;
using System.Text.RegularExpressions;

class Kon
{
    public static void Main(string [] args)
    {
//    Console.WriteLine();
//  <-- Keep this information secure! -->
//    Console.WriteLine("UserName: {0}", Environment.UserName);
        string act = "s";
        for (int i = 0; i < args.Length; i++) {
            if (args[i].StartsWith("/")) {
                act = args[i].Substring(1, args[i].Length-1);
                Console.WriteLine("act: {0}", act);
                continue;
            }
            if (string.IsNullOrEmpty(act))  {
                Console.Write(" ");
                Console.Write(args[i].SimpleDate());
            } else if (act.StartsWith("s")) {
                Console.WriteLine(args[i].SanitizeFilename());
            }

        }
    }
}

public static class StrHelper {
    public static string SanitizeFilename(this string insane)
    {
        Regex regEx = new Regex("[^A-z0-9\\-_\\.]+");
        Regex rX = new Regex("[`\\s\\^\\]\\[]+");
        return Regex.Replace(regEx.Replace(rX.Replace(insane,"_"), "_"), @"[\s|_]+", "_");
    }

    public static string SimpleDate(this string d)
    {
        string r = d;
        if (d.Length >= 6)
        {
            char[] delimiters = new char[] { '-', '.' };
            string[] l = r.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);

            if (l.Length == 3)
            {
                if (l[0].Length > 2)
                {
                    r = l[0].PadLeft(4, '0') + l[1].PadLeft(2, '0') + l[2].PadLeft(2, '0');
                } else if (l[2].Length > 2)
                {
                    r = l[2].PadLeft(4, '0') + l[1].PadLeft(2, '0') + l[0].PadLeft(2, '0');
                }
                else {
                    r = l[0].PadLeft(4,'0') + l[1].PadLeft(2,'0') + l[2].PadLeft(2, '0');
                }
            }

        }

        return r ;
    }

}