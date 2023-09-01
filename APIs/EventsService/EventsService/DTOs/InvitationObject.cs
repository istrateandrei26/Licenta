using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class InvitationObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("fromUser")]
        public UserObject? FromUser { get; set; }
        [JsonProperty("toUser")]
        public UserObject? ToUser { get; set; }
        [JsonProperty("event")]
        public EventObject? Event { get; set; }
        [JsonProperty("accepted")]
        public bool Accepted { get; set; }
    }
}
