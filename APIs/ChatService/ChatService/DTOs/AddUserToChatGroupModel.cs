using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class AddUserToChatGroupModel
    {
        [JsonProperty("userWhoAdded")]
        public int UserWhoAdded { get; set; }
        [JsonProperty("newGroupPartnerList")]
        public List<UserObject> NewGroupPartnerList { get; set; } = null!;
        [JsonProperty("chatListItem")]
        public LastMessage ChatListItem { get; set; } = null!;
        [JsonProperty("addedUsers")]
        public List<UserObject> AddedUsers { get; set; } = null!;
    }
}
