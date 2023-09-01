namespace EventsService.DTOs.Request
{
    public class RemoveGoogleCalendarEventRequest
    {
        public int UserId { get; set; }
        public int EventId { get; set; }
    }
}
