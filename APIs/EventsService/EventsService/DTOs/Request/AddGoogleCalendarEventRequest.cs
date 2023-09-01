namespace EventsService.DTOs.Request
{
    public class AddGoogleCalendarEventRequest
    {
        public string GoogleCalendarEventId { get; set; } = string.Empty;
        public int UserId { get; set; }
        public int EventId { get; set; }
    }
}
