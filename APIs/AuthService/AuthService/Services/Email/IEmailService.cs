using AuthService.DTOs;

namespace AuthService.Services.Email
{
    public interface IEmailService
    {
        public Task SendResetPasswordEmail(string emailAddress);
    }
}
