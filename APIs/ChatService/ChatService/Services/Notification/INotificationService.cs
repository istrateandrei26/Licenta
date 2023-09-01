namespace ChatService.Services.Notification
{
    public interface INotificationService
    {
        public Task<HttpResponseMessage> SendNotificationToUserTest(string screen);
        public Task SendNotification(List<int> to, string title, string body, string screenInfo = "");
        public List<string> getUserDeviceTokens(int userId);
    }
}
