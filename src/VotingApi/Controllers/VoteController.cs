using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace VotingApi.Controllers
{
    [Route("api/[controller]")]
    public class VoteController : Controller
    {
        private IVoteRepository _repo;

        public VoteController(IVoteRepository repo)
        {
            _repo = repo;    
        }

        [HttpGet]
        public Task<IEnumerable<VoteSummary>> Get(string pair)
        {
            return _repo.LoadVoteSummaries(pair);
        }

        [HttpPost]
        public Task Post([FromBody]VoteSummary vote) => _repo.SaveVote(vote);

        public Task Delete(string pair) => _repo.ClearVotes(pair);
    }
}
