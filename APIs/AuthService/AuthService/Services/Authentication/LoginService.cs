using AuthService.DTOs;
using AuthService.Models;
using AuthService.Utility;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Mail;
using System.Security.Claims;
using System.Text;

namespace AuthService.Services.Authentication
{
    public class LoginService : ILoginService
    {
        private SportNetContext ctx;

        public LoginService(SportNetContext ctx)
        {
            this.ctx = ctx;
        }

        public async Task<LoginResponse?> Login(string username, string password)
        {
            try
            {
                var user = ctx.UsersCredentials.FirstOrDefault(x => x.Username == username);
                if (user == null)
                {
                    return new LoginResponse
                    {
                        StatusCode = 200,
                        Type = DTOs.Type.InvalidUsernameOrPassword,
                        Message = "Invalid username or password"
                    };
                }

                byte[] passwordToValidate = Encoding.ASCII.GetBytes(password);
                byte[] salt = user.Salt;

                var _hashedPassword = SecurityHelper.ComputeHash(salt.Concat(passwordToValidate).ToArray());
                var isValid = _hashedPassword.SequenceEqual(user.Password);

                if (!isValid)
                {
                    return new LoginResponse
                    {
                        StatusCode = 200,
                        Type = DTOs.Type.InvalidUsernameOrPassword,
                        Message = "Invalid username or password"
                    };
                }

                var accessToken = SecurityHelper.GenerateAccessToken(user);
                var refreshToken = SecurityHelper.GenerateRefreshToken();

                user.RefreshToken = refreshToken;
                await ctx.SaveChangesAsync();

                var validUser = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!;

                return new LoginResponse
                {
                    Id = user.UserId,
                    StatusCode = 200,
                    Message = "Successfully logged in",
                    Type = DTOs.Type.Ok,
                    AccessToken = accessToken,
                    RefreshToken = refreshToken,
                    Username = username,
                    Firstname = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Firstname,
                    Lastname = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Lastname,
                    Email = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Email,
                    ProfileImage = validUser.ProfileImage != null ? validUser.ProfileImage.Select(x => (int)x).ToList() : null
                };
            }
            catch (Exception e)
            {
                return null;
            }

        }

        public async Task<LoginResponse?> SignInWithGoogle(string email, string firstname, string lastname, List<int>? profileImageBytes)
        {

            string accessToken;
            string refreshToken;

            // Search user by gmail in our database:
            var user = ctx.Users.FirstOrDefault(x => x.Email == email);

            if (user == null)
            {
                var _salt = SecurityHelper.GenerateSalt(8);
                var _password = SecurityHelper.GenerateRandomPassword(10);
                var _hashedPassword = SecurityHelper.ComputeHash(_salt.Concat(_password).ToArray());

                var newUser = new User
                {
                    Email = email,
                    Firstname = firstname,
                    Lastname = lastname,
                    ProfileImage = profileImageBytes != null ? profileImageBytes.Select(i => (byte)i).ToArray() : null
                };

                try
                {

                    await ctx.Users.AddAsync(newUser);
                    await ctx.SaveChangesAsync();

                    var mail = new MailAddress(email);
                    var username = mail.User;

                    var newUserCredentials = new UsersCredential
                    {
                        UserId = newUser.Id,
                        Username = username,
                        Password = _hashedPassword,
                        Salt = _salt,
                        User = newUser
                    };

                    await ctx.UsersCredentials.AddAsync(newUserCredentials);
                    await ctx.SaveChangesAsync();

                    accessToken = SecurityHelper.GenerateAccessToken(newUserCredentials);
                    refreshToken = SecurityHelper.GenerateRefreshToken();

                    newUserCredentials.RefreshToken = refreshToken;
                    await ctx.SaveChangesAsync();

                    return new LoginResponse
                    {
                        Id = newUser.Id,
                        StatusCode = 200,
                        Message = "Successfully logged in",
                        Type = DTOs.Type.Ok,
                        AccessToken = accessToken,
                        RefreshToken = refreshToken,
                        Username = username,
                        Firstname = firstname,
                        Lastname = lastname,
                        Email = email,
                        ProfileImage = profileImageBytes
                    };

                }
                catch (Exception e)
                {
                    return null;
                }


            }
            else
            {

                var credentials = ctx.UsersCredentials.First(x => x.UserId == user.Id);
                accessToken = SecurityHelper.GenerateAccessToken(credentials);
                refreshToken = SecurityHelper.GenerateRefreshToken();

                return new LoginResponse
                {
                    Id = user.Id,
                    StatusCode = 200,
                    Message = "Successfully logged in",
                    Type = DTOs.Type.Ok,
                    AccessToken = accessToken,
                    RefreshToken = refreshToken,
                    Username = credentials.Username,
                    Firstname = user.Firstname,
                    Lastname = user.Lastname,
                    Email = user.Email,
                    ProfileImage = user.ProfileImage != null ? user.ProfileImage!.Select(x => (int)x).ToList() : null
                };
            }

        }
    }
}
