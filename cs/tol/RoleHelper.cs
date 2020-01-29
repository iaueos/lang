using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace tol
{
    public static class RoleHelper
    {
        public static IList<string> Get(string username)
        {
            string dbcon = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
            //  get Role from databse by username 
            return null;            
        }
    }
}
