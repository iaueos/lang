using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Reflection;
using System.Diagnostics;

namespace konsol.Common
{
    public static class AppSetting
    {
        public static object ReadObject(string name, string pType)
        {
            object o = null;
            
            if ("String".Equals(pType))
            {
                o = Read(name, null);
            }
            else if (pType.StartsWith("Int"))
            {
                o = ReadInt(name);
            }
            else if (pType.StartsWith("Bool"))
            {
                string bv = Read(name);

                bool r = false;
                if ("True".Equals(bv))
                    r = true;
                else if ("False".Equals(bv))
                    r = false;
                else
                {
                    int ibv = 0;
                    int.TryParse(bv, out ibv);
                    r = (ibv != 0);
                }
                o = r;
            }

            return o;
        }

        static AppSetting()
        {
            /// fetch public property values using Reflection 
            foreach (PropertyInfo p in typeof(AppSetting).GetProperties())
            {
                string pt = p.PropertyType.Name;
                string pn = p.Name;               

                object o = ReadObject(pn, pt);

                if (o!=null && !string.IsNullOrEmpty(pn))
                    p.SetValue(null, o, null);
                else
                {
                    if (p.GetCustomAttributes(true).Length > 0)
                    {
                        object[] defaultValueAttribute =
                            p.GetCustomAttributes(typeof(DefaultSettingValueAttribute), true);
                        if (defaultValueAttribute != null && defaultValueAttribute.Length > 0)
                        {
                            DefaultSettingValueAttribute dva =
                                defaultValueAttribute[0] as DefaultSettingValueAttribute;
                            if (dva != null)
                            {
                                p.SetValue(null, dva.Value, null);
                                o = dva.Value;
                            }
                        }
                    }
                }
                //Debug.WriteLine("public static {0} {1}={2}", pt, pn, o);
            }
            /// fetch fields values using Reflection 
            foreach (FieldInfo fi in 
                    typeof(AppSetting).GetFields(
                        BindingFlags.NonPublic 
                      | BindingFlags.Static)) 
            {
                string pt = fi.FieldType.Name;
                string fin = fi.Name;
                if (!fin.StartsWith("<"))
                {
                    object o = ReadObject(fin, pt);
                    fi.SetValue(null, o);

                    /// Debug.WriteLine("private static {0} {1}={2}", pt, fin, fi.GetValue(null)); 
                }
            }
       }
        [DefaultSettingValue("userID")]
        public static string UID { get; set; }

        [DefaultSettingValue("Kumpeni")]
        public static string Domain { get; set; }

        [DefaultSettingValue("konsol")]
        public static string ApplicationID { get; set; }

        [DefaultSettingValue("DB")]
        public static string DB { get; set; }

        [DefaultSettingValue("0")]
        public static int DEBUG
        {
            get;
            set;
        }

        public static int ReadInt(string setting, int value = 0)
        {
            string b = ConfigurationManager.AppSettings[setting];
            if (string.IsNullOrEmpty(b))
                return value;
            else
            {
                int x = value;
                if (Int32.TryParse(b, out x))
                    return x;
                else
                    return value;
            }
        }

        public static string Read(string setting, string value = "")
        {
            string b = ConfigurationManager.AppSettings[setting];
            if (string.IsNullOrEmpty(b))
                return value;
            else
            {
                return b;
            }
        }
    }
}