namespace ChatService.DTOs
{
    public class GetFriendsResponse : BasicResponse
    {
        public IEnumerable<UserObject> Friends { get; set; } = null!;
    }
}
