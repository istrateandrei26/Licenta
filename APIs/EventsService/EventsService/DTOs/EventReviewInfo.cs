using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class EventReviewInfo
    {
        [JsonProperty("event")]
        public EventObject Event { get; set; } = null!;
        [JsonProperty("members")]
        public IEnumerable<UserObject> Members { get; set; } = null!;
    }
}
