using System;

public class TestWbsSubst {
	public static void Main(string[] args) {
		string buNo  = "";
        
        if (args.Length > 0)
            buNo = args[0];
        else
        {
            Console.WriteLine("test wbs-no");
            return;
        }
        Console.WriteLine(buNo);
		
		int fiscalYear  = 2014;

        if (!buNo.isEmpty() && buNo.IndexOf("E-") == 0)
        {
            string buNoYY = buNo.Substring(2, 2);
            Console.WriteLine("buNoYY = {0}", buNoYY);
            string buFiscal = fiscalYear.str();
            buFiscal = buFiscal.Substring(buFiscal.Length - 2, 2);
            Console.WriteLine("buFiscal = {0}", buFiscal);
            if (string.Compare(buNoYY, buFiscal, true) != 0)
            {
                buNo = buNo.Substring(0, 2) + buFiscal + buNo.Substring(4, buNo.Length - 4);
                Console.WriteLine(buNo);
            }
            else
            {
            }
            
        }
        else
        {
            Console.WriteLine("Budget Number not Started with E-");
        }
		
	}
}

public static class StrTool {
	public static bool isEmpty(this string x) {
		return string.IsNullOrEmpty(x);
	}
	
	public static string str(this int x) {
		return x.ToString();
	}
}