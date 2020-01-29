using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using konsol.Common;
using konsol.Data; 

namespace konsol
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                if (string.Compare(args[0], "Show", true) == 0)
                {
                    ShowEmployees((args.Length > 2) ? args[1].Long() : 0L);
                }
                else if (string.Compare(args[0], "Add", true) == 0)
                {
                    int n = args.Length;
                    
                    AddEmployee(new Employee()
                    {
                        FIRST_NAME = (n > 1) ? args[1] : "EMPLOYEE TEST",
                        LAST_NAME = (n > 2) ? args[2] : "",
                        BIRTH_PLACE = (n>3)? args[3] : "JAKARTA", 
                        BORN = (n > 4) ? args[4].Date() : DateTime.Now,
                        GENDER = (n > 5) ? args[5].Substring(0, 1) : " ",
                        EMAIL = (n > 6) ? args[6] : "",
                        USERNAME = (n > 7) ? args[7] : "",
                        BEGUN = DateTime.Now,
                        ENDED = new DateTime(9999, 12, 31)
                    });

                }
                else 
                {
                    ShowEmployees(0);
                }
            }
            else
            {
                ShowPositions();
            }
        }

        public static void AddEmployee(Employee e)
        {
            Sing.Me.Do("AddEmployee", e);
        }

        public static void ShowPositions()
        {
            List<Position> positions = Sing.Me.Qx<Position>("GetPosition").ToList();
            Console.WriteLine("ID\tNAME");
            foreach (var position in positions)
            {
                Console.WriteLine("{0}\t{1}", position.POSITION_ID, position.POSITION_NAME);
            }
        }

        public static void ShowEmployees(long EmployeeID)
        {
            List<Employee> e = Sing.Me.Qx<Employee>("GetEmployee", new { EMPLOYEE_ID = EmployeeID }).ToList();
            Console.WriteLine("ID\tNAME\tPLACE\tBORN\tGENDER\tEMAIL\tUSERNAME");
            foreach (var employee in e)
            {
                Console.WriteLine("{0}\t{1}\t{2}\t{3}\t{4}\t{5}",
                    employee.EMPLOYEE_ID,
                    employee.FIRST_NAME + " " + employee.LAST_NAME, 
                    employee.BIRTH_PLACE, 
                    employee.BORN.fmt(StrTo.XLS_DATE),
                    employee.GENDER,
                    employee.EMAIL,
                    employee.USERNAME
                    );
            }
        }
    }
}
