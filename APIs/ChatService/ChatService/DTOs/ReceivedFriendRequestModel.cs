using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace ChatService.DTOs
{
    public class ReceivedFriendRequestModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("firstname")]
        public string Firstname { get; set; } = string.Empty;
        [JsonProperty("lastname")]
        public string Lastname { get; set; } = string.Empty;
        [JsonProperty("profileImage")]
        public List<int>? ProfileImage { get; set; } = null!;
        [JsonProperty("friendRequestId")]
        public int FriendRequestId;
    }
}
