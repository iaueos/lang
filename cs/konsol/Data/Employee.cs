using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace konsol.Data
{
    public class Employee
    {
        public long EMPLOYEE_ID { get; set; }
        public string FIRST_NAME{ get; set; }
        public string LAST_NAME { get; set; }
        public DateTime BORN { get; set; }
        public string BIRTH_PLACE { get; set; }
        public string GENDER { get; set; }
        public string EMAIL { get; set; }
        public string USERNAME { get; set; }
        public DateTime? BEGUN { get; set; }
        public DateTime? ENDED { get; set; }             
    }
}
