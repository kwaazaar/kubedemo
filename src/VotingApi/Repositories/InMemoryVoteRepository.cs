using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public class InMemoryVoteRepository : IVoteRepository
{
    private IDictionary<string, List<VoteSummary>> _repo = new ConcurrentDictionary<string, List<VoteSummary>>();

    public Task ClearVotes(string pair = null)
    {
        if (_repo.ContainsKey(pair))
        {
            _repo.Remove(pair);
        }

        return Task.CompletedTask;
    }

    public Task<IEnumerable<VoteSummary>> LoadVoteSummaries(string pair = null)
    {
        if (_repo.TryGetValue(pair, out List<VoteSummary> votes))
        {
            return Task.FromResult(votes.AsEnumerable());
        }

        return Task.FromResult(Enumerable.Empty<VoteSummary>());
    }

    public Task SaveVote(VoteSummary vote)
    {
        if (!_repo.TryAdd(vote.Pair, new List<VoteSummary>() { vote }))
        {
            if (_repo.TryGetValue(vote.Pair, out List<VoteSummary> votes))
            {
                votes.Add(vote);
            }
            else
            {
                throw new Exception("Cannot add vote :-s");
            }
        }

        return Task.CompletedTask;
    }
}
