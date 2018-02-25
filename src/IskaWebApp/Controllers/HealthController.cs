using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace IskaWebApp.Controllers
{
    [Route("api/[controller]")]
    public class HealthController : Controller
   
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok();
        }
    }
}