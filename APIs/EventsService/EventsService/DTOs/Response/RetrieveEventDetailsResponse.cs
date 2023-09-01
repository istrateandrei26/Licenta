namespace EventsService.DTOs.Response
{
    public class RetrieveEventDetailsResponse: BasicResponse
    {
        public EventObject Event { get; set; } = null!;
        public IEnumerable<UserObject> Members { get; set; } = null!;
        public IEnumerable<UserObject> Friends { get; set; } = null!;

    }
}
