using System;
using System.IO;
using System.Text.RegularExpressions;

public class Glodate {
public static void Main(string[] args)
{
	string input = null;
	if (args.Length == 0)
	{
		string r;
		while ((r = Console.ReadLine()) != null)
		{
			Console.WriteLine(MDYToDMY(r));
		}
		return;
	}
	string text = null;
	if (args.Length != 0)
	{
		input = File.ReadAllText(args[0]);
	}
	if (args.Length > 1)
	{
		text = args[1];
	}
	string text2 = MDYToDMY(input);
	if (string.IsNullOrEmpty(text))
	{
		Console.WriteLine(text2);
	}
	else
	{
		File.WriteAllText(text, text2);
	}
}



private static string MDYToDMY(string input)
{
    
    string[] arepl = new string[] {
            @"\b(?<month>\d{2})/(?<day>\d{2})/(?<year>\d{4})\b", "${year}-${month}-${day}", 
            @"\b(?<month>\d{1})/(?<day>\d{1})/(?<year>\d{4})\b", "${year}-0${month}-0${day}",
            @"\b(?<month>\d{2})/(?<day>\d{1})/(?<year>\d{4})\b", "${year}-${month}-0${day}",
            @"\b(?<month>\d{1})/(?<day>\d{2})/(?<year>\d{4})\b", "${year}-0${month}-${day}",
            @"\b(?<hour>\d{1})\:", "0${hour}:", 
            @"\b(?<minute>\d{2})\:(?<second>\d{2})( (A|P)M)\b", "${minute}:${second}" 
    }; 
    
	try
    {
        string r= input; 
        for (int i = 0; i < (arepl.Length / 2); i++) {
             r = Regex.Replace(r, arepl[i*2], arepl[(i*2)+1], 
                RegexOptions.None, TimeSpan.FromMilliseconds(100.0));
        }
        return r;
	}
	catch (Exception e)
	{
        Console.WriteLine(e.Message + "\r\n" + e.StackTrace);
		return null;
	}
}

}

