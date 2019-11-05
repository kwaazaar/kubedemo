using System.ComponentModel.DataAnnotations;

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

    [Required]
    [MinLength(1)]
    public string Pair { get; set; }

    [Required]
    [MinLength(1)]
    public string Key { get; set; }

    [Required]
    [Range(0f,100f)]
    public float Score { get; set; }
}