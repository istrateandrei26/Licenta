namespace EventsService.DTOs.Response
{
    public class CheckEventToJoinResponse : BasicResponse
    {
        public bool Busy { get; set; }
        public bool Expired { get; set; }
        public bool Full { get; set; }
    }
}
