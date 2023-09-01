using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class GroupObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("groupImage")]
        public List<int>? GroupImage { get; set; }
        [JsonProperty("groupName")]
        public string GroupName { get; set; } = string.Empty;
    }
}
