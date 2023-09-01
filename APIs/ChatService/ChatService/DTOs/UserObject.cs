using Newtonsoft.Json;

namespace ChatService.DTOs
{
    public class UserObject
    {
        [JsonProperty("id")]
        public int Id { get; set; }
        [JsonProperty("email")]
        public string Email { get; set; } = null!;
        [JsonProperty("firstname")]
        public string Firstname { get; set; } = null!;
        [JsonProperty("lastname")]
        public string Lastname { get; set; } = null!;
        [JsonProperty("username")]
        public string Username { get; set; } = null!;
        [JsonProperty("profileImage")]
        public List<int>? ProfileImage { get; set; } = null!;
    }
}
