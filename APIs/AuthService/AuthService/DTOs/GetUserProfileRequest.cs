namespace AuthService.DTOs
{
    public class GetUserProfileRequest
    {
        public int CurrentUserId { get; set; }
        public int UserProfileId { get; set; }
    }
}
