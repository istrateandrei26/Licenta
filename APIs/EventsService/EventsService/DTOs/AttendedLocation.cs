using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class AttendedLocation
    {
        [JsonProperty("location")]
        public LocationObject Location { get; set; } = null!;
        [JsonProperty("sportCategory")]
        public SportCategoryObject SportCategory { get; set; } = null!;
        public DateTime AttendedDatetime { get; set; }

    }
}
