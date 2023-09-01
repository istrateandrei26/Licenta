using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class MessageReactionObject
    {
        [JsonProperty("reactedMessageId")]
        public int ReactedMessageId { get; set; }
        [JsonProperty("conversationId")]
        public int ConversationId { get; set; }
        [JsonProperty("whoReacted")]
        public UserObject WhoReacted { get; set; } = null!;
    }
}
