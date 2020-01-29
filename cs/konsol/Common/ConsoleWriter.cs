using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace konsol.Common
{
    public class ConsoleWriter : IPut, ISay, IPrint
    {
        private string lastWhere = null;

        public int Put(string what,
            string user = "",
            string site = "",
            int ID = 0, // ignored 
            string function = "", // ignored 
            string remarks = null, // ignored 
            int tag = 0, // ignored 
            string messageId = "", // ignored 
            string status = null // ignored 
            )
        {
            lastWhere = site;
            return Say(site, what, null);
        }

        public int say(string w, params object[] x)
        {
            return Say(lastWhere, w, x);
        }

        public int Say(string loc, string w, params object[] x)
        {
            lastWhere = loc;
            if (x != null && x.Length > 0)
                Console.WriteLine(w, x);
            else
                Console.WriteLine(w);
            return 0;
        }

        public void Dispose()
        {

        }
    }
}
