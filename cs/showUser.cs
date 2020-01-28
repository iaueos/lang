using System;

class Program 
{
	static void Main(string[] args) {
		Console.WriteLine(System.Security.Principal.WindowsIdentity.GetCurrent().Name);
		Console.WriteLine(Environment.UserName);
	}
} 