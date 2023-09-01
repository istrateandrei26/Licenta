namespace EventsService.DTOs.Response
{
    public class CreateEventResponse : BasicResponse
    {
        public bool SuccessfullyCreated { get; set; }
        public int EventId { get; set; }
        public bool Overlaps { get; set; }
        public bool BusyCreator { get; set; }
    }
}
