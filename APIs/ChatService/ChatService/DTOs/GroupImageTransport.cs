using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class GroupImageTransport
    {
        [JsonProperty("groupId")]
        public int GroupId { get; set; }
        [JsonProperty("groupImage")]
        public List<int> GroupImage { get; set; } = null!;
    }
}
