using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class RequestedLocationObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("city")]
        public string City { get; set; } = string.Empty;
        [JsonProperty("locationName")]
        public string LocationName { get; set; } = string.Empty;
        [JsonProperty("ownerEmail")]
        public string OwnerEmail { get; set; } = string.Empty;
        [JsonProperty("sportCategoryName")]
        public string SportCategoryName { get; set; } = string.Empty;
        [JsonProperty("sportCategoryId")]
        public int SportCategoryId { get; set; }

        [JsonProperty("coordinates")]
        public CoordinatesObject Coordinates { get; set; } = null!;
        [JsonProperty("approved")]
        public bool Approved { get; set; } = false;

    }
}
