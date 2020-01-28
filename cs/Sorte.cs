using System;
using System.Linq; 
using System.Collections;
using System.Collections.Generic; 

public class PackItem {
	public int  i { get; set; }
	public string Nm { get; set; } 
}

public class Program {
	public static void Main(string [] args)  {
		List<PackItem> l = new List<PackItem>(); 
		
		l.Add(new PackItem() { i = 10, Nm = "puluh" });
		l.Add(new PackItem() { i = 20, Nm = "wapul" });
		l.Add(new PackItem() { i = 50, Nm = "mapul" });
		l.Add(new PackItem() { i = 5, Nm = "ma" });
		Console.WriteLine("asc"); 
		l.Sort(delegate (PackItem a, PackItem b) { return a.i.CompareTo(b.i); } );
		Liste(l);
		Console.WriteLine("desc"); 
		l.Sort(delegate (PackItem a, PackItem b) { return b.i.CompareTo(a.i); } );
		Liste(l);
		
		
	} 
	
	public static void Liste(List<PackItem> p) {
		for(int i = 0; i < p.Count; i ++) {
			Console.WriteLine("[{0,2}] {1,3} {2}", @i, p[i].i, p[i].Nm); 
		}
		Console.WriteLine(""); 
	}
}