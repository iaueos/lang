using System;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Globalization; 
public class tesEvalCurr {
	public static void Main(string[] args) 
	{
			Console.WriteLine(Eval_Curr("IDR", 1234.456, 1));
			Console.WriteLine(Eval_Curr("IDR", -567.890, 1));
			Console.WriteLine(Eval_Curr("USD", -567.890, 1));
			Console.WriteLine(Eval_Curr("USD", 123.456, 1));
	}
	
		public static string Eval_Curr(Object currencyCd, Object decimalValue, int displayCurrency=0)
        {
		string[] RoundCurrency = new string[] {"IDR", "JPY"};
            decimal decimalResult = 0;
            string preCurr = (displayCurrency == 1) ? currencyCd.str() + " " : "";
            string postCurr = (displayCurrency == 2) ? " " + currencyCd.str() : "";
            bool parseOk = Decimal.TryParse(decimalValue.str(), out decimalResult);
			
            if (currencyCd != null 
                && !String.IsNullOrWhiteSpace(currencyCd.ToString()) 
                && decimalValue != null && parseOk)
            {
                if ( RoundCurrency.Contains(currencyCd))
                // if (currencyCd.Equals("IDR") || currencyCd.Equals("JPY"))
                {
                    return  preCurr  + decimalResult.ToString("###,###,###,###,###,##0") + postCurr;
                }
                else
                {
                    return preCurr + decimalResult.ToString("###,###,###,###,###,##0.00") + postCurr;
                }
            }

            if (decimalValue != null && parseOk)
            {
                return preCurr + decimalResult.ToString() + postCurr;
            }
            
            
            return null;
        }
}		

    public static class StrTo
    {
        public const string INQ_DATE = "dd/MM/yyyy";
        public const string XLS_DATE = "dd-MM-yyyy";
        public const string TO_MINUTE = "dd MMM yyyy HH:mm";
        public const string TO_DATUM = "dd MMM yyyy";
        public const string SAP_DATUM = "dd.MM.yyyy";
        public const string dateTimeNoTime = "dd MMM yyyy";
        public const string dateTimeWithTime = "dd MMM yyyy HH:mm";

        public static string str(this object o)
        {
            return (o!=null) ? Convert.ToString(o) : null;
        }
        public static string str(this int o)
        {
            return o.ToString();
        }
        public static string DATUM(this DateTime datum)
        {
            return fmt(datum, TO_DATUM);
        }
        public static string MINUTE(this DateTime datum)
        {
            return fmt(datum, TO_MINUTE);
        }

        public static string DATUM(this DateTime? datum)
        {
            return fmt(datum, TO_DATUM);
        }
        public static string MINUTE(this DateTime? datum)
        {
            return fmt(datum, TO_MINUTE);
        }
        public static string fmt(this DateTime datum, string dateformat)
        {
            return datum.ToString(dateformat);
        }
        public static string fmt(this DateTime? datum, string dateformat = XLS_DATE)
        {
            return (datum != null) ? 
                ((DateTime)datum).ToString(dateformat) 
                : "";
        }
        public static string SAPnum(this decimal num, bool fractions=false)
        {
            return num.ToString(fractions? "#.##": "#");
        }
        
        public static string SAPnum(this Decimal? num, bool fractions=false)
        {
            return (num != null) ? SAPnum((decimal)num, fractions) : "";            
        }
        public static string SAPdate(this DateTime? datum)
        {
            return fmt(datum, SAP_DATUM);
        }
        public static string SAPdate(this DateTime datum)
        {
            return fmt(datum, SAP_DATUM);
        }
        public static string fmt(this decimal? n, int dec = 0)
        {
            return string.Format("{0:N" + dec.ToString() + "}", n ?? 0);
        }
        public static string fmt(this decimal n, int dec = 0)
        {
            return string.Format("{0:N" + dec.ToString() + "}", n);            
        }
        public static string date(this DateTime d)
        {
            return d.ToString(dateTimeNoTime);
        }
        public static string date(this DateTime? d)
        {
            return (d!=null) ? ((DateTime) d).ToString(dateTimeNoTime) :"";
        }

        public static string minute(this DateTime d)
        {
            return d.ToString(dateTimeWithTime);
        }
        public static string minute(this DateTime? d)
        {
            return (d != null) ? ((DateTime)d).ToString(dateTimeWithTime) : "";
        }
        
        public static bool isEmpty(this string s)
        {
            return string.IsNullOrEmpty(s);
        }

        public static int Int(this object o, int v=0)
        {
            return Int(Convert.ToString(o), v);
        }

        public static int Int(this string s, int v = 0)
        {
            int R = 0;
            if (!Int32.TryParse(s, out R)) R = v;
            return R;
        }
        public static long Long(this string s, long v = 0)
        {
            long R = 0;
            if (!Int64.TryParse(s, out R)) R = v;
            return R;
        }
        public static long Long(this object o, long v = 0)
        {
            return Long(Convert.ToString(o), v);
        }
        public static double Num(this object o, double v = 0.0d)
        {
            double d = 0;
            if (!Double.TryParse(Convert.ToString(o), out d)) d = v;
            return d;
        }

        public static decimal Dec(this string s, decimal v=0)
        {
            decimal R = 0;
            if (!Decimal.TryParse(s, out R)) R = v;
            return R;
        }

        public static bool DateOk(this string s, string fmt, ref DateTime d)
        {
            bool r = DateTime.TryParseExact(s, fmt, CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out d);
            return r;
        }

        public static DateTime Date(this string s, string fmt, DateTime? v=null)
        {
            DateTime r = new DateTime();
            if (!DateTime.TryParseExact(s, fmt, CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out r))
                r = v ?? new DateTime(1, 1, 1);
            return r;
        }

        public static DateTime Date(this string a, DateTime? def = null)
        {
            return Date(a, INQ_DATE, def);
        }

        public static DateTime Date(this string a)
        {
            return Date(a, XLS_DATE, new DateTime(1, 1, 1, 0, 0, 0));            
        }

        public static DateTime DateFrom(this string a, DateTime? def = null)
        {
            DateTime r = Date(a, def);
            DateTime ret = new DateTime(r.Year, r.Month, r.Day, 0, 0, 0);
            return ret;
        }

        public static DateTime DateTo(this string a, DateTime? def = null)
        {
            DateTime r = Date(a, def);

            DateTime ret = new DateTime(r.Year, r.Month, r.Day, 23, 59, 59);
            return ret;
        }

        public static string mul(this string s, int n)
        {
            StringBuilder b = new StringBuilder("");
            for (int i = 0; i < n; i++)
            {
                b.Append(s);
            }
            return b.ToString();
        }
    }
