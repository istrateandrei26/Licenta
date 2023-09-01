using Newtonsoft.Json;

namespace AuthService.DTOs
{
    public class CoordinatesObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("latitude")]
        public decimal Latitude { get; set; }
        [JsonProperty("longitude")]
        public decimal Longitude { get; set; }
    }
}
