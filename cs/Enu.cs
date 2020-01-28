using System;
using System.Collections;
using System.Text; 
/// testing enumerations

public class Enu { 
	public static void Main(string[] args) {
		Console.WriteLine("siji : " + Texum.Einsa);
		Console.WriteLine(string.Format("loro : {0}" , Texum.Zweia));
		Console.WriteLine("telu : " + Texum.Dreya);
	}
}

public enum Texum {
	Einsa, Zweia, Dreya
}