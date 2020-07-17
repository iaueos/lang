using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Text; 

namespace Konro
{
    /*
     * compile use visual studio cross tools command line prompt 
     * 
     * csc kon.cs /debug
     *
     * use for testing connection string and getting query resulting tab separated text in console
     */
    class Konro
    {
        static void Main(string[] args)
        {
            try
            {
                if (args.Length < 1)
                {
                    Console.WriteLine("kon ConnectionString SQL separator|outputFile\r\n"
                        + "testing ConnectionString with SQL query, if query contains data, print it out"
                        );
                    return;
                }
                
                string connectionString = null;
                string query = null;
                string sep = "\t";
                string outFile = null;
                List<string> a = new List<string>();
                Dictionary<string, string> d = new Dictionary<string, string>();
                foreach(string s in args)
                {
                    if (s.StartsWith("@"))
                    {
                        if (a.Count < 2)
                        {
                            if (s.Length > 2)
                                a.Add(GetArg(s));
                            else
                            {
                                if (File.Exists("konro.txt"))
                                    a.Add(File.ReadAllText("konro.txt"));
                            }
                        } 
                        else
                        {
                            int pEq = s.IndexOf("=");
                            if (pEq > 1 && (pEq < s.Length - 1) )
                            {
                                d.Add(s.Substring(0, pEq), s.Substring(pEq + 1, s.Length - pEq - 1));
                            }
                        }
                    } else
                    {
                        if ((s.Length < 3) || s.StartsWith("\\"))
                        {
                            sep = s;
                        }
                        else
                            a.Add(s);
                    }
                }
                connectionString = a[0];
                query = a[1];
                if (a.Count > 2)
                    outFile = a[2];
                StreamWriter w = null;
                if (!string.IsNullOrEmpty(outFile))
                {
                    w = new StreamWriter(outFile, true, System.Text.Encoding.ASCII);
                }

                using (SqlConnection kon = new SqlConnection(connectionString))
                {
                    using (SqlCommand tol = new SqlCommand(!string.IsNullOrEmpty(query) ? query: "SELECT SUSER_NAME() me, USER_NAME()[self], @@VERSION ver", kon))
                    {
                        kon.Open();
                        kon.InfoMessage += de;
                        if (d.Count > 0)
                        {
                            foreach (var kv in d)
                            {
                                tol.Parameters.AddWithValue(kv.Key, kv.Value);
                            }
                        }
                        StringBuilder b = new StringBuilder(); 
                        using (SqlDataReader ge = tol.ExecuteReader())
                        {
                            int j = ge.FieldCount;
                            for (int i =0; i < j; i++)
                            {
                                if (i>0)
                                    b.Append(sep);
                                b.Append(ge.GetName(i)); 
                            }

                            if (w != null)
                            {
                                w.WriteLine(b.ToString());
                            }
                            else
                            {
                                Console.WriteLine(b.ToString());
                            }

                            b.Clear();
                            if (ge.HasRows)
                            {
                                while (ge.Read())
                                {
                                    for (int i = 0; i < j; i++)
                                    {
                                        if (i > 0) b.Append(sep);
                                        if (ge[i] != null)
                                            b.Append(Convert.ToString(ge[i]));
                                    }

                                    if (w == null)
                                    {
                                        Console.WriteLine(b.ToString());
                                    }
                                    else
                                    {
                                        w.WriteLine(b.ToString());
                                    }
                                    b.Clear();
                                }
                            } 
                            else
                            {
                                b.Clear();
                                for (int i = 0; i < j - 1; i++)
                                {
                                    b.Append(sep);
                                    Console.Write(sep);
                                }
                                if (w == null)
                                    Console.WriteLine(b.ToString());
                                else
                                    w.WriteLine(b.ToString());
                            }
                            ge.Close();
                        }
                        kon.Close();
                    }
                }

                if (w != null)
                {
                    w.Flush();
                    w.Close();                    
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace);
            }
        }

        static void de(object sender, SqlInfoMessageEventArgs e)
        {
            Console.WriteLine(e.Message);
        }

        static string GetArg(string a)
        {
            if (a.StartsWith("@"))
                return File.ReadAllText(a.Substring(1));
            else
                return a;
        }
    }
}