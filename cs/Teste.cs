using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Globalization;

namespace Teste
{
    public class Teste 
    {
	    public static void Main(string[] args)
        {
			if (args.Length < 1) {
				Console.WriteLine("Teste <[@]file>"); 
				return; 
			}
            
            List<string> s = new List<string>();
            List<string> groups = new List<string>();

            
            int i = 0;
            do
            {
                if (args[i].StartsWith("@"))
                {
                    s.AddRange(
                        File.ReadAllText(args[i].Substring(1))
                            .Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                        );
                }
                else
                    s.Add(args[i]);

                i++;
            }
            while (i < args.Length);

            Regex rmiRx = new Regex(@"(((1011|2012)//)(?<details>((?<inv>[^\(\)\r\n]+)\((?<amt>(([0-9]{1,3}(((\.|,)[0-9]{3})?)+)|([0-9]+))((\.|,)[0-9]{1,2})?)\))+))");
            Regex invRx = new Regex(@"((?<invno>[^\(\)\r\n]+)\((?<amount>(([0-9]{1,3}(((\.|,)[0-9]{3})?)+)|([0-9]+))((\.|,)[0-9]{1,2})?)\))");

            decimal tot = 0;
            foreach (string x in s)
            {
                if (!rmiRx.IsMatch(x)) continue;
                tot = 0;
                foreach (Match m in rmiRx.Matches(x))
                {
                    if (!string.IsNullOrEmpty(m.Groups["details"].Value))
                    {
                        string iv = m.Groups["details"].Value;
                        Console.WriteLine($"details: {iv}");
                        int invSeq = 0;
                        foreach (Match inv in invRx.Matches(iv))
                        {
                            string invoiceNo = inv.Groups["invno"].Value;
                            string alokasi = inv.Groups["amount"].Value;
                            decimal dalokasi = alokasi.AsDecimal()??0;
                            Console.WriteLine(
                                    string.Format("___{0}|{1}|{2}"
                                      , ++invSeq
                                      , invoiceNo
                                      , dalokasi.ToString("0.##", new CultureInfo("de-DE"))
                                     ).Replace("|","\t") );
                            // Console.WriteLine("___{0,5:00000}|{1,-20}|{2,20}", ++invSeq, invoiceNo, alokasi);
                            decimal alo = alokasi.AsDecimal() ?? 0;
                            tot = tot + alo; 
                            //decimal alo = alokasi.AsDecimal() ?? 0;
                            //tot += alo;
                        }
                    }
                }
                Console.WriteLine(string.Format("_TOT||{0}\r\n", tot.ToString("0.##", new CultureInfo("de-DE"))).Replace("|", "\t"));
                
            }

            
		}
	}


    public static class StrHelper
    {
        public static decimal? AsDecimal(this string s)
        {
            int deciID = s.LastIndexOf(",");
            int deciEN = s.LastIndexOf(".");
            NumberStyles n = NumberStyles.None;
            string culture = "";
            if (deciID > 0 && deciEN > 0)
            {
                n = n | NumberStyles.AllowThousands;
            }
            if (deciID > deciEN)
            {
                culture = "id-ID";
                n = n | NumberStyles.AllowDecimalPoint;
            }
            else
            {
                culture = "en-US";
                n = n | NumberStyles.AllowDecimalPoint;
            }
            if (decimal.TryParse(s, n, new CultureInfo(culture), out decimal d))
                return d;
            else
                return null;
        }
    }
}	
