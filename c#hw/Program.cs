using System;

namespace ConsoleApp1
{
    class Program
    {
        //1.find the factorial of a number, 6! = 6x5x4x3x2x1
        public int fact(int a)
        {
            int result = a;
            for (int i = a-1;  i>=1; i--)
            {
                result *= i;
            }
            return result;
        }
        //2. if a number is prime or not
        public void prime(int a) 
        {
            bool result = true;
            for (int i = 2; i < a / 2; i++)
            {
                if (a % i == 0)
                {
                    result = false;
                    break;
                }
            }
            Console.WriteLine(result);
        }
        //3.if a year is leap or not
        public void leap(int year)
        {
            bool result = false;
            if (year % 400 == 0) result = true;
            else if (year % 100 == 0) result = false;
            else if (year % 4 == 0) result = true;
            else result = false;
            if (result == true) Console.WriteLine("leap year");
            if (result == false) Console.WriteLine("not leap year");
        }
        //4.LCM of 2 number
        public void lcm(int a, int b)
        {
            int f = a;
            int s = b;
            while (s != 0)//find the GCD of a,b
            {
                int t = s;
                s = f % s;
                f = t;
            }
            int result = (a / f) * b;
            Console.WriteLine(result);
        }

        static void Main(string[] args)
        {
            Program fac = new Program();
            int factor = fac.fact(6);
            Console.WriteLine(factor);

            Program p = new Program();
            p.prime(3);

            Program l = new Program();
            l.leap(2021);

            Program m = new Program();
            m.lcm(4,6);
        }
    }
}
