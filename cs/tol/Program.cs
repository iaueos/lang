using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;

namespace tol
{
    class Program
    {
        static void Main(string[] args)
        {
            Equate tol = new Equate();
            
            int act = 0;
            if (args.Length < 1)
            {
                Hilfe();
                return;
            }
            foreach (string arg in args)
            {
                if (arg.Equals("/auth", StringComparison.InvariantCultureIgnoreCase))
                {
                    act = 1;
                    continue;
                }
                else if (arg.Equals("/js", StringComparison.InvariantCultureIgnoreCase))
                {
                    act = 2;
                    continue;
                }
                else if (arg.Equals("/jsauth", StringComparison.InvariantCultureIgnoreCase))
                {
                    act = 3;
                    continue;
                }
                string r = null;
                switch(act) {
                    case 1: 
                        r = Formator.TextProp(tol.Walk(RoleHelper.Get(arg)));
                        break;
                    case 2: 
                        JavaScriptSerializer ja = new JavaScriptSerializer();
                        r = ja.Serialize(RoleHelper.Get(arg));
                        break;
                    case 3: 
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        r = js.Serialize(tol.Walk(RoleHelper.Get(arg)));
                        break;
                    default:
                        r = Formator.TextProp(RoleHelper.Get(arg)); 
                        break;
                }
                Console.WriteLine(r);
            }
        }

        static void Hilfe()
        {
            Console.WriteLine("tol /<Option:auth|js|jsauth> username");
        }
    }
}
