using Microsoft.AspNetCore.Mvc;

namespace VotingApi.Controllers
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