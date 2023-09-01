using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class EventReview
    {
        [JsonProperty("fromReview")]
        public UserObject FromReview { get; set; } = null!;
        [JsonProperty("reviewedEvent")]
        public EventObjectAndRatingAverage ReviewedEvent { get; set; } = null!;
    }
}
