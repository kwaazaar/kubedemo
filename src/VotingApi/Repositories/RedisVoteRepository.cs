using StackExchange.Redis;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public class RedisVoteRepository : IVoteRepository
{
    private IDatabase _db;

    public RedisVoteRepository(string connString)
    {
        ConnectionMultiplexer conn = ConnectionMultiplexer.Connect(connString);
        _db = conn.GetDatabase();
    }

    public async Task ClearVotes(string pair)
    {
        var valueKeys = await _db.HashKeysAsync(pair);
        foreach (var valueKey in valueKeys)
        {
           await _db.HashSetAsync(pair, valueKey, 0);
        }
    }

    public async Task<IEnumerable<VoteSummary>> LoadVoteSummaries(string pair)
    {
        var valueKeys = await _db.HashKeysAsync(pair);
        var summaries = valueKeys.Select((vk) =>
        {
            _db.HashGet(pair, vk).TryParse(out long valueInt);
            return new VoteSummary(pair, vk, (float)valueInt);
        });

        return summaries;
    }

    public Task SaveVote(VoteSummary vote)
    {
        return _db.HashIncrementAsync(vote.Pair, vote.Key, 1);
    }
}