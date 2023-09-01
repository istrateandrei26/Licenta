using EventsService.Models;
using Newtonsoft.Json;
using System.Text;

namespace EventsService.Services.Notification
{
    public class NotificationService : INotificationService
    {
        private readonly IConfiguration _config;
        private SportNetContext _context;


        public NotificationService(IConfiguration config, SportNetContext context)
        {
            _config = config;
            _context = context;
        }


        public List<string> getUserDeviceTokens(int userId)
        {
            return _context.UserDevices
                .Where(x => x.UserId == userId)
                .ToList()
                .Select(x => x.DeviceId)
                .ToList();
        }


        public async Task SendNotification(List<int> to, string title, string body, string screenInfo = "")
        {
            var serverKey = _config.GetSection("FirebaseCloudMessageAPIKey"); // Replace with your actual server key
            var requestUri = new Uri("https://fcm.googleapis.com/fcm/send");

            var deviceTokens = new List<string>(); // here we will add all the device tokens of all users of given list
            
            foreach(var userId in to)
            {
                var userDeviceTokens = getUserDeviceTokens(userId);
                if (userDeviceTokens.Count == 0) continue;

                deviceTokens.AddRange(userDeviceTokens);
            }

            if (deviceTokens.Count == 0) return;
            
            var payload = new
            {
                registration_ids = deviceTokens,
                notification = new
                {
                    android_channel_id = "high_importance_channel",
                    title = title,
                    body = body,
                },
                priority = "high",
                data = new
                {
                    screen = screenInfo,
                }
            };

            var json = JsonConvert.SerializeObject(payload);

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "key=" + serverKey);
                httpClient.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");

                var response = await httpClient.PostAsync(requestUri, new StringContent(json, Encoding.UTF8, "application/json"));

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine("Notification sent successfully");
                }
                else
                {
                    Console.WriteLine($"Failed to send notification: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

            }
        }

        public async Task<HttpResponseMessage> SendNotificationToUserTest(string screen)
        {
            var serverKey = _config.GetSection("FirebaseCloudMessageAPIKey"); // Replace with your actual server key
            var deviceToken = "eAh_Irw1Tnqwu1mpn0o6D8:APA91bE2DSkeeabKvDHamx2wf8hornCwso6c_eqw8_tiCY1PY0AHUlc3qWFI6BouUk-tukeAs1-Ux1bG3zilyKdufNC_5qDRClvxfCcK_RxMBAaCSAyCMHn-PJ_01RYYmFf8rrDc1YOV"; // Replace with the registration token of the device you want to send the notification to

            var requestUri = new Uri("https://fcm.googleapis.com/fcm/send");
            var payload = new
            {
                to = deviceToken,
                notification = new
                {
                    android_channel_id = "high_importance_channel",
                    title = "Gabriel Frumuzache",
                    body = "Ce mai faci ?",
                },
                priority = "high",
                data = new
                {
                    screen = screen,
                }
            };
            var json = JsonConvert.SerializeObject(payload);

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "key=" + serverKey);
                httpClient.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");

                var response = await httpClient.PostAsync(requestUri, new StringContent(json, Encoding.UTF8, "application/json"));

                return response;

            }
        }
    }
}
