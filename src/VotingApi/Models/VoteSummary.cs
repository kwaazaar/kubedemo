public class VoteSummary
{
    public VoteSummary()
    {
    }

    public VoteSummary(string pair, string key, float score)
    {
        Pair = pair;
        Key = key;
        Score = score;
    }

    public string Pair { get; set; }
    public string Key { get; set; }
    public float Score { get; set; }
}