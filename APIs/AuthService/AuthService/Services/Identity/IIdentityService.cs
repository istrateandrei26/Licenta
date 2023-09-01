using AuthService.DTOs;

namespace AuthService.Services.Identity
{
    public interface IIdentityService
    {
        public Task<RefreshTokenResponse> RefreshToken(RefreshTokenRequest request);
        public UserObject? getUserById(int id);
        public Task<ChangePasswordResponse> ChangePassword(ChangePasswordRequest request);
        public Task<bool> CheckIfUserIsFriend(int currentUserId, int possibleFriendId);
        public IEnumerable<AttendedEvent> GetAttendedEvents(int userId);
        public IEnumerable<UserObject> GetAdmirers(int userId);
        public IEnumerable<EventObjectAndRatingAverage> GetMyEventsAverages(int userId);
        public int getNumberOfHonors(int userId);
        public int getGivenHonors(int userId);
        public IEnumerable<AttendedCategory> GetAttendedCategories(int userId);
        public Task<List<int>> SaveProfileImage(IFormFile profileImage, int userId);
        public Task AddDeviceId(int userId, string deviceId);
        public Task RemoveDeviceId(int userId, string deviceId);
        public Task<GetLoggedInProfileInfoResponse> GetLoggedInProfileInfo(int userId);
        public bool CheckEmailExists(string email);
        public Task ResetPassword(string newPassword, string resetCode);
        public bool CheckIfPasswordResetCodeIsExpired(string resetCode);
        public bool CheckIfPasswordResetCodeIsAlreadyUsed(string resetCode);
        public bool CheckIfResetCodeExists(string resetCode);
        public bool CheckFriendRequestSent(int userId, int toUserId);
    }
}
