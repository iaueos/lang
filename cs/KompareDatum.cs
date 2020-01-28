using System;
using System.Globalization;


public static class KompareDatum {
        /// <summary>
        ///  for comparing two dates 
        ///  
        /// </summary>
        /// <param name="args">[first date] [second date] </param>
        /// returns first date CompareTo second date 
		public static void Main(string[] args) {
            DateTime d1 = args.Length > 0 ? args[0].Date("yyyymmdd") : DateTime.Now;
            DateTime d2 = args.Length > 1 ? args[1].Date("yyyymmdd") : DateTime.Now;

            Console.WriteLine("{0:yyyy.MM.dd} {1:yyyy.MM.dd} {2}", d1, d2, d1.CompareTo(d2));
		}
		
		public static DateTime Date(this string s, string fmt, DateTime? v=null)
        {
            DateTime r = new DateTime();
            if (!DateTime.TryParseExact(s, fmt, CultureInfo.InvariantCulture, 
                DateTimeStyles.AssumeLocal, out r))
                r = v ?? new DateTime(1969, 1, 1);
            return r;
        }

}