namespace AuthService.DTOs
{
    public class GoogleSignInRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Firstname { get; set; } = string.Empty;
        public string Lastname { get; set; } = string.Empty;
        public List<int>? ProfileImageBytes { get; set; }
    }
}
