using System;
using System.Text;

public class stringFormatten {
	public static void Main()
	{
		string _ReffNo = "12345", USERNAME = "USERNAME", _Command="Approve";
		
		StringBuilder b = new StringBuilder("b\r\n");
		b.AppendLine(DateTime.Now.ToString("HH:mm:ss"));
		Console.WriteLine(string.Format(
		"ReffNo: \"{0}\",|USERNAME: \"{1}\",|Command: \"{2}\",|DataField:|{3}".Replace("|","\r\n"),
		///"ReffNo: \"{0}\",\r\n USERNAME: \"{1}\",\r\n Command: \"{2}\",\r\n DataField:  \r\n {3} \r\n ", 
            _ReffNo, USERNAME, _Command, b.ToString()));
	}
}