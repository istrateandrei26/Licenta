namespace EventsService.Services.Email
{
    public interface IEmailService
    {
        public Task SendNewLocationApprovalVerificationCode(int newLocationRequestId);
    }
}
