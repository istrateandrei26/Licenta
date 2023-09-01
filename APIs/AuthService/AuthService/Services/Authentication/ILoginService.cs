using AuthService.DTOs;
using AuthService.Models;

namespace AuthService.Services.Authentication
{
    public interface ILoginService
    {
        public Task<LoginResponse?> Login(string username, string password);
        public Task<LoginResponse?> SignInWithGoogle(string email, string firstname, string lastname, List<int>? profileUrl);
    }
}
