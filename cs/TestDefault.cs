using System;
using System.Text;

public class TestDefault 
{

		public static void Main(string[] args) {
			Console.WriteLine(Default("Put")); 
			Console.WriteLine(Default("LoginValidator")); 
			Console.WriteLine(Default("xxx")); 
		}
		public static readonly string Defaults = "=|Put=Trachi.Web.Util.Logger|LoginValidator=Trachi.Web.MockBaseValidator|";
	//Console.WriteLine("i = {0} j = {1} k = {2}", i, j, k);

        public static string Default(string name)
        {
            string v= null;
            string k = "|" + name + "=";
            int i = Defaults.IndexOf(k);
			int l = i+k.Length;
            int j = (i>0)? Defaults.IndexOf('|', l) : 0;
            if (i < j && j > 0 && (j - l) > 0)
            {
                v = Defaults.Substring(l, j - (l));
            }
            return v;
        }
}