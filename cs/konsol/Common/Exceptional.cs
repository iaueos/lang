using System;
using System.Text;

namespace konsol.Common
{
    public static class Exceptional
    {
        public static string Trace(this Exception x)
        {
            if (x == null) return null;
            StringBuilder b = new StringBuilder("");
            Exception e = x;
            string addi = "";
            while (e != null)
            {
                b.AppendLine(addi + e.Message);
                b.AppendLine(addi + e.StackTrace);
                e = e.InnerException;
                addi = addi + "\t";
            }
            return b.ToString();
        }
    }
}
