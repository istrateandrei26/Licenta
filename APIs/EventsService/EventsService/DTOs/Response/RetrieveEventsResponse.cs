namespace EventsService.DTOs.Response
{
    public class RetrieveEventsResponse : BasicResponse
    {
        public IEnumerable<EventObject> Events { get; set; } = null!;
        public IEnumerable<SportCategoryObject> Categories { get; set; } = null!;
    }
}
