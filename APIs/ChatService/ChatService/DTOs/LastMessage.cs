using ChatService.Models;
using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class LastMessage
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("content")]
        public string Content { get; set; } = null!;
        [JsonProperty("datetime")]
        public DateTime Datetime { get; set; }
        [JsonProperty("userId")]
        public int UserId { get; set; }
        [JsonProperty("userDetails")]
        public IEnumerable<UserObject?> userDetails { get; set; } = null!;
        [JsonProperty("conversationId")]
        public int ConversationId { get; set; }
        [JsonProperty("fromUser")]
        public int FromUser { get; set; }

        [JsonProperty("fromUserDetails")]
        public UserObject FromUserDetails { get; set; } = null!;
        [JsonProperty("isImage")]
        public bool isImage { get; set; }
        [JsonProperty("isVideo")]
        public bool isVideo { get; set; }
        [JsonProperty("conversationDescription")]
        public string? ConversationDescription { get; set; } = null!;
        [JsonProperty("groupImage")]
        public List<int>? GroupImage { get; set; } = null!;
        [JsonProperty("isGroup")]
        public bool IsGroup { get; set; }
        [JsonProperty("usersWhoReacted")]
        public List<UserObject> UsersWhoReacted { get; set; } = new List<UserObject>();
    }
}
