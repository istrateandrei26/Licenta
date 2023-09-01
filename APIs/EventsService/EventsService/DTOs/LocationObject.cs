using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json;

namespace EventsService.DTOs
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
        [JsonProperty("mapChosen")]
        public bool MapChosen { get; set; }
    }
}
