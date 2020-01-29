using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Diagnostics;

namespace konsol.Common
{
    public class TextLogger : IPut, ISay, IPrint
    {
        private int pid = 0;
        private string _dir = "";
        private string lastWhere = "";
        
        private readonly string dateFmt = "HH:mm:ss";
        private string filler = "        ";
        private DateTime lastNow = new DateTime(1900, 12, 31);
        public readonly string logExt = ".txt";
        public TextLogger()
        {
            _dir = GetPath();

            Util.ForceDirectories(_dir);            
        }

        public TextLogger(string nm): this()
        {
            lastWhere = nm;
            
        }

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
            if (string.IsNullOrEmpty(site))
                site = (new StackTrace(true)).SourceLocation();

            string lin = "";
            string filename = user + logExt;
            if (string.Compare(lastWhere, site) != 0)
            {
                lastWhere = site;
                lin = filler + " [" + site + "]" + Environment.NewLine;
            }
            else
                site = "";

            string ts = GetPeriodicTimeStamp(); 
            
            lin = lin + string.Format("{0} {1}\r\n", ts, what);

            File.AppendAllText(Path.Combine(_dir, filename), lin);
            if (ID >= 0)
            {
                pid = ID;
            }
            else
            {
                pid = 1;
            }
            return pid;
        }

        public static string GetPath()
        {
            DateTime n = DateTime.Now;
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData)
                , AppSetting.Domain, AppSetting.ApplicationID, "log"
                , n.Year.ToString()
                , n.Month.ToString()
                , n.Day.ToString());
        }

        public void Dispose()
        {

        }

        public string GetPeriodicTimeStamp()
        {
            if (Math.Floor((DateTime.Now - lastNow).TotalSeconds) > 0)
            {
                lastNow = DateTime.Now;
                return DateTime.Now.ToString(lastNow.ToString(dateFmt));
            }
            return filler;
        }

        public int say(string w, params object[] x)
        {
            return Say(lastWhere, w, x);
        }

        public int Say(string loc, string w, params object[] x)
        {
            string logfile = Path.Combine(_dir, ((string.IsNullOrEmpty(loc)) ? "0" + logExt : Util.SanitizeFilename(loc) + logExt));
            string ts = GetPeriodicTimeStamp();
            lastWhere = loc;
            try
            {
                File.AppendAllText(logfile, Environment.NewLine + ts + " "
                    + ((x != null) ? String.Format(w.Replace("|", Environment.NewLine + "\t"), x) : w));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return -2;
            }
            return 0;
        }
    }
}