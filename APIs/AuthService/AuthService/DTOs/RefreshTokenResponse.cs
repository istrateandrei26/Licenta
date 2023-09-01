namespace AuthService.DTOs
{
    public class RefreshTokenResponse : BasicResponse
    {
        public string AccessToken { get; set; } = string.Empty;
        public string RefreshToken { get; set; } = string.Empty;
    }
}
