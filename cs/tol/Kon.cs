using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Configuration;

namespace tol
{
    public class AuthBitter
    {
        public int seq = 0;
        public int level = 0;

        public string[] allow = new string[] { };
        public string[] deny = new string[] { };

        public string[][] aCols = null;
        public readonly string DefColumnList = "id;key,name;qualifier,description";
        public void Init(string columnList)
        {
            aCols = new string[][] { };
            string[] a = columnList.Split(new string[] { "," }, StringSplitOptions.None);
            Array.Resize(ref aCols, a.Length);
            for (int i = 0; i < a.Length; i++)
            {
                aCols[i] = a[i].Split(new string[] { ";" }, StringSplitOptions.None);
            }
        }
        public int Coli(string fname)
        {
            int r = -1;
            for (int i = 0; (i < aCols.Length) && r < 0; i++)
            {
                for (int j = 0; (j < aCols[i].Length) && r < 0; j++)
                {
                    if ((aCols[i][j]).Equals(fname))
                        r = i;
                }
            }
            return r;
        }
        public AuthBitter()
        {
            Init(DefColumnList);
        }
        public AuthBit Trek(object o)
        {
            AuthBit a = new AuthBit();

            if (o == null)
                return null;
            StringBuilder bu = new StringBuilder("");
        

            a.Seq = ++seq;


            if (typeof(IList).IsAssignableFrom(o.GetType()))
            {

                List<AuthBit> b = new List<AuthBit>();
                string ltype = null;
                foreach (var ox in ((IList)o))
                {
                    level++;
                    AuthBit bx = Trek(ox);
                    level--;
                    ltype = ox.GetType().Name;
                    if (!string.IsNullOrEmpty(bx.Tag) || (bx.Bits != null && bx.Bits.Count > 0))
                    {
                        b.Add(bx);
                    }
                }
                if (b.Count > 0)
                {
                    a.Bits = b;
                    a.Tag = ltype;
                }

            }
            else
            {
                foreach (PropertyInfo pi in o.GetType().GetProperties())
                {
                    if (!pi.CanRead) continue;

                    MethodInfo m = pi.GetGetMethod();
                    if (m == null) continue;

                    string v = null;

                    if ((allow.Length > 0 && !allow.Contains(pi.Name))
                        || (deny.Length > 0 && deny.Contains(pi.Name)))
                        continue;
                    string vt = pi.PropertyType.FullName;

                    object x = null;
                    bool ok = true;

                    try
                    {
                        x = m.Invoke(o, null);
                    }
                    catch (Exception e)
                    {
                        v = "\"(" + e.GetType().FullName + ") " + e.Message + "\"";
                        ok = false;
                    }

                    if (x != null)
                    {
                        if (pi.PropertyType.Namespace.Equals("System"))
                            v = x.OVal();
                        else
                        {
                            if (typeof(IList).IsAssignableFrom(x.GetType()))
                            {
                                level++;
                                --seq;
                                AuthBit xx = Trek(x);
                                level--;
                                if (xx.Bits != null && xx.Bits.Count > 0)
                                {
                                    if (a.Bits == null)
                                        a.Bits = new List<AuthBit>();
                                    a.Bits.AddRange(xx.Bits);
                                }
                                else
                                {
                                    ++seq;
                                }
                            }
                            else
                            {
                                level++;
                                AuthBit bx = Trek(x);
                                level--;
                                if (!string.IsNullOrEmpty(bx.Tag) || (bx.Bits != null && bx.Bits.Count > 0))
                                {
                                    if (a.Bits == null)
                                        a.Bits = new List<AuthBit>();
                                    a.Bits.Add(bx);
                                }

                            }
                        }
                    }
                    if (v != null && ok)
                    {
                        string nm = pi.Name.ToLower();
                        int coli = Coli(nm);
                        switch (coli)
                        {
                            case 0:
                                a.Id = v;
                                break;
                            case 1:
                                a.Tag = v;
                                break;
                            case 2:
                                a.Text = v;
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            if (!(
                     (a.Bits != null && a.Bits.Count > 0)
                  || !string.IsNullOrEmpty(a.Id)
                  || !string.IsNullOrEmpty(a.Tag)
                  || !string.IsNullOrEmpty(a.Text)
                  )
               )
            {
                --seq;
            }
            return a;
        }
    }
}
