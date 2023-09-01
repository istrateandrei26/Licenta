using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class MembersHonor
    {
        [JsonProperty("fromHonor")]
        public UserObject FromHonor { get; set; } = null!;
        [JsonProperty("attendedCategory")]
        public AttendedCategory AttendedCategory { get; set; } = null!;
    }
}
