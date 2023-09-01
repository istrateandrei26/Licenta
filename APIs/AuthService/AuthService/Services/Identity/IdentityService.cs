using AuthService.DTOs;
using AuthService.Models;
using AuthService.Services.Details;
using AuthService.Utility;
using Microsoft.EntityFrameworkCore;
using System.Text;

namespace AuthService.Services.Identity
{
    public class IdentityService : IIdentityService
    {
        private SportNetContext ctx;
        private IDetailsService _detailsService;

        public IdentityService(SportNetContext ctx, IDetailsService detailsService)
        {
            this.ctx = ctx;
            _detailsService = detailsService;
        }
        public async Task<RefreshTokenResponse> RefreshToken(RefreshTokenRequest request)
        {
            var response = new RefreshTokenResponse();

            var principal = SecurityHelper.GetPrincipalFromExpiredToken(request.AccessToken);

            if (principal != null)
            {
                var userId = int.Parse(principal.Claims.First(x => x.Type == "id").Value);

                var user = ctx.UsersCredentials.FirstOrDefault(x => x.UserId == userId);

                if (request.RefreshToken != user!.RefreshToken)
                {
                    response.Type = DTOs.Type.InvalidTokenRequest;
                    response.Message = "Refresh token is not valid";
                    return response;
                }

                string newAccessToken = SecurityHelper.GenerateAccessToken(user!);
                string refreshToken = SecurityHelper.GenerateRefreshToken();

                user.RefreshToken = refreshToken;
                await ctx.SaveChangesAsync();
                //todo : alter table usersCredentials add column refresh token and check it !

                response.AccessToken = newAccessToken;
                response.RefreshToken = refreshToken;
                response.Type = DTOs.Type.Ok;
                response.Message = "Access Token successfully refreshed";
                return response;
            }

            response.Type = DTOs.Type.InvalidTokenRequest;
            response.Message = "Invalid Request";
            return response;
        }


        public async Task<ChangePasswordResponse> ChangePassword(ChangePasswordRequest request)
        {
            var userFound = ctx.UsersCredentials.FirstOrDefault(x => x.UserId == request.UserId);

            if (userFound == null)
            {
                return new ChangePasswordResponse
                {
                    Message = "Invalid user, user id not found.",
                    Type = DTOs.Type.UserNotFound,
                    StatusCode = 200
                };
            }

            byte[] passwordToValidate = Encoding.ASCII.GetBytes(request.OldPassword);
            byte[] salt = userFound.Salt;

            var _hashedPassword = SecurityHelper.ComputeHash(salt.Concat(passwordToValidate).ToArray());
            var isValid = _hashedPassword.SequenceEqual(userFound.Password);

            if (!isValid)
            {
                return new ChangePasswordResponse
                {
                    Message = "Invalid old password!",
                    Type = DTOs.Type.InvalidOldPassword,
                    StatusCode = 200,
                };
            }

            userFound.Password = _hashedPassword;
            await ctx.SaveChangesAsync();

            return new ChangePasswordResponse
            {
                Message = "Successfully changed password!",
                Type = DTOs.Type.Ok,
                StatusCode = 200,
            };
        }

        public UserObject? getUserById(int id)
        {
            var userFound = ctx.Users.FirstOrDefault(x => x.Id == id);

            if (userFound == null)
                return null;

            return new UserObject
            {
                Id = userFound.Id,
                Email = userFound.Email,
                Lastname = userFound.Lastname,
                Firstname = userFound.Firstname,
                Username = ctx.UsersCredentials.FirstOrDefault(x => x.UserId == id)!.Username,
                ProfileImage = userFound.ProfileImage != null ? userFound.ProfileImage!.Select(x => (int)x).ToList() : null
            };

        }


        public async Task<bool> CheckIfUserIsFriend(int currentUserId, int possibleFriendId)
        {
            var friendship = await ctx.Friendships
                .FirstOrDefaultAsync(x =>
                            x.UserId == currentUserId && x.FriendId == possibleFriendId ||
                            x.UserId == possibleFriendId && x.FriendId == currentUserId);

            if (friendship == null)
                return false;

            return true;
        }

