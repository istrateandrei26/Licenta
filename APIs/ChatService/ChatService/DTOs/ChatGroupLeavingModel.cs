using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class ChatGroupLeavingModel
    {
        [JsonProperty("conversationId")]
        public int ConversationId { get; set; }
        [JsonProperty("userId")]
        public int UserId { get; set; }
        [JsonProperty("newGroupName")]
        public string NewGroupName { get; set; } = string.Empty;
    }
}
