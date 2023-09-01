using Newtonsoft.Json;

namespace AuthService.DTOs
{
    public class EventObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("startDateTime")]
        public DateTime StartDateTime { get; set; }
        [JsonProperty("duration")]
        public double Duration { get; set; }
        [JsonProperty("sportCategory")]
        public SportCategoryObject? SportCategory { get; set; }
        [JsonProperty("location")]
        public LocationObject? Location { get; set; }
        [JsonProperty("creator")]
        public UserObject? Creator { get; set; }
        [JsonProperty("requiredMembersTotal")]
        public int RequiredMembersTotal { get; set; }
    }
}
