namespace EventsService.DTOs.Request
{
    public class AcceptEventInvitationRequest
    {
        public int InvitationId { get; set; }
        public int UserId { get; set; }
    }
}
