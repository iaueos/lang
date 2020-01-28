using System;
using System.Globalization;

public class ThisNextTest{ 

		
		public static void Main(string[] args) {
					public static string ThisMonth = DateTime.ParseExact(
                DateTime.Now.ToString("MMMM yyyy"), 
                "MMMM yyyy", 
                new System.Globalization.CultureInfo("en-US"))
                .ToString("MMMM yyyy");
		public static string NextMonth = DateTime.ParseExact(
                DateTime.Now.ToString("MMMM yyyy"), 
                "MMMM yyyy", 
                new System.Globalization.CultureInfo("en-US"))
                .AddMonths(1)
                .ToString("MMMM yyyy");
		
			Console.WriteLine("ThisMonth : {0}, NextMonth : {1} ", ThisMonth, NextMonth);			
		}
}