using System;
class Milisek {
	static void Main(string[]args)
	{
        int waits =1;
        if (args.Length > 0)
            int.TryParse(args[0], out waits);

        TimeSpan t;
        string f = "{0,2} {1,2} {2,2} {3,2} {4,3} {5,8}";
        Console.WriteLine(f, "dd", "hh", "mi", "ss", "ms", "TOT");
        for (int i = 0; i < 23; i++)
        {
            t = DateTime.Now.TimeOfDay;
            Console.WriteLine(f, t.Days, t.Hours, t.Minutes, t.Seconds, t.Milliseconds, Math.Floor(t.TotalMilliseconds));
            System.Threading.Thread.Sleep(waits);
        }
	}
}