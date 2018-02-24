using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace VotingApi.Controllers
{
    [Route("api/[controller]")]
    public class ReadyController : Controller
    {
        [HttpGet]
        public IActionResult Get()
        {
            lock (LockObject.LockingObject)
            {
                return Ok();
            }
        }
    }
}