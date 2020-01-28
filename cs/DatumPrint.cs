using System;
using System.Collections;
using System.Text; 
/// testing print date
using System.Threading;

public class Enu { 
	public static void Main(string[] args) {
        int DEF_WAIT = 50;
        int msWait = DEF_WAIT;

        if (args.Length > 0)
        {
            if (!(int.TryParse(args[0], out msWait))
                || msWait > 1000 || msWait < 0
                ) msWait = DEF_WAIT;

            
        }

        Console.WriteLine(DateTime.Now.ToString("yyyyMMdd HHmmss"));
        Console.WriteLine(DateTime.Now.Ticks);
        // Console.WriteLine(Base52(DateTime.Now.Ticks));
        
        for (int i = 0; i < 10; i++)
        {
            Console.WriteLine(Base52(
                    (int)Math.Round(DateTime.Now.TimeOfDay.TotalSeconds))
                + Base52(
                    (int)Math.Round((double)DateTime.Now.Millisecond / 38)
                    ));
            Thread.Sleep(msWait);        
        }
        

	}

    public static string Base52(long l)
    {
        const byte BASE = 52;
        const string a = "etaoinshrdlucmfwypvbgkjqxzETAOINSHRDLUCMFWYPVBGKJQXZ";
        StringBuilder x = new StringBuilder("");
        byte n;

        do
        {
            n = (byte)(l % BASE);
            x.Insert(0, a.Substring(n, 1));
            l = (l - n) / BASE;
        }
        while (l > 0);
        return x.ToString();
    }
}

