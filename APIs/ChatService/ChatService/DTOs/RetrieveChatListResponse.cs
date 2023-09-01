using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class RetrieveChatListResponse : BasicResponse
    {
        [JsonProperty("lastMessages")]
        public IEnumerable<LastMessage> LastMessages { get; set; } = null!;

        [JsonProperty("user")]
        public UserObject User { get; set; } = null!;

        [JsonProperty("friends")]
        public IEnumerable<UserObject> Friends { get; set; } = null!;
        [JsonProperty("recommendedPersons")]
        public IEnumerable<UserObject> RecommendedPersons { get; set; } = null!;
    }
}
