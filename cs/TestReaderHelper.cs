using System; 
using System.Diagnostics; 

namespace TestReaderHelper 
{
	class Program 
	{

		static void Main(string[] args) {
		
			
			if (args.Length > 0 ) 
			{
				for(int i= 0; i < args.Length; i++) {
					string s = args[i];
					Console.WriteLine("{0} GetPos(0):{1} GetPos(1):{2} GetRow:{3} GetCol:{4}", 
						s, 
						ReaderHelper.GetPos(s, 0),
						ReaderHelper.GetPos(s, 1),
						ReaderHelper.GetRow(s), 
						ReaderHelper.GetCol(s));
				}
			}
			
		}
		
	}
	
	 public static class ReaderHelper
    {
	    public static int Value26(string x)
        {
            int a = 0;
            int m = 1;
			if (!string.IsNullOrEmpty(x)) {
				x = x.ToUpper();
				for (int i = x.Length - 1; i >= 0; i--)
				{
					int n = (int)x[i];
					a += (n - 64) * m;
					m *= 26;
				}
			}
            return a;
        }
		
		  public static string GetPos(string CellPos, int elem = 0)
        {
            string r = null;
            if (string.IsNullOrEmpty(CellPos))
                return r;

            int j = CellPos.Length;
            for (int i = 0; i < j; i++)
            {
                int x;
                if (!int.TryParse(CellPos.Substring(j - i - 1), out x))
                {
                    if (elem == 0)
                        r = CellPos.Substring(j-i, i);
                    else
                        r = CellPos.Substring(0, j-i);

                    break;
                }

            }
            return r;
        }
		
		 public static int GetRow(string CellPos)
        {
            int r = -1;
            int.TryParse(GetPos(CellPos, 0), out r);
            return r;
        }

        public static int GetCol(string CellPos)
        {
            return ReaderHelper.Value26(GetPos(CellPos, 1));
        }
		
		
        
	}

}