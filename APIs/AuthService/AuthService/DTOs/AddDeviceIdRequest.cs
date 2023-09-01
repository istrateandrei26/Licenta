namespace AuthService.DTOs
{
    public class AddDeviceIdRequest
    {
        public int UserId { get; set; }
        public string DeviceId { get; set; } = string.Empty;
    }
}
