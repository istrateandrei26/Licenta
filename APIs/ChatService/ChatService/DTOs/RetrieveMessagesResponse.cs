using ChatService.Models;

namespace ChatService.DTOs
{
    public class RetrieveMessagesResponse : BasicResponse
    {
        public IEnumerable<MessageObject> Messages { get; set; } = null!;
        public IEnumerable<UserObject?> ConversationPartners { get; set; } = null!;
        public List<int>? groupImage { get; set; } = null!;
        public string? groupName { get; set; } = null!;
        public bool IsGroup { get; set; }
        public IEnumerable<UserObject> Friends { get; set; } = null!;
    }
}
