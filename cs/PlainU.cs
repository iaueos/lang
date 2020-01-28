using System;

namespace PlainU {
	public class PlainUx {
		public static void Main(string[] args) {
			for (int i = 0; i < args.Length; i++) {
				Console.WriteLine(PlainUserName(args[i]));
			}
		}
		
		public static string PlainUserName(string s)
        {
            if (string.IsNullOrEmpty(s)) return s;
            int i = s.LastIndexOf("\\");
            return (i>0)? s.Substring(i+1): s;
        }
	}
}