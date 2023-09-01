namespace EventsService.DTOs.Response
{
    public class AcceptEventInvitationResponse: BasicResponse
    {
        public bool Busy { get; set; }
        public bool Expired { get; set; }
        public bool Full { get; set; }
    }
}
