using System;
using System.Globalization;

public class DatumDiff 
{
	public static void Main(string [] args)
	{
		if (args.Length > 1) 
		{
			DateTime a = DateTime.Now;
			DateTime b = DateTime.Now;
				
			if (
				DateTime.TryParseExact(args[0], "yyyy-MM-dd", 
											CultureInfo.InvariantCulture, 
											DateTimeStyles.AssumeLocal,  out a)
				&&
				DateTime.TryParseExact(args[1], "yyyy-MM-dd", 
											CultureInfo.InvariantCulture, 
											DateTimeStyles.AssumeLocal,  out b))
				{
					Console.WriteLine("a={0:yyyy.MM.dd} b={1:yyyy.MM.dd} a-b={2,4}", a, b, ((TimeSpan) (a-b)).TotalDays);
				}
		}
	}
	
}