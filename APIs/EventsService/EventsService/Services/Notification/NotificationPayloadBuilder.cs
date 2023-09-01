namespace EventsService.Services.Notification
{
    public class NotificationPayloadBuilder
    {
        public static string BuildPayload(string viewRoute, List<int> ids, List<string> infos)
        {
            List<string> payload = new List<string>();

            payload.Add(viewRoute);
            if (ids.Count != 0)
            {
                foreach (var id in ids)
                {
                    payload.Add(",");
                    payload.Add(id.ToString());
                }
            }

            if (infos.Count != 0)
            {
                foreach (var info in infos)
                {
                    payload.Add(",");
                    payload.Add(info);
                }
            }


            return string.Join("", payload);
        }
    }
}
