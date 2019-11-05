using System.Collections.Generic;
using System.Threading.Tasks;

public interface IVoteRepository
{
    Task SaveVote(VoteSummary vote);
    Task<IEnumerable<VoteSummary>> LoadVoteSummaries(string pair = null);
    Task ClearVotes(string pair = null);
}