using AuthService.DTOs;
using AuthService.Models;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using AuthService.Utility;

namespace AuthService.Services.Authentication
{
    public class RegisterService : IRegisterService
    {
        private SportNetContext ctx;
        public RegisterService(SportNetContext ctx)
        {
            this.ctx = ctx;
        }
        public async Task<RegisterResponse?> RegisterUser(string username, string email, string firstname, string lastname, string password)
        {

            var existingUsername = ctx.Users.FirstOrDefault(x => x.UsersCredential.Username == username);
            if (existingUsername != null)
            {
                return new RegisterResponse { StatusCode = 200, Type = DTOs.Type.ExistingUsername };
            }

            var existingEmail = ctx.Users.FirstOrDefault(x => x.Email == email);
            if (existingEmail != null)
            {
                return new RegisterResponse { StatusCode = 200, Type = DTOs.Type.ExistingEmail };
            }

            var _salt = SecurityHelper.GenerateSalt(8);
            var _password = Encoding.ASCII.GetBytes(password);
            var _hashedPassword = SecurityHelper.ComputeHash(_salt.Concat(_password).ToArray());

            var newUser = new User
            {
                Email = email,
                Firstname = firstname,
                Lastname = lastname
            };

            try
            {

                await ctx.Users.AddAsync(newUser);
                await ctx.SaveChangesAsync();

                var newUserCredentials = new UsersCredential
                {
                    UserId = newUser.Id,                         // check here if errors
                    Username = username,
                    Password = _hashedPassword,
                    Salt = _salt,
                    User = newUser
                };

                await ctx.UsersCredentials.AddAsync(newUserCredentials);
                await ctx.SaveChangesAsync();


                return new RegisterResponse { StatusCode = 200, Message = "Successfully registered", Type = DTOs.Type.Ok };

            }
            catch (Exception e)
            {
                return null;
            }

        }
    }
}