        public IEnumerable<AttendedEvent> GetAttendedEvents(int userId)
        {
            var attendedEvents = (
                    from E in ctx.Events
                    join EM in ctx.EventMembers
                    on E.Id equals EM.EventId
                    where EM.MemberId == userId && DateTime.Now > E.StartDatetime.AddMinutes(E.Duration)
                    select E
                )
                .ToList();

            var attended = new List<AttendedEvent>();

            foreach (var x in attendedEvents)
            {
                var members = _detailsService.getEventMembers(x.Id);

                var ev = new AttendedEvent
                {
                    Event = new EventObject
                    {
                        Id = x.Id,
                        StartDateTime = x.StartDatetime,
                        Duration = x.Duration,
                        SportCategory = _detailsService.getSportCategoryById(x.SportCategory),
                        Location = _detailsService.getLocationById(x.LocationId),
                        Creator = _detailsService.getUserById(x.CreatorId),
                        RequiredMembersTotal = x.RequiredMembersTotal
                    },
                    Members = members!
                };

                attended.Add(ev);
            }

            return attended;
        }

        public IEnumerable<UserObject> GetAdmirers(int userId)
        {
            var admirers = (
                    from U in ctx.Users
                    join H in ctx.Honors
                    on U.Id equals H.FromId
                    where H.ToId == userId
                    select U
                )
                .ToList()
                .Select(user => new UserObject
                {
                    Id = user.Id,
                    Email = user.Email,
                    Lastname = user.Lastname,
                    Firstname = user.Firstname,
                    Username = ctx.UsersCredentials.FirstOrDefault(x => x.UserId == userId)!.Username,
                    ProfileImage = user.ProfileImage != null ? user.ProfileImage!.Select(x => (int)x).ToList() : null
        })
                .ToList()
                .GroupBy(x => x.Id)
                   .Select(grp => grp.First())
                   .ToList();

            //foreach (var adm in admirers)
            //{
            //    adm.ProfileImage = adm.ProfileImage != null ? adm.ProfileImage!.Select(x => (int)x).ToList() : null;
            //}

            return admirers;
        }

        public IEnumerable<EventObjectAndRatingAverage> GetMyEventsAverages(int userId)
        {
            return _detailsService.getRatingForEachOfMyEvents(userId);
        }

        public int getNumberOfHonors(int userId)
        {
            var honors = ctx.Honors.Where(x => x.ToId == userId).Count();

            return honors;
        }

        public int getGivenHonors(int userId)
        {
            var honors = ctx.Honors.Where(x => x.FromId == userId).GroupBy(x => x.ToId).Count();

            return honors;
        }

        public IEnumerable<AttendedCategory> GetAttendedCategories(int userId)
        {
            var attendedCategoriesWithHonor = (
                    from honor in ctx.Honors
                    join ev in ctx.Events
                    on honor.EventId equals ev.Id
                    join cat in ctx.SportCategories
                    on ev.SportCategory equals cat.Id
                    where honor.ToId == userId
                    group cat by cat.Id into g
                    select new
                    {
                        SportCategoryId = g.Key,
                        Honors = g.Count()
                    }
                )
                .ToList()
                .Select(x => new AttendedCategory
                {
                    SportCategory = _detailsService.getSportCategoryById(x.SportCategoryId)!,
                    Honors = x.Honors
                })
                .ToList();

            var attendedCategories = (
                from E in ctx.Events
                join EM in ctx.EventMembers on E.Id equals EM.EventId
                join SP in ctx.SportCategories on E.SportCategory equals SP.Id
                join U in ctx.Users on EM.MemberId equals U.Id
                where U.Id == userId
                group SP by SP.Id into g
                select g.Key
            ).ToList();


            foreach (var attendedCat in attendedCategories)
            {
                var foundCategory = attendedCategoriesWithHonor.Find(x => x.SportCategory.Id == attendedCat);
                if (foundCategory == null)
                    attendedCategoriesWithHonor.Add(new AttendedCategory
                    {
                        SportCategory = _detailsService.getSportCategoryById(attendedCat)!,
                        Honors = 0
                    });
            }


            return attendedCategoriesWithHonor;
        }

        public async Task<List<int>> SaveProfileImage(IFormFile profileImage, int userId)
        {
            byte[] imageData;
            using (var stream = new MemoryStream())
            {
                await profileImage.CopyToAsync(stream);
                imageData = stream.ToArray();
            }

            var userFound = ctx.Users.First(x => x.Id == userId);

            userFound.ProfileImage = imageData;

            ctx.SaveChanges();

            var imageBytes = userFound.ProfileImage.Select((b) => (int)b).ToList();

            return imageBytes;
        }

