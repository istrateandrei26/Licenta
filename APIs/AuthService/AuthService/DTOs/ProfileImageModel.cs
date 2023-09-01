using MessagePack.Formatters;

namespace AuthService.DTOs
{
    public class ProfileImageModel
    {
        public string UserId { get; set; } = string.Empty;
        public string ImageName { get; set; } = string.Empty;
        public IFormFile file { get; set; } = null!;
    }
}
