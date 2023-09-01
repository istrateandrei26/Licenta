using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class AttendedCategory
    {
        [JsonProperty("sportCategory")]
        public SportCategoryObject SportCategory { get; set; } = null!;
        [JsonProperty("honors")]
        public int Honors { get; set; }
    }
}