        public async Task AddDeviceId(int userId, string deviceId)
        {
            var sameDeviceFound = ctx.UserDevices.FirstOrDefault(x => x.UserId == userId && x.DeviceId == deviceId);

            if (sameDeviceFound != null)
                return;


            var userDeviceRecord = new UserDevice
            {
                UserId = userId,
                DeviceId = deviceId
            };

            ctx.UserDevices.Add(userDeviceRecord);
            await ctx.SaveChangesAsync();
        }

        public async Task RemoveDeviceId(int userId, string deviceId)
        {
            var deviceFound = ctx.UserDevices.FirstOrDefault(x => x.DeviceId == deviceId);

            if(deviceFound != null)
            {
                ctx.UserDevices.Remove(deviceFound);
                await ctx.SaveChangesAsync();
            }
        }

        public async Task<GetLoggedInProfileInfoResponse> GetLoggedInProfileInfo(int userId)
        {
            var user = ctx.UsersCredentials.FirstOrDefault(x => x.UserId == userId);
            if (user == null)
            {
                return new GetLoggedInProfileInfoResponse
                {
                    StatusCode = 200,
                    Type = DTOs.Type.UserNotFound,
                    Message = "User not found"
                };
            }

            var accessToken = SecurityHelper.GenerateAccessToken(user);
            var refreshToken = SecurityHelper.GenerateRefreshToken();

            user.RefreshToken = refreshToken;
            await ctx.SaveChangesAsync();

            return new GetLoggedInProfileInfoResponse
            {
                Id = user.UserId,
                StatusCode = 200,
                Message = "Successfully logged in",
                Type = DTOs.Type.Ok,
                AccessToken = accessToken,
                RefreshToken = refreshToken,
                Username = user.Username,
                Firstname = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Firstname,
                Lastname = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Lastname,
                Email = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.Email,
                ProfileImage = ctx.Users.FirstOrDefault(x => x.Id == user.UserId)!.ProfileImage!.Select(x => (int)x).ToList()
            };

        }

        public bool CheckEmailExists(string email)
        {
            var emailExists = ctx.Users.Any(x => x.Email == email);

            return emailExists;
        }

        public async Task ResetPassword(string newPassword, string resetCode)
        {
            var resetCodeDatabaseStored = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(resetCode));

            var userCredentials = (
                from user in ctx.Users
                join passReset in ctx.AccountPasswordResets
                on user.Id equals passReset.UserId
                join usersCred in ctx.UsersCredentials
                on user.Id equals usersCred.UserId
                where passReset.ResetCode.SequenceEqual(resetCodeDatabaseStored)
                select usersCred
            ).First();

            //generate new password hash to update:
            var salt = SecurityHelper.GenerateSalt(8);
            var password = Encoding.ASCII.GetBytes(newPassword);
            var hashedPassword = SecurityHelper.ComputeHash(salt.Concat(password).ToArray());

            userCredentials.Salt = salt;
            userCredentials.Password = hashedPassword;

            await ctx.SaveChangesAsync();

        }

        public bool CheckIfPasswordResetCodeIsExpired(string resetCode)
        {
            var resetCodeDatabaseStored = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(resetCode));
            var resetCodeRecord = ctx.AccountPasswordResets.First(x => x.ResetCode.SequenceEqual(resetCodeDatabaseStored));

            return DateTime.Now > resetCodeRecord.ExpiryDate;
        }

        public bool CheckIfPasswordResetCodeIsAlreadyUsed(string resetCode)
        {
            var resetCodeDatabaseStored = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(resetCode));
            var resetCodeRecord = ctx.AccountPasswordResets.First(x => x.ResetCode.SequenceEqual(resetCodeDatabaseStored));

            return resetCodeRecord.Used;
        }

        public bool CheckIfResetCodeExists(string resetCode)
        {
            var resetCodeDatabaseStored = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(resetCode));
            var resetCodeExists = ctx.AccountPasswordResets.Any(x => x.ResetCode.SequenceEqual(resetCodeDatabaseStored));

            return resetCodeExists;
        }

        public bool CheckFriendRequestSent(int userId, int toUserId)
        {
            var friendRequestSent = ctx.FriendRequests.Any(x => x.FromUserId == userId && x.ToUserId == toUserId);

            return friendRequestSent;
        }
    }
}
