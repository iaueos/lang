using System;
using System.Text;
using System.Security.Cryptography;
namespace Enk {
    public class enk
    {
        public static void Main(string [] args)
        {
            int act = 0;
            if (args.Length < 1) {
                    Console.WriteLine("enk \"string\" --option |Encrypt string|option:"
                    +"|   e: Base64Encode |   d: Base64Decode"
                    +"|   s: SHA256".Replace("|","\r\n"));
                    return;
            }
            foreach(string s in args)  {
                if (s.StartsWith("--"))
                {
                    string x  = s.Substring(2,1).ToLower();
                    act = "  e d s".IndexOf(x)/2;
                    if (act < 0) act = 0;
                    continue;
                }
                string r = null;
                switch (@act) {
                    case 0 : r = Nak.Encrypt(s); break;
                    case 1 : r = Nak.Encode(s);  break;
                    case 2 : r = Nak.Decode(s);  break;
                    case 3 : r = Nak.Sha256(s);  break;
                    default: r = "?"; break;
                }
                Console.WriteLine("{0}\t{1}", s, r);
            }
        }
    }
    public static class Nak {
        public static string Encrypt(string plainText)
        {
            string encoded = String.Empty;
            string result = String.Empty;
            string salts = String.Empty;
            string plain = String.Empty;
            string plainSugar = String.Empty;
            int stringLength = 0;
            plain = plainText;
            stringLength = plain.Length;
            plainSugar = Encode(plain);
            if (stringLength > 3)
                salts = plain.Substring(stringLength - 3, 3) + plain.Substring(1, 2) + stringLength.ToString();
            else
                salts = plain.Reverse();
            encoded = Encode(plainSugar + salts);
            result = HashSHA256(plainSugar, encoded);
            return result;
        }
         private static string HashSHA256(string plain, string encoded)
        {
            string result = String.Empty;
            string combineString = String.Empty;
            combineString = plain + encoded;
            using (SHA256 sha = SHA256.Create())
            {
                byte[] source = Encoding.UTF8.GetBytes(combineString);
                byte[] hash = sha.ComputeHash(source);
                result = BitConverter.ToString(hash).Replace("-", String.Empty);
            }
            return result;
        }
        public static string Reverse(this string s) {
            char [] c = s.ToCharArray();
            Array.Reverse(c);
            return new string(c);
        }
        public static string Sha256(string s) {
            byte[] x = Encoding.UTF8.GetBytes(s);
            string r = "";
            using (SHA256 sha = SHA256.Create())
            {
                byte[] h = sha.ComputeHash(x);
                r = BitConverter.ToString(h).Replace("-", "");
            }
            return r;
        }
        public static string Encode(string plain)
        {
            string value = String.Empty;
            byte[] byteValue;
            byteValue = Encoding.UTF8.GetBytes(plain);
            value = Convert.ToBase64String(byteValue);
            return value;
        }
         public static string Decode(string encoded)
        {
            string value = String.Empty;
            byte[] byteValue;
            byteValue = Convert.FromBase64String(encoded);
            value = Encoding.UTF8.GetString(byteValue);
            return value;
        }
    }
}