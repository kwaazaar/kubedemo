using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace VotingApi.Controllers
{
    [Route("api/[controller]")]
    public class WorkController : Controller
    {
        [HttpPost]
        public long Post(int primeNumber)
        {
            // Leg een lock zodat de ReadyController geen antwoord meer kan geven
            lock (LockObject.LockingObject)
            {
                var stopwatch = Stopwatch.StartNew();
                FindPrimeNumber(primeNumber);
                return stopwatch.ElapsedMilliseconds;
            }
        }

        private long FindPrimeNumber(int n)
        {
            int count = 0;
            long a = 2;
            while (count < n)
            {
                long b = 2;
                int prime = 1;// to check if found a prime
                while (b * b <= a)
                {
                    if (a % b == 0)
                    {
                        prime = 0;
                        break;
                    }
                    b++;
                }
                if (prime > 0)
                {
                    count++;
                }
                a++;
            }
            return (--a);
        }
    }
}
