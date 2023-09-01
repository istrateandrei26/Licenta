namespace ChatService.DTOs
{
    public class MessageObject
    {
        public int Id { get; set; }
        public int FromUser { get; set; }
        public int? ToUser { get; set; }
        public string Content { get; set; } = null!;
        public DateTime Datetime { get; set; }
        public int ConversationId { get; set; }
        public bool isImage { get; set; }
        public bool isVideo { get; set; }
        public UserObject? fromUserDetails { get; set; }
        public List<UserObject> UsersWhoReacted { get; set; } = new List<UserObject>();
    }
}
