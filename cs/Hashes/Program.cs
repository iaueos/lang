using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using Murmur;
using xxHashSharp;
using System.IO;
using System.Security.Cryptography;
using Force.Crc32;

namespace Hashes
{
    class Program
    {
        static void Main(string[] args)
        {
            Hashe hx = Hashe.Murmur3;
            uint seed = 0;
           
            List<string> words = new List<string>();
            IHash h;
            OutputWriter o;

            string infile="", outfile="";
            foreach (string a in args)
            {
                if (a.StartsWith("-"))
                {
                    string he = (a.Substring(1, a.Length - 1));
                    if (he.StartsWith("-"))
                    {
                        he = a.Substring(2, a.Length - 2);
                        if (!uint.TryParse(he, out seed))
                        {
                            hx = he.What();
                        }
                    }
                    else
                    {
                        string opt = he.Substring(0, 1).ToLower();
                        string val = he.Substring(1, he.Length - 1);

                        switch (opt)
                        {
                            case "i":
                                infile = val;
                                break;
                            case "o":
                                outfile = val;                               
                                break;
                            default: 
                                break;
                        }

                    }
                }                
                else
                {
                    words.Add(a);                     
                }
            }
            Reader r;
           

            if (!string.IsNullOrEmpty(infile))
            {
                r = new TextLineReader(infile);
            }

            else if (words.Count > 0)
            {

                r = new ListReader(words);
            }
            else
            {
                r = new ConsoleReader();

                if (args.Length < 1 && ! ((ConsoleReader) r).isPiped)
                {
                    Console.WriteLine(Res.Get("help"));
                    return;
                }

            }
            string lin;
            switch (hx)
            {
                case Hashe.Murmur3:
                    h = new MurmurHasher(seed);
                    break;
                case Hashe.MD5:
                    h = new MD5Hasher();
                    break;
                case Hashe.CRC32:
                    h = new CRC32Hasher();
                    break;
                case Hashe.xxHash:
                    h = new xxHasher(seed);
                    break;
                default:
                    h = new MurmurHasher(seed);
                    break;
            }
            if (string.IsNullOrEmpty(outfile))
            {
                if (words.Count > 0)

                    o = new ConsoleWriter();
                else
                    o = new ConsoleLine();
            }
            else
            {
                o = new BinaryDataWriter(outfile);
            }
            while ((lin = r.Next()) != null)
            {
                byte[] b = Encoding.UTF8.GetBytes(lin);
                o.Tell(h.Has(b));                
            }
            o.Dispose();
            r.Dispose();
        }
    }

    public static class Res
    {
        public static string Get(string filename)
        {
            string result = null;
            Regex r = new Regex("[\\w]+");
            MatchCollection mc = r.Matches(filename);

            if (mc.Count == 1 && !filename.Contains("."))
            {
                filename = filename + ".txt";
            }

            using (Stream stream = Assembly.GetEntryAssembly()
                            .GetManifestResourceStream(
                                Assembly.GetEntryAssembly().GetName().Name
                                + "." + filename))
            {
                if (stream != null)
                    using (StreamReader reader = new StreamReader(stream))
                    {
                        result = reader.ReadToEnd();
                    }
            }
            if (string.IsNullOrEmpty(result)){
                result = string.Join(" ", Assembly.GetEntryAssembly().GetManifestResourceNames());
            }
            return result;
        }
    }


    public abstract class Reader : IDisposable
    {
        public abstract string Next();
        public abstract void Dispose();
    }


    public class ConsoleReader : Reader
    {
        public bool isPiped = false;
        public ConsoleReader()
        {
            try
            {
                bool x = Console.KeyAvailable;
                isPiped = false;
            }
            catch 
            {
                isPiped = true;
            }

        }

        public override string Next()
        {
            if (!isPiped) return null;
            string s = null;

            //if (Console.In.Peek() != -1)
            //{
            try
            {
                s = Console.ReadLine();
            }
            catch
            {
                s = null;
            }
            return s;
                
        }

        public override void Dispose()
        {
            
        }
    }

    public class ListReader : Reader
    {
        List<string> lx = null;
        int i = 0;
        public ListReader(List<string> l)
        {
            lx = l;
        }
        
        public override string Next()
        {
            if (i < lx.Count)
                return lx[i];
            else
                return null;
        }

        public override void Dispose()
        {
            
        }
    }

    public class TextLineReader : Reader
    {
        FileStream f;
        StreamReader r;
        bool ende = false;

