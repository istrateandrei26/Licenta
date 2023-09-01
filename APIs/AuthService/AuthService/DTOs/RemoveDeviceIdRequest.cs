namespace AuthService.DTOs
{
    public class RemoveDeviceIdRequest
    {
        public int UserId { get; set; }
        public string DeviceId { get; set; } = null!;
    }
}
