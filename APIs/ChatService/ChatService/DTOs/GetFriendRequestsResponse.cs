namespace ChatService.DTOs
{
    public class GetFriendRequestsResponse : BasicResponse
    {
        public List<FriendRequestObject> FriendRequests { get; set; } = null!;
        public int NumberOfFriends { get; set; }
    }
}
