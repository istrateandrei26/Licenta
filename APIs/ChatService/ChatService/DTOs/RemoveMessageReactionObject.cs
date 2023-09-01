using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class RemoveMessageReactionObject
    {
        [JsonProperty("messageId")]
        public int MessageId { get; set; }
        [JsonProperty("conversationId")]
        public int ConversationId { get; set; }
        [JsonProperty("whoRemovedReaction")]
        public int WhoRemovedReaction { get; set; }
    }
}
