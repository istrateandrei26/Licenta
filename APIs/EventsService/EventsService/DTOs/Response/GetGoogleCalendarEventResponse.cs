namespace EventsService.DTOs.Response
{
    public class GetGoogleCalendarEventResponse : BasicResponse
    {
        public string Id { get; set; } = string.Empty;
        public bool Found { get; set; }
    }
}
