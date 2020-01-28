using System; 
using System.Diagnostics; 

namespace Guid 
{
	class Program 
	{

		static void Main(string[] args) {
		
			bool defaultAct = true;
			if (args.Length > 0 ) 
			{
				int g = 0;
				if (int.TryParse(args[0], out g) && (g > 0))
				{
					g = Math.Min(g, 25); 
					if (g < 25) 
					{
						for (int i = 0; i < g; i++) 
						{
							Console.WriteLine(System.Guid.NewGuid());
						}						
						defaultAct = false;
					}
					
				}
			}
			
			if (defaultAct) 
				Console.WriteLine(System.Guid.NewGuid());
		}
		
	}

}