using System;
using System.Collections.Generic;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Text;

namespace kon
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> a = new List<string>();
            if (args != null && args.Length > 0))
            {
                foreach(string s in args)
                {
                    a.Add(s);
                }
                string domain = (a.Count > 2) ? a[2] : "";
                string container = (a.Count > 3 ) ? a[3] : "";
                string username = (a.Count > 0) ? a[0] : null;
                string password = (a.Count > 1) ? a[1] : null;
                try
                {
                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                        throw new Exception("username password domain container");
                    using (PrincipalContext context = new PrincipalContext(ContextType.Domain, domain, container))
                    {
                        if (context.ValidateCredentials(username, password))
                        {
                            Console.WriteLine("OK");
                        }
                        else
                        {
                            Console.WriteLine("NG");

                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("ERR\r\n"+e.Message+"\r\n"+e.StackTrace);
                }
            }
            else
            {
                Console.WriteLine("kon domain container username password\r\n"
                 + "check ldap user\r\n"
                );
            }
        }
    }
}
