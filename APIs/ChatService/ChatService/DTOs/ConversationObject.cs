namespace ChatService.DTOs
{
    public class ConversationObject
    {
        public int Id { get; set; }
        public string? Description { get; set; } = null!;
        public List<int>? GroupImage { get; set; } = null!;
        public bool IsGroup { get; set; }
    }
}
