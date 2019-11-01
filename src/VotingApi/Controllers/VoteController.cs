using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace VotingApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VoteController : Controller
    {
        private IVoteRepository _repo;

        public VoteController(IVoteRepository repo)
        {
            _repo = repo;    
        }

        [HttpGet]
        public async Task<IActionResult> Get(string pair)
        {
            if (string.IsNullOrWhiteSpace(pair))
            {
                return BadRequest("No votingpair ('pair') provided");
            }

            return Ok(await _repo.LoadVoteSummaries(pair));
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody]VoteSummary vote)
        {
            if (vote == null)
            {
                return BadRequest("No vote provided");
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await _repo.SaveVote(vote);
            return Ok();
        }

        public async Task<IActionResult> Delete(string pair)
        {
            if (string.IsNullOrWhiteSpace(pair))
            {
                return BadRequest("No votingpair ('pair') provided");
            }

            await _repo.ClearVotes(pair);
            return Ok();
        }
    }
}
