using System; 
using System.Text.RegularExpressions;

namespace isPrime{
public class IsPrime{
public static void Main(string[] args)
{
int c;
if (args.Length == 1 && int.TryParse(args[0], out c))
Console.WriteLine(!Regex.IsMatch(new String('1', c), @"^1?$|^(11+?)\1+$"));
}
}
}