using System.Collections.Generic;
using System.Threading.Tasks;

public class MsSqlVoteRepository : IVoteRepository
{
    public Task ClearVotes(string pair = null)
    {
        throw new System.NotImplementedException();
    }

    public Task<IEnumerable<VoteSummary>> LoadVoteSummaries(string pair = null)
    {
        throw new System.NotImplementedException();
    }

    public Task SaveVote(VoteSummary vote)
    {
        throw new System.NotImplementedException();
    }
}