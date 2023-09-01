using Newtonsoft.Json;

namespace AuthService.DTOs
{
    public class EventObjectAndRatingAverage
    {
        [JsonProperty("event")]
        public EventObject Event { get; set; } = null!;
        [JsonProperty("ratingAverage")]
        public double? RatingAverage { get; set; }
        [JsonProperty("members")]
        public IEnumerable<UserObject> Members { get; set; } = null!;
    }
}
