using AuthService.DTOs;
using AuthService.Models;

namespace AuthService.Services.Authentication
{
    public interface IRegisterService
    {
        public Task<RegisterResponse?> RegisterUser(string username, string email, string firstname, string lastname, string password);
    }
}
