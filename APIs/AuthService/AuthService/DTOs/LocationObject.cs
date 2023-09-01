using Newtonsoft.Json;

namespace AuthService.DTOs
{
    public class LocationObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("city")]
        public string City { get; set; } = null!;
        [JsonProperty("locationName")]
        public string LocationName { get; set; } = null!;
        [JsonProperty("coordinates")]
        public CoordinatesObject Coordinates { get; set; } = null!;
    }
}
