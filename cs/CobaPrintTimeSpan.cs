using System;
using System.Text;

namespace  CobaPrintTimeSpan {
	public class Program {
		public static void Main (string [] args) {
			Console.WriteLine(TimeSpan.FromSeconds((double) 500).ToString("hh\\:mm\\:ss"));
		}
	}
}