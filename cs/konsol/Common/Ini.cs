using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace konsol.Common
{
    public class Ini
    {
        private Dictionary<string, string> kv = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);
        public Dictionary<string, string> Section = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);

        public List<string> Keys
        {
            get
            {
                return kv.Keys.ToList<string>();
            }
        }

        public List<string> Sections
        {
            get
            {
                return Section.Keys.Select(a=>a.ToUpper()).ToList<string>();
            }
        }


        
        private void AddSection(string key, StringBuilder val)
        {
            string k = string.IsNullOrEmpty(key) ? "#" : key;
            Section.Add(k, val.ToString());
            val.Clear();
        }
        

        public Ini()
        {
            
        }

        public void Parse(string contents)
        {
            string[] t = contents.Split(new string[] { "\r\n" }, StringSplitOptions.None);
            string section = "";

            int blanks = 0;
            StringBuilder sBody = new StringBuilder("");

            foreach (string u in t)
            {
                if (u.isEmpty() || u.StartsWith("*") || u.StartsWith("/*")
                    || u.StartsWith(";") || u.StartsWith("#")
                    || u.StartsWith("//")
                    || u.StartsWith("--")
                    )
                {
                    if (!u.StartsWith("---- "))
                        blanks++;
                    continue;
                }

                string s = u.Trim();
                if (s.StartsWith("[") && s.EndsWith("]"))
                {
                    /// fill previous section 
                    AddSection(section, sBody);
                    blanks = 0;
                    section = s.Substring(1, s.Length - 2).Trim();
                }
                else if (s.StartsWith("---- "))
                {
                    AddSection(section, sBody);
                    blanks = 0;
                    section = s.Substring(5, s.Length - 5).Trim();
                }
                else
                {
                    sBody.AppendLine(u);
                    if (blanks < 1)
                    {
                        if (u.IndexOf('=') > 0)
                        {
                            string[] v = u.Split('=');
                            string k = "";
                            if (v.Length > 0)
                            {
                                k = v[0].Trim();
                                if (!section.isEmpty()) { k = section + "." + k; }
                            }
                            if (v.Length > 1)
                            {
                                this[k] = v[1].Trim(); 
                            }
                        }
                    }
                    blanks = 0;
                }
            }
            AddSection(section, sBody);            
        }

        public Ini(string inFile)
        {
            Parse(File.ReadAllText(inFile));            
        }

        public string this[string index]
        {
            get
            {
                if (kv.Keys.Contains(index))
                    return kv[index];
                else
                    return null;
            }

            set
            {
                if (!kv.Keys.Contains(index))
                    kv.Add(index, value);
                else
                    kv[index] = value;
            }
        }
    }
}