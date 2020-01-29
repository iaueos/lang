using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;

namespace tol
{
    public static class Formator
    {
        public static string PropValues(this object o, string allowedFields = null, string separator = ", ")
        {
            int allowed = 0;
            List<string> allow = ListFrom(allowedFields);
            allowed = allow.Count;

            string r = string.Join(separator,
                o.GetType()
                .GetProperties()
                .Where(pi => pi.CanRead && pi.GetGetMethod() != null
                     && (allowed < 1 || allow.IndexOf(pi.Name) >= 0))
                .Select(prop => prop.GetGetMethod().Invoke(o, null).OVal()))
                ;
            return r;
        }

        public static string ValOf(this object o, string fields, string separator = ",")
        {
            List<string> f = ListFrom(fields);
            if (f == null || f.Count < 1)
                return null;

            PropertyInfo[] p = o.GetType().GetProperties();
            List<int> pix = new List<int>();

            foreach (string fi in f)
            {
                int x = -1;
                for (int i = 0; i < p.Length; i++)
                {
                    PropertyInfo pi = p[i];
                    if (pi.CanRead && pi.GetGetMethod() != null && pi.Name.Equals(fi))
                    {
                        x = i;
                    }
                }
                pix.Add(x);
            }

            int[] ix = pix.ToArray();

            List<string> ox = new List<string>();
            for (int i = 0; i < ix.Length; i++)
            {
                if (ix[i] >= 0)
                {
                    ox.Add(p[ix[i]].GetGetMethod().Invoke(o, null).OVal());
                }
                else
                {
                    ox.Add("");
                }
            }
            return string.Join(separator, ox);
        }

        public static string PropNames(this object o, string allowedFields = null, string separator = ", ")
        {
            int allowed = 0;
            List<string> allow = ListFrom(allowedFields);
            allowed = allow.Count;

            string r = string.Join(separator,
                o.GetType()
                .GetProperties()
                .Where(pi => pi.CanRead && pi.GetGetMethod() != null
                     && (allowed < 1 || allow.IndexOf(pi.Name) >= 0))
                .Select(prop => prop.Name))
                ;
            return r;
        }

        public static string TextProp(object o, string allowedFields = null, string separator = ",\r\n", int Level = 0)
        {
            int allowed = 0;
            List<string> allow = ListFrom(allowedFields);
            allowed = allow.Count;
            StringBuilder bu = new StringBuilder("");
            int ix = 0;
            string tab = (Level > 0) ? new string('\t', Level) : "";
            string tabx = new string('\t', (Level + 1));

            if (typeof(IList).IsAssignableFrom(o.GetType()))
            {
                List<string> so = new List<string>();
                foreach (var ox in ((IList)o))
                {
                    so.Add(TextProp(ox, allowedFields, separator, Level + 1));
                }

                if (so.Count > 0)
                {
                    bu.Append("\r\n" + tab + "[\r\n" + tabx + string.Join(separator + tabx, so) + "\r\n" + tab + "]");
                }
            }
            else
            {
                foreach (PropertyInfo pi in o.GetType().GetProperties())
                {
                    if (!pi.CanRead) continue;
                    MethodInfo m = pi.GetGetMethod();
                    
                    if (m == null) continue;
                    if (m.IsPrivate) continue;
                    if (allowed > 0 && allow.IndexOf(pi.Name) < 0) continue;
                    if (pi.Name.StartsWith("_")) continue;

                    string v = null;


                    string vt = pi.PropertyType.FullName;

                    object x = null;

                    try
                    {
                        x = m.Invoke(o, null);
                    }
                    catch (Exception e)
                    {
                        v = "\"(" + e.GetType().FullName + ") " + e.Message + "\"";
                    }
                    
                    if (x != null)
                    {
                        if (pi.PropertyType.Namespace.Equals("System"))
                            v = "\"" + x.OVal() + "\"";
                        else
                        {
                            if (typeof(IList).IsAssignableFrom(x.GetType()))
                            {
                                v = TextProp(x, allowedFields, separator, Level +1);
                                if (string.IsNullOrEmpty(v))
                                {
                                    v = null;
                                }                              
                            }
                            else
                            {
                                string pv = TextProp(x, allowedFields, separator, Level + 1);
                                if (string.IsNullOrEmpty(pv))
                                    v = pv;
                                else
                                    v = null;
                            }
                        }
                    }
                    if (v != null)
                    {
                        if (ix++ > 0)
                        {
                            bu.Append(separator);
                        }
                        bu.Append(tabx);
                        bu.AppendFormat("\"{0}\":{1}", pi.Name, v);
                    }
                }
                if (ix > 0)
                {
                    bu.Insert(0, "{\r\n");
                    bu.Append("\r\n");
                    bu.Append(tab);
                    bu.Append("}");
                }
            }
            return bu.ToString();
        }

