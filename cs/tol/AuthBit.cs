using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace tol
{
    public class AuthBit
    {
        public int Seq { get; set; } 
        public string Id { get; set; }
        public string Tag { get; set; }
        public string Text { get; set; }
        public List<AuthBit> Bits { get; set; } 
    }
}