namespace AuthService.DTOs
{
    public class UploadProfileImageResponse: BasicResponse
    {
        public List<int> ProfileImage { get; set; } = null!;
    }
}
