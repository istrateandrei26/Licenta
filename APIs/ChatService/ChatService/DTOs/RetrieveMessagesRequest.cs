namespace ChatService.DTOs
{
    public class RetrieveMessagesRequest
    {
        public int UserId { get; set; }
        public int ConversationId { get; set; }
    }
}
