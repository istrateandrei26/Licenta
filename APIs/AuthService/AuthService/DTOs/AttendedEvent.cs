using Newtonsoft.Json;

namespace AuthService.DTOs
{
    public class AttendedEvent
    {
        [JsonProperty("event")]
        public EventObject Event { get; set; } = null!;
        
        [JsonProperty("members")]
        public IEnumerable<UserObject> Members { get; set; } = null!;
    }
}
