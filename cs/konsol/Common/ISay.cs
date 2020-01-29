using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace konsol.Common
{
    public interface ISay: IDisposable
    {
        int Say(string loc, string w, params object[] x);
    }
    public interface IPrint : IDisposable
    {
        int say(string w, params object[] x);
    }
    public delegate int Log(string w, params object[] x);
}