        public TextLineReader(string filename)
        {
            f = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read);
            r = new StreamReader(f, true);    
        }

        public override string Next()
        {
            string s = r.ReadLine();
            ende = (s == null);
            return s;
        }

        public override void Dispose()
        {
            if (r != null)
            {
                r.Close();
            }
            if (f != null)
            {
                f.Close();
            }
        }        
    }

    public abstract class OutputWriter: IDisposable {
        public abstract void Tell(byte[] b);
        public abstract void Dispose();
    }

    public class ConsoleLine: OutputWriter {
        public override void Tell(byte[] b)
        {
            uint i = 0;
            ulong l = 0;

            switch (b.Length)
            {
                case 4:
                    i = BitConverter.ToUInt32(b, 0);
                    Console.WriteLine(i);

                    break;
                case 8:
                    l = BitConverter.ToUInt64(b, 0);
                    Console.WriteLine(l);
                    break;
                case 16:
                    l = BitConverter.ToUInt64(b, 0);
                    Console.WriteLine(l);
                    break;
                default:
                    break;

            }
        }

        public override void Dispose()
        {
            
        }
    }

    public class ConsoleWriter: OutputWriter {
        int ix =0 ;
        public override void Tell(byte[] b) 
        {
            uint i = 0;
            ulong l = 0;
            if (ix>0) Console.Write("\t");
            switch (b.Length) {
                case 4: 
                        i = BitConverter.ToUInt32(b, 0);
                Console.Write(i);

                    break;
                case 8:
                     l = BitConverter.ToUInt64(b, 0);
                    Console.Write(l);
                    break;
                case 16: 
                    l = BitConverter.ToUInt64(b, 0);
                    Console.Write(l);
                    break;
                default: 
                    break;

            }
            
            ++ix;
        }

        public override void Dispose() {}
    }

    public class BinaryDataWriter : OutputWriter
    {
        int ix = 0;
        FileStream f; 

        public BinaryDataWriter(string filename)
        {
            f = new FileStream(filename, FileMode.OpenOrCreate);
            f.Seek(0, SeekOrigin.End);
            ix = 0;
        }

        public override void Tell(byte[] b)
        {
            ++ix;
            f.Write(b, 0, b.Length);
        }

        public override void Dispose()
            
        {
            if (f != null)
                f.Close();
        }
    }
   

    public interface IHash 
    {
        byte[] Has(byte[] b);
    }


    public class CRC32Hasher: IHash
    {
        HashAlgorithm A;
        
        public CRC32Hasher() {
            A = new Crc32Algorithm();
        }
        public byte[] Has(byte[] b)
        {
            return A.ComputeHash(b);
        }
    }

    public class MD5Hasher : IHash
    {
        MD5 m;
        
        public MD5Hasher()
        {
            m = MD5.Create();
        }

        public byte[] Has(byte[] b)
        {
            return m.ComputeHash(b);
        }
    }


    public class MurmurHasher : IHash
    {
        Murmur3 m; 
        
        public MurmurHasher(uint seed=0)
        {
            m = new Murmur3(seed);
        }

        public byte[] Has(byte[] b) {

            byte[] bx = null;            
            bx = m.ComputeHash(b);
            return bx;            
        }
    }

    public class xxHasher : IHash
    {
        uint _seed = 0;

        public xxHasher(uint seed)
        {
            _seed = seed;    
        }

        public byte[] Has(byte[] b)
        {
            byte[] bx = null;
            bx = BitConverter.GetBytes(xxHash.CalculateHash(b, b.Length, _seed));
            return bx;
        }

        public void Dispose()
        {
        }
    }

    public static class HashHelper
    {
        public static Hashe What(this string a)
        {
            Hashe it = Hashe.NONE;
            List<string> he = Enum.GetNames(typeof(Hashe)).Select(x => x.ToLower()).ToList();
            int[] hi = Enum.GetValues(typeof(Hashe)).Cast<int>().ToArray();
            a = a.ToLower();
            for (int ai = 0; ai < he.Count; ai++)
            {
                if (he[ai].StartsWith(a))
                {
                    int actionIndex = ai;
                    if (actionIndex >= 0 && Enum.IsDefined(typeof(Hashe), hi[actionIndex]))
                        it = (Hashe)hi[actionIndex];
                    break;
                }
            }
            return it;
        }

        public static uint Seed = 0;

    }

    public enum Hashe
    {
        NONE = 0,
        xxHash = 1,
        MD5 = 2, 
        Murmur3 = 3, 
        CRC32 = 4
    }

    

}