        public static string OVal(this object o)
        {
            if (o == null) return "";

            Type t = o.GetType();
            Debug.WriteLine(t.Name);

            if (t.Name.Equals("DateTime"))
                return ((DateTime)o).ToString("yyyy-MM-dd HH:mm:ss");
            else
                return Convert.ToString(o);
        }

        public static List<string> PropOf<T>(this T o)
        {
            List<string> r = new List<string>();
            r.AddRange(
                o.GetType()
                .GetProperties()
                .Where(pi => pi.CanRead && pi.GetGetMethod() != null)
                .Select(pi => pi.Name)
            );
            return r;
        }

        public static List<string> Props<T>(IEnumerable<T> l)
        {
            return PropOf(l.FirstOrDefault());
        }

        public static string PropList<T>(List<T> l, string allowedFields = null, string separator = ", ")
        {
            List<string> r = new List<string>();

            List<string> allow = ListFrom(allowedFields);
            int allowed = 0;
            allowed = allow.Count;

            if (!string.IsNullOrEmpty(allowedFields))
            {
                allow = allowedFields.Split(',').ToList();
                allowed = allow.Count;
            }
            foreach (T o in l)
            {
                r.Add(
                    string.Join(separator,
                        o.GetType()
                        .GetProperties()
                        .Where(pi => pi.CanRead && pi.GetGetMethod() != null
                            && (allowed < 1 || allow.IndexOf(pi.Name) >= 0))
                .Select(pi => pi.Name + ": " + pi.GetGetMethod().Invoke(o, null).OVal()))
                );
            }
            return string.Join("\r\n", r);
        }

        public static List<string> ListFrom(string list)
        {
            List<string> allow = new List<string>();
            if (!string.IsNullOrEmpty(list))
                allow = list.Split(',').ToList();
            return allow;
        }

        public static object[][] ArrayOf<T>(IEnumerable<T> l, string allowedFields = null)
        {
            List<string> allow = ListFrom(allowedFields);
            int allowed = 0;
            allowed = allow.Count;
            List<List<object>> a = new List<List<object>>();
            var f = l.FirstOrDefault();

            List<int> allowi = new List<int>();
            PropertyInfo[] propinfo = null;
            if (f != null)
            {
                propinfo = f.GetType().GetProperties();
                if (allowed == 0)
                {
                    for (int j = 0; j < propinfo.Length; j++)
                    {
                        if (propinfo[j].CanRead && propinfo[j].GetGetMethod() != null)
                            allowi.Add(j);
                    }
                }
                else
                    for (int i = 0; i < allow.Count; i++)
                    {
                        int ix = -1;
                        for (int j = 0; j < propinfo.Length; j++)
                        {
                            if (propinfo[j].CanRead && propinfo[j].GetGetMethod() != null)
                                if (string.Compare(propinfo[j].Name, allow[i]) == 0)
                                {
                                    ix = j;
                                    break;
                                }

                        }
                        allowi.Add(ix);
                    }
            }
            foreach (T e in l)
            {

                List<object> ol = new List<object>();
                for (int i = 0; i < allowi.Count; i++)
                {
                    if (allowi[i] >= 0)
                    {
                        ol.Add(propinfo[allowi[i]].GetValue(e, null));
                    }
                    else
                        ol.Add(null);

                }
                a.Add(ol);
            }
            return a.Select(x => x.ToArray()).ToArray();
        }
    }
}