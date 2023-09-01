namespace EventsService.DTOs.Response
{
    public class RetrieveEventInvitesResponse : BasicResponse
    {
        public IEnumerable<InvitationObject> Invites { get; set; } = null!;
    }
}
