namespace ChatService.DTOs
{
    public class FriendRequestObject
    {
        public UserObject User { get; set; } = null!;
        public int FriendRequestId { get; set; }
        public bool Accepted { get; set; }
    }
}
