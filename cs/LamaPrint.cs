using System;
using System.Text;

public class LamaPrint {

	public static void Main(string[]args) {
		Console.WriteLine(string.Format("{0,20}|{1,5}|{2,-20}|{3, -10}|", "20", "5","-20", "-10"));
		Console.WriteLine(string.Format("{0,20}|{1,5}|{0,-20}|{1, -10}|", "12345678901234567890", 12345,"12345678901234567890", "1234567890"));

		Console.WriteLine(string.Format("{0,20}|{1,5}|{0,-20}|{1, -10}|", "satusatu", 123));
	}
}