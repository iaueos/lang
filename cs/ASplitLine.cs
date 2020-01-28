using System;

public class ASplitLine {

	public static void Main(string[] args) {
		if (args.Length <1) return;
		Console.WriteLine(SplitLines(args[0]));
	}
	
	public static string SplitLines(string v, string separator = ",", int maxCol = 10)
        {
            if (string.IsNullOrEmpty(v)) return v;
            string x = "";
            int i = 0, j = v.Length, k = 0, l = 0;
            do
            {
                i = k;
                k = v.IndexOf(separator, i)+1;
                if (k > i)
                {
                    l++;
                    x = x + v.Substring(i, k - i);
										
                    if ((l % maxCol) == 0)
                    {
                        x = x + Environment.NewLine;
                    }
                } 
            }
            while (i < j && k > i);
			if  (i > 0)
				x = x + v.Substring(i, v.Length -i);
            return x;
        }
}
